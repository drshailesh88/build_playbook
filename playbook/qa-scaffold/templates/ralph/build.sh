#!/usr/bin/env bash
# Ralph build loop — adapted from Huntley's pattern 
#
# Usage:   ./ralph/build.sh [max_iterations=999]
# Stops:   on <promise>COMPLETE</promise>, max_iterations, or Ctrl-C.

set -euo pipefail
cd "$(dirname "$0")/.."

MAX_ITER="${1:-999}"
PRD=ralph/prd.json
PROGRESS=ralph/progress.txt
ITER_TIMEOUT=1800   # 30-minute hard wall-clock per iteration (gtimeout/timeout)
SLEEP_BETWEEN=3

# Circuit breaker — deterministic gutter detection
CONSECUTIVE_NO_FLIP=0
MAX_CONSECUTIVE_NO_FLIP="${MAX_CONSECUTIVE_NO_FLIP:-3}"
STORY_WALL_CLOCK="${STORY_WALL_CLOCK:-2700}"  # 45 min total per story (across retries)
SAME_STORY_START=""
LAST_STORY_ID=""
CIRCUIT_BREAKER_TRIGGERED=""

if [ ! -f "$PRD" ]; then
  echo "ERROR: $PRD not found. Run /playbook:prd-to-ralph first." >&2
  exit 1
fi

# Freeze success contracts BEFORE any building (DEC-005). Idempotent: only
# unfrozen stories get contracts; existing contracts are never regenerated.
if [ -x ./ralph/freeze-contracts.sh ]; then
  ./ralph/freeze-contracts.sh
fi

# GitHub is the source of truth (DEC-004 Phase 3): sync issue labels into
# prd.json flags before building — a human relabeling an issue on GitHub
# re-queues or parks stories without touching the VPS.
if [ -x ./ralph/gh-state.sh ]; then
  ./ralph/gh-state.sh pull || true
fi

JUDGE_MAX_FAILURES="${JUDGE_MAX_FAILURES:-3}"

# Resolve timeout command (macOS ships without `timeout`; coreutils supplies `gtimeout`).
if command -v timeout >/dev/null 2>&1; then
  TIMEOUT_CMD=(timeout "$ITER_TIMEOUT")
elif command -v gtimeout >/dev/null 2>&1; then
  TIMEOUT_CMD=(gtimeout "$ITER_TIMEOUT")
