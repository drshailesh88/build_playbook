#!/usr/bin/env bash
# ralph/watch.sh — passive monitor for Ralph build + QA progress.
#
# Reads ralph/prd.json (Huntley's flat array) + git log. Posts to Slack,
# updates Linear issues. Does NOT modify any files Ralph touches — pure
# observer. Run in a separate terminal tab. Kill/restart freely.
#
# Usage (all env vars optional):
#   SLACK_WEBHOOK_URL="https://hooks.slack.com/..." \
#   LINEAR_TEAM="DRS" \   # optional — defaults to your default Linear team
#   ./ralph/watch.sh
#
# Linear: uses the `linear` CLI (brew install linear). Must be authed
# (`linear auth login`). If `linear` is missing or not authed, the
# watcher skips Linear silently.

set -euo pipefail
cd "$(dirname "$0")/.."

# Load local env (gitignored) so we don't depend on the invoking shell.
if [ -f ralph/.env ]; then
  set -a
  . ralph/.env
  set +a
fi

PRD_FILE="ralph/prd.json"
POLL_INTERVAL=60

SLACK_WEBHOOK="${SLACK_WEBHOOK_URL:-}"
LINEAR_TEAM="${LINEAR_TEAM:-}"

# Detect Linear CLI + auth. Set LINEAR_ENABLED=1 if usable.
LINEAR_ENABLED=0
if command -v linear > /dev/null 2>&1; then
  if linear auth whoami > /dev/null 2>&1; then
    LINEAR_ENABLED=1
    # Auto-detect team if not explicitly set (CLI has no default-team resolver).
    if [ -z "$LINEAR_TEAM" ]; then
      LINEAR_TEAM=$(linear team list 2>/dev/null | awk 'NR==2 {print $1}')
    fi
    if [ -z "$LINEAR_TEAM" ]; then
      echo "WARN: Linear authed but could not detect a team. Set LINEAR_TEAM=<KEY> to enable Linear." >&2
      LINEAR_ENABLED=0
    fi
  fi
fi

if [ ! -f "$PRD_FILE" ]; then
  echo "ERROR: $PRD_FILE not found. Run /playbook:prd-to-ralph first." >&2
  exit 1
fi

LAST_COMMIT=""
LAST_PASSES=0
LAST_QA=0
LINEAR_ISSUE_IDS=()

# ─── Helpers ──────────────────────────────────────────────────────────────────

# Story label = description (Huntley's field). Fall back to title if present.
story_label() {
  python3 -c "
import json, sys
d = json.load(open('$PRD_FILE'))
for s in d:
    if s.get('id') == sys.argv[1]:
        print(s.get('description') or s.get('title') or s.get('id', '?'))
        break
" "$1" 2>/dev/null || echo "$1"
}

count_passes() {
  python3 -c "import json; d=json.load(open('$PRD_FILE')); print(sum(1 for x in d if x.get('passes', False)))" 2>/dev/null || echo "0"
}

count_qa_done() {
  python3 -c "import json; d=json.load(open('$PRD_FILE')); print(sum(1 for x in d if x.get('qa_tested', False)))" 2>/dev/null || echo "0"
}

total_tasks() {
  python3 -c "import json; d=json.load(open('$PRD_FILE')); print(len(d))" 2>/dev/null || echo "0"
}

get_latest_commit() {
  git log -1 --format="%H|%s" 2>/dev/null || echo ""
}

get_story_statuses() {
  python3 -c "
import json
d = json.load(open('$PRD_FILE'))
for s in d:
    sid = s.get('id', '?')
    label = s.get('description') or s.get('title') or sid
    if s.get('qa_tested'): icon = '🟢'
    elif s.get('passes'):  icon = '✅'
    else:                   icon = '⬜'
    # Truncate label so Slack messages stay readable
    if len(label) > 70: label = label[:67] + '...'
    print(f'{icon} {sid}: {label}')
" 2>/dev/null
}

# Find the most recent story whose passes flipped to true (heuristic: last
# entry in priority order with passes=true).
latest_passed_id() {
  python3 -c "
import json
d = json.load(open('$PRD_FILE'))
passing = [s for s in d if s.get('passes')]
if passing:
    last = passing[-1]
    print(last.get('id', ''))
" 2>/dev/null
}

