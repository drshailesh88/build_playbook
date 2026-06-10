#!/usr/bin/env bash
# gh-state.sh — GitHub as the factory's source of truth (DEC-004 Phase 3)
#
# Three stores by lifetime:
#   GitHub (durable, authoritative): one issue per story (contract in body,
#     status as s:* labels, verdicts as the comment trail) + a pinned
#     tracking issue whose body holds the crash-recovery cursor.
#   ralph/ scratchpad (per-run): prd.json flags, verdicts, progress.txt.
#     `pull` makes GitHub win at run start; events push local -> GitHub
#     during a run.
#   Memory (distilled): Supermemory + learnings JSONL (outside this script).
#
# Escalation semantics (DEC-009): escalate = label + comment + optional
# Slack webhook + PARK the story (parked:true in prd.json) — the loop skips
# parked stories and continues. The factory never blocks on a human.
#
# Commands:
#   init                       create labels, story issues, pinned tracking issue
#   pull                       GitHub labels -> prd.json flags (GitHub wins)
#   event <id> <event> [file]  comment + label swap; events: built,
#                              judge-rejected, qa-passed, quorum-approved,
#                              quorum-rejected
#   escalate <id> <reason> [file]  park story + escalated label + notify
#   cursor [k=v ...]           get (no args) or set cursor fields
#   recover                    print cursor + parked/escalated stories
#
# Env: GH_STATE=0     disable all GitHub calls (everything degrades to local)
#      NOTIFY_WEBHOOK Slack-compatible webhook for escalations
#      GH_REPO        owner/repo override (default: current repo's origin)
#
# Every GitHub call is best-effort: network/auth failure prints a warning
# and the loop continues on local state. Exit 0 unless the command itself
# is invalid.

set -uo pipefail
cd "$(dirname "$0")/.."

PRD=ralph/prd.json
ISSUE_MAP=ralph/gh-issues.json
CURSOR_MIRROR=ralph/loop-cursor.json
TRACKING_LABEL=ralph-tracking
STORY_LABEL=ralph
GH_STATE="${GH_STATE:-1}"
GH_REPO_FLAG=()
[ -n "${GH_REPO:-}" ] && GH_REPO_FLAG=(--repo "$GH_REPO")

CMD="${1:-}"
shift || true

warn() { echo "[gh-state] WARN: $*" >&2; }

gh_ok() {
  [ "$GH_STATE" = "1" ] || return 1
  command -v gh >/dev/null 2>&1 || { warn "gh CLI not found — local-only mode"; return 1; }
  return 0
}

issue_for() {  # story id -> issue number (empty if unmapped)
  python3 -c "
import json
try: m = json.load(open('$ISSUE_MAP'))
except Exception: m = {}
print(m.get('$1', ''))"
}

map_issue() {  # store story id -> issue number
  python3 - "$1" "$2" <<'PY'
import json, sys
try: m = json.load(open('ralph/gh-issues.json'))
except Exception: m = {}
m[sys.argv[1]] = int(sys.argv[2])
json.dump(m, open('ralph/gh-issues.json', 'w'), indent=2)
PY
}

set_label() {  # set_label <issue> <new s:label>
  local issue="$1" new="$2"
  gh issue edit "$issue" "${GH_REPO_FLAG[@]}" \
    --remove-label "s:pending" --remove-label "s:built" \
    --remove-label "s:qa" --remove-label "s:approved" \
    --add-label "$new" >/dev/null 2>&1 || warn "label swap failed for #$issue"
}

comment() {  # comment <issue> <text> [json-file-to-attach]
  local issue="$1" text="$2" file="${3:-}"
  local body="$text"
  if [ -n "$file" ] && [ -f "$file" ]; then
    body=$(printf '%s\n\n```json\n%s\n```\n' "$text" "$(head -c 60000 "$file")")
  fi
  printf '%s' "$body" | gh issue comment "$issue" "${GH_REPO_FLAG[@]}" --body-file - \
    >/dev/null 2>&1 || warn "comment failed for #$issue"
}

notify() {
  [ -n "${NOTIFY_WEBHOOK:-}" ] || return 0
  curl -s -X POST "$NOTIFY_WEBHOOK" -H "Content-Type: application/json" \
    -d "{\"text\": \"[ralph] $1\"}" >/dev/null 2>&1 || true
}

# ── cursor (pinned tracking issue body between markers + local mirror) ──────
tracking_issue() {
  local n
  n=$(issue_for "__tracking__")
  if [ -z "$n" ] && gh_ok; then
    n=$(gh issue list "${GH_REPO_FLAG[@]}" --label "$TRACKING_LABEL" --state open \
        --json number --jq '.[0].number' 2>/dev/null || true)
    [ -n "$n" ] && map_issue "__tracking__" "$n"
  fi
  echo "$n"
}

