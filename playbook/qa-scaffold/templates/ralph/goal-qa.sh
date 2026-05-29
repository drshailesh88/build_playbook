#!/usr/bin/env bash
# Ralph goal-mode QA — verify a single story via Claude Code /goal.
#
# Uses a DIFFERENT model context than the builder (independence principle).
# The QA goal instructs the worker to verify acceptance criteria, check
# pinned test names (fail_to_pass), probe edge cases, and fix bugs.
#
# Prerequisites:
#   - ralph/goals/{story-id}.qa.goal exists (run /playbook:ralph-goal first)
#   - Story must have passes:true (build completed)
#   - .claude/hooks/goal-acceptance-gate.sh installed
#
# Env overrides:
#   QA_GOAL_MODEL=<id>                  default claude-opus-4-6
#   GOAL_PERMISSION_MODE=<mode>         default acceptEdits
#   CLAUDE_CODE_GOAL_MAX_STOP_CONTINUES default 5
#   SKIP_CLAUDE_MD_SWAP=1               don't swap CLAUDE.md
#
# Usage: ./ralph/goal-qa.sh <story-id>

set -euo pipefail
cd "$(dirname "$0")/.."

STORY_ID="${1:?Usage: ./ralph/goal-qa.sh <story-id>}"
PRD=ralph/prd.json
QA_REPORT=ralph/qa-report.json
GOAL_FILE="ralph/goals/${STORY_ID}.qa.goal"
QA_GOAL_MODEL="${QA_GOAL_MODEL:-claude-opus-4-6}"
GOAL_PERMISSION_MODE="${GOAL_PERMISSION_MODE:-acceptEdits}"
GOAL_CLAUDE_MD="${GOAL_CLAUDE_MD:-ralph/CLAUDE.goal.md}"
SKIP_CLAUDE_MD_SWAP="${SKIP_CLAUDE_MD_SWAP:-0}"

export CLAUDE_CODE_GOAL_MAX_STOP_CONTINUES="${CLAUDE_CODE_GOAL_MAX_STOP_CONTINUES:-5}"

if [ ! -f "$PRD" ]; then
  echo "ERROR: $PRD not found." >&2
  exit 1
fi

# Verify story exists and is built
STORY_STATUS=$(python3 -c "
import json
prd = json.load(open('$PRD'))
story = next((s for s in prd if s['id'] == '$STORY_ID'), None)
if not story:
    print('NOT_FOUND')
elif not story.get('passes', False):
    print('NOT_BUILT')
elif story.get('qa_tested', False):
    print('ALREADY_QAD')
else:
    print('READY')
")

case "$STORY_STATUS" in
  NOT_FOUND)
    echo "ERROR: Story '$STORY_ID' not found in $PRD." >&2
    exit 1
    ;;
  NOT_BUILT)
    echo "ERROR: Story '$STORY_ID' hasn't been built yet (passes:false)." >&2
    echo "Build it first: ./ralph/goal-build.sh $STORY_ID" >&2
    exit 1
    ;;
  ALREADY_QAD)
    echo "Story '$STORY_ID' already QA'd. Skipping." >&2
    exit 0
    ;;
esac

if [ ! -f "$GOAL_FILE" ]; then
  echo "ERROR: $GOAL_FILE not found." >&2
  echo "Generate it first: /playbook:ralph-goal $STORY_ID" >&2
  exit 1
fi

GOAL_CONDITION=$(cat "$GOAL_FILE")
if [ ${#GOAL_CONDITION} -gt 4000 ]; then
  echo "ERROR: QA goal condition exceeds 4000 chars." >&2
  exit 1
fi

echo "qa:${STORY_ID}:$$" > ralph/goal-current-story.txt

# Swap CLAUDE.md if needed
SWAPPED=0
if [ "$SKIP_CLAUDE_MD_SWAP" != "1" ] && [ -f "$GOAL_CLAUDE_MD" ]; then
  if [ -f CLAUDE.md ]; then
    CLAUDE_MD_LINES=$(wc -l < CLAUDE.md)
    if [ "$CLAUDE_MD_LINES" -gt 200 ]; then
      echo "[goal-qa] swapping CLAUDE.md to lean version."
      cp CLAUDE.md "CLAUDE.full.$$.md"
      cp "$GOAL_CLAUDE_MD" CLAUDE.md
      SWAPPED=1
    fi
  fi
fi

cleanup() {
  if [ "$SWAPPED" -eq 1 ] && [ -f "CLAUDE.full.$$.md" ]; then
    cp "CLAUDE.full.$$.md" CLAUDE.md
    rm -f "CLAUDE.full.$$.md"
  fi
  # Only remove tracking file if it still belongs to this process
  if [ -f ralph/goal-current-story.txt ]; then
    CURRENT=$(cat ralph/goal-current-story.txt 2>/dev/null || echo "")
    if [ "$CURRENT" = "qa:${STORY_ID}:$$" ]; then
      rm -f ralph/goal-current-story.txt
    fi
  fi
}
trap cleanup EXIT

if [ ! -f "$QA_REPORT" ]; then
  echo "[]" > "$QA_REPORT"
fi

TS=$(date -u +'%Y%m%dT%H%M%SZ')
LOG="ralph/goal-qa-${STORY_ID}-${TS}.log"

echo "───────────────────────────────────────────────────────────────"
echo "Ralph goal-mode QA"
echo "  story:        $STORY_ID"
echo "  goal file:    $GOAL_FILE"
echo "  model:        $QA_GOAL_MODEL"
echo "  permission:   $GOAL_PERMISSION_MODE"
echo "  log:          $LOG"
echo "───────────────────────────────────────────────────────────────"

set +e
claude -p "/goal $GOAL_CONDITION" \
  --model "$QA_GOAL_MODEL" \
  --permission-mode "$GOAL_PERMISSION_MODE" \
  2>&1 | tee "$LOG"
GOAL_EXIT=${PIPESTATUS[0]}
set -e

# Check if QA was completed (both prd.json flag AND report entry)
QA_DONE=$(python3 -c "
import json
prd = json.load(open('$PRD'))
story = next((s for s in prd if s['id'] == '$STORY_ID'), None)
report = json.load(open('$QA_REPORT'))
has_report = any(e.get('story_id') == '$STORY_ID' for e in report)
qa_tested = story and story.get('qa_tested', False)
print('yes' if qa_tested and has_report else 'no')
")

echo ""
echo "───────────────────────────────────────────────────────────────"
echo "Goal-mode QA result: $STORY_ID"
echo "  exit code:    $GOAL_EXIT"
echo "  qa_tested:    $QA_DONE"
echo "  log:          $LOG"
if [ "$QA_DONE" = "no" ]; then
  echo ""
  echo "  QA did not complete. Check $LOG for details."
  echo "  Retry: ./ralph/goal-qa.sh $STORY_ID"
fi
echo "───────────────────────────────────────────────────────────────"

if [ "$QA_DONE" = "no" ]; then
  exit 1
fi
