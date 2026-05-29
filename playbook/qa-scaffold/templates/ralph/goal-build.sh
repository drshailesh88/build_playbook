#!/usr/bin/env bash
# Ralph goal-mode build — run a single story via Claude Code /goal.
#
# Instead of build.sh's external bash loop (fresh context each iteration),
# /goal runs Worker (Opus) continuously with Judge (Haiku) evaluating
# completion after each turn. The worker retains full context across turns.
#
# Prerequisites:
#   - ralph/goals/{story-id}.build.goal exists (run /playbook:ralph-goal first)
#   - ralph/CLAUDE.goal.md exists (lean CLAUDE.md for judge)
#   - .claude/hooks/goal-acceptance-gate.sh installed
#
# Env overrides:
#   GOAL_MODEL=<id>                     default claude-opus-4-6
#   GOAL_PERMISSION_MODE=<mode>         default acceptEdits
#   CLAUDE_CODE_GOAL_MAX_STOP_CONTINUES default 5
#   GOAL_CLAUDE_MD=<path>               default ralph/CLAUDE.goal.md
#   SKIP_CLAUDE_MD_SWAP=1               don't swap CLAUDE.md
#
# Usage: ./ralph/goal-build.sh <story-id>

set -euo pipefail
cd "$(dirname "$0")/.."

STORY_ID="${1:?Usage: ./ralph/goal-build.sh <story-id>}"
PRD=ralph/prd.json
GOAL_FILE="ralph/goals/${STORY_ID}.build.goal"
GOAL_MODEL="${GOAL_MODEL:-claude-opus-4-6}"
GOAL_PERMISSION_MODE="${GOAL_PERMISSION_MODE:-acceptEdits}"
GOAL_CLAUDE_MD="${GOAL_CLAUDE_MD:-ralph/CLAUDE.goal.md}"
SKIP_CLAUDE_MD_SWAP="${SKIP_CLAUDE_MD_SWAP:-0}"

export CLAUDE_CODE_GOAL_MAX_STOP_CONTINUES="${CLAUDE_CODE_GOAL_MAX_STOP_CONTINUES:-5}"

if [ ! -f "$PRD" ]; then
  echo "ERROR: $PRD not found. Run /playbook:prd-to-ralph first." >&2
  exit 1
fi

# Verify story exists and hasn't passed yet
STORY_STATUS=$(python3 -c "
import json, sys
prd = json.load(open('$PRD'))
story = next((s for s in prd if s['id'] == '$STORY_ID'), None)
if not story:
    print('NOT_FOUND')
elif story.get('passes', False):
    print('ALREADY_PASSES')
else:
    print('READY')
")

case "$STORY_STATUS" in
  NOT_FOUND)
    echo "ERROR: Story '$STORY_ID' not found in $PRD." >&2
    echo "Available stories:" >&2
    python3 -c "import json; [print(f'  {s[\"id\"]} — {s[\"description\"][:60]}') for s in json.load(open('$PRD')) if not s.get('passes')]" >&2
    exit 1
    ;;
  ALREADY_PASSES)
    echo "Story '$STORY_ID' already passes. Nothing to build." >&2
    echo "To QA it: ./ralph/goal-qa.sh $STORY_ID" >&2
    exit 0
    ;;
esac

# Check goal file exists
if [ ! -f "$GOAL_FILE" ]; then
  echo "ERROR: $GOAL_FILE not found." >&2
  echo "Generate it first: /playbook:ralph-goal $STORY_ID" >&2
  exit 1
fi

