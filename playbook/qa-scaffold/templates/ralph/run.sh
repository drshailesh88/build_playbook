#!/usr/bin/env bash
# Ralph master entrypoint — chains build (Claude Opus) → QA (Codex).
#
# Three-layer testing stack:
#   1. Build (this script, phase 1)    — Claude Opus builds features TDD-first
#   2. QA (this script, phase 2)       — Codex independently evaluates, fixes bugs
#   3. YOUR QA pipeline (after this)   — /playbook:qa-run — the ungameable judge
#
# Usage: ./ralph/run.sh [build_iters=999] [qa_iters=999]

set -euo pipefail
cd "$(dirname "$0")/.."

BUILD_ITERS="${1:-999}"
QA_ITERS="${2:-999}"
PRD=ralph/prd.json
PROGRESS=ralph/progress.txt
QA_PROGRESS=ralph/qa-progress.txt

if [ ! -f "$PRD" ]; then
  echo "ERROR: $PRD not found. Run /playbook:prd-to-ralph first." >&2
  exit 1
fi

# Initialize progress.txt if missing (seeded with Codebase Patterns header).
if [ ! -f "$PROGRESS" ]; then
  cat > "$PROGRESS" <<'PROG_EOF'
# Ralph Progress Log

## Codebase Patterns

<!-- Reusable patterns discovered during builds. Ralph writes here. -->

## Iteration log

<!-- Dated entries per completed story, appended by build agent. -->
PROG_EOF
  echo "Initialized $PROGRESS"
fi

TS=$(date -u +'%Y%m%dT%H%M%SZ')
LOG="ralph/ralph-$TS.log"
START_EPOCH=$(date +%s)

count_passes() {
  python3 -c "import json; d=json.load(open('$PRD')); print(sum(1 for x in d if x.get('passes', False)))"
}
count_qa() {
  python3 -c "import json; d=json.load(open('$PRD')); print(sum(1 for x in d if x.get('qa_tested', False)))"
}
count_total() {
  python3 -c "import json; d=json.load(open('$PRD')); print(len(d))"
}

START_PASSES=$(count_passes)
START_QA=$(count_qa)
TOTAL=$(count_total)

echo "─ Ralph full run ─"
echo "  log:         $LOG"
echo "  start:       $START_PASSES/$TOTAL built, $START_QA/$TOTAL QA'd"
echo "  max iter:    build=$BUILD_ITERS, qa=$QA_ITERS"
echo ""

# Phase 1: Build (Claude Opus)
echo ">>> Phase 1/2: Build (Claude Opus 4.6)"
echo ""
set +e
./ralph/build.sh "$BUILD_ITERS" 2>&1 | tee "$LOG"
BUILD_EXIT=${PIPESTATUS[0]}
set -e

# Phase 2: QA (Codex) — only if build completed cleanly
if [ "$BUILD_EXIT" -eq 0 ]; then
  echo ""
  echo ">>> Phase 2/2: QA (Codex as independent evaluator)"
  echo ""
  set +e
  ./ralph/qa.sh "$QA_ITERS" 2>&1 | tee -a "$LOG"
  QA_EXIT=${PIPESTATUS[0]}
  set -e
else
  echo ""
  echo "Build exited non-zero ($BUILD_EXIT). Skipping QA phase."
  QA_EXIT=255
fi

END_EPOCH=$(date +%s)
DURATION=$((END_EPOCH - START_EPOCH))
HOURS=$((DURATION / 3600))
MINUTES=$(((DURATION % 3600) / 60))

END_PASSES=$(count_passes)
END_QA=$(count_qa)
DELTA_BUILT=$((END_PASSES - START_PASSES))
DELTA_QA=$((END_QA - START_QA))

SUMMARY="Ralph done: built $END_PASSES/$TOTAL (+$DELTA_BUILT), QA'd $END_QA/$TOTAL (+$DELTA_QA) in ${HOURS}h${MINUTES}m"

echo ""
echo "───────────────────────────────────────────────────────────────"
echo "$SUMMARY"
echo "  log:         $LOG"
echo "  build exit:  $BUILD_EXIT"
echo "  qa exit:     $QA_EXIT"
echo ""
echo "Next: run your hardened QA pipeline — /playbook:qa-run"
echo "───────────────────────────────────────────────────────────────"

# macOS notification (silent no-op on other platforms)
if command -v osascript >/dev/null 2>&1; then
  osascript -e "display notification \"$SUMMARY\" with title \"Ralph\"" || true
fi

# Open progress.txt so the user can read what was built (macOS only; best-effort)
if command -v open >/dev/null 2>&1; then
  open "$PROGRESS" || true
fi

exit "$BUILD_EXIT"
