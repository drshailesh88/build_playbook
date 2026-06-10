#!/usr/bin/env bash
# Ralph master entrypoint — chains build → QA → harden (+ future loops).
#
# Phase sequence (all independently runnable — see individual scripts):
#   1. Build         (build.sh — Claude Opus builds features TDD-first)
#   2. Verify        (qa.sh — Codex independently evaluates, fixes bugs)
#   3. Harden        (harden.sh — Claude Sonnet kills surviving mutants)
#
#   Future phases chained here as they're built:
#   4. Completeness  (harden-completeness.sh — catch features builder skipped)
#   5. Adversarial   (harden-adversarial.sh — red-team attacks)
#   6. Drift         (harden-drift.sh — runtime vs frozen contracts)
#   7. Security      (harden-security.sh — OWASP findings loop)
#
# After phases complete, emits a summary notification and opens progress files.
# Run individual phases directly while debugging; use this script once the
# pipeline is stable for overnight runs.
#
# Usage: ./ralph/run.sh [build_iters=999] [qa_iters=999] [harden_iters=999]
# Skip phases: BUILD_SKIP=1 QA_SKIP=1 HARDEN_SKIP=1 ./ralph/run.sh

set -euo pipefail
cd "$(dirname "$0")/.."

BUILD_ITERS="${1:-999}"
QA_ITERS="${2:-999}"
HARDEN_ITERS="${3:-999}"
PRD=ralph/prd.json
PROGRESS=ralph/progress.txt
QA_PROGRESS=ralph/qa-progress.txt
HARDEN_PROGRESS=ralph/harden-progress.txt

BUILD_SKIP="${BUILD_SKIP:-0}"
QA_SKIP="${QA_SKIP:-0}"
HARDEN_SKIP="${HARDEN_SKIP:-0}"

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
echo "  max iter:    build=$BUILD_ITERS, qa=$QA_ITERS, harden=$HARDEN_ITERS"
echo "  skip:        build=$BUILD_SKIP, qa=$QA_SKIP, harden=$HARDEN_SKIP"
echo ""

# Freeze success contracts before any building (DEC-005). Idempotent: only
# unfrozen stories get contracts; frozen contracts are never regenerated.
touch "$LOG"
if [ -x ./ralph/freeze-contracts.sh ]; then
  ./ralph/freeze-contracts.sh 2>&1 | tee -a "$LOG"
fi

# Hard run budget (Phase 4): wall-clock cap enforced by the loops at
# iteration boundaries — outside the agent, where it cannot be negotiated.
RUN_BUDGET_SECONDS="${RUN_BUDGET_SECONDS:-0}"
rm -f ralph/.budget-warned
if [ "$RUN_BUDGET_SECONDS" -gt 0 ]; then
  export RALPH_RUN_START="$START_EPOCH"
  export RALPH_DEADLINE=$((START_EPOCH + RUN_BUDGET_SECONDS))
  echo "  budget:      ${RUN_BUDGET_SECONDS}s wall-clock (hard stop at iteration boundaries, exit 4)"
fi

# GitHub source of truth (DEC-004 Phase 3): sync issue state in, mark the run.
if [ -x ./ralph/gh-state.sh ]; then
  ./ralph/gh-state.sh pull 2>&1 | tee -a "$LOG" || true
  ./ralph/gh-state.sh cursor phase=build run_id="$TS" iteration=0 deadline="${RALPH_DEADLINE:-0}" >/dev/null 2>&1 || true
fi

# Aggregate-drift baseline (DEC-009): snapshot deps/schema/config so the
# end-of-run audit can catch cross-story accumulation no per-story check sees.
if [ -x ./ralph/drift-audit.sh ]; then
  ./ralph/drift-audit.sh snapshot 2>&1 | tee -a "$LOG" || true
fi

# Phases 1+2: Build ↔ QA bounce loop (DEC-004). The QA loop's judge gate can
# reject stories back to passes:false; a bounce round sends them through the
# build loop again with the judge verdict as feedback.
MAX_BOUNCES="${RALPH_MAX_BOUNCES:-1}"
ROUND=0
BUILD_EXIT=0
QA_EXIT=0
while :; do
  if [ "$BUILD_SKIP" = "1" ]; then
    echo ">>> Phase 1/3: Build — SKIPPED (BUILD_SKIP=1)"
    BUILD_EXIT=0
  else
    echo ">>> Phase 1/3: Build (Claude Opus 4.6) — round $((ROUND + 1))"
    echo ""
    set +e
    ./ralph/build.sh "$BUILD_ITERS" 2>&1 | tee -a "$LOG"
    BUILD_EXIT=${PIPESTATUS[0]}
    set -e
  fi

  if [ "$QA_SKIP" = "1" ]; then
    echo ""
    echo ">>> Phase 2/3: QA — SKIPPED (QA_SKIP=1)"
    QA_EXIT=0
    break
  elif [ "$BUILD_EXIT" -ne 0 ]; then
    echo ""
    echo "Build exited non-zero ($BUILD_EXIT). Skipping QA phase."
    QA_EXIT=255
    break
  fi

  echo ""
  echo ">>> Phase 2/3: QA (Codex as independent evaluator)"
  echo ""
  PASSES_BEFORE_QA=$(count_passes)
  set +e
  ./ralph/qa.sh "$QA_ITERS" 2>&1 | tee -a "$LOG"
  QA_EXIT=${PIPESTATUS[0]}
  set -e
  PASSES_AFTER_QA=$(count_passes)

  if [ "$PASSES_AFTER_QA" -lt "$PASSES_BEFORE_QA" ] \
     && [ "$ROUND" -lt "$MAX_BOUNCES" ] && [ "$BUILD_SKIP" != "1" ]; then
    ROUND=$((ROUND + 1))
    REJECTED=$((PASSES_BEFORE_QA - PASSES_AFTER_QA))
    echo ""
    echo ">>> Judge rejected $REJECTED stories during QA — bounce round $ROUND/$MAX_BOUNCES (builder retries with verdict feedback)"
    echo ""
    continue
  fi
  break