# Read goal condition
GOAL_CONDITION=$(cat "$GOAL_FILE")
if [ ${#GOAL_CONDITION} -gt 4000 ]; then
  echo "ERROR: Goal condition exceeds 4000 chars (${#GOAL_CONDITION}). Regenerate with /playbook:ralph-goal." >&2
  exit 1
fi

# Track current story + mode for the acceptance gate hook (PID-safe)
echo "build:${STORY_ID}:$$" > ralph/goal-current-story.txt

# Swap CLAUDE.md to lean version (judge reads it every tick)
SWAPPED=0
if [ "$SKIP_CLAUDE_MD_SWAP" != "1" ] && [ -f "$GOAL_CLAUDE_MD" ]; then
  if [ -f CLAUDE.md ]; then
    CLAUDE_MD_LINES=$(wc -l < CLAUDE.md)
    if [ "$CLAUDE_MD_LINES" -gt 200 ]; then
      echo "[goal] CLAUDE.md is ${CLAUDE_MD_LINES} lines — swapping to lean version for judge efficiency."
      cp CLAUDE.md "CLAUDE.full.$$.md"
      cp "$GOAL_CLAUDE_MD" CLAUDE.md
      SWAPPED=1
    fi
  fi
fi

# Cleanup on exit: restore CLAUDE.md and remove tracking file
cleanup() {
  if [ "$SWAPPED" -eq 1 ] && [ -f "CLAUDE.full.$$.md" ]; then
    cp "CLAUDE.full.$$.md" CLAUDE.md
    rm -f "CLAUDE.full.$$.md"
    echo "[goal] restored CLAUDE.md from backup."
  fi
  rm -f ralph/goal-current-story.txt
}
trap cleanup EXIT

count_passes() {
  python3 -c "import json; d=json.load(open('$PRD')); print(sum(1 for x in d if x.get('passes', False)))"
}

PASSES_BEFORE=$(count_passes)
TS=$(date -u +'%Y%m%dT%H%M%SZ')
LOG="ralph/goal-${STORY_ID}-${TS}.log"

echo "───────────────────────────────────────────────────────────────"
echo "Ralph goal-mode build"
echo "  story:        $STORY_ID"
echo "  goal file:    $GOAL_FILE"
echo "  model:        $GOAL_MODEL"
echo "  permission:   $GOAL_PERMISSION_MODE"
echo "  max stops:    $CLAUDE_CODE_GOAL_MAX_STOP_CONTINUES"
echo "  log:          $LOG"
echo "  claude.md:    $([ $SWAPPED -eq 1 ] && echo 'swapped to lean' || echo 'unchanged')"
echo "───────────────────────────────────────────────────────────────"

set +e
claude -p "/goal $GOAL_CONDITION" \
  --model "$GOAL_MODEL" \
  --permission-mode "$GOAL_PERMISSION_MODE" \
  2>&1 | tee "$LOG"
GOAL_EXIT=${PIPESTATUS[0]}
set -e

PASSES_AFTER=$(count_passes)
DELTA=$((PASSES_AFTER - PASSES_BEFORE))

# Check if the story actually passed
STORY_PASSED=$(python3 -c "
import json
prd = json.load(open('$PRD'))
story = next((s for s in prd if s['id'] == '$STORY_ID'), None)
print('yes' if story and story.get('passes', False) else 'no')
")

echo ""
echo "───────────────────────────────────────────────────────────────"
echo "Goal-mode result: $STORY_ID"
echo "  exit code:    $GOAL_EXIT"
echo "  story passed: $STORY_PASSED"
echo "  passes delta: +$DELTA (before: $PASSES_BEFORE, after: $PASSES_AFTER)"
echo "  log:          $LOG"

if [ "$STORY_PASSED" = "yes" ]; then
  echo ""
  echo "  Next: QA this story:"
  echo "    ./ralph/goal-qa.sh $STORY_ID"
else
  echo ""
  echo "  Story did not pass. Check $LOG for details."
  echo "  Retry: ./ralph/goal-build.sh $STORY_ID"
  echo "  Debug: open claude and /goal interactively"
fi
echo "───────────────────────────────────────────────────────────────"

if [ "$STORY_PASSED" = "no" ]; then
  exit 1
fi
