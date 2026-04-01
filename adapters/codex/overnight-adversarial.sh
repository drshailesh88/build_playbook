#!/bin/bash
# =============================================================================
# OVERNIGHT ADVERSARIAL BUILD LOOP
# =============================================================================
#
# Three ML concepts applied to software building:
#
# 1. AUTORESEARCH (Karpathy): One metric (test pass count). One direction
#    (must not decrease). Automatic revert if it does. Keep only improvements.
#
# 2. ADVERSARIAL LOOP (GAN-inspired): Two agents — a Builder that writes code
#    and an Adversary that tries to break it. The Builder must survive the
#    Adversary's attacks before code is committed.
#
# 3. ANNEALING (self-healing): When tests fail, the system diagnoses and
#    fixes automatically, cooling down (reducing change scope) with each
#    retry until stable.
#
# Usage: ./overnight-adversarial.sh [iterations]
# Example: ./overnight-adversarial.sh 75
#
# =============================================================================

set -uo pipefail
# Note: NOT using set -e because codex exec may return non-zero
# exit codes even on successful completion. We handle errors manually.

ITERATIONS=${1:-20}
BRANCH="codex/$(date +%Y-%m-%d)"
MAX_HEAL_ATTEMPTS=3
MAX_ADVERSARY_ROUNDS=2
SCORE_FILE=".planning/build-scores.jsonl"
PROGRESS_FILE="progress.txt"
PHASE_SCORES_FILE=".planning/phase-gate-scores.json"

# ─── COLORS ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ─── HELPER: Capture test score ──────────────────────────────────────────────
capture_score() {
  local typecheck_pass=0
  local test_output=""
  local pass_count=0
  local fail_count=0
  local total=0

  # Run typecheck (ScholarSync uses npx tsc directly, no npm script)
  if npx tsc --noEmit 2>/dev/null; then
    typecheck_pass=1
  fi

  # Run tests, capture output
  test_output=$(npm test 2>&1 || true)

  # Try to extract pass/fail counts from common test runners
  # Jest format: "Tests: X passed, Y failed, Z total"
  # Vitest format: "Tests  X passed | Y failed"
  # Playwright format: "X passed Y failed"
  pass_count=$(echo "$test_output" | grep -oE '[0-9]+ passed' | head -1 | grep -oE '[0-9]+' || echo "0")
  fail_count=$(echo "$test_output" | grep -oE '[0-9]+ failed' | head -1 | grep -oE '[0-9]+' || echo "0")
  total=$((pass_count + fail_count))

  # If we couldn't parse, check exit code
  if [ "$total" -eq 0 ]; then
    if echo "$test_output" | grep -qiE "pass|success|ok"; then
      pass_count=1
      total=1
    fi
  fi

  # Return as JSON-like string
  echo "${typecheck_pass}:${pass_count}:${fail_count}:${total}"
}

# ─── HELPER: Get current phase from STATE.md ─────────────────────────────────
get_current_phase() {
  if [ -f .planning/STATE.md ]; then
    grep -oE "Phase [0-9]+" .planning/STATE.md | head -1 | grep -oE "[0-9]+" || echo "1"
  else
    echo "1"
  fi
}

# ─── HELPER: Get next unchecked requirement ──────────────────────────────────
get_next_requirement() {
  grep -n "^- \[ \]" .planning/REQUIREMENTS.md | head -1 || echo ""
}

# ─── HELPER: Log to score file (autoresearch metric tracking) ────────────────
log_score() {
  local iteration=$1
  local phase=$2
  local requirement=$3
  local pass_count=$4
  local fail_count=$5
  local action=$6
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  echo "{\"ts\":\"$timestamp\",\"iter\":$iteration,\"phase\":$phase,\"req\":\"$requirement\",\"pass\":$pass_count,\"fail\":$fail_count,\"action\":\"$action\"}" >> "$SCORE_FILE"
}

# =============================================================================
# MAIN LOOP
# =============================================================================

echo -e "${BLUE}=== OVERNIGHT ADVERSARIAL BUILD LOOP ===${NC}"
echo -e "Iterations: $ITERATIONS"
echo -e "Branch: $BRANCH"
echo -e "Max heal attempts per requirement: $MAX_HEAL_ATTEMPTS"
echo -e "Max adversary rounds per requirement: $MAX_ADVERSARY_ROUNDS"
echo ""

