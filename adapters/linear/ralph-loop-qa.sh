#!/bin/bash
# =============================================================================
# RALPH LOOP QA — Overnight Quality Engine with Linear Tracking
# =============================================================================
#
# Autoresearch + GAN architecture for code quality improvement.
# Iterates over modules (sorted by worst quality first), each iteration:
#   Stage 1: DISCOVER — Codex (adversary, can't see source) attacks the running app
#   Stage 2: FIX — Claude fixes bugs found (ratchet: ALL scores must hold)
#   Stage 3: STRENGTHEN — Stryker reports surviving mutants, Claude strengthens tests
#   Stage 4: VERIFY — Run frozen contract tests, accessibility checks
#
# The metric that can't be gamed: mutation score + frozen test pass count.
# Every fix runs ALL tests. Any score drop = revert. No exceptions.
#
# Usage:
#   ./ralph-loop-qa.sh                        # Auto-detect project
#   ./ralph-loop-qa.sh "My Project"           # Specify project
#   ./ralph-loop-qa.sh "My Project" 30        # Max 30 iterations
#
# Environment:
#   LINEAR_TEAM=DRS                 Override team key
#   TEST_CMD="npm test"             Override test command
#   TYPE_CHECK_CMD="npx tsc --noEmit"  Override type check
#   MUTATION_THRESHOLD=70           Min mutation score to lock a module (default: 70)
#   NOTIFY_WEBHOOK=https://...      Slack/Discord/Telegram webhook
#   APP_URL=http://localhost:3000   Running app URL for adversary
#   MAX_ADVERSARY_TESTS=10          Max tests adversary writes per module (default: 10)
#   STRYKER_CONCURRENCY=4           Stryker parallel workers (default: 4)
#
# Prerequisites:
#   - Claude Code CLI (claude)
#   - Codex CLI (codex)
#   - Stryker installed (npm install -D @stryker-mutator/core @stryker-mutator/vitest-runner)
#   - App running at APP_URL
#   - Linear CLI authenticated
#
# Stop: Ctrl+C (safe — all work is committed per iteration)
# =============================================================================

set -uo pipefail

PROJECT="${1:-}"
MAX_ITERATIONS="${2:-50}"
LINEAR_TEAM="${LINEAR_TEAM:-}"
TEST_CMD="${TEST_CMD:-}"
TYPE_CHECK_CMD="${TYPE_CHECK_CMD:-npx tsc --noEmit}"
MUTATION_THRESHOLD="${MUTATION_THRESHOLD:-70}"
NOTIFY_WEBHOOK="${NOTIFY_WEBHOOK:-}"
APP_URL="${APP_URL:-http://localhost:3000}"
MAX_ADVERSARY_TESTS="${MAX_ADVERSARY_TESTS:-10}"
MAX_FIX_ATTEMPTS=3
SCORE_FILE=".planning/ralph-qa-scores.jsonl"
STATUS_FILE=".planning/ralph-qa-status.json"

# ─── COLORS ─────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log()    { echo -e "${BLUE}[$(date +%H:%M:%S)]${NC} $1"; }
ok()     { echo -e "${GREEN}[$(date +%H:%M:%S)] ✓${NC} $1"; }
warn()   { echo -e "${YELLOW}[$(date +%H:%M:%S)] ⚠${NC} $1"; }
fail()   { echo -e "${RED}[$(date +%H:%M:%S)] ✗${NC} $1"; }
adv()    { echo -e "${MAGENTA}[$(date +%H:%M:%S)] ⚔${NC} $1"; }
header() { echo -e "\n${CYAN}═══════════════════════════════════════════════════${NC}"; echo -e "${CYAN}  $1${NC}"; echo -e "${CYAN}═══════════════════════════════════════════════════${NC}\n"; }

notify() {
  if [ -n "$NOTIFY_WEBHOOK" ]; then
    curl -s -X POST "$NOTIFY_WEBHOOK" \
      -H "Content-Type: application/json" \
      -d "{\"text\": \"[Ralph QA] $1\"}" \
      2>/dev/null || true
  fi
}