next_pending_id() {
  python3 -c "
import json
d = json.load(open('$PRD_FILE'))
pending = [s for s in d if not s.get('passes', False)]
if pending:
    print(pending[0].get('id', ''))
" 2>/dev/null
}

# ─── Slack ────────────────────────────────────────────────────────────────────

slack_post() {
  local msg="$1"
  if [ -n "$SLACK_WEBHOOK" ]; then
    # Escape message for JSON (basic: " and \n).
    local json_msg=$(python3 -c "import json,sys; print(json.dumps({'text': sys.argv[1]}))" "$msg")
    curl -s -X POST "$SLACK_WEBHOOK" \
      -H 'Content-type: application/json' \
      -d "$json_msg" > /dev/null 2>&1 || true
  fi
}

# ─── Linear (via `linear` CLI) ────────────────────────────────────────────────

# Create an issue, echo back its identifier (e.g. "DRS-42") or empty string.
linear_create_issue() {
  local title="$1"
  local story_id="$2"
  if [ "$LINEAR_ENABLED" != "1" ]; then return; fi
  local out
  out=$(linear issue create --no-interactive \
    -t "$title" \
    -d "Ralph build task: $story_id" \
    --team "$LINEAR_TEAM" 2>&1) || { echo ""; return 0; }
  echo "$out" | grep -oE '[A-Z]+-[0-9]+' | head -1 || echo ""
}

linear_update_status() {
  local issue_id="$1"
  local state_name="$2"
  if [ "$LINEAR_ENABLED" != "1" ] || [ -z "$issue_id" ]; then return; fi
  linear issue update "$issue_id" -s "$state_name" > /dev/null 2>&1 || true
}

linear_add_comment() {
  local issue_id="$1"
  local body="$2"
  if [ "$LINEAR_ENABLED" != "1" ] || [ -z "$issue_id" ]; then return; fi
  linear issue comment add "$issue_id" -b "$body" > /dev/null 2>&1 || true
}

LINEAR_MAP_FILE="ralph/.linear-issues.txt"

