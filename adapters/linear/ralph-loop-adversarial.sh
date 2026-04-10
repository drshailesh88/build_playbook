#!/bin/bash
# =============================================================================
# RALPH LOOP ADVERSARIAL — Build→Review→Fix Loop with Linear Tracking
# =============================================================================
#
# Geoffrey Huntley's Ralph pattern + GAN-inspired adversarial review.
# Each iteration: Claude Code builds, Codex attacks, Claude fixes.
# Repeat review→fix until Codex finds nothing. Then commit and move on.
# Linear is the scoreboard. Every phase transition is visible.
#
# Flow per iteration:
#   1. Query Linear for next unblocked "unstarted" issue
#   2. Mark "In Progress" in Linear
#   3. Claude Code builds it (TDD, fresh context)
#   4. Autoresearch: verify score didn't drop
#   5. Codex adversarial review — tries to break the code
#   6. Claude Code fixes Codex's findings
#   7. Repeat 5-6 until Codex says "no bugs found" or max rounds
#   8. Final score gate: pass → Done | fail → Blocked
#   9. Next issue
#
# Usage:
#   ./ralph-loop-adversarial.sh                        # Auto-detect project
#   ./ralph-loop-adversarial.sh "My Project"           # Specify project
#   ./ralph-loop-adversarial.sh "My Project" 30        # Max 30 iterations
#
# Environment:
#   LINEAR_TEAM=DRS                 Override team key (auto-detected)
#   TEST_CMD="npm test"             Override test command (auto-detected)
#   TYPE_CHECK_CMD="npx tsc --noEmit"  Override type check
#   NOTIFY_WEBHOOK=https://...      Slack/Discord/Telegram webhook
#   RALPH_LABEL="phase-1"           Only process issues with this label
#   MAX_REVIEW_ROUNDS=3             Max adversarial review→fix cycles (default: 3)
#
# Stop: Ctrl+C (safe — all work is committed per iteration)
# =============================================================================

set -uo pipefail

PROJECT="${1:-}"
MAX_ITERATIONS="${2:-50}"
LINEAR_TEAM="${LINEAR_TEAM:-}"
TEST_CMD="${TEST_CMD:-}"
TYPE_CHECK_CMD="${TYPE_CHECK_CMD:-npx tsc --noEmit}"
NOTIFY_WEBHOOK="${NOTIFY_WEBHOOK:-}"
RALPH_LABEL="${RALPH_LABEL:-}"
MAX_HEAL_ATTEMPTS=3
MAX_REVIEW_ROUNDS="${MAX_REVIEW_ROUNDS:-3}"
SCORE_FILE=".planning/ralph-adversarial-scores.jsonl"
STATUS_FILE=".planning/ralph-adversarial-status.json"

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
  local message=$1
  if [ -n "$NOTIFY_WEBHOOK" ]; then
    curl -s -X POST "$NOTIFY_WEBHOOK" \
      -H "Content-Type: application/json" \
      -d "{\"text\": \"[Ralph Adversarial] $message\"}" \
      2>/dev/null || true
  fi
}

update_status() {
  local issue_id=$1 phase=$2 detail=$3 iteration=$4
  mkdir -p .planning
  cat > "$STATUS_FILE" << EOF
{
  "issue": "$issue_id",
  "phase": "$phase",
  "detail": "$detail",
  "iteration": $iteration,
  "maxIterations": $MAX_ITERATIONS,
  "project": "$PROJECT",
  "mode": "adversarial",
  "builder": "claude",
  "adversary": "codex",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
}

log_score() {
  local iteration=$1 issue_id=$2 pass_before=$3 pass_after=$4 action=$5 review_rounds=$6
  mkdir -p .planning
  echo "{\"ts\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"iter\":$iteration,\"issue\":\"$issue_id\",\"before\":$pass_before,\"after\":$pass_after,\"action\":\"$action\",\"reviewRounds\":$review_rounds}" >> "$SCORE_FILE"
}

# ─── AUTO-DETECT TEST COMMAND ──────────────────────────────────────────────
detect_test_cmd() {
  if [ -n "$TEST_CMD" ]; then return; fi
  if [ -f "package.json" ]; then
    if grep -q 'vitest' package.json 2>/dev/null; then
      TEST_CMD="npx vitest run"
    elif grep -q 'jest' package.json 2>/dev/null; then
      TEST_CMD="npx jest"
    else
      TEST_CMD="npm test"
    fi
  elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ]; then
    TEST_CMD="pytest"
  elif [ -f "Cargo.toml" ]; then
    TEST_CMD="cargo test"
  elif [ -f "go.mod" ]; then
    TEST_CMD="go test ./..."
  else
    TEST_CMD="npm test"
  fi
  log "Test command: ${TEST_CMD}"
}

