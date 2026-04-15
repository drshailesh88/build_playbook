#!/usr/bin/env bash
# Ralph build loop — adapted from Huntley's methodology.
#
# Each iteration invokes Claude Code headless with the PRD + progress + last
# 10 RALPH commits. Claude picks the first passes:false story, implements it
# TDD-first, commits with RALPH: prefix, flips passes:true, appends to
# progress.txt, and signals <promise>NEXT</promise> (or COMPLETE when done).
#
# Usage:   ./ralph/build.sh [max_iterations=999]
# Stops:   on <promise>COMPLETE</promise>, max_iterations, <promise>ABORT</promise>, or Ctrl-C.

set -euo pipefail
cd "$(dirname "$0")/.."

MAX_ITER="${1:-999}"
PRD=ralph/prd.json
PROGRESS=ralph/progress.txt
BUILD_PROMPT=ralph/build-prompt.md
ITER_TIMEOUT=1800   # 30-minute hard wall-clock per iteration (gtimeout/timeout)
SLEEP_BETWEEN=3

if [ ! -f "$PRD" ]; then
  echo "ERROR: $PRD not found. Run /playbook:prd-to-ralph first." >&2
  exit 1
fi

if [ ! -f "$BUILD_PROMPT" ]; then
  echo "ERROR: $BUILD_PROMPT not found. Run /playbook:scaffold-ralph first." >&2
  exit 1
fi

# Resolve timeout command (macOS ships without `timeout`; coreutils supplies `gtimeout`).
# Without one, an iteration can hang indefinitely — so we WARN but don't fail.
if command -v timeout >/dev/null 2>&1; then
  TIMEOUT_CMD=(timeout "$ITER_TIMEOUT")
elif command -v gtimeout >/dev/null 2>&1; then
  TIMEOUT_CMD=(gtimeout "$ITER_TIMEOUT")
else
  echo "WARNING: no timeout command found. Install via 'brew install coreutils' on macOS for gtimeout." >&2
  echo "         Iterations will run without a time limit — Ctrl-C if hung." >&2
  TIMEOUT_CMD=()
fi

count_passes() {
  python3 -c "import json; d=json.load(open('$PRD')); print(sum(1 for x in d if x.get('passes', False)))"
}
count_total() {
  python3 -c "import json; d=json.load(open('$PRD')); print(len(d))"
}

TOTAL=$(count_total)
START_PASSES=$(count_passes)

echo "───────────────────────────────────────────────────────────────"
echo "Ralph build loop"
echo "  prd:        $PRD  ($TOTAL stories, $START_PASSES already passing)"
echo "  max iter:   $MAX_ITER"
echo "  timeout:    ${ITER_TIMEOUT}s per iter (${TIMEOUT_CMD[0]:-none})"
echo "  model:      claude-opus-4-6"
echo "───────────────────────────────────────────────────────────────"

for i in $(seq 1 "$MAX_ITER"); do
  PASSES=$(count_passes)
  REMAINING=$((TOTAL - PASSES))
  echo ""
  echo "═══ iter $i/$MAX_ITER — $PASSES/$TOTAL passing ($REMAINING remaining) ══"
  echo ""

  if [ "$PASSES" -ge "$TOTAL" ]; then
    echo "All $TOTAL stories complete. Ralph build done."
    break
  fi

  # Last 10 RALPH-prefixed git commits, inline.
  RECENT_COMMITS=$(git log --grep='^RALPH:' -n 10 --format='%H%n%ad%n%B---' --date=short 2>/dev/null || echo '(no RALPH commits yet)')

  # Compose the iteration prompt. File-refs use @path syntax so Claude Code
  # loads them as context; inline RECENT_COMMITS is appended.
  PROMPT=$(cat <<EOF
@$BUILD_PROMPT
@CLAUDE.md
@$PRD
@$PROGRESS

## Recent RALPH commits (last 10)

\`\`\`
$RECENT_COMMITS
\`\`\`

## Iteration

This is Ralph iteration $i. $PASSES of $TOTAL stories already pass.
Pick the FIRST entry in $PRD where passes:false. Follow $BUILD_PROMPT.
EOF
)

  set +e
  OUTPUT=$("${TIMEOUT_CMD[@]}" claude \
    --dangerously-skip-permissions \
    --print \
    --model claude-opus-4-6 \
    "$PROMPT" 2>&1)
  CLAUDE_EXIT=$?
  set -e

  echo "$OUTPUT" | tail -20

  if echo "$OUTPUT" | grep -q '<promise>COMPLETE</promise>'; then
    echo ""
    echo "Ralph signaled COMPLETE."
    break
  elif echo "$OUTPUT" | grep -q '<promise>ABORT</promise>'; then
    echo ""
    echo "Ralph signaled ABORT — a story is blocked. Stopping." >&2
    exit 2
  elif echo "$OUTPUT" | grep -q '<promise>NEXT</promise>'; then
    : # one story done, continue
  else
    echo ""
    echo "No promise tag found (exit=$CLAUDE_EXIT). Restarting iteration."
  fi

  sleep "$SLEEP_BETWEEN"
done

FINAL_PASSES=$(count_passes)
DELTA=$((FINAL_PASSES - START_PASSES))
echo ""
echo "───────────────────────────────────────────────────────────────"
echo "Ralph build summary: $FINAL_PASSES/$TOTAL passing  (+$DELTA this run)"
echo "───────────────────────────────────────────────────────────────"