bootstrap_linear() {
  if [ "$LINEAR_ENABLED" != "1" ]; then return; fi
  # Restore existing map so we don't create duplicates on restart.
  if [ -f "$LINEAR_MAP_FILE" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && LINEAR_ISSUE_IDS+=("$line")
    done < "$LINEAR_MAP_FILE"
    echo "Loaded ${#LINEAR_ISSUE_IDS[@]} existing Linear issues from $LINEAR_MAP_FILE"
  fi
  echo "Creating Linear issues for new stories..."
  local stories
  stories=$(python3 -c "
import json
d = json.load(open('$PRD_FILE'))
for s in d:
    sid = s.get('id', '')
    label = s.get('description') or s.get('title') or sid
    if len(label) > 100: label = label[:97] + '...'
    print(f'{sid}\t{label}')
" 2>/dev/null)

  while IFS=$'\t' read -r sid title; do
    if [ -n "$sid" ]; then
      # Skip if we already have an issue for this story.
      if [ -n "$(get_linear_issue_id "$sid")" ]; then continue; fi
      issue_id=$(linear_create_issue "[$sid] $title" "$sid")
      if [ -n "$issue_id" ]; then
        LINEAR_ISSUE_IDS+=("$sid:$issue_id")
        echo "$sid:$issue_id" >> "$LINEAR_MAP_FILE"
        echo "  Created: $sid → $issue_id"
      else
        echo "  FAILED to create Linear issue for $sid"
      fi
    fi
  done <<< "$stories"
}

get_linear_issue_id() {
  local story_id="$1"
  for entry in "${LINEAR_ISSUE_IDS[@]:-}"; do
    if [[ "$entry" == "$story_id:"* ]]; then
      echo "${entry#*:}"
      return
    fi
  done
}

# ─── Main loop ────────────────────────────────────────────────────────────────

echo "=== Ralph Watcher ==="
echo "Polling every ${POLL_INTERVAL}s against $PRD_FILE + git log"
echo "Slack:  $([ -n "$SLACK_WEBHOOK" ] && echo 'configured' || echo 'not set')"
echo "Linear: $([ "$LINEAR_ENABLED" = "1" ] && echo "configured (team: ${LINEAR_TEAM:-default})" || echo 'not set')"
echo ""

LAST_COMMIT=$(get_latest_commit)
LAST_PASSES=$(count_passes)
LAST_QA=$(count_qa_done)
TOTAL=$(total_tasks)

slack_post "🚀 *Ralph build started*
Features: $LAST_PASSES/$TOTAL built, $LAST_QA/$TOTAL QA'd

$(get_story_statuses)"

bootstrap_linear

while true; do
  sleep "$POLL_INTERVAL"

  CURRENT_COMMIT=$(get_latest_commit)
  CURRENT_PASSES=$(count_passes)
  CURRENT_QA=$(count_qa_done)

  if [ "$CURRENT_COMMIT" != "$LAST_COMMIT" ]; then
    COMMIT_MSG="${CURRENT_COMMIT#*|}"

    if [ "$CURRENT_PASSES" -gt "$LAST_PASSES" ]; then
      STORY_ID=$(latest_passed_id)
      LABEL=$(story_label "$STORY_ID")

      slack_post "✅ *Built:* $STORY_ID — $LABEL
Progress: $CURRENT_PASSES/$TOTAL built, $CURRENT_QA/$TOTAL QA'd
Commit: \`$COMMIT_MSG\`"

      ISSUE_ID=$(get_linear_issue_id "$STORY_ID")
      if [ -n "$ISSUE_ID" ]; then
        linear_update_status "$ISSUE_ID" "In Review"
        linear_add_comment "$ISSUE_ID" "✅ Built by Ralph build agent.

Commit: $COMMIT_MSG"
      fi

      NEXT_ID=$(next_pending_id)
      if [ -n "$NEXT_ID" ]; then
        NEXT_ISSUE=$(get_linear_issue_id "$NEXT_ID")
        if [ -n "$NEXT_ISSUE" ]; then
          linear_update_status "$NEXT_ISSUE" "In Progress"
        fi
      fi

    elif [ "$CURRENT_QA" -gt "$LAST_QA" ]; then
      # QA agent completed a feature
      QA_ID=$(python3 -c "
import json
d = json.load(open('$PRD_FILE'))
qa_done = [s for s in d if s.get('qa_tested')]
if qa_done:
    last = qa_done[-1]
    print(last.get('id', ''))
" 2>/dev/null)
      LABEL=$(story_label "$QA_ID")

      slack_post "🟢 *QA'd:* $QA_ID — $LABEL
Progress: $CURRENT_PASSES/$TOTAL built, $CURRENT_QA/$TOTAL QA'd
Commit: \`$COMMIT_MSG\`"

      ISSUE_ID=$(get_linear_issue_id "$QA_ID")
      if [ -n "$ISSUE_ID" ]; then
        linear_update_status "$ISSUE_ID" "Done"
        linear_add_comment "$ISSUE_ID" "🟢 QA'd by Codex independent evaluator.

Commit: $COMMIT_MSG"
      fi
    else
      slack_post "🔧 *Commit:* \`$COMMIT_MSG\`
Progress: $CURRENT_PASSES/$TOTAL built, $CURRENT_QA/$TOTAL QA'd"
    fi

    # Everything done?
    if [ "$CURRENT_QA" -ge "$TOTAL" ] && [ "$TOTAL" -gt 0 ]; then
      slack_post "🎉 *Ralph COMPLETE!*
All $TOTAL features built AND QA'd.

$(get_story_statuses)

Next: run your hardened QA pipeline (\`npm run qa:run\`)."

      for entry in "${LINEAR_ISSUE_IDS[@]:-}"; do
        issue_id="${entry#*:}"
        linear_update_status "$issue_id" "Done" 2>/dev/null || true
      done

      echo "All features built + QA'd. Watcher exiting."
      exit 0
    fi

    LAST_COMMIT="$CURRENT_COMMIT"
    LAST_PASSES="$CURRENT_PASSES"
    LAST_QA="$CURRENT_QA"
  fi
done