# ─── AUTO-DETECT LINEAR TEAM ──────────────────────────────────────────────
detect_team() {
  if [ -n "$LINEAR_TEAM" ]; then return; fi
  LINEAR_TEAM=$(linear team list --no-pager 2>/dev/null | tail -n +2 | head -1 | awk '{print $1}')
  if [ -z "$LINEAR_TEAM" ]; then
    fail "Could not detect Linear team. Set LINEAR_TEAM env var."
    exit 1
  fi
  log "Linear team: ${LINEAR_TEAM}"
}

# ─── AUTO-DETECT PROJECT ──────────────────────────────────────────────────
detect_project() {
  if [ -n "$PROJECT" ]; then return; fi
  if [ -f ".planning/STATE.md" ]; then
    PROJECT=$(grep -i "project\|milestone" .planning/STATE.md | head -1 | sed 's/.*: *//' | sed 's/#.*//' | xargs)
  fi
  if [ -z "$PROJECT" ]; then
    echo -e "${YELLOW}Available Linear projects:${NC}"
    linear project list --no-pager 2>/dev/null
    echo ""
    echo -e "${YELLOW}Specify project: ./ralph-loop-adversarial.sh \"Project Name\"${NC}"
    exit 1
  fi
  log "Project: ${PROJECT}"
}

# ─── COUNT PASSING TESTS ──────────────────────────────────────────────────
count_passing() {
  local output
  output=$($TEST_CMD 2>&1) || true
  local count=0

  count=$(echo "$output" | grep -oE '[0-9]+ passed' | grep -oE '[0-9]+' | head -1)
  if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then echo "$count"; return; fi

  count=$(echo "$output" | grep -c '^ok' || true)
  if [ "$count" -gt 0 ] 2>/dev/null; then echo "$count"; return; fi

  count=$(echo "$output" | grep -cE '(✓|✔|PASS)' || true)
  echo "${count:-0}"
}

# ─── COUNT FAILING TESTS ──────────────────────────────────────────────────
count_failing() {
  local output
  output=$($TEST_CMD 2>&1) || true

  local count
  count=$(echo "$output" | grep -oE '[0-9]+ failed' | grep -oE '[0-9]+' | head -1)
  echo "${count:-0}"
}

# ─── GET NEXT ISSUE FROM LINEAR ───────────────────────────────────────────
get_next_issue() {
  local list_cmd="linear issue list --team $LINEAR_TEAM --project \"$PROJECT\" --state unstarted --sort priority --no-pager --limit 10"

  if [ -n "$RALPH_LABEL" ]; then
    list_cmd="$list_cmd --label \"$RALPH_LABEL\""
  fi

  local issue_line
  issue_line=$(eval "$list_cmd" 2>/dev/null | tail -n +2 | head -1)

  if [ -z "$issue_line" ]; then
    echo ""
    return
  fi

  echo "$issue_line" | grep -oE '[A-Z]+-[0-9]+' | head -1
}

# ─── GET ISSUE TITLE ──────────────────────────────────────────────────────
get_issue_title() {
  local issue_id=$1
  linear issue view "$issue_id" --no-pager 2>/dev/null | head -1 | sed 's/^# //'
}