cursor_get() {
  local n body
  if gh_ok; then
    n=$(tracking_issue)
    if [ -n "$n" ]; then
      body=$(gh issue view "$n" "${GH_REPO_FLAG[@]}" --json body --jq .body 2>/dev/null || true)
      if [ -n "$body" ]; then
        printf '%s' "$body" | python3 -c "
import re, sys
m = re.search(r'<!-- cursor:start -->\s*\`\`\`json\s*(\{.*?\})\s*\`\`\`\s*<!-- cursor:end -->', sys.stdin.read(), re.DOTALL)
print(m.group(1) if m else '{}')"
        return
      fi
    fi
  fi
  cat "$CURSOR_MIRROR" 2>/dev/null || echo '{}'
}

cursor_set() {  # cursor_set k=v [k=v ...]
  local current updated
  current=$(cursor_get)
  updated=$(printf '%s' "$current" | python3 - "$@" <<'PY'
import datetime, json, sys
try: c = json.load(sys.stdin)
except Exception: c = {}
for kv in sys.argv[1:]:
    k, _, v = kv.partition('=')
    c[k] = int(v) if v.isdigit() else v
c['updated'] = datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
print(json.dumps(c, indent=2))
PY
)
  printf '%s\n' "$updated" > "$CURSOR_MIRROR"
  if gh_ok; then
    local n
    n=$(tracking_issue)
    if [ -n "$n" ]; then
      printf 'Ralph factory tracking issue. Do not edit the cursor block by hand.\n\n<!-- cursor:start -->\n```json\n%s\n```\n<!-- cursor:end -->\n' \
        "$updated" | gh issue edit "$n" "${GH_REPO_FLAG[@]}" --body-file - \
        >/dev/null 2>&1 || warn "cursor push failed"
    fi
  fi
}

park_story() {  # park_story <id>  (local flag; loops skip parked stories)
  python3 - "$1" <<'PY'
import json, sys
d = json.load(open('ralph/prd.json'))
for s in d:
    if s.get('id') == sys.argv[1]:
        s['parked'] = True
json.dump(d, open('ralph/prd.json', 'w'), indent=2)
PY
}

case "$CMD" in
  init)
    gh_ok || { warn "GitHub disabled/unavailable — nothing to init"; exit 0; }
    for L in "$STORY_LABEL:1d76db" "$TRACKING_LABEL:5319e7" "s:pending:ededed" \
             "s:built:fbca04" "s:qa:0e8a16" "s:approved:006b75" \
             "escalated:b60205" "parked:7057ff"; do
      gh label create "${L%%:*}" --color "${L##*:}" "${GH_REPO_FLAG[@]}" \
        --force >/dev/null 2>&1 || warn "label ${L%%:*} create failed"
    done
    # Tracking issue (create once, pin, seed cursor)
    if [ -z "$(tracking_issue)" ]; then
      N=$(printf 'created by gh-state.sh init' | gh issue create "${GH_REPO_FLAG[@]}" \
        --title "Ralph Factory — tracking" --label "$TRACKING_LABEL" --body-file - \
        2>/dev/null | grep -oE '[0-9]+$' || true)
      if [ -n "$N" ]; then
        map_issue "__tracking__" "$N"
        gh issue pin "$N" "${GH_REPO_FLAG[@]}" >/dev/null 2>&1 || warn "pin failed (needs triage permission)"
        cursor_set phase=init story= iteration=0
        echo "[gh-state] tracking issue #$N created and pinned"
      else
        warn "tracking issue creation failed"
      fi
    fi
    # One issue per story, contract in body
    while IFS=$'\t' read -r sid desc; do
      [ -z "$sid" ] && continue
      [ -n "$(issue_for "$sid")" ] && continue
      BODY_FILE=$(mktemp)
      {
        printf 'Story `%s` — managed by the Ralph factory.\n\n' "$sid"
        if [ -f "ralph/contracts/$sid.contract.md" ]; then
          printf '## Frozen Contract\n\n%s\n' "$(cat "ralph/contracts/$sid.contract.md")"
        else
          printf '%s\n' "$desc"
        fi
      } > "$BODY_FILE"
      # </dev/null: never let a child command eat the story list on stdin
      N=$(gh issue create "${GH_REPO_FLAG[@]}" --title "[$sid] $desc" \
        --label "$STORY_LABEL" --label "s:pending" --body-file "$BODY_FILE" \
        </dev/null 2>/dev/null | grep -oE '[0-9]+$' || true)
      rm -f "$BODY_FILE"
      if [ -n "$N" ]; then
        map_issue "$sid" "$N"
        echo "[gh-state] issue #$N created for $sid"
      else
        warn "issue creation failed for $sid"
      fi
    done < <(python3 -c "
import json
for s in json.load(open('$PRD')):
    print(s.get('id',''), s.get('description','')[:80].replace('\t',' '), sep='\t')")
    ;;

  pull)
    gh_ok || { warn "GitHub disabled/unavailable — keeping local state"; exit 0; }
    LABELS_JSON=$(gh issue list "${GH_REPO_FLAG[@]}" --label "$STORY_LABEL" \
      --state all --limit 500 --json number,labels \
      --jq '[.[] | {number: .number, labels: [.labels[].name]}]' 2>/dev/null || echo '')
    if [ -z "$LABELS_JSON" ]; then
      warn "pull failed — keeping local state"
      exit 0
    fi
    LABELS_JSON="$LABELS_JSON" python3 <<'PY'
