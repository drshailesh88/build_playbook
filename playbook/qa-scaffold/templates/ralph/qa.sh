#!/usr/bin/env bash
# Ralph QA loop — Codex as independent evaluator (Huntley's pattern).
#
# A DIFFERENT model from the builder. Verifies every feature the build agent
# claimed passes. Fixes the CODE when bugs are found (never the tests).
# Writes structured findings to qa-report.json. Iterates until every
# passes:true entry is also qa_tested:true, or signals QA_COMPLETE.
#
# Usage:   ./ralph/qa.sh [max_iterations=999]
# Stops:   on <promise>QA_COMPLETE</promise>, max_iterations,
#          <promise>ABORT</promise>, or Ctrl-C.

set -euo pipefail
cd "$(dirname "$0")/.."

MAX_ITER="${1:-999}"
PRD=ralph/prd.json
QA_PROGRESS=ralph/qa-progress.txt
QA_PROMPT=ralph/qa-prompt.md
QA_REPORT=ralph/qa-report.json
ITER_TIMEOUT=1200
SLEEP_BETWEEN=3

if [ ! -f "$PRD" ]; then
  echo "ERROR: $PRD not found. Run the build loop first." >&2
  exit 1
fi

if [ ! -f "$QA_PROMPT" ]; then
  echo "ERROR: $QA_PROMPT not found. Run /playbook:scaffold-ralph first." >&2
  exit 1
fi

if ! command -v codex >/dev/null 2>&1; then
  echo "ERROR: codex CLI not found. Install Codex CLI to run the QA loop." >&2
  exit 3
fi

if [ ! -f "$QA_REPORT" ]; then
  echo '[]' > "$QA_REPORT"
fi

if [ ! -f "$QA_PROGRESS" ]; then
  cat > "$QA_PROGRESS" <<'PROG_EOF'
# Ralph QA Progress — Codex independent evaluator

## Iteration log
PROG_EOF
fi

# Pending QA = built (passes:true) but not yet qa_tested:true.
count_pending_qa() {
  python3 -c "
import json
d = json.load(open('$PRD'))
print(sum(1 for x in d if x.get('passes', False) and not x.get('qa_tested', False)))
"
}
count_qa_done() {
  python3 -c "
import json
d = json.load(open('$PRD'))
print(sum(1 for x in d if x.get('qa_tested', False)))
"
}
count_total() {
  python3 -c "import json; d=json.load(open('$PRD')); print(len(d))"
}

TOTAL=$(count_total)
START_QA=$(count_qa_done)

echo "───────────────────────────────────────────────────────────────"
echo "Ralph QA loop (Codex — independent evaluator)"
echo "  prd:        $PRD"
echo "  qa report:  $QA_REPORT"
echo "  start:      $START_QA/$TOTAL already QA'd"
echo "  max iter:   $MAX_ITER"
echo "  timeout:    ${ITER_TIMEOUT}s per iter"
echo "───────────────────────────────────────────────────────────────"

for i in $(seq 1 "$MAX_ITER"); do
  PENDING=$(count_pending_qa)
  DONE=$(count_qa_done)
  echo ""
  echo "═══ QA iter $i/$MAX_ITER — $DONE/$TOTAL QA'd ($PENDING pending) ══"
  echo ""

  if [ "$PENDING" -eq 0 ]; then
    echo "No pending QA. Exiting."
    break
  fi

  RECENT_QA=$(git log --grep='^QA:' -n 10 --format='%H%n%ad%n%B---' --date=short 2>/dev/null || echo '(no QA commits yet)')

  PROMPT=$(cat <<EOF
@$QA_PROMPT
@CLAUDE.md
@$PRD
@$QA_PROGRESS
@$QA_REPORT

## Recent QA commits (last 10)

\`\`\`
$RECENT_QA
\`\`\`

## Iteration

This is QA iter $i. $DONE of $TOTAL features QA'd; $PENDING pending.
Pick the FIRST entry where passes:true AND qa_tested is missing or false.
You are a DIFFERENT agent from the builder. Do not trust that features
work just because passes:true. Verify independently. Follow $QA_PROMPT.
EOF
)

  set +e
  OUTPUT=$(timeout "$ITER_TIMEOUT" codex exec \
    --dangerously-bypass-approvals-and-sandbox \
    "$PROMPT" 2>&1)
  CODEX_EXIT=$?
  set -e

  echo "$OUTPUT" | tail -20

  if echo "$OUTPUT" | grep -q '<promise>QA_COMPLETE</promise>'; then
    echo ""
    echo "QA signaled QA_COMPLETE."
    break
  elif echo "$OUTPUT" | grep -q '<promise>ABORT</promise>'; then
    echo ""
    echo "QA signaled ABORT. Stopping." >&2
    exit 2
  elif echo "$OUTPUT" | grep -q '<promise>NEXT</promise>'; then
    :
  else
    echo ""
    echo "No promise tag (exit=$CODEX_EXIT). Restarting iteration."
  fi

  sleep "$SLEEP_BETWEEN"
done

FINAL_QA=$(count_qa_done)
DELTA=$((FINAL_QA - START_QA))
echo ""
echo "───────────────────────────────────────────────────────────────"
echo "QA summary: $FINAL_QA/$TOTAL QA'd  (+$DELTA this run)"
echo "  qa report:  $QA_REPORT"
echo "───────────────────────────────────────────────────────────────"