# ─── CHECK DEPENDENCIES ──────────────────────────────────────────────────
check_dependencies() {
  local issue_id=$1
  local body
  body=$(linear issue view "$issue_id" --no-pager 2>/dev/null)

  local depends_line
  depends_line=$(echo "$body" | grep -i "depends on:\|blocked.by:" | head -1 || true)

  if [ -z "$depends_line" ]; then
    return 0
  fi

  local dep_ids
  dep_ids=$(echo "$depends_line" | grep -oE '[A-Z]+-[0-9]+' || true)

  for dep_id in $dep_ids; do
    local dep_state
    dep_state=$(linear issue view "$dep_id" --no-pager 2>&1 | grep -oE 'State: [A-Za-z ]+' | sed 's/State: //' || true)
    if [ -n "$dep_state" ] && ! echo "$dep_state" | grep -qi "done\|complete"; then
      warn "Dependency ${dep_id} not done (state: ${dep_state})"
      return 1
    fi
  done

  return 0
}

# =============================================================================
# PRE-FLIGHT
# =============================================================================

header "RALPH LOOP ADVERSARIAL — PRE-FLIGHT"

# Verify tools
if ! command -v linear &>/dev/null; then
  fail "Linear CLI not found. Install: brew install schpet/tap/linear"
  exit 1
fi
linear auth whoami >/dev/null 2>&1 || { fail "Linear not authenticated. Run: linear auth login"; exit 1; }
ok "Linear CLI authenticated"

if ! command -v claude &>/dev/null; then
  fail "Claude Code CLI not found."
  exit 1
fi
ok "Claude Code available (builder)"

if ! command -v codex &>/dev/null; then
  fail "Codex CLI not found."
  exit 1
fi
ok "Codex CLI available (adversary)"

detect_team
detect_project
detect_test_cmd

# Clean working tree
DIRTY=$(git status --porcelain 2>/dev/null | grep -v "^??" | wc -l | tr -d ' ')
if [ "$DIRTY" -gt 0 ]; then
  fail "Working tree has $DIRTY uncommitted changes."
  echo -e "Run: ${YELLOW}git stash${NC} or ${YELLOW}git add -A && git commit -m 'wip: save before ralph loop'${NC}"
  exit 1
fi
ok "Clean working tree"

# Baseline
log "Measuring baseline..."
BASELINE_PASS=$(count_passing)
ok "Baseline: ${BASELINE_PASS} tests passing"

mkdir -p .planning

# =============================================================================
# THE RALPH LOOP
# =============================================================================

header "RALPH LOOP ADVERSARIAL — STARTING"
echo -e "Project:           ${CYAN}${PROJECT}${NC}"
echo -e "Team:              ${CYAN}${LINEAR_TEAM}${NC}"
echo -e "Max iterations:    ${CYAN}${MAX_ITERATIONS}${NC}"
echo -e "Max review rounds: ${CYAN}${MAX_REVIEW_ROUNDS}${NC}"
echo -e "Builder:           ${GREEN}Claude Code${NC}"
echo -e "Adversary:         ${MAGENTA}Codex${NC}"
echo -e "Test command:      ${CYAN}${TEST_CMD}${NC}"
echo -e "Baseline:          ${GREEN}${BASELINE_PASS} passing${NC}"
echo ""

COMPLETED=0
FAILED=0
SKIPPED=0
TOTAL_REVIEW_ROUNDS=0
CONSECUTIVE_EMPTY=0

notify "Ralph Adversarial started: project=${PROJECT}, baseline=${BASELINE_PASS}"