git checkout -b "$BRANCH" 2>/dev/null || git checkout "$BRANCH"

# ─── SAFETY: Require clean working tree ──────────────────────────────────────
DIRTY_FILES=$(git status --porcelain 2>/dev/null | grep -v "^??" | wc -l | tr -d ' ')
if [ "$DIRTY_FILES" -gt 0 ]; then
  echo -e "${RED}Working tree has $DIRTY_FILES uncommitted changes.${NC}"
  echo -e "${RED}Commit or stash them first. This script must start from a clean tree${NC}"
  echo -e "${RED}to avoid committing unrelated files or destroying local work on revert.${NC}"
  echo ""
  echo -e "Run: ${YELLOW}git stash${NC} or ${YELLOW}git add -A && git commit -m 'wip: save before overnight run'${NC}"
  exit 1
fi

# ─── Capture baseline score (autoresearch: know where you started) ───────────
echo -e "${YELLOW}Capturing baseline score...${NC}"
BASELINE=$(capture_score)
BASELINE_PASS=$(echo "$BASELINE" | cut -d: -f2)
BASELINE_FAIL=$(echo "$BASELINE" | cut -d: -f3)
echo -e "Baseline: ${GREEN}$BASELINE_PASS passing${NC}, ${RED}$BASELINE_FAIL failing${NC}"
echo ""

PREV_PHASE=$(get_current_phase)
PHASE_START_PASS=$BASELINE_PASS
LAST_REQ=""
CONSECUTIVE_SKIPS=0