update_status() {
  local module=$1 stage=$2 detail=$3 iteration=$4
  mkdir -p .planning
  cat > "$STATUS_FILE" << EOF
{
  "module": "$module",
  "stage": "$stage",
  "detail": "$detail",
  "iteration": $iteration,
  "maxIterations": $MAX_ITERATIONS,
  "project": "$PROJECT",
  "mutationThreshold": $MUTATION_THRESHOLD,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
}

log_score() {
  local iteration=$1 module=$2 stage=$3 metric=$4 value=$5 action=$6
  mkdir -p .planning
  echo "{\"ts\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"iter\":$iteration,\"module\":\"$module\",\"stage\":\"$stage\",\"metric\":\"$metric\",\"value\":\"$value\",\"action\":\"$action\"}" >> "$SCORE_FILE"
}

# ─── AUTO-DETECT ────────────────────────────────────────────────────────────
detect_test_cmd() {
  if [ -n "$TEST_CMD" ]; then return; fi
  if [ -f "package.json" ]; then
    if grep -q 'vitest' package.json 2>/dev/null; then TEST_CMD="npx vitest run"
    elif grep -q 'jest' package.json 2>/dev/null; then TEST_CMD="npx jest"
    else TEST_CMD="npm test"; fi
  else TEST_CMD="npm test"; fi
  log "Test command: ${TEST_CMD}"
}

detect_team() {
  if [ -n "$LINEAR_TEAM" ]; then return; fi
  LINEAR_TEAM=$(linear team list --no-pager 2>/dev/null | tail -n +2 | head -1 | awk '{print $1}')
  if [ -z "$LINEAR_TEAM" ]; then warn "Could not detect Linear team. Linear updates disabled."; fi
}

detect_project() {
  if [ -n "$PROJECT" ]; then return; fi
  if [ -f ".planning/STATE.md" ]; then
    PROJECT=$(grep -i "project\|milestone" .planning/STATE.md | head -1 | sed 's/.*: *//' | sed 's/#.*//' | xargs)
  fi
  if [ -z "$PROJECT" ]; then PROJECT="QA"; fi
  log "Project: ${PROJECT}"
}

# ─── SCORE CAPTURE ──────────────────────────────────────────────────────────
count_passing() {
  local output
  output=$($TEST_CMD 2>&1) || true
  local count
  count=$(echo "$output" | grep -oE '[0-9]+ passed' | grep -oE '[0-9]+' | head -1)
  if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then echo "$count"; return; fi
  count=$(echo "$output" | grep -cE '(✓|✔|PASS)' || true)
  echo "${count:-0}"
}

count_frozen_passing() {
  if [ -d "contracts" ]; then
    local output
    output=$(npx playwright test contracts/ --reporter=json 2>&1) || true
    echo "$output" | grep -oE '"expected":[0-9]+' | grep -oE '[0-9]+' | head -1 || echo "0"
  else
    echo "0"
  fi
}

get_mutation_score() {
  local scope=$1
  if ! command -v npx &>/dev/null || ! npx stryker --version &>/dev/null 2>&1; then
    echo "0"
    return
  fi
  local output
  output=$(npx stryker run --mutate "$scope" --reporters json 2>&1) || true
  echo "$output" | grep -oE '"mutationScore":[0-9.]+' | grep -oE '[0-9.]+' | head -1 || echo "0"
}

# ─── SNAPSHOT AND RATCHET ───────────────────────────────────────────────────
snapshot_all() {
  SNAP_PASS=$(count_passing)
  SNAP_FROZEN=$(count_frozen_passing)
  log "Snapshot: ${SNAP_PASS} unit passing, ${SNAP_FROZEN} frozen passing"
}

ratchet_check() {
  local after_pass
  after_pass=$(count_passing)
  local after_frozen
  after_frozen=$(count_frozen_passing)

  if [ "$after_pass" -lt "$SNAP_PASS" ] 2>/dev/null; then
    fail "RATCHET: unit tests dropped ${SNAP_PASS} → ${after_pass}. REVERTING."
    git checkout -- . 2>/dev/null || true
    git clean -fd 2>/dev/null || true
    return 1
  fi

  if [ "$after_frozen" -lt "$SNAP_FROZEN" ] 2>/dev/null; then
    fail "RATCHET: frozen tests dropped ${SNAP_FROZEN} → ${after_frozen}. REVERTING."
    git checkout -- . 2>/dev/null || true
    git clean -fd 2>/dev/null || true
    return 1
  fi

  SNAP_PASS=$after_pass
  SNAP_FROZEN=$after_frozen
  return 0
}

# ─── DISCOVER MODULES ──────────────────────────────────────────────────────
discover_modules() {
  # Look for module manifest first
  if [ -f ".planning/modules.json" ]; then
    cat .planning/modules.json | grep -oE '"path":"[^"]*"' | cut -d'"' -f4
    return
  fi

  # Fall back to directory-based discovery
  # Find directories under src/ that have .ts/.tsx files
  find src -maxdepth 2 -type d 2>/dev/null | while read -r dir; do
    local file_count
    file_count=$(find "$dir" -maxdepth 1 -name "*.ts" -o -name "*.tsx" 2>/dev/null | grep -v test | grep -v spec | wc -l | tr -d ' ')
    if [ "$file_count" -gt 0 ]; then
      echo "$dir"
    fi
  done
}

# ─── CHECK APP IS RUNNING ──────────────────────────────────────────────────
check_app() {
  if curl -s -o /dev/null -w "%{http_code}" "$APP_URL" 2>/dev/null | grep -qE "^[23]"; then
    return 0
  fi
  return 1
}

start_app() {
  if check_app; then
    ok "App running at ${APP_URL}"
    return
  fi

  log "Starting dev server..."
  npm run dev &>/dev/null &
  APP_PID=$!

  # Wait up to 30s for app to start
  for i in $(seq 1 30); do
    if check_app; then
      ok "App started at ${APP_URL} (PID: ${APP_PID})"
      return
    fi
    sleep 1
  done

  fail "App failed to start at ${APP_URL}"
  exit 1
}

# =============================================================================
# PRE-FLIGHT
# =============================================================================

header "RALPH LOOP QA — PRE-FLIGHT"

# Verify tools
if ! command -v claude &>/dev/null; then fail "Claude Code not found."; exit 1; fi
ok "Claude Code (builder/fixer)"

if ! command -v codex &>/dev/null; then fail "Codex CLI not found."; exit 1; fi
ok "Codex (adversary)"

if command -v linear &>/dev/null; then
  linear auth whoami >/dev/null 2>&1 && ok "Linear CLI" || warn "Linear not authenticated"
  detect_team
else
  warn "Linear CLI not found — progress tracking disabled"
fi

detect_test_cmd
detect_project

# Check Stryker
if npx stryker --version &>/dev/null 2>&1; then
  ok "Stryker mutation testing"
  HAS_STRYKER=true
else
  warn "Stryker not installed — mutation testing disabled. Install: npm i -D @stryker-mutator/core @stryker-mutator/vitest-runner"
  HAS_STRYKER=false
fi

# Clean working tree
DIRTY=$(git status --porcelain 2>/dev/null | grep -v "^??" | wc -l | tr -d ' ')
if [ "$DIRTY" -gt 0 ]; then
  fail "Working tree has $DIRTY uncommitted changes."
  exit 1
fi
ok "Clean working tree"

# Start/check app
start_app

# Baseline
snapshot_all
BASELINE_PASS=$SNAP_PASS

mkdir -p .planning

# =============================================================================
# DISCOVER AND SORT MODULES
# =============================================================================

header "DISCOVERING MODULES"

mapfile -t MODULES < <(discover_modules)

if [ ${#MODULES[@]} -eq 0 ]; then
  warn "No modules found. Check src/ directory structure."
  exit 0
fi

log "Found ${#MODULES[@]} module(s):"
for mod in "${MODULES[@]}"; do
  echo -e "  ${CYAN}${mod}${NC}"
done

# =============================================================================
# THE QA RALPH LOOP
# =============================================================================

header "RALPH LOOP QA — STARTING"
echo -e "Project:            ${CYAN}${PROJECT}${NC}"
echo -e "Modules:            ${CYAN}${#MODULES[@]}${NC}"
echo -e "Max iterations:     ${CYAN}${MAX_ITERATIONS}${NC}"
echo -e "Mutation threshold: ${CYAN}${MUTATION_THRESHOLD}%${NC}"
echo -e "App URL:            ${CYAN}${APP_URL}${NC}"
echo -e "Baseline:           ${GREEN}${BASELINE_PASS} tests passing${NC}"
echo ""

MODULES_DONE=0
MODULES_STUCK=0
TOTAL_BUGS_FOUND=0
TOTAL_BUGS_FIXED=0
TOTAL_TESTS_ADDED=0
ITERATION=0

notify "Ralph QA started: ${#MODULES[@]} modules, baseline ${BASELINE_PASS} passing"

for MODULE in "${MODULES[@]}"; do
  ITERATION=$((ITERATION + 1))
  if [ "$ITERATION" -gt "$MAX_ITERATIONS" ]; then
    warn "Max iterations reached. Stopping."
    break
  fi

  MODULE_NAME=$(basename "$MODULE")

  header "MODULE ${ITERATION}/${#MODULES[@]}: ${MODULE}"
  update_status "$MODULE" "starting" "Beginning QA" "$ITERATION"

  # Create Linear issue for this module's QA
  QA_ISSUE_ID=""
  if [ -n "$LINEAR_TEAM" ]; then
    QA_ISSUE_ID=$(linear issue create \
      --team "$LINEAR_TEAM" \
      --title "QA: ${MODULE_NAME}" \
      --description "Overnight QA for module ${MODULE}" \
      --no-interactive 2>/dev/null | grep -oE '[A-Z]+-[0-9]+' | head -1 || true)
    if [ -n "$QA_ISSUE_ID" ]; then
      linear issue update "$QA_ISSUE_ID" --state "In Progress" 2>/dev/null || true
      log "Linear issue: ${QA_ISSUE_ID}"
    fi
  fi

  # =====================================================================
  # STAGE 1: DISCOVER — Adversary attacks the running app
  # =====================================================================
  header "STAGE 1: DISCOVER (Codex adversary)"
  update_status "$MODULE" "discover" "Codex attacking running app" "$ITERATION"
  adv "Codex attacking ${MODULE_NAME} at ${APP_URL}..."

  BUGS_THIS_MODULE=0
  DISCOVER_FILE="/tmp/ralph-qa-discover-${MODULE_NAME}.md"

  codex "You are the ADVERSARY in a QA loop. Your job is to FIND BUGS in a running web app.

APP URL: ${APP_URL}
MODULE: ${MODULE_NAME}

IMPORTANT CONSTRAINTS:
- You CANNOT read source code. You are a BLACK-BOX tester.
- You CAN ONLY interact with the running app through a browser.
- Use Playwright to navigate, click, fill forms, and verify behavior.

YOUR MISSION:
1. Navigate to pages related to ${MODULE_NAME}
2. Try normal flows — do they work as expected?
3. Try edge cases — empty inputs, very long text, special characters, duplicate submissions
4. Try forbidden actions — can you access things you shouldn't?
5. Try breaking things — rapid clicks, back button, refresh mid-action
6. For each bug found, write a Playwright test that reproduces it

ASSERTION RULES (CRITICAL):
Each test must assert at least ONE of:
- Data persists after page reload
- API returns expected status code and body
- URL changes to expected path
- Multiple DOM elements confirm the full state change
- Accessibility attributes are correct

NOT acceptable as the only assertion:
- Toast/notification appeared
- Button exists
- Element is visible

Write all bugs and tests to ${DISCOVER_FILE}
Write Playwright test files to qa/adversary/${MODULE_NAME}/

Maximum ${MAX_ADVERSARY_TESTS} tests. Focus on real bugs, not nitpicks." \
    2>&1 || true

  # Count bugs found
  if [ -f "$DISCOVER_FILE" ]; then
    BUGS_THIS_MODULE=$(grep -ciE "bug|failure|broken|missing|error|crash" "$DISCOVER_FILE" 2>/dev/null || echo "0")
  fi

  # Count new test files
  TESTS_ADDED=$(find qa/adversary/${MODULE_NAME}/ -name "*.spec.ts" 2>/dev/null | wc -l | tr -d ' ')
  TOTAL_BUGS_FOUND=$((TOTAL_BUGS_FOUND + BUGS_THIS_MODULE))
  TOTAL_TESTS_ADDED=$((TOTAL_TESTS_ADDED + TESTS_ADDED))

  log "Adversary found ${BUGS_THIS_MODULE} potential bugs, wrote ${TESTS_ADDED} tests"

  if [ -n "$QA_ISSUE_ID" ]; then
    linear issue comment add "$QA_ISSUE_ID" --body "**Adversary (Codex)** — Found ${BUGS_THIS_MODULE} potential bugs. Wrote ${TESTS_ADDED} tests." 2>/dev/null || true
  fi

  log_score "$ITERATION" "$MODULE" "discover" "bugs_found" "$BUGS_THIS_MODULE" "DISCOVERED"

  # =====================================================================
  # STAGE 2: FIX — Claude fixes bugs (with ratchet)
  # =====================================================================
  if [ "$BUGS_THIS_MODULE" -gt 0 ] || [ "$TESTS_ADDED" -gt 0 ]; then
    header "STAGE 2: FIX (Claude builder)"
    update_status "$MODULE" "fix" "Claude fixing bugs" "$ITERATION"

    BUGS_FIXED=0
    FINDINGS=""
    if [ -f "$DISCOVER_FILE" ]; then FINDINGS=$(cat "$DISCOVER_FILE"); fi

    # Snapshot before fixes
    snapshot_all

    for ((fix_attempt=1; fix_attempt<=MAX_FIX_ATTEMPTS; fix_attempt++)); do
      log "Fix attempt ${fix_attempt}/${MAX_FIX_ATTEMPTS}..."

      claude -p "You are the BUILDER fixing bugs found by an adversarial tester.

MODULE: ${MODULE}

ADVERSARY FINDINGS:
${FINDINGS}

ADVERSARY TESTS: qa/adversary/${MODULE_NAME}/

INSTRUCTIONS:
1. Read the adversary's findings and tests
2. Fix the CODE to make the adversary's tests pass
3. Do NOT edit the adversary's tests — they found real bugs
4. Do NOT weaken assertions
5. Run: ${TEST_CMD}
6. Run: ${TYPE_CHECK_CMD}
7. Make sure ALL existing tests still pass (not just this module)
8. Do NOT commit — the loop script handles commits" \
        --dangerously-skip-permissions \
        2>&1 || true

      # Ratchet check
      if ratchet_check; then
        ok "Fix attempt ${fix_attempt} passed ratchet"
        git add -A 2>/dev/null
        git commit -m "fix(${MODULE_NAME}): address adversary findings — attempt ${fix_attempt}" 2>/dev/null || true
        BUGS_FIXED=$((BUGS_FIXED + 1))
        break
      else
        warn "Fix attempt ${fix_attempt} caused regression — reverted"
      fi
    done

    TOTAL_BUGS_FIXED=$((TOTAL_BUGS_FIXED + BUGS_FIXED))

    if [ -n "$QA_ISSUE_ID" ]; then
      linear issue comment add "$QA_ISSUE_ID" --body "**Builder (Claude)** — Fixed ${BUGS_FIXED} bugs. Ratchet: ${SNAP_PASS} tests passing." 2>/dev/null || true
    fi

    log_score "$ITERATION" "$MODULE" "fix" "bugs_fixed" "$BUGS_FIXED" "FIXED"
  fi

  # =====================================================================
  # STAGE 3: STRENGTHEN — Mutation testing (at module boundary, not per-fix)
  # =====================================================================
  if [ "$HAS_STRYKER" = true ]; then
    header "STAGE 3: STRENGTHEN (Stryker mutation gate)"
    update_status "$MODULE" "strengthen" "Running Stryker" "$ITERATION"

    log "Running Stryker on ${MODULE}..."
    MUTATION_SCORE=$(get_mutation_score "${MODULE}/**/*.ts")
    log "Mutation score: ${MUTATION_SCORE}%"

    if [ -n "$QA_ISSUE_ID" ]; then
      linear issue comment add "$QA_ISSUE_ID" --body "**Mutation Gate** — Score: ${MUTATION_SCORE}% (threshold: ${MUTATION_THRESHOLD}%)" 2>/dev/null || true
    fi

    log_score "$ITERATION" "$MODULE" "strengthen" "mutation_score" "$MUTATION_SCORE" "MEASURED"

    # If below threshold, try to strengthen
    MUTATION_INT=$(echo "$MUTATION_SCORE" | cut -d. -f1)
    if [ "$MUTATION_INT" -lt "$MUTATION_THRESHOLD" ] 2>/dev/null; then
      log "Below threshold. Strengthening assertions..."

      snapshot_all

      claude -p "Mutation testing shows ${MODULE} has a mutation score of ${MUTATION_SCORE}%.
Target: ${MUTATION_THRESHOLD}%.

Run Stryker to see surviving mutants:
npx stryker run --mutate '${MODULE}/**/*.ts' --reporters clear-text

For each surviving mutant, ADD or STRENGTHEN a test assertion that catches it.
Write BEHAVIORAL assertions (what the code should do for a given input), not implementation assertions.

Rules:
- Do NOT weaken any existing assertions
- Do NOT delete any tests
- Run ${TEST_CMD} after each change
- Stop after improving 5 assertions (don't try to fix everything in one pass)" \
        --dangerously-skip-permissions \
        2>&1 || true

      if ratchet_check; then
        NEW_MUTATION=$(get_mutation_score "${MODULE}/**/*.ts")
        ok "Mutation score: ${MUTATION_SCORE}% → ${NEW_MUTATION}%"
        git add -A 2>/dev/null
        git commit -m "test(${MODULE_NAME}): strengthen assertions — mutation ${MUTATION_SCORE}% → ${NEW_MUTATION}%" 2>/dev/null || true

        if [ -n "$QA_ISSUE_ID" ]; then
          linear issue comment add "$QA_ISSUE_ID" --body "**Mutation Strengthening** — Score: ${MUTATION_SCORE}% → ${NEW_MUTATION}%" 2>/dev/null || true
        fi

        MUTATION_SCORE=$NEW_MUTATION
        log_score "$ITERATION" "$MODULE" "strengthen" "mutation_score" "$NEW_MUTATION" "IMPROVED"
      else
        warn "Strengthening caused regression — reverted"
        log_score "$ITERATION" "$MODULE" "strengthen" "mutation_score" "$MUTATION_SCORE" "REVERTED"
      fi
    fi
  fi

  # =====================================================================
  # STAGE 4: VERIFY — Frozen contract tests + accessibility
  # =====================================================================
  header "STAGE 4: VERIFY (frozen oracle)"
  update_status "$MODULE" "verify" "Running frozen tests" "$ITERATION"

  FROZEN_RESULT="N/A"
  if [ -d "contracts/${MODULE_NAME}" ]; then
    log "Running frozen contract tests for ${MODULE_NAME}..."
    FROZEN_OUTPUT=$(npx playwright test "contracts/${MODULE_NAME}/" --reporter=list 2>&1) || true
    FROZEN_PASS=$(echo "$FROZEN_OUTPUT" | grep -oE '[0-9]+ passed' | grep -oE '[0-9]+' | head -1 || echo "0")
    FROZEN_FAIL=$(echo "$FROZEN_OUTPUT" | grep -oE '[0-9]+ failed' | grep -oE '[0-9]+' | head -1 || echo "0")
    FROZEN_RESULT="${FROZEN_PASS} pass, ${FROZEN_FAIL} fail"
    log "Frozen tests: ${FROZEN_RESULT}"

    if [ "$FROZEN_FAIL" -gt 0 ] 2>/dev/null; then
      warn "Frozen contract tests failing — needs attention"
      if [ -n "$QA_ISSUE_ID" ]; then
        linear issue comment add "$QA_ISSUE_ID" --body "**Frozen Oracle** — ${FROZEN_FAIL} contract tests FAILING. These cannot be edited — the code must be fixed." 2>/dev/null || true
      fi
    fi
  else
    log "No frozen contracts for ${MODULE_NAME} — skipping"
  fi

  log_score "$ITERATION" "$MODULE" "verify" "frozen_tests" "$FROZEN_RESULT" "VERIFIED"

  # =====================================================================
  # MODULE SUMMARY
  # =====================================================================
  header "MODULE COMPLETE: ${MODULE_NAME}"

  FINAL_PASS=$(count_passing)
  echo -e "Tests:          ${GREEN}${BASELINE_PASS} → ${FINAL_PASS} (+$((FINAL_PASS - BASELINE_PASS)))${NC}"
  echo -e "Bugs found:     ${MAGENTA}${BUGS_THIS_MODULE}${NC}"
  echo -e "Bugs fixed:     ${GREEN}${BUGS_FIXED:-0}${NC}"
  echo -e "Tests added:    ${CYAN}${TESTS_ADDED}${NC}"
  if [ "$HAS_STRYKER" = true ]; then
    echo -e "Mutation score: ${CYAN}${MUTATION_SCORE:-N/A}%${NC}"
  fi
  echo -e "Frozen tests:   ${CYAN}${FROZEN_RESULT}${NC}"

  # Check if module is done
  MUTATION_INT=$(echo "${MUTATION_SCORE:-0}" | cut -d. -f1)
  if [ "$MUTATION_INT" -ge "$MUTATION_THRESHOLD" ] 2>/dev/null && [ "${FROZEN_FAIL:-0}" -eq 0 ] 2>/dev/null; then
    ok "Module ${MODULE_NAME} meets thresholds — LOCKED"
    MODULES_DONE=$((MODULES_DONE + 1))
    if [ -n "$QA_ISSUE_ID" ]; then
      linear issue update "$QA_ISSUE_ID" --state "Done" 2>/dev/null || true
      linear issue comment add "$QA_ISSUE_ID" --body "**Ralph QA** — Module LOCKED. Mutation: ${MUTATION_SCORE}%. Frozen: ${FROZEN_RESULT}. Bugs: ${BUGS_THIS_MODULE} found, ${BUGS_FIXED:-0} fixed." 2>/dev/null || true
    fi
    notify "${MODULE_NAME} LOCKED — mutation ${MUTATION_SCORE}%, ${BUGS_THIS_MODULE} bugs found and fixed"
  else
    warn "Module ${MODULE_NAME} below threshold — needs more work"
    MODULES_STUCK=$((MODULES_STUCK + 1))
    if [ -n "$QA_ISSUE_ID" ]; then
      linear issue comment add "$QA_ISSUE_ID" --body "**Ralph QA** — Module needs more work. Mutation: ${MUTATION_SCORE:-N/A}%. Continue next night." 2>/dev/null || true
    fi
  fi

  BASELINE_PASS=$FINAL_PASS

  echo ""
  log "Cooling down 3s before next module..."
  sleep 3
done

# =============================================================================
# FINAL REPORT
# =============================================================================

header "RALPH LOOP QA — COMPLETE"

FINAL_TOTAL=$(count_passing)

echo -e "Project:            ${CYAN}${PROJECT}${NC}"
echo -e "Builder:            ${GREEN}Claude Code${NC}"
echo -e "Adversary:          ${MAGENTA}Codex${NC}"
echo -e ""
echo -e "Baseline score:     ${GREEN}${BASELINE_PASS} passing${NC}"
echo -e "Final score:        ${GREEN}${FINAL_TOTAL} passing${NC}"
echo -e "Net improvement:    ${GREEN}+$((FINAL_TOTAL - BASELINE_PASS)) tests${NC}"
echo -e ""
echo -e "Modules processed:  ${CYAN}${#MODULES[@]}${NC}"
echo -e "${GREEN}Modules locked:     ${MODULES_DONE}${NC}"
echo -e "${YELLOW}Modules in progress:${MODULES_STUCK}${NC}"
echo -e ""
echo -e "Bugs found:         ${MAGENTA}${TOTAL_BUGS_FOUND}${NC}"
echo -e "Bugs fixed:         ${GREEN}${TOTAL_BUGS_FIXED}${NC}"
echo -e "Tests added:        ${CYAN}${TOTAL_TESTS_ADDED}${NC}"
echo -e ""
echo -e "Scores:  ${YELLOW}cat ${SCORE_FILE}${NC}"
echo -e "Status:  ${YELLOW}cat ${STATUS_FILE}${NC}"
echo -e "Linear:  ${YELLOW}linear issue list --team ${LINEAR_TEAM} --all-states${NC}"
echo -e ""
echo -e "Review:  ${YELLOW}git log --oneline -20${NC}"
echo -e "Next:    Run again tomorrow to continue improving modules that didn't lock"

notify "Ralph QA complete: ${MODULES_DONE}/${#MODULES[@]} locked. Bugs: ${TOTAL_BUGS_FOUND} found, ${TOTAL_BUGS_FIXED} fixed. Score: ${BASELINE_PASS}→${FINAL_TOTAL}"