for ((i=1; i<=MAX_ITERATIONS; i++)); do

  # ── Get next issue ──────────────────────────────────────────────────────
  ISSUE_ID=$(get_next_issue)

  if [ -z "$ISSUE_ID" ]; then
    header "ALL ISSUES COMPLETE"
    notify "All issues done! ${COMPLETED} completed, ${FAILED} failed"
    break
  fi

  ISSUE_TITLE=$(get_issue_title "$ISSUE_ID")
  REVIEW_ROUNDS_THIS=0

  header "ITERATION ${i}/${MAX_ITERATIONS}: ${ISSUE_ID}"
  log "Issue: ${ISSUE_TITLE}"
  update_status "$ISSUE_ID" "starting" "$ISSUE_TITLE" "$i"

  # ── Check dependencies ─────────────────────────────────────────────────
  if ! check_dependencies "$ISSUE_ID"; then
    warn "Skipping ${ISSUE_ID} — has unresolved dependencies"
    linear issue update "$ISSUE_ID" --state "Blocked" 2>/dev/null || true
    linear issue comment add "$ISSUE_ID" --body "Ralph Loop: skipped — unresolved dependencies" 2>/dev/null || true
    log_score "$i" "$ISSUE_ID" "$BASELINE_PASS" "$BASELINE_PASS" "SKIPPED_DEPS" "0"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  # ── Mark In Progress ───────────────────────────────────────────────────
  linear issue update "$ISSUE_ID" --state "In Progress" 2>/dev/null || true
  linear issue comment add "$ISSUE_ID" --body "**Ralph Adversarial** iteration ${i} — Claude Code building, Codex reviewing" 2>/dev/null || true

  # ── Snapshot for revert ────────────────────────────────────────────────
  SNAPSHOT_SHA=$(git rev-parse HEAD 2>/dev/null)

  # ── Measure before ─────────────────────────────────────────────────────
  BEFORE_PASS=$(count_passing)

  # =====================================================================
  # PHASE 1: BUILD — Claude Code (fresh session)
  # =====================================================================
  header "PHASE 1: BUILD (Claude Code)"
  update_status "$ISSUE_ID" "building" "Claude Code implementing" "$i"

  ISSUE_BODY=$(linear issue view "$ISSUE_ID" --no-pager 2>/dev/null)

  PROMPT_FILE="/tmp/ralph-build-${ISSUE_ID}.md"
  cat > "$PROMPT_FILE" << PROMPT
You are the BUILDER in a Ralph Adversarial Loop. Build ONE Linear issue.

## Linear Issue: ${ISSUE_ID}
${ISSUE_BODY}

## Instructions

1. Read the issue description above carefully
2. Read CLAUDE.md and any .planning/ files for project context
3. Follow TDD — write failing tests FIRST, then implement
4. Run tests: ${TEST_CMD}
5. Run type check: ${TYPE_CHECK_CMD}
6. Fix until all tests pass and types are clean
7. Do NOT commit — the loop script handles commits
8. Keep changes minimal — ONE issue, ONE deliverable