done

# Phase 3: Harden (Claude Sonnet) — only if QA completed cleanly
if [ "$HARDEN_SKIP" = "1" ]; then
  echo ""
  echo ">>> Phase 3/3: Harden — SKIPPED (HARDEN_SKIP=1)"
  HARDEN_EXIT=0
elif [ "$QA_EXIT" -eq 0 ]; then
  echo ""
  echo ">>> Phase 3/3: Harden (Claude Sonnet 4.6 — test quality)"
  echo ""
  if [ -x ./ralph/harden.sh ]; then
    set +e
    ./ralph/harden.sh "$HARDEN_ITERS" 2>&1 | tee -a "$LOG"
    HARDEN_EXIT=${PIPESTATUS[0]}
    set -e
  else
    echo "ralph/harden.sh not installed or not executable. Skipping."
    echo "Install via /playbook:install-qa-harness."
    HARDEN_EXIT=0
  fi
else
  echo ""
  echo "QA exited non-zero ($QA_EXIT). Skipping harden phase."
  HARDEN_EXIT=255
fi

# Aggregate-drift audit (DEC-009): non-blocking; unattributed changes land
# in drift-report.json and the tracking issue for /morning-review.
DRIFT_EXIT=0
if [ -x ./ralph/drift-audit.sh ]; then
  echo ""
  echo ">>> Drift audit (deps/schema/config vs run baseline)"
  set +e
  ./ralph/drift-audit.sh audit 2>&1 | tee -a "$LOG"
  DRIFT_EXIT=${PIPESTATUS[0]}
  set -e
fi

END_EPOCH=$(date +%s)
DURATION=$((END_EPOCH - START_EPOCH))
HOURS=$((DURATION / 3600))
MINUTES=$(((DURATION % 3600) / 60))

END_PASSES=$(count_passes)
END_QA=$(count_qa)
DELTA_BUILT=$((END_PASSES - START_PASSES))
DELTA_QA=$((END_QA - START_QA))

# Harden status — read .quality/state.json if it exists.
# Schema: modules is a DICT keyed by path; each has tier + has_exceeded_floor.
# ui_gates_only modules are excluded (no mutation floor).
HARDEN_STATUS=""
if [ -f .quality/state.json ]; then
  HARDEN_STATUS=$(python3 -c "
import json
def has_floor(tier):
    if not tier or 'ui_gates_only' in tier:
        return False
    parts = tier.rsplit('_', 1)
    return len(parts) == 2 and parts[1].isdigit()
try:
    s = json.load(open('.quality/state.json'))
    mods = s.get('modules', {})
    tracked = [(p, m) for p, m in mods.items() if has_floor(m.get('tier'))]
    below = sum(1 for _, m in tracked if not m.get('has_exceeded_floor', False))
    total = len(tracked)
    print(f'{total-below}/{total} at floor')
except Exception:
    print('(state.json unreadable)')
" 2>/dev/null || echo '')
fi

SUMMARY="Ralph done: built $END_PASSES/$TOTAL (+$DELTA_BUILT), QA'd $END_QA/$TOTAL (+$DELTA_QA)"
if [ -n "$HARDEN_STATUS" ]; then
  SUMMARY="$SUMMARY, hardened $HARDEN_STATUS"
fi
SUMMARY="$SUMMARY in ${HOURS}h${MINUTES}m"
if [ "$DRIFT_EXIT" -ne 0 ]; then
  SUMMARY="$SUMMARY — DRIFT: unattributed dep/schema/config changes (see drift-report.json)"
fi

echo ""
echo "───────────────────────────────────────────────────────────────"
echo "$SUMMARY"
echo "  log:         $LOG"
echo "  build exit:  $BUILD_EXIT"
echo "  qa exit:     $QA_EXIT"
echo "  harden exit: $HARDEN_EXIT"
echo ""
if [ "$HARDEN_EXIT" -ne 0 ] && [ "$HARDEN_EXIT" -ne 255 ]; then
  echo "Harden plateaued or aborted. Inspect ralph/harden-report.json and"
  echo "consider /playbook:qa-unblock <feature> before the next run."
fi
echo "Release gate: /playbook:qa-run  (runs release gates, produces summary.md)"
echo "───────────────────────────────────────────────────────────────"

# Close out the run on the tracking issue (crash recovery reads this cursor).
if [ -x ./ralph/gh-state.sh ]; then
  ./ralph/gh-state.sh cursor phase=idle story= iteration=0 >/dev/null 2>&1 || true
  ./ralph/gh-state.sh note "**Run $TS finished.** $SUMMARY (build exit $BUILD_EXIT, qa exit $QA_EXIT, harden exit $HARDEN_EXIT)" || true
fi

# macOS notification (silent no-op on other platforms)
if command -v osascript >/dev/null 2>&1; then
  osascript -e "display notification \"$SUMMARY\" with title \"Ralph\"" || true
fi

# Open progress.txt so the user can read what was built (macOS only; best-effort)
if command -v open >/dev/null 2>&1; then
  open "$PROGRESS" || true
fi

# Exit with the first non-zero non-skip code; skipping (255) is not an error.
for CODE in "$BUILD_EXIT" "$QA_EXIT" "$HARDEN_EXIT"; do
  if [ "$CODE" -ne 0 ] && [ "$CODE" -ne 255 ]; then
    exit "$CODE"
  fi
done
exit 0