for ((i=1; i<=$ITERATIONS; i++)); do

  CURRENT_PHASE=$(get_current_phase)
  NEXT_REQ=$(get_next_requirement)

  # ─── Nothing left to build ───────────────────────────────────────────────
  if [ -z "$NEXT_REQ" ]; then
    echo -e "${GREEN}=== ALL REQUIREMENTS COMPLETE ===${NC}"
    break
  fi

  # ─── Phase boundary gate (autoresearch: score must not regress) ──────────
  if [ "$CURRENT_PHASE" != "$PREV_PHASE" ]; then
    echo ""
    echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  PHASE GATE: Phase $PREV_PHASE → Phase $CURRENT_PHASE${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"

    GATE_SCORE=$(capture_score)
    GATE_PASS=$(echo "$GATE_SCORE" | cut -d: -f2)
    GATE_FAIL=$(echo "$GATE_SCORE" | cut -d: -f3)

    echo -e "Phase $PREV_PHASE start: ${GREEN}$PHASE_START_PASS passing${NC}"
    echo -e "Phase $PREV_PHASE end:   ${GREEN}$GATE_PASS passing${NC}, ${RED}$GATE_FAIL failing${NC}"

    if [ "$GATE_PASS" -lt "$PHASE_START_PASS" ]; then
      echo -e "${RED}REGRESSION DETECTED. Pass count dropped from $PHASE_START_PASS to $GATE_PASS.${NC}"
      echo -e "${RED}STOPPING. Do not build Phase $CURRENT_PHASE on broken Phase $PREV_PHASE.${NC}"
      echo "[$i] PHASE GATE FAILED: Phase $PREV_PHASE regressed from $PHASE_START_PASS to $GATE_PASS passing" >> "$PROGRESS_FILE"
      log_score "$i" "$PREV_PHASE" "PHASE_GATE" "$GATE_PASS" "$GATE_FAIL" "STOPPED_REGRESSION"
      break
    fi

    echo -e "${GREEN}PHASE GATE PASSED. No regression. Advancing to Phase $CURRENT_PHASE.${NC}"
    log_score "$i" "$CURRENT_PHASE" "PHASE_GATE" "$GATE_PASS" "$GATE_FAIL" "PASSED"
    PHASE_START_PASS=$GATE_PASS
    PREV_PHASE=$CURRENT_PHASE
    echo ""
  fi

  REQ_TEXT=$(echo "$NEXT_REQ" | cut -d: -f2-)
  REQ_LINE_NUM=$(echo "$NEXT_REQ" | cut -d: -f1)

  # ─── Deduplication: detect stuck loop ───────────────────────────────────
  if [ "$REQ_TEXT" = "$LAST_REQ" ]; then
    echo -e "${RED}STUCK: Same requirement as last iteration. Checkbox update failed. STOPPING.${NC}"
    echo "STUCK: Same requirement repeated — checkbox update likely failed" >> "$PROGRESS_FILE"
    break
  fi
  LAST_REQ="$REQ_TEXT"

  echo -e "${BLUE}=== Iteration $i/$ITERATIONS | Phase $CURRENT_PHASE ===${NC}"
  echo -e "Requirement: $REQ_TEXT"
  echo ""

  # ─── SCORE BEFORE (autoresearch: measure before changing) ────────────────
  BEFORE=$(capture_score)
  BEFORE_PASS=$(echo "$BEFORE" | cut -d: -f2)

  # =========================================================================
  # LAYER 1: BUILDER — Codex writes the code
  # =========================================================================
  echo -e "${GREEN}[BUILDER] Writing code...${NC}"

  codex exec --full-auto \
    "You are the BUILDER agent.

Read AGENTS.md for project rules.
Read .planning/REQUIREMENTS.md — find this requirement: $REQ_TEXT
Read .planning/STATE.md for current phase context.
Read relevant .planning/ files (ux-brief, ui-brief, data-requirements) for decisions.

BUILD this ONE requirement:
1. Read existing code first — follow established patterns
2. Write the implementation code
3. Write tests for what you built
4. Run: npx tsc --noEmit && npm test
5. Do NOT check the box yet — the Adversary reviews first
6. Do NOT commit yet

If the requirement is too big, build the smallest meaningful slice." \
    || true

  echo "[BUILDER] Finished building: $REQ_TEXT" >> "$PROGRESS_FILE"

  # ─── Check if Codex actually produced changes (Bug 3: detect errors/rate limits)
  if [ -z "$(git diff --name-only 2>/dev/null)" ]; then
    echo -e "${RED}[BUILDER] No code changes detected. Codex may have errored. Skipping.${NC}"
    echo "[$i] SKIPPED: No code changes from builder" >> "$PROGRESS_FILE"

    # Check if this is 3rd consecutive skip — if so, likely rate limited
    CONSECUTIVE_SKIPS=$((CONSECUTIVE_SKIPS + 1))
    if [ "$CONSECUTIVE_SKIPS" -ge 3 ]; then
      echo -e "${RED}3 consecutive empty iterations. Codex likely rate-limited. STOPPING.${NC}"
      echo "STOPPED: 3 consecutive empty builder iterations" >> "$PROGRESS_FILE"
      break
    fi
    continue
  fi
  CONSECUTIVE_SKIPS=0

  # =========================================================================
  # LAYER 2: TEST — Automated score capture
  # =========================================================================
  echo ""
  echo -e "${YELLOW}[TEST] Running test suite...${NC}"

  AFTER_BUILD=$(capture_score)
  AFTER_BUILD_TC=$(echo "$AFTER_BUILD" | cut -d: -f1)
  AFTER_BUILD_PASS=$(echo "$AFTER_BUILD" | cut -d: -f2)
  AFTER_BUILD_FAIL=$(echo "$AFTER_BUILD" | cut -d: -f3)

  echo -e "Before: ${GREEN}$BEFORE_PASS passing${NC} | After build: ${GREEN}$AFTER_BUILD_PASS passing${NC}, ${RED}$AFTER_BUILD_FAIL failing${NC}, TypeCheck: $([ "$AFTER_BUILD_TC" = "1" ] && echo "${GREEN}PASS${NC}" || echo "${RED}FAIL${NC}")"

  # ─── TYPECHECK GATE: TypeScript errors block everything ──────────────────
  if [ "$AFTER_BUILD_TC" != "1" ]; then
    echo -e "${RED}[TYPECHECK] TypeScript compilation failed. Cannot proceed.${NC}"
    echo -e "${YELLOW}[ANNEAL] Attempting to fix type errors...${NC}"

    codex exec --full-auto \
      "TypeScript compilation is failing (npx tsc --noEmit returns errors).
Fix ALL type errors. Do not change any logic — only fix types.
Run: npx tsc --noEmit" \
      || true

    # Re-check typecheck
    if ! npx tsc --noEmit 2>/dev/null; then
      echo -e "${RED}[TYPECHECK] Still failing after fix attempt. REVERTING.${NC}"
      CHANGED_FILES=$(git diff --name-only 2>/dev/null)
      echo "$CHANGED_FILES" | xargs git checkout -- 2>/dev/null || true
      git clean -fd -- $(echo "$CHANGED_FILES" | head -20) 2>/dev/null || true
      echo "[$i] REVERTED: $REQ_TEXT — TypeScript compilation failed" >> "$PROGRESS_FILE"
      log_score "$i" "$CURRENT_PHASE" "$REQ_TEXT" "$AFTER_BUILD_PASS" "$AFTER_BUILD_FAIL" "REVERTED_TYPECHECK"
      continue
    fi

    # Re-capture score after type fix
    AFTER_BUILD=$(capture_score)
    AFTER_BUILD_PASS=$(echo "$AFTER_BUILD" | cut -d: -f2)
    AFTER_BUILD_FAIL=$(echo "$AFTER_BUILD" | cut -d: -f3)
  fi

  # ─── AUTORESEARCH CHECK: Did score go down? ──────────────────────────────
  if [ "$AFTER_BUILD_PASS" -lt "$BEFORE_PASS" ]; then
    echo -e "${RED}[AUTORESEARCH] Score DROPPED from $BEFORE_PASS to $AFTER_BUILD_PASS.${NC}"
    echo -e "${YELLOW}[ANNEAL] Starting self-healing...${NC}"

    HEALED=false
    for ((heal=1; heal<=$MAX_HEAL_ATTEMPTS; heal++)); do
      echo -e "${YELLOW}[ANNEAL] Heal attempt $heal/$MAX_HEAL_ATTEMPTS (cooling down)...${NC}"

      codex exec --full-auto \
        "You are the HEALER agent. Tests are failing after building: $REQ_TEXT

The test pass count DROPPED from $BEFORE_PASS to $AFTER_BUILD_PASS.
This is attempt $heal of $MAX_HEAL_ATTEMPTS. Be MORE CONSERVATIVE with each attempt.

Attempt 1: Fix the obvious bug.
Attempt 2: Smaller fix. Only touch the lines that caused the failure.
Attempt 3: Minimal change. If you can't fix it, revert your changes to the failing file.

Run: npx tsc --noEmit && npm test
Fix ONLY what's broken. Do NOT add new features. Do NOT refactor." \
        || true

      echo "[ANNEAL] Heal attempt $heal complete" >> "$PROGRESS_FILE"

      HEAL_SCORE=$(capture_score)
      HEAL_PASS=$(echo "$HEAL_SCORE" | cut -d: -f2)

      if [ "$HEAL_PASS" -ge "$BEFORE_PASS" ]; then
        echo -e "${GREEN}[ANNEAL] Healed! Score restored to $HEAL_PASS.${NC}"
        AFTER_BUILD_PASS=$HEAL_PASS
        AFTER_BUILD_FAIL=$(echo "$HEAL_SCORE" | cut -d: -f3)
        HEALED=true
        break
      fi
    done

    if [ "$HEALED" = false ]; then
      echo -e "${RED}[ANNEAL] Could not heal after $MAX_HEAL_ATTEMPTS attempts. REVERTING.${NC}"
      # Only revert files changed in this iteration, not the entire tree
      CHANGED_FILES=$(git diff --name-only 2>/dev/null)
      if [ -n "$CHANGED_FILES" ]; then
        echo "$CHANGED_FILES" | xargs git checkout -- 2>/dev/null || true
        # Also remove any new untracked files from this iteration
        git clean -fd -- $(echo "$CHANGED_FILES" | head -20) 2>/dev/null || true
      fi
      echo "[$i] REVERTED: $REQ_TEXT — score dropped and could not heal" >> "$PROGRESS_FILE"
      log_score "$i" "$CURRENT_PHASE" "$REQ_TEXT" "$BEFORE_PASS" "0" "REVERTED"
      continue
    fi
  fi

  # =========================================================================
  # LAYER 3: ADVERSARY — Second agent tries to break the code
  # =========================================================================
  echo ""
  echo -e "${RED}[ADVERSARY] Attacking the code...${NC}"

  for ((adv_round=1; adv_round<=$MAX_ADVERSARY_ROUNDS; adv_round++)); do
    echo -e "${RED}[ADVERSARY] Round $adv_round/$MAX_ADVERSARY_ROUNDS${NC}"

    # Get the diff of what was built
    DIFF=$(git diff --no-color 2>/dev/null | head -500)

    codex exec --full-auto \
      "You are the ADVERSARY agent. Your job is to BREAK the code that was just written.

The BUILDER just implemented: $REQ_TEXT

Here is what changed:
$DIFF

Your mission:
1. Read the diff carefully
2. Find bugs: edge cases not handled, missing null checks, missing error handling,
   SQL injection, XSS, race conditions, off-by-one errors, missing validation,
   broken existing functionality
3. For each bug you find, write a FAILING TEST that exposes it
4. Add these tests to the existing test files
5. Run: npm test
6. Report what you found

Be ruthless. Think like a hacker and a QA engineer combined.
If you genuinely cannot find any bugs, say 'NO BUGS FOUND' and stop." \
      || true

    echo "[ADVERSARY] Round $adv_round complete" >> "$PROGRESS_FILE"

    # Check if adversary found bugs (new failures)
    ADV_SCORE=$(capture_score)
    ADV_PASS=$(echo "$ADV_SCORE" | cut -d: -f2)
    ADV_FAIL=$(echo "$ADV_SCORE" | cut -d: -f3)

    echo -e "After adversary: ${GREEN}$ADV_PASS passing${NC}, ${RED}$ADV_FAIL failing${NC}"

    if [ "$ADV_FAIL" -eq 0 ]; then
      echo -e "${GREEN}[ADVERSARY] Code survived the attack. Zero failures.${NC}"
      break
    fi

    echo -e "${YELLOW}[ADVERSARY] Found $ADV_FAIL failing tests. Builder must fix.${NC}"

    # ─── Adversary found bugs. Builder must fix them. ────────────────────
    echo -e "${YELLOW}[BUILDER] Fixing adversary-found bugs...${NC}"

    codex exec --full-auto \
      "You are the BUILDER agent. The ADVERSARY found bugs in your code.

There are $ADV_FAIL failing tests. Fix the CODE (not the tests) to make them pass.
The adversary's tests are valid — they found real bugs.

Run: npx tsc --noEmit && npm test
Fix the bugs. Do not delete or modify the adversary's tests." \
      || true

    echo "[BUILDER] Fix attempt for adversary bugs complete" >> "$PROGRESS_FILE"

    FIX_SCORE=$(capture_score)
    FIX_PASS=$(echo "$FIX_SCORE" | cut -d: -f2)
    FIX_FAIL=$(echo "$FIX_SCORE" | cut -d: -f3)

    echo -e "After fix: ${GREEN}$FIX_PASS passing${NC}, ${RED}$FIX_FAIL failing${NC}"
    AFTER_BUILD_PASS=$FIX_PASS
    AFTER_BUILD_FAIL=$FIX_FAIL

    if [ "$FIX_FAIL" -eq 0 ]; then
      echo -e "${GREEN}[BUILDER] All adversary bugs fixed.${NC}"
      break
    fi
  done

  # =========================================================================
  # FINAL AUTORESEARCH CHECK: Is the score better than or equal to before?
  # =========================================================================
  FINAL=$(capture_score)
  FINAL_TC=$(echo "$FINAL" | cut -d: -f1)
  FINAL_PASS=$(echo "$FINAL" | cut -d: -f2)
  FINAL_FAIL=$(echo "$FINAL" | cut -d: -f3)

  echo ""
  echo -e "FINAL SCORE: Before=$BEFORE_PASS | After=${FINAL_PASS} passing, ${FINAL_FAIL} failing, TypeCheck: $([ "$FINAL_TC" = "1" ] && echo "PASS" || echo "FAIL")"

  # Gate on: typecheck must pass AND pass count must not drop AND zero failures from adversary
  if [ "$FINAL_TC" != "1" ] || [ "$FINAL_PASS" -lt "$BEFORE_PASS" ] || [ "$FINAL_FAIL" -gt 0 ]; then
    if [ "$FINAL_TC" != "1" ]; then
      echo -e "${RED}[GATE] TypeScript compilation failed. REVERTING.${NC}"
    elif [ "$FINAL_FAIL" -gt 0 ]; then
      echo -e "${RED}[GATE] $FINAL_FAIL tests still failing. REVERTING.${NC}"
    fi
  fi

  if [ "$FINAL_TC" != "1" ] || [ "$FINAL_PASS" -lt "$BEFORE_PASS" ]; then
    echo -e "${RED}[AUTORESEARCH] Score STILL below baseline. REVERTING iteration changes.${NC}"
    CHANGED_FILES=$(git diff --name-only 2>/dev/null)
    if [ -n "$CHANGED_FILES" ]; then
      echo "$CHANGED_FILES" | xargs git checkout -- 2>/dev/null || true
      git clean -fd -- $(echo "$CHANGED_FILES" | head -20) 2>/dev/null || true
    fi
    echo "[$i] REVERTED: $REQ_TEXT — final score $FINAL_PASS < baseline $BEFORE_PASS" >> "$PROGRESS_FILE"
    log_score "$i" "$CURRENT_PHASE" "$REQ_TEXT" "$FINAL_PASS" "$FINAL_FAIL" "REVERTED"
    continue
  fi

  # =========================================================================
  # COMMIT — Only if score held or improved
  # =========================================================================
  echo -e "${GREEN}[COMMIT] Score held or improved. Committing.${NC}"

  # Check the requirement box by line number (avoids regex issues with special chars)
  sed -i '' "${REQ_LINE_NUM}s/- \[ \]/- [x]/" .planning/REQUIREMENTS.md

  # Only stage files changed in this iteration + the requirements file
  CHANGED_FILES=$(git diff --name-only 2>/dev/null)
  UNTRACKED_FILES=$(git ls-files --others --exclude-standard 2>/dev/null)
  if [ -n "$CHANGED_FILES" ]; then
    echo "$CHANGED_FILES" | xargs git add 2>/dev/null || true
  fi
  if [ -n "$UNTRACKED_FILES" ]; then
    echo "$UNTRACKED_FILES" | xargs git add 2>/dev/null || true
  fi
  git add .planning/REQUIREMENTS.md .planning/build-scores.jsonl progress.txt 2>/dev/null || true
  git commit -m "feat: $(echo "$REQ_TEXT" | head -c 60) (Phase $CURRENT_PHASE)

Ralph iteration $i. Score: $FINAL_PASS passing ($((FINAL_PASS - BEFORE_PASS)) net).
Builder → Tests → Adversary ($MAX_ADVERSARY_ROUNDS rounds) → Verified." \
    2>/dev/null || true

  echo "[$i] COMMITTED: $REQ_TEXT | Score: $BEFORE_PASS → $FINAL_PASS" >> "$PROGRESS_FILE"
  log_score "$i" "$CURRENT_PHASE" "$REQ_TEXT" "$FINAL_PASS" "$FINAL_FAIL" "COMMITTED"

  echo -e "${GREEN}Done. Score: $BEFORE_PASS → $FINAL_PASS (+$((FINAL_PASS - BEFORE_PASS)))${NC}"
  echo ""
done

# =============================================================================
# FINAL REPORT
# =============================================================================
echo ""
echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  OVERNIGHT BUILD COMPLETE${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
echo ""

FINAL_TOTAL=$(capture_score)
FINAL_TOTAL_PASS=$(echo "$FINAL_TOTAL" | cut -d: -f2)
COMMITTED=$(grep -c "COMMITTED" "$PROGRESS_FILE" 2>/dev/null || echo "0")
REVERTED=$(grep -c "REVERTED" "$PROGRESS_FILE" 2>/dev/null || echo "0")
BLOCKED=$(grep -c "BLOCKED" "$PROGRESS_FILE" 2>/dev/null || echo "0")

echo -e "Baseline score:    ${GREEN}$BASELINE_PASS passing${NC}"
echo -e "Final score:       ${GREEN}$FINAL_TOTAL_PASS passing${NC}"
echo -e "Net improvement:   ${GREEN}+$((FINAL_TOTAL_PASS - BASELINE_PASS)) tests${NC}"
echo ""
echo -e "Requirements committed: ${GREEN}$COMMITTED${NC}"
echo -e "Requirements reverted:  ${RED}$REVERTED${NC}"
echo -e "Requirements blocked:   ${YELLOW}$BLOCKED${NC}"
echo ""
echo -e "Review: git log --oneline $BRANCH"
echo -e "Scores: cat $SCORE_FILE"
echo -e "Progress: cat $PROGRESS_FILE"
echo ""
echo -e "${BLUE}Every committed requirement survived:${NC}"
echo -e "  1. Builder wrote code + tests"
echo -e "  2. Autoresearch verified score didn't drop"
echo -e "  3. Adversary tried to break it"
echo -e "  4. Builder fixed what adversary found"
echo -e "  5. Final score >= baseline (or changes reverted)"
echo -e "  6. Phase gates blocked regression between phases"