IMPORTANT:
- An adversary (Codex) will review your code after you're done
- Write defensively — handle edge cases, validate inputs, check nulls
- Write thorough tests — the adversary will try to find gaps
- Follow existing code patterns
PROMPT

  claude -p "$(cat "$PROMPT_FILE")" \
    --dangerously-skip-permissions \
    2>&1 || true

  rm -f "$PROMPT_FILE"

  # ── Check if anything was built ────────────────────────────────────────
  CHANGED=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  NEW_FILES=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

  if [ "$CHANGED" -eq 0 ] && [ "$NEW_FILES" -eq 0 ]; then
    warn "No code changes produced."
    linear issue comment add "$ISSUE_ID" --body "**Ralph Adversarial** — Builder produced no changes. Skipping." 2>/dev/null || true
    log_score "$i" "$ISSUE_ID" "$BEFORE_PASS" "$BEFORE_PASS" "NO_CHANGES" "0"

    CONSECUTIVE_EMPTY=$((CONSECUTIVE_EMPTY + 1))
    if [ "$CONSECUTIVE_EMPTY" -ge 3 ]; then
      fail "3 consecutive empty iterations. Stopping."
      notify "Stopped: 3 consecutive empty iterations"
      break
    fi
    SKIPPED=$((SKIPPED + 1))
    continue
  fi
  CONSECUTIVE_EMPTY=0

  # ── Autoresearch: score check after build ──────────────────────────────
  AFTER_BUILD=$(count_passing)
  TYPE_OK=true
  $TYPE_CHECK_CMD 2>/dev/null || TYPE_OK=false

  log "After build: ${BEFORE_PASS} → ${AFTER_BUILD} | TypeCheck: $([ "$TYPE_OK" = true ] && echo 'PASS' || echo 'FAIL')"

  # ── Heal if needed (before adversarial review) ─────────────────────────
  if [ "$AFTER_BUILD" -lt "$BEFORE_PASS" ] || [ "$TYPE_OK" = false ]; then
    warn "Build caused issues. Healing before adversarial review..."
    update_status "$ISSUE_ID" "healing" "Self-healing before review" "$i"

    HEALED=false
    for ((heal=1; heal<=MAX_HEAL_ATTEMPTS; heal++)); do
      warn "Heal attempt ${heal}/${MAX_HEAL_ATTEMPTS}"

      HEAL_REASON=""
      if [ "$TYPE_OK" = false ]; then HEAL_REASON="TypeScript compilation failing. "; fi
      if [ "$AFTER_BUILD" -lt "$BEFORE_PASS" ]; then HEAL_REASON="${HEAL_REASON}Test count dropped from ${BEFORE_PASS} to ${AFTER_BUILD}."; fi

      claude -p "Fix broken tests/types for ${ISSUE_ID}. ${HEAL_REASON}
Attempt ${heal}/${MAX_HEAL_ATTEMPTS}. Be MORE CONSERVATIVE each attempt.
Run: ${TEST_CMD} && ${TYPE_CHECK_CMD}" \
        --dangerously-skip-permissions \
        2>&1 || true

      AFTER_BUILD=$(count_passing)
      TYPE_OK=true
      $TYPE_CHECK_CMD 2>/dev/null || TYPE_OK=false

      if [ "$AFTER_BUILD" -ge "$BEFORE_PASS" ] && [ "$TYPE_OK" = true ]; then
        ok "Healed on attempt ${heal}"
        HEALED=true
        break
      fi
    done

    if [ "$HEALED" = false ]; then
      fail "Could not heal. Reverting."
      git checkout -- . 2>/dev/null || true
      git clean -fd 2>/dev/null || true

      linear issue update "$ISSUE_ID" --state "Blocked" 2>/dev/null || true
      linear issue comment add "$ISSUE_ID" --body "**Ralph Adversarial** — BUILD FAILED. Score ${BEFORE_PASS}→${AFTER_BUILD}, could not heal. Reverted." 2>/dev/null || true
      notify "${ISSUE_ID} BLOCKED — build regression"
      log_score "$i" "$ISSUE_ID" "$BEFORE_PASS" "$AFTER_BUILD" "REVERTED_BUILD" "0"

      FAILED=$((FAILED + 1))
      continue
    fi
  fi

  linear issue comment add "$ISSUE_ID" --body "**Builder (Claude)** — Build complete. Tests: ${BEFORE_PASS}→${AFTER_BUILD} (+$((AFTER_BUILD - BEFORE_PASS))). Sending to adversary." 2>/dev/null || true

  # =====================================================================
  # PHASE 2: ADVERSARIAL REVIEW→FIX LOOP — Codex attacks, Claude fixes
  # =====================================================================

  CURRENT_PASS=$AFTER_BUILD

  for ((round=1; round<=MAX_REVIEW_ROUNDS; round++)); do

    REVIEW_ROUNDS_THIS=$round
    TOTAL_REVIEW_ROUNDS=$((TOTAL_REVIEW_ROUNDS + 1))

    # ── ADVERSARY: Codex reviews ─────────────────────────────────────────
    header "PHASE 2: ADVERSARIAL REVIEW — Round ${round}/${MAX_REVIEW_ROUNDS} (Codex)"
    update_status "$ISSUE_ID" "reviewing" "Codex adversarial review round ${round}" "$i"

    adv "Codex attacking..."

    DIFF=$(git diff --no-color 2>/dev/null | head -1000)
    REVIEW_FILE="/tmp/ralph-review-${ISSUE_ID}-r${round}.md"

    codex "You are the ADVERSARY in a Ralph Loop. Your job is to BREAK the code.