else
  echo "WARNING: no timeout command found (install coreutils for gtimeout). Iterations will run without time limit — Ctrl-C if hung." >&2
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
if [ ${#TIMEOUT_CMD[@]} -gt 0 ]; then
  echo "  timeout:    ${ITER_TIMEOUT}s per iter (${TIMEOUT_CMD[0]})"
else
  echo "  timeout:    (none available)"
fi
echo "───────────────────────────────────────────────────────────────"

for i in $(seq 1 "$MAX_ITER"); do
  PASSES=$(count_passes)
  REMAINING=$((TOTAL - PASSES))
  echo ""
  echo "═══ iter $i/$MAX_ITER — $PASSES/$TOTAL passing ($REMAINING remaining) ══"
  echo ""

  if [ "$PASSES" -ge "$TOTAL" ]; then
    echo "All $TOTAL stories complete. Ralph done."
    break
  fi

  # Hard run budget (Phase 4) — checked at iteration boundaries, outside the
  # agent. exit 4 is deliberate: systemd's RestartPreventExitStatus honors it.
  if [ -n "${RALPH_DEADLINE:-}" ]; then
    NOW=$(date +%s)
    if [ "$NOW" -ge "$RALPH_DEADLINE" ]; then
      echo "RUN BUDGET EXHAUSTED — stopping cleanly at iteration boundary." >&2
      exit 4
    fi
    if [ -n "${RALPH_RUN_START:-}" ] && [ ! -f ralph/.budget-warned ] \
       && [ $(( (NOW - RALPH_RUN_START) * 5 )) -ge $(( (RALPH_DEADLINE - RALPH_RUN_START) * 4 )) ]; then
      touch ralph/.budget-warned
      echo "[budget] 80% of run budget consumed"
      [ -x ./ralph/gh-state.sh ] && { ./ralph/gh-state.sh note "**Budget warning:** 80% of run budget consumed." || true; }
      [ -n "${NOTIFY_WEBHOOK:-}" ] && curl -s -X POST "$NOTIFY_WEBHOOK" -H "Content-Type: application/json" \
        -d '{"text":"[ralph] 80% of run budget consumed"}' >/dev/null 2>&1 || true
    fi
  fi

  # Circuit breaker — record pre-iteration state. Parked (escalated) stories
  # are skipped: the factory never blocks on a human decision.
  PASSES_BEFORE=$PASSES
  CURRENT_STORY_ID=$(python3 -c "import json; d=json.load(open('$PRD')); print(next((x['id'] for x in d if not x.get('passes', False) and not x.get('parked', False)), ''))")
  if [ -z "$CURRENT_STORY_ID" ]; then
    echo "All unparked stories built — $REMAINING remaining are PARKED (escalated to human). Stopping build loop."
    break
  fi
  if [ -x ./ralph/gh-state.sh ]; then
    ./ralph/gh-state.sh cursor phase=build story="$CURRENT_STORY_ID" iteration="$i" >/dev/null 2>&1 || true
  fi
  printf '{"phase":"build","story":"%s","iteration":%s,"ts":"%s"}\n' \
    "$CURRENT_STORY_ID" "$i" "$(date -u +%FT%TZ)" > ralph/.heartbeat
  if [ "$CURRENT_STORY_ID" != "$LAST_STORY_ID" ]; then
    LAST_STORY_ID="$CURRENT_STORY_ID"
    SAME_STORY_START=$(date +%s)
  fi
  if [ -n "$SAME_STORY_START" ] && [ -n "$CURRENT_STORY_ID" ]; then
    ELAPSED_ON_STORY=$(( $(date +%s) - SAME_STORY_START ))
    if [ "$ELAPSED_ON_STORY" -ge "$STORY_WALL_CLOCK" ]; then
      echo ""
      echo "CIRCUIT BREAKER: story '$CURRENT_STORY_ID' stuck for ${ELAPSED_ON_STORY}s (limit ${STORY_WALL_CLOCK}s)." >&2
      CIRCUIT_BREAKER_TRIGGERED="wall-clock on story $CURRENT_STORY_ID (${ELAPSED_ON_STORY}s)"
      exit 3
    fi
  fi

  RECENT_COMMITS=$(git log --grep='^RALPH:' -n 10 --format='%H%n%ad%n%B---' --date=short 2>/dev/null || echo '(no RALPH commits yet)')

  # Huntley-style single-string prompt argument — no intermediate heredoc.
  set +e
  result=$("${TIMEOUT_CMD[@]}" claude -p --dangerously-skip-permissions --model claude-opus-4-6 \
"@ralph/build-prompt.md @CLAUDE.md @$PRD @$PROGRESS

ITERATION: $i of $MAX_ITER
PROGRESS: $PASSES/$TOTAL features passed
Previous RALPH commits:
$RECENT_COMMITS

Build exactly ONE feature (the first entry with passes:false and no parked:true — parked stories are escalated to a human, never touch them), then commit and stop.
Output <promise>NEXT</promise> when done.
Output <promise>COMPLETE</promise> only if ALL features pass.
Output <promise>ABORT</promise> if you cannot proceed (explain why above the tag).")
  CLAUDE_EXIT=$?
  set -e

  # Full output — visible and captured.
  echo "$result"

  # Grep only the tail to avoid matching prompt-echo of promise tags
  result_tail=$(printf '%s\n' "$result" | tail -n 40)

  if echo "$result_tail" | grep -q '<promise>COMPLETE</promise>'; then
    echo ""
    echo "Ralph signaled COMPLETE."
    break
  elif echo "$result_tail" | grep -q '<promise>ABORT</promise>'; then
    echo ""
    echo "Ralph signaled ABORT — a story is blocked. Stopping." >&2
    exit 2
  elif echo "$result_tail" | grep -q '<promise>NEXT</promise>'; then
    :
  else
    echo ""
    echo "No promise tag found (exit=$CLAUDE_EXIT). Restarting iteration."
  fi

  PASSES_AFTER=$(count_passes)

  # Judge gate (DEC-004): the builder's passes:true claim only counts if the
  # deterministic tiers agree. T2 (LLM judge) is deferred to the QA loop so
  # the build loop stays fast and free. On rejection the flag is reverted and
  # the verdict is fed to progress.txt for the next fresh-context retry.
  if [ "$PASSES_AFTER" -gt "$PASSES_BEFORE" ] && [ -n "$CURRENT_STORY_ID" ] && [ -x ./ralph/judge.sh ]; then
    set +e
    JUDGE_TIERS="${BUILD_JUDGE_TIERS:-t0,t1}" ./ralph/judge.sh "$CURRENT_STORY_ID"
    JUDGE_EXIT=$?
    set -e
    if [ "$JUDGE_EXIT" -ne 0 ]; then
      echo "[judge] $CURRENT_STORY_ID rejected (exit=$JUDGE_EXIT) — reverting passes flag"
      FAILURES=$(python3 - "$CURRENT_STORY_ID" "$PRD" <<'PY'
import json, sys
sid, prd_path = sys.argv[1], sys.argv[2]
d = json.load(open(prd_path))
for s in d:
    if s.get('id') == sid:
        s['passes'] = False
        s['judge_failures'] = s.get('judge_failures', 0) + 1
        print(s['judge_failures'])
json.dump(d, open(prd_path, 'w'), indent=2)
PY
)
      VERDICT_SUMMARY=$(python3 - "$CURRENT_STORY_ID" <<'PY'
import json, sys
try:
    v = json.load(open(f"ralph/verdicts/{sys.argv[1]}.json"))
    fails = [f"{c['id']}: {c['detail'][:120]}"
             for t in v.get('tiers', {}).values()
             for c in t.get('checks', []) if not c['pass']]
    print(f"failed tier {v.get('failed_tier')}: " + " | ".join(fails[:4]))
except Exception:
    print("(verdict unreadable)")
PY
)
      printf '\n%s — JUDGE REJECTED %s: %s\n' "$(date +%F)" "$CURRENT_STORY_ID" "$VERDICT_SUMMARY" >> "$PROGRESS"
      PASSES_AFTER=$PASSES_BEFORE
      if [ -x ./ralph/gh-state.sh ]; then
        if [ "$JUDGE_EXIT" -eq 2 ]; then
          ./ralph/gh-state.sh escalate "$CURRENT_STORY_ID" "judge T2 ESCALATE verdict" "ralph/verdicts/$CURRENT_STORY_ID.json" || true
        elif [ "${FAILURES:-0}" -ge "$JUDGE_MAX_FAILURES" ]; then
          ./ralph/gh-state.sh escalate "$CURRENT_STORY_ID" "judge rejected ${FAILURES}x (limit $JUDGE_MAX_FAILURES)" "ralph/verdicts/$CURRENT_STORY_ID.json" || true
        else
          ./ralph/gh-state.sh event "$CURRENT_STORY_ID" judge-rejected "ralph/verdicts/$CURRENT_STORY_ID.json" || true
        fi
      fi
    elif [ -x ./ralph/gh-state.sh ]; then
      ./ralph/gh-state.sh event "$CURRENT_STORY_ID" built "ralph/verdicts/$CURRENT_STORY_ID.json" || true
    fi
  fi

  # Circuit breaker — check if passes count increased
  if [ "$PASSES_AFTER" -gt "$PASSES_BEFORE" ]; then
    CONSECUTIVE_NO_FLIP=0
    SAME_STORY_START=""
  else
    CONSECUTIVE_NO_FLIP=$((CONSECUTIVE_NO_FLIP + 1))
    echo "[circuit-breaker] no new passes this iteration (consecutive: $CONSECUTIVE_NO_FLIP/$MAX_CONSECUTIVE_NO_FLIP)"
    if [ "$CONSECUTIVE_NO_FLIP" -ge "$MAX_CONSECUTIVE_NO_FLIP" ]; then
      echo ""
      echo "CIRCUIT BREAKER: $CONSECUTIVE_NO_FLIP consecutive iterations with no new passes. Agent is stuck." >&2
      CIRCUIT_BREAKER_TRIGGERED="$CONSECUTIVE_NO_FLIP consecutive no-flip iterations"
      break
    fi
  fi

  sleep "$SLEEP_BETWEEN"
done

FINAL_PASSES=$(count_passes)
DELTA=$((FINAL_PASSES - START_PASSES))
echo ""
echo "───────────────────────────────────────────────────────────────"
echo "Ralph summary: $FINAL_PASSES/$TOTAL passing  (+$DELTA this run)"
if [ -n "$CIRCUIT_BREAKER_TRIGGERED" ]; then
  echo "  CIRCUIT BREAKER: $CIRCUIT_BREAKER_TRIGGERED"
fi
echo "───────────────────────────────────────────────────────────────"
if [ -n "$CIRCUIT_BREAKER_TRIGGERED" ]; then
  exit 3
fi
