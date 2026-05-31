#!/bin/bash
# ──────────────────────────────────────────────────────────────────────────────
# TEMPLATE — Unified Fitness Function for Autoresearch Improvement Loops
# ──────────────────────────────────────────────────────────────────────────────
#
# THIS IS A TEMPLATE. Copy it to your project and customize the commands below
# for your actual toolchain. Do NOT run this in the build_playbook repo itself.
#
# Usage: ./scripts/score.sh <metric-name>
# Output: {"score": N, "max": N, "unit": "...", "details": "..."}
#
# Convention (from goal-md):
#   - Score is an integer between 0 and max
#   - Exit 0 ALWAYS, even on score=0 (non-zero exit = script is broken)
#   - Each metric must complete in under 2 minutes
#   - If a tool isn't installed, output {"score":0,"max":100,"error":"tool not found"} and exit 0
# ──────────────────────────────────────────────────────────────────────────────

set -o pipefail

METRIC="${1:?Usage: ./scripts/score.sh <metric-name>}"

json_out() {
  local score="$1" max="$2" unit="$3" details="$4"
  printf '{"score": %d, "max": %d, "unit": "%s", "details": "%s"}\n' \
    "$score" "$max" "$unit" "$details"
}

json_err() {
  local tool="$1"
  printf '{"score": 0, "max": 100, "error": "%s not found"}\n' "$tool"
}

case "$METRIC" in

  tsc-errors)
    if ! command -v npx &>/dev/null; then json_err "npx"; exit 0; fi
    ERRORS=$(npx tsc --noEmit 2>&1 | grep -c " error TS" || true)
    SCORE=$((100 - ERRORS * 5))
    [ "$SCORE" -lt 0 ] && SCORE=0
    json_out "$SCORE" 100 "points" "$ERRORS type errors"
    ;;

  eslint)
    if ! command -v npx &>/dev/null; then json_err "npx"; exit 0; fi
    OUTPUT=$(npx eslint src/ --format compact 2>&1 || true)
    ERRORS=$(echo "$OUTPUT" | grep -c " Error " || true)
    WARNS=$(echo "$OUTPUT" | grep -c " Warning " || true)
    SCORE=$((100 - ERRORS * 3 - WARNS))
    [ "$SCORE" -lt 0 ] && SCORE=0
    json_out "$SCORE" 100 "points" "$ERRORS errors, $WARNS warnings"
    ;;

  coverage)
    if ! command -v npx &>/dev/null; then json_err "npx"; exit 0; fi
    # Adapt: vitest, jest, or c8
    COV_OUTPUT=$(npx vitest run --coverage --reporter=json 2>/dev/null || true)
    SCORE=$(echo "$COV_OUTPUT" | grep -o '"lines":[0-9.]*' | head -1 | grep -o '[0-9]*' | head -1 || echo 0)
    [ -z "$SCORE" ] && SCORE=0
    json_out "$SCORE" 100 "%" "$SCORE% line coverage"
    ;;

  mutation)
    if ! command -v npx &>/dev/null; then json_err "npx"; exit 0; fi
    STRYKER_OUTPUT=$(npx stryker run --reporters json 2>/dev/null || true)
    SCORE=$(echo "$STRYKER_OUTPUT" | grep -o '"mutationScore":[0-9.]*' | grep -o '[0-9]*' | head -1 || echo 0)
    [ -z "$SCORE" ] && SCORE=0
    json_out "$SCORE" 100 "%" "$SCORE% mutation score"
    ;;

  lighthouse-perf)
    if ! command -v npx &>/dev/null; then json_err "npx"; exit 0; fi
    if ! npx lighthouse --version &>/dev/null 2>&1; then json_err "lighthouse"; exit 0; fi
    # Adapt: replace URL with your dev server
    LH_OUTPUT=$(npx lighthouse http://localhost:3000 --output=json --chrome-flags="--headless --no-sandbox" 2>/dev/null || true)
    SCORE=$(echo "$LH_OUTPUT" | grep -o '"performance":{[^}]*"score":[0-9.]*' | grep -o 'score":[0-9.]*' | grep -o '[0-9]*' | head -1 || echo 0)
    [ -z "$SCORE" ] && SCORE=0
    # Lighthouse scores are 0-1, multiply by 100
    [ "$SCORE" -le 1 ] 2>/dev/null && SCORE=$((SCORE * 100))
    json_out "$SCORE" 100 "points" "Lighthouse performance"
    ;;

  lighthouse-a11y)
    if ! command -v npx &>/dev/null; then json_err "npx"; exit 0; fi
    if ! npx lighthouse --version &>/dev/null 2>&1; then json_err "lighthouse"; exit 0; fi
    LH_OUTPUT=$(npx lighthouse http://localhost:3000 --output=json --chrome-flags="--headless --no-sandbox" 2>/dev/null || true)
    SCORE=$(echo "$LH_OUTPUT" | grep -o '"accessibility":{[^}]*"score":[0-9.]*' | grep -o 'score":[0-9.]*' | grep -o '[0-9]*' | head -1 || echo 0)
    [ -z "$SCORE" ] && SCORE=0
    [ "$SCORE" -le 1 ] 2>/dev/null && SCORE=$((SCORE * 100))
    json_out "$SCORE" 100 "points" "Lighthouse accessibility"
    ;;

  axe-violations)
    if ! command -v npx &>/dev/null; then json_err "npx"; exit 0; fi
    # Adapt: run axe-core against your app
    AXE_OUTPUT=$(npx axe http://localhost:3000 --exit 2>/dev/null || true)
    COUNT=$(echo "$AXE_OUTPUT" | grep -ci "violation" || true)
    SCORE=$((100 - COUNT * 10))
    [ "$SCORE" -lt 0 ] && SCORE=0
    json_out "$SCORE" 100 "points" "$COUNT violations"
    ;;

  playwright-pass)
    if ! command -v npx &>/dev/null; then json_err "npx"; exit 0; fi
    PW_OUTPUT=$(npx playwright test --reporter=json 2>/dev/null || true)
    TOTAL=$(echo "$PW_OUTPUT" | grep -o '"expected":[0-9]*' | grep -o '[0-9]*' | head -1 || echo 0)
    PASSED=$(echo "$PW_OUTPUT" | grep -o '"passed":[0-9]*' | grep -o '[0-9]*' | head -1 || echo 0)
    [ -z "$TOTAL" ] || [ "$TOTAL" = "0" ] && { json_out 0 100 "%" "no tests found"; exit 0; }
    SCORE=$((PASSED * 100 / TOTAL))
    json_out "$SCORE" 100 "%" "$PASSED/$TOTAL tests passing"
    ;;

  *)
    echo "Unknown metric: $METRIC" >&2
    echo "Available: tsc-errors, eslint, coverage, mutation, lighthouse-perf, lighthouse-a11y, axe-violations, playwright-pass" >&2
    printf '{"score": 0, "max": 100, "error": "unknown metric: %s"}\n' "$METRIC"
    exit 0
    ;;
esac

exit 0