The BUILDER (Claude Code) just implemented Linear issue ${ISSUE_ID}: ${ISSUE_TITLE}

Here is the diff of changes:
${DIFF}

YOUR MISSION:
1. Read the diff carefully
2. Find bugs: edge cases, missing null checks, missing error handling,
   SQL injection, XSS, race conditions, off-by-one, missing validation,
   broken existing functionality, untested paths
3. For each bug, write a FAILING TEST that exposes it
4. Add tests to the existing test files
5. Run: ${TEST_CMD}
6. Write ALL findings to ${REVIEW_FILE}

Format each finding as:
## Finding N: [title]
- **File:** path/to/file
- **Line:** N
- **Severity:** critical | major | minor
- **Bug:** What's wrong
- **Test added:** Yes/No — test name

If you genuinely cannot find any bugs, write 'NO BUGS FOUND' to ${REVIEW_FILE} and stop.
Be ruthless. Think like a hacker." \
      2>&1 || true

    # ── Check adversary results ──────────────────────────────────────────
    AFTER_REVIEW=$(count_passing)
    FAILING=$(count_failing)

    log "After Codex review: ${AFTER_REVIEW} passing, ${FAILING} failing"

    # Post findings to Linear
    if [ -f "$REVIEW_FILE" ]; then
      COMMENT_FILE="/tmp/ralph-review-comment-${ISSUE_ID}-r${round}.md"
      echo "**Adversary (Codex) — Round ${round}**" > "$COMMENT_FILE"
      echo "" >> "$COMMENT_FILE"
      cat "$REVIEW_FILE" >> "$COMMENT_FILE"
      linear issue comment add "$ISSUE_ID" --body-file "$COMMENT_FILE" 2>/dev/null || true
      rm -f "$COMMENT_FILE"
    fi

    # ── Check if Codex found nothing ─────────────────────────────────────
    if [ -f "$REVIEW_FILE" ] && grep -qi "no bugs found\|no issues found\|lgtm\|clean" "$REVIEW_FILE" 2>/dev/null; then
      ok "Codex found no bugs. Code survived adversarial review."
      linear issue comment add "$ISSUE_ID" --body "**Adversary (Codex)** — NO BUGS FOUND in round ${round}. Code is clean." 2>/dev/null || true
      break
    fi

    if [ "$FAILING" -eq 0 ] && [ "$AFTER_REVIEW" -ge "$CURRENT_PASS" ]; then
      ok "No failing tests after review. Moving on."
      CURRENT_PASS=$AFTER_REVIEW
      break
    fi

    # ── FIXER: Claude fixes Codex's findings ─────────────────────────────
    header "PHASE 3: FIX FINDINGS — Round ${round} (Claude Code)"
    update_status "$ISSUE_ID" "fixing" "Claude fixing Codex findings round ${round}" "$i"

    log "Claude fixing ${FAILING} failing tests..."

    FINDINGS=""
    if [ -f "$REVIEW_FILE" ]; then
      FINDINGS=$(cat "$REVIEW_FILE")
    fi

    claude -p "You are the BUILDER. The adversary (Codex) found bugs in your code for ${ISSUE_ID}.

There are ${FAILING} failing tests. Fix the CODE (not the tests) to make them pass.
The adversary's tests are valid — they found real bugs.

ADVERSARY FINDINGS:
${FINDINGS}