import json, os
issues = json.loads(os.environ['LABELS_JSON'])
try: m = json.load(open('ralph/gh-issues.json'))
except Exception: m = {}
by_issue = {v: k for k, v in m.items() if k != '__tracking__'}
prd = json.load(open('ralph/prd.json'))
stories = {s['id']: s for s in prd}
changed = 0
for it in issues:
    sid = by_issue.get(it['number'])
    s = stories.get(sid)
    if not s:
        continue
    labels = set(it['labels'])
    new = {
        'passes': bool(labels & {'s:built', 's:qa', 's:approved'}),
        'qa_tested': bool(labels & {'s:qa', 's:approved'}),
        'quorum_approved': 's:approved' in labels,
        'parked': 'parked' in labels,
    }
    for k, v in new.items():
        if s.get(k, False) != v:
            s[k] = v
            changed += 1
json.dump(prd, open('ralph/prd.json', 'w'), indent=2)
print(f"[gh-state] pull: {len(issues)} issues read, {changed} flags updated (GitHub wins)")
PY
    ;;

  event)
    SID="${1:?event needs <story-id>}"; EVENT="${2:?event needs <event>}"; FILE="${3:-}"
    gh_ok || exit 0
    N=$(issue_for "$SID")
    [ -z "$N" ] && { warn "no issue mapped for $SID (run init)"; exit 0; }
    case "$EVENT" in
      built)            set_label "$N" "s:built";  comment "$N" "**BUILT** — judge T0/T1 passed." "$FILE" ;;
      judge-rejected)   set_label "$N" "s:pending"; comment "$N" "**JUDGE REJECTED** — returned to build loop." "$FILE" ;;
      qa-passed)        set_label "$N" "s:qa";     comment "$N" "**QA PASSED** — full ladder + independent grader." "$FILE" ;;
      quorum-approved)  set_label "$N" "s:approved"; comment "$N" "**QUORUM APPROVED** — Codex + Grok." "$FILE"
                        gh issue close "$N" "${GH_REPO_FLAG[@]}" --reason completed >/dev/null 2>&1 || true ;;
      quorum-rejected)  set_label "$N" "s:pending"; comment "$N" "**QUORUM REJECTED** — returned to build loop." "$FILE" ;;
      *) warn "unknown event '$EVENT'"; exit 1 ;;
    esac
    ;;

  escalate)
    SID="${1:?escalate needs <story-id>}"; REASON="${2:-unspecified}"; FILE="${3:-}"
    park_story "$SID"
    echo "[gh-state] $SID PARKED — $REASON (factory continues)"
    if gh_ok; then
      N=$(issue_for "$SID")
      if [ -n "$N" ]; then
        gh issue edit "$N" "${GH_REPO_FLAG[@]}" --add-label escalated --add-label parked \
          >/dev/null 2>&1 || warn "escalate labels failed"
        comment "$N" "**ESCALATED — human decision needed.** $REASON

The story is parked; the factory has moved on. To resume: fix the cause, remove the \`parked\` label, and set \`s:pending\` (next \`pull\` re-queues it)." "$FILE"
      fi
    fi
    notify "ESCALATED $SID: $REASON"
    ;;

  cursor)
    if [ $# -eq 0 ]; then cursor_get; else cursor_set "$@"; fi
    ;;

  note)
    gh_ok || exit 0
    N=$(tracking_issue)
    [ -n "$N" ] && comment "$N" "${1:?note needs text}" "${2:-}"
    ;;

  recover)
    echo "=== cursor ==="
    cursor_get
    echo ""
    echo "=== parked/escalated ==="
    python3 -c "
import json
d = json.load(open('$PRD'))
parked = [s['id'] for s in d if s.get('parked')]
print('\n'.join(parked) if parked else '(none)')
print(f\"progress: {sum(1 for s in d if s.get('passes'))}/{len(d)} built, {sum(1 for s in d if s.get('qa_tested'))} qa'd, {sum(1 for s in d if s.get('quorum_approved'))} approved\")"
    ;;

  *)
    echo "Usage: $0 {init|pull|event <id> <event> [file]|escalate <id> <reason> [file]|cursor [k=v ...]|recover}" >&2
    exit 1
    ;;
esac