Run: ${TEST_CMD} && ${TYPE_CHECK_CMD}
Fix the bugs. Do NOT delete or modify the adversary's tests.
Do NOT commit." \
      --dangerously-skip-permissions \
      2>&1 || true

    AFTER_FIX=$(count_passing)
    FIX_FAILING=$(count_failing)
    TYPE_OK=true
    $TYPE_CHECK_CMD 2>/dev/null || TYPE_OK=false

    log "After fix: ${AFTER_FIX} passing, ${FIX_FAILING} failing, TypeCheck: $([ "$TYPE_OK" = true ] && echo 'PASS' || echo 'FAIL')"

    linear issue comment add "$ISSUE_ID" --body "**Builder (Claude)** — Fix round ${round}: ${AFTER_FIX} passing, ${FIX_FAILING} failing" 2>/dev/null || true

    CURRENT_PASS=$AFTER_FIX

    # If everything passes, Codex gets another look (unless max rounds)
    if [ "$FIX_FAILING" -eq 0 ] && [ "$TYPE_OK" = true ]; then
      ok "All tests pass after fix round ${round}"
      if [ "$round" -eq "$MAX_REVIEW_ROUNDS" ]; then
        log "Max review rounds reached. Proceeding to final gate."
      fi
    else
      warn "Still ${FIX_FAILING} failing after fix round ${round}"
      if [ "$round" -eq "$MAX_REVIEW_ROUNDS" ]; then
        warn "Max review rounds reached with failures remaining."
      fi
    fi

    rm -f "$REVIEW_FILE"
  done

  # =====================================================================
  # FINAL GATE — Score must hold
  # =====================================================================
  header "FINAL GATE"
  update_status "$ISSUE_ID" "gate" "Final score check" "$i"

  FINAL_PASS=$(count_passing)
  FINAL_FAIL=$(count_failing)
  FINAL_TYPE=true
  $TYPE_CHECK_CMD 2>/dev/null || FINAL_TYPE=false

  log "Final: ${FINAL_PASS} passing, ${FINAL_FAIL} failing, TypeCheck: $([ "$FINAL_TYPE" = true ] && echo 'PASS' || echo 'FAIL')"

  GATE_FAILED=false
  GATE_REASON=""

  if [ "$FINAL_TYPE" = false ]; then
    GATE_FAILED=true
    GATE_REASON="TypeScript compilation failed"
  elif [ "$FINAL_PASS" -lt "$BEFORE_PASS" ]; then
    GATE_FAILED=true
    GATE_REASON="Pass count dropped from ${BEFORE_PASS} to ${FINAL_PASS}"
  elif [ "$FINAL_FAIL" -gt 0 ]; then
    GATE_FAILED=true
    GATE_REASON="${FINAL_FAIL} tests still failing"
  fi

  if [ "$GATE_FAILED" = true ]; then
    fail "GATE FAILED: ${GATE_REASON}. Reverting."

    git checkout -- . 2>/dev/null || true
    git clean -fd 2>/dev/null || true

    linear issue update "$ISSUE_ID" --state "Blocked" 2>/dev/null || true
    linear issue comment add "$ISSUE_ID" --body "**Ralph Adversarial** — GATE FAILED: ${GATE_REASON}. Reverted. Needs manual attention." 2>/dev/null || true
    notify "${ISSUE_ID} GATE FAILED — ${GATE_REASON}"
    log_score "$i" "$ISSUE_ID" "$BEFORE_PASS" "$FINAL_PASS" "REVERTED_GATE" "$REVIEW_ROUNDS_THIS"

    FAILED=$((FAILED + 1))
    continue
  fi

  # =====================================================================
  # COMMIT
  # =====================================================================
  update_status "$ISSUE_ID" "committing" "Passed all gates" "$i"
  ok "All gates passed. Score: ${BEFORE_PASS} → ${FINAL_PASS} (+$((FINAL_PASS - BEFORE_PASS)))"

  git add -A 2>/dev/null
  COMMIT_MSG="feat: ${ISSUE_TITLE} (${ISSUE_ID})

Ralph Adversarial iteration ${i}. Tests: ${BEFORE_PASS} → ${FINAL_PASS} (+$((FINAL_PASS - BEFORE_PASS))).
Builder: Claude Code | Adversary: Codex | Review rounds: ${REVIEW_ROUNDS_THIS}."

  if git commit -m "$COMMIT_MSG" 2>/dev/null; then
    ok "Committed: ${ISSUE_ID}"
  else
    warn "Nothing to commit"
  fi

  # ── Update Linear: Done ────────────────────────────────────────────────
  linear issue update "$ISSUE_ID" --state "Done" 2>/dev/null || true
  linear issue comment add "$ISSUE_ID" --body "**Ralph Adversarial** — COMPLETE ✓
Tests: ${BEFORE_PASS} → ${FINAL_PASS} (+$((FINAL_PASS - BEFORE_PASS)))
Adversarial rounds: ${REVIEW_ROUNDS_THIS}
Iteration: ${i}" 2>/dev/null || true

  notify "${ISSUE_ID} DONE — ${ISSUE_TITLE} (+$((FINAL_PASS - BEFORE_PASS)) tests, ${REVIEW_ROUNDS_THIS} review rounds)"
  log_score "$i" "$ISSUE_ID" "$BEFORE_PASS" "$FINAL_PASS" "COMMITTED" "$REVIEW_ROUNDS_THIS"

  COMPLETED=$((COMPLETED + 1))
  BASELINE_PASS=$FINAL_PASS

  echo ""
  log "Cooling down 3s before next iteration..."
  sleep 3
done

# =============================================================================
# FINAL REPORT
# =============================================================================

header "RALPH LOOP ADVERSARIAL — COMPLETE"

FINAL_TOTAL=$(count_passing)

echo -e "Project:              ${CYAN}${PROJECT}${NC}"
echo -e "Builder:              ${GREEN}Claude Code${NC}"
echo -e "Adversary:            ${MAGENTA}Codex${NC}"
echo -e "Iterations run:       ${CYAN}${i}${NC}"
echo -e ""
echo -e "Baseline score:       ${GREEN}${BASELINE_PASS} passing${NC}"
echo -e "Final score:          ${GREEN}${FINAL_TOTAL} passing${NC}"
echo -e "Net improvement:      ${GREEN}+$((FINAL_TOTAL - BASELINE_PASS)) tests${NC}"
echo -e ""
echo -e "${GREEN}Completed:            ${COMPLETED}${NC}"
echo -e "${RED}Failed/Blocked:       ${FAILED}${NC}"
echo -e "${YELLOW}Skipped:              ${SKIPPED}${NC}"
echo -e ""
echo -e "Total review rounds:  ${MAGENTA}${TOTAL_REVIEW_ROUNDS}${NC}"
echo -e "Avg rounds/issue:     ${MAGENTA}$([ "$COMPLETED" -gt 0 ] && echo "$((TOTAL_REVIEW_ROUNDS / COMPLETED))" || echo "0")${NC}"
echo -e ""
echo -e "Every committed issue survived:"
echo -e "  1. Claude Code built with TDD"
echo -e "  2. Autoresearch verified score didn't drop"
echo -e "  3. Codex tried to break it (up to ${MAX_REVIEW_ROUNDS} rounds)"
echo -e "  4. Claude fixed what Codex found"
echo -e "  5. Final gate: score >= baseline, zero failures, types clean"
echo -e ""
echo -e "Scores:  ${YELLOW}cat ${SCORE_FILE}${NC}"
echo -e "Status:  ${YELLOW}cat ${STATUS_FILE}${NC}"
echo -e "Linear:  ${YELLOW}linear issue list --team ${LINEAR_TEAM} --project \"${PROJECT}\" --all-states${NC}"

notify "Ralph Adversarial complete: ${COMPLETED} done, ${FAILED} failed. Score: ${BASELINE_PASS}→${FINAL_TOTAL}. Review rounds: ${TOTAL_REVIEW_ROUNDS}"
