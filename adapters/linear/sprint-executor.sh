#!/bin/bash
# =============================================================================
# SPRINT EXECUTOR — Provider-Agnostic Build→Review→Fix Loop via Linear
# =============================================================================
#
# Takes a Linear issue ID, builds it with TDD, reviews adversarially with a
# second agent, fixes findings, and updates Linear throughout. Any agent that
# can run shell commands can participate.
#
# The key insight: Linear CLI is the coordination layer. Claude Code, Codex,
# Aider, Qwen Code, Jules — any agent that can call `linear issue update`
# and `linear issue comment add` can participate in this loop.
#
# Three ML concepts (same as overnight-adversarial-v2):
#   1. AUTORESEARCH — test pass count must never decrease
#   2. ADVERSARIAL — builder agent vs reviewer agent
#   3. ANNEALING — conservative retries on failure
#
# =============================================================================
# PROVIDER CONFIGURATION
# =============================================================================
#
# Set these environment variables to choose your agents:
#
#   BUILDER_AGENT    — who builds (default: claude)
#   REVIEWER_AGENT   — who reviews (default: codex)
#   FIXER_AGENT      — who fixes review findings (default: same as BUILDER_AGENT)
#
# Supported values:
#   claude   — Claude Code headless mode
#   codex    — OpenAI Codex CLI
#   aider    — Aider with any OpenRouter model
#   qwen     — Qwen Code CLI
#
# Agent-specific env vars:
#   AIDER_MODEL       — model for Aider (default: openrouter/qwen/qwen3-coder-480b)
#   OPENROUTER_API_KEY — required for Aider
#   QWEN_MODEL        — model for Qwen Code (default: qwen3-coder)
#
# =============================================================================
# Usage:
#   ./sprint-executor.sh DRS-10
#   ./sprint-executor.sh DRS-10 DRS-11 DRS-12         # Sequential batch
#   BUILDER_AGENT=aider REVIEWER_AGENT=codex ./sprint-executor.sh DRS-10
#   BUILDER_AGENT=qwen REVIEWER_AGENT=claude ./sprint-executor.sh DRS-10
#
# Environment:
#   BUILDER_AGENT=claude|codex|aider|qwen    (default: claude)
#   REVIEWER_AGENT=claude|codex|aider|qwen   (default: codex)
#   FIXER_AGENT=claude|codex|aider|qwen      (default: $BUILDER_AGENT)
#   NOTIFY_WEBHOOK=https://...               (optional: Slack/Discord webhook)
#   TEST_CMD="npm test"                      (default: auto-detect)
#   TYPE_CHECK_CMD="npx tsc --noEmit"        (default: npx tsc --noEmit)
#   LINEAR_TEAM=DRS                          (default: auto-detect)
# =============================================================================

set -uo pipefail

# ─── CONFIGURATION ──────────────────────────────────────────────────────────
BUILDER_AGENT="${BUILDER_AGENT:-claude}"
REVIEWER_AGENT="${REVIEWER_AGENT:-codex}"
FIXER_AGENT="${FIXER_AGENT:-$BUILDER_AGENT}"
AIDER_MODEL="${AIDER_MODEL:-openrouter/qwen/qwen3-coder-480b}"
QWEN_MODEL="${QWEN_MODEL:-qwen3-coder}"
NOTIFY_WEBHOOK="${NOTIFY_WEBHOOK:-}"
TEST_CMD="${TEST_CMD:-}"
TYPE_CHECK_CMD="${TYPE_CHECK_CMD:-npx tsc --noEmit}"
LINEAR_TEAM="${LINEAR_TEAM:-}"
MAX_HEAL_ATTEMPTS=3
MAX_REVIEW_ROUNDS=2
STATUS_FILE=".planning/sprint-executor-status.json"

# ─── COLORS ─────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ─── HELPERS ────────────────────────────────────────────────────────────────
log()    { echo -e "${BLUE}[$(date +%H:%M:%S)]${NC} $1"; }
ok()     { echo -e "${GREEN}[$(date +%H:%M:%S)] ✓${NC} $1"; }
warn()   { echo -e "${YELLOW}[$(date +%H:%M:%S)] ⚠${NC} $1"; }
fail()   { echo -e "${RED}[$(date +%H:%M:%S)] ✗${NC} $1"; }
header() { echo -e "\n${CYAN}═══════════════════════════════════════════════════${NC}"; echo -e "${CYAN}  $1${NC}"; echo -e "${CYAN}═══════════════════════════════════════════════════${NC}\n"; }

notify() {
  local message=$1
  if [ -n "$NOTIFY_WEBHOOK" ]; then
    curl -s -X POST "$NOTIFY_WEBHOOK" \
      -H "Content-Type: application/json" \
      -d "{\"text\": \"[Sprint Executor] $message\"}" \
      2>/dev/null || true
  fi
}

update_status() {
  local issue_id=$1 phase=$2 detail=$3
  cat > "$STATUS_FILE" << EOF
{
  "issue": "$issue_id",
  "phase": "$phase",
  "detail": "$detail",
  "builder": "$BUILDER_AGENT",
  "reviewer": "$REVIEWER_AGENT",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
}

# ─── AUTO-DETECT TEST COMMAND ───────────────────────────────────────────────
detect_test_cmd() {
  if [ -n "$TEST_CMD" ]; then return; fi

  if [ -f "package.json" ]; then
    if grep -q '"test"' package.json 2>/dev/null; then
      if grep -q 'vitest' package.json 2>/dev/null; then
        TEST_CMD="npx vitest run"
      elif grep -q 'jest' package.json 2>/dev/null; then
        TEST_CMD="npx jest"
      else
        TEST_CMD="npm test"
      fi
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
  log "Auto-detected test command: ${TEST_CMD}"
}

# ─── AUTO-DETECT LINEAR TEAM ───────────────────────────────────────────────
detect_team() {
  if [ -n "$LINEAR_TEAM" ]; then return; fi
  LINEAR_TEAM=$(linear team list 2>/dev/null | tail -n +2 | head -1 | awk '{print $1}')
  if [ -z "$LINEAR_TEAM" ]; then
    fail "Could not detect Linear team. Set LINEAR_TEAM env var."
    exit 1
  fi
  log "Auto-detected Linear team: ${LINEAR_TEAM}"
}

# ─── COUNT PASSING TESTS ───────────────────────────────────────────────────
count_passing_tests() {
  local output
  output=$($TEST_CMD 2>&1) || true
  local count=0

  # Try vitest/jest format: "X passed"
  count=$(echo "$output" | grep -oE '[0-9]+ passed' | grep -oE '[0-9]+' | head -1)
  if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then echo "$count"; return; fi

  # Try pytest format: "X passed"
  count=$(echo "$output" | grep -oE '[0-9]+ passed' | grep -oE '[0-9]+' | head -1)
  if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then echo "$count"; return; fi

  # Try go test format: count "ok" lines
  count=$(echo "$output" | grep -c '^ok' || true)
  if [ "$count" -gt 0 ] 2>/dev/null; then echo "$count"; return; fi

  # Fallback: count "✓" or "PASS" lines
  count=$(echo "$output" | grep -cE '(✓|✔|PASS)' || true)
  echo "${count:-0}"
}

# ─── AGENT RUNNER ───────────────────────────────────────────────────────────
# Runs a prompt through the specified agent. Provider-agnostic.
# Usage: run_agent <agent_name> <prompt> [allowed_tools]
run_agent() {
  local agent=$1
  local prompt=$2
  local allowed_tools="${3:-}"

  case "$agent" in
    claude)
      if [ -n "$allowed_tools" ]; then
        claude -p "$prompt" --allowedTools "$allowed_tools" 2>&1
      else
        claude -p "$prompt" 2>&1
      fi
      ;;
    codex)
      codex "$prompt" 2>&1
      ;;
    aider)
      echo "$prompt" | aider --model "$AIDER_MODEL" --no-auto-commits --message "$prompt" 2>&1
      ;;
    qwen)
      qwen-code -p "$prompt" 2>&1
      ;;
    *)
      fail "Unknown agent: $agent. Supported: claude, codex, aider, qwen"
      return 1
      ;;
  esac
}

# ─── EXECUTE ONE ISSUE ─────────────────────────────────────────────────────
execute_issue() {
  local ISSUE_ID=$1
  local START_TIME=$(date +%s)

  header "EXECUTING: ${ISSUE_ID}"
  log "Builder: ${BUILDER_AGENT} | Reviewer: ${REVIEWER_AGENT} | Fixer: ${FIXER_AGENT}"

  # ── Read issue from Linear ──────────────────────────────────────────────
  update_status "$ISSUE_ID" "reading" "Fetching issue from Linear"
  log "Reading issue ${ISSUE_ID} from Linear..."

  local ISSUE_BODY
  ISSUE_BODY=$(linear issue view "$ISSUE_ID" --no-pager 2>&1)
  if [ $? -ne 0 ]; then
    fail "Could not read issue ${ISSUE_ID}: ${ISSUE_BODY}"
    return 1
  fi

  local ISSUE_TITLE
  ISSUE_TITLE=$(echo "$ISSUE_BODY" | head -1 | sed 's/^# //')
  ok "Loaded: ${ISSUE_TITLE}"

  # ── Check dependencies ──────────────────────────────────────────────────
  # Look for "DEPENDS ON:" in the issue description or comments
  local DEPENDS_ON
  DEPENDS_ON=$(echo "$ISSUE_BODY" | grep -i "depends on:" | head -1 || true)
  if [ -n "$DEPENDS_ON" ]; then
    log "Dependency found: ${DEPENDS_ON}"
    # Extract issue IDs from the depends line
    local DEP_IDS
    DEP_IDS=$(echo "$DEPENDS_ON" | grep -oE '[A-Z]+-[0-9]+' || true)
    for dep_id in $DEP_IDS; do
      local dep_state
      dep_state=$(linear issue view "$dep_id" --no-pager 2>&1 | grep -oE 'State: [A-Za-z ]+' | sed 's/State: //' || true)
      if [ -n "$dep_state" ] && ! echo "$dep_state" | grep -qi "done\|complete"; then
        warn "Dependency ${dep_id} is not done (state: ${dep_state}). Marking ${ISSUE_ID} as blocked."
        linear issue update "$ISSUE_ID" --state "Blocked" 2>/dev/null
        linear issue comment add "$ISSUE_ID" --body "BLOCKED: Waiting on dependency ${dep_id} (currently: ${dep_state})" 2>/dev/null
        notify "${ISSUE_ID} blocked on ${dep_id}"
        return 2
      fi
    done
    ok "All dependencies satisfied"
  fi

  # ── Mark as In Progress ─────────────────────────────────────────────────
  linear issue update "$ISSUE_ID" --state "In Progress" --assignee self 2>/dev/null
  linear issue comment add "$ISSUE_ID" --body "**Agent: ${BUILDER_AGENT}** — Starting TDD implementation" 2>/dev/null
  notify "${ISSUE_ID} started by ${BUILDER_AGENT}"

  # ── Measure baseline ───────────────────────────────────────────────────
  update_status "$ISSUE_ID" "baseline" "Measuring test baseline"
  log "Measuring test baseline..."
  local BEFORE_PASS
  BEFORE_PASS=$(count_passing_tests)
  ok "Baseline: ${BEFORE_PASS} tests passing"

  # ── Create worktree ────────────────────────────────────────────────────
  local BRANCH_NAME="wt/sprint-${ISSUE_ID}-$(date +%s)"
  local WORKTREE_DIR="../worktree-sprint-${ISSUE_ID}"
  local MAIN_DIR=$(pwd)

  log "Creating git worktree: ${WORKTREE_DIR}"
  git worktree add "$WORKTREE_DIR" -b "$BRANCH_NAME" 2>/dev/null
  cd "$WORKTREE_DIR"

  # ── PHASE 1: BUILD WITH TDD ────────────────────────────────────────────
  header "PHASE 1: BUILD (${BUILDER_AGENT})"
  update_status "$ISSUE_ID" "building" "TDD implementation in progress"

  local BUILD_PROMPT="You are building a feature for a software project.

LINEAR ISSUE: ${ISSUE_ID}
${ISSUE_BODY}

INSTRUCTIONS:
1. Read the task description above carefully
2. Follow TDD — write failing tests FIRST, then implement
3. Run tests with: ${TEST_CMD}
4. Run type check with: ${TYPE_CHECK_CMD}
5. Loop until all tests pass and types are clean
6. Do NOT commit — leave changes staged
7. When done, write a summary of what you built to /tmp/sprint-${ISSUE_ID}-build-summary.txt

IMPORTANT: Follow existing code patterns. Do not over-engineer. One requirement only."

  run_agent "$BUILDER_AGENT" "$BUILD_PROMPT"

  # ── Measure after build ─────────────────────────────────────────────────
  local AFTER_BUILD
  AFTER_BUILD=$(count_passing_tests)
  log "After build: ${AFTER_BUILD} tests passing (was: ${BEFORE_PASS})"

  if [ "$AFTER_BUILD" -lt "$BEFORE_PASS" ] 2>/dev/null; then
    warn "Test count dropped! Attempting to heal..."
    local healed=false
    for attempt in $(seq 1 $MAX_HEAL_ATTEMPTS); do
      warn "Heal attempt ${attempt}/${MAX_HEAL_ATTEMPTS} (more conservative each time)"
      run_agent "$BUILDER_AGENT" "Tests are failing. Fix ONLY the broken tests without changing working functionality. Be conservative. Run: ${TEST_CMD}" >/dev/null 2>&1
      AFTER_BUILD=$(count_passing_tests)
      if [ "$AFTER_BUILD" -ge "$BEFORE_PASS" ] 2>/dev/null; then
        ok "Healed on attempt ${attempt}"
        healed=true
        break
      fi
    done

    if [ "$healed" = false ]; then
      fail "Could not heal. Deleting worktree and skipping."
      cd "$MAIN_DIR"
      git worktree remove "$WORKTREE_DIR" --force 2>/dev/null
      git branch -D "$BRANCH_NAME" 2>/dev/null
      linear issue comment add "$ISSUE_ID" --body "**Agent: ${BUILDER_AGENT}** — BUILD FAILED: Test count dropped from ${BEFORE_PASS} to ${AFTER_BUILD} and could not heal after ${MAX_HEAL_ATTEMPTS} attempts. Worktree deleted." 2>/dev/null
      linear issue update "$ISSUE_ID" --state "Blocked" 2>/dev/null
      notify "${ISSUE_ID} BUILD FAILED — test regression"
      return 1
    fi
  fi

  # Commit build work in worktree
  git add -A 2>/dev/null
  git commit -m "feat: ${ISSUE_TITLE} (${ISSUE_ID}) — TDD implementation" 2>/dev/null || true

  linear issue comment add "$ISSUE_ID" --body "**Agent: ${BUILDER_AGENT}** — Build complete. Tests: ${BEFORE_PASS} → ${AFTER_BUILD} (+$((AFTER_BUILD - BEFORE_PASS)))" 2>/dev/null

  # ── PHASE 2: ADVERSARIAL REVIEW ────────────────────────────────────────
  header "PHASE 2: ADVERSARIAL REVIEW (${REVIEWER_AGENT})"
  update_status "$ISSUE_ID" "reviewing" "Adversarial review in progress"

  local DIFF
  DIFF=$(git diff main --stat 2>/dev/null)
  local FULL_DIFF
  FULL_DIFF=$(git diff main 2>/dev/null)

  local REVIEW_PROMPT="You are the ADVERSARY agent. Your job is to BREAK the code that was just written.

LINEAR ISSUE: ${ISSUE_ID} — ${ISSUE_TITLE}

FILES CHANGED:
${DIFF}

FULL DIFF:
${FULL_DIFF}

YOUR MISSION:
1. Read the diff carefully
2. Find bugs: edge cases, missing null checks, missing error handling, SQL injection, XSS, race conditions, off-by-one errors, missing validation, broken existing functionality
3. For each bug found, report: FILE, LINE, SEVERITY (critical/major/minor), EXACT FIX
4. Write ALL findings to /tmp/sprint-${ISSUE_ID}-review.md
5. If you can write failing tests that expose bugs, do so
6. Run: ${TEST_CMD}

Be ruthless. Think like a hacker and a QA engineer combined.
If you genuinely find no bugs, write 'NO BUGS FOUND' to the file."

  run_agent "$REVIEWER_AGENT" "$REVIEW_PROMPT"

  # Read review findings
  local REVIEW_FILE="/tmp/sprint-${ISSUE_ID}-review.md"
  local FINDINGS=""
  if [ -f "$REVIEW_FILE" ]; then
    FINDINGS=$(cat "$REVIEW_FILE")
  fi

  # Post findings to Linear
  if [ -n "$FINDINGS" ]; then
    # Write findings to a temp file for --body-file (handles markdown properly)
    local COMMENT_FILE="/tmp/sprint-${ISSUE_ID}-review-comment.md"
    echo "**Agent: ${REVIEWER_AGENT} (Adversary)**" > "$COMMENT_FILE"
    echo "" >> "$COMMENT_FILE"
    cat "$REVIEW_FILE" >> "$COMMENT_FILE"
    linear issue comment add "$ISSUE_ID" --body-file "$COMMENT_FILE" 2>/dev/null
  else
    linear issue comment add "$ISSUE_ID" --body "**Agent: ${REVIEWER_AGENT} (Adversary)** — Review complete. No findings file generated." 2>/dev/null
  fi

  # ── PHASE 3: FIX FINDINGS ──────────────────────────────────────────────
  if [ -f "$REVIEW_FILE" ] && ! grep -qi "no bugs found\|no issues found\|lgtm" "$REVIEW_FILE" 2>/dev/null; then
    header "PHASE 3: FIX FINDINGS (${FIXER_AGENT})"
    update_status "$ISSUE_ID" "fixing" "Addressing adversarial findings"

    for round in $(seq 1 $MAX_REVIEW_ROUNDS); do
      log "Fix round ${round}/${MAX_REVIEW_ROUNDS}"

      local FIX_PROMPT="You are fixing bugs found by an adversarial code reviewer.

LINEAR ISSUE: ${ISSUE_ID} — ${ISSUE_TITLE}

REVIEW FINDINGS:
$(cat "$REVIEW_FILE")

INSTRUCTIONS:
1. For each finding, apply the fix
2. Do NOT change test expectations — fix the CODE
3. Run tests: ${TEST_CMD}
4. Run type check: ${TYPE_CHECK_CMD}
5. Loop until all tests pass
6. Write a summary of fixes to /tmp/sprint-${ISSUE_ID}-fixes.txt"

      run_agent "$FIXER_AGENT" "$FIX_PROMPT"

      local AFTER_FIX
      AFTER_FIX=$(count_passing_tests)

      if [ "$AFTER_FIX" -ge "$AFTER_BUILD" ] 2>/dev/null; then
        ok "Fixes applied. Tests: ${AFTER_FIX} passing"
        git add -A 2>/dev/null
        git commit -m "fix: address adversarial review for ${ISSUE_ID}" 2>/dev/null || true
        linear issue comment add "$ISSUE_ID" --body "**Agent: ${FIXER_AGENT}** — Adversarial findings addressed. Tests: ${AFTER_FIX} passing." 2>/dev/null
        AFTER_BUILD=$AFTER_FIX
        break
      else
        warn "Fix round ${round} caused regression. Tests: ${AFTER_FIX} (was: ${AFTER_BUILD})"
        if [ "$round" -eq "$MAX_REVIEW_ROUNDS" ]; then
          warn "Max fix rounds reached. Proceeding with best effort."
        fi
      fi
    done
  else
    ok "No bugs found by ${REVIEWER_AGENT}. Skipping fix phase."
  fi

  # ── FINAL SCORE CHECK (Autoresearch iron law) ──────────────────────────
  header "FINAL VALIDATION"
  update_status "$ISSUE_ID" "validating" "Final score check"

  local FINAL_PASS
  FINAL_PASS=$(count_passing_tests)

  local TYPE_OK=true
  $TYPE_CHECK_CMD 2>/dev/null || TYPE_OK=false

  log "Final score: ${FINAL_PASS} passing (baseline was: ${BEFORE_PASS})"
  log "Type check: $([ "$TYPE_OK" = true ] && echo 'PASS' || echo 'FAIL')"

  # ── MERGE OR REVERT ────────────────────────────────────────────────────
  cd "$MAIN_DIR"

  if [ "$FINAL_PASS" -ge "$BEFORE_PASS" ] 2>/dev/null; then
    header "MERGING: ${ISSUE_ID}"
    git merge "$BRANCH_NAME" --no-ff -m "feat: ${ISSUE_TITLE} (${ISSUE_ID}) — score: ${BEFORE_PASS}→${FINAL_PASS}, adversary: ${REVIEWER_AGENT}" 2>/dev/null
    git worktree remove "$WORKTREE_DIR" 2>/dev/null || true
    git branch -d "$BRANCH_NAME" 2>/dev/null || true

    local ELAPSED=$(( $(date +%s) - START_TIME ))
    local ELAPSED_MIN=$(( ELAPSED / 60 ))

    linear issue update "$ISSUE_ID" --state "Done" 2>/dev/null
    linear issue comment add "$ISSUE_ID" --body "**COMPLETED** in ${ELAPSED_MIN}min | Builder: ${BUILDER_AGENT} | Reviewer: ${REVIEWER_AGENT} | Tests: ${BEFORE_PASS}→${FINAL_PASS} (+$((FINAL_PASS - BEFORE_PASS)))" 2>/dev/null
    notify "${ISSUE_ID} DONE — ${ISSUE_TITLE} (${ELAPSED_MIN}min)"

    ok "MERGED: ${ISSUE_ID} | Score: ${BEFORE_PASS} → ${FINAL_PASS} | Time: ${ELAPSED_MIN}min"
    update_status "$ISSUE_ID" "done" "Merged successfully"
    return 0
  else
    header "REVERTING: ${ISSUE_ID}"
    git worktree remove "$WORKTREE_DIR" --force 2>/dev/null
    git branch -D "$BRANCH_NAME" 2>/dev/null

    linear issue update "$ISSUE_ID" --state "Blocked" 2>/dev/null
    linear issue comment add "$ISSUE_ID" --body "**REVERTED** — Final score ${FINAL_PASS} < baseline ${BEFORE_PASS}. Worktree deleted. Needs manual attention." 2>/dev/null
    notify "${ISSUE_ID} REVERTED — score regression"

    fail "REVERTED: ${ISSUE_ID} | Score dropped: ${BEFORE_PASS} → ${FINAL_PASS}"
    update_status "$ISSUE_ID" "reverted" "Score regression — worktree deleted"
    return 1
  fi
}

# ─── MAIN ───────────────────────────────────────────────────────────────────

if [ $# -eq 0 ]; then
  echo "Usage: $0 <ISSUE_ID> [ISSUE_ID...]"
  echo ""
  echo "Execute Linear issues through the full build→review→fix loop."
  echo ""
  echo "Examples:"
  echo "  $0 DRS-10                                    # Single issue"
  echo "  $0 DRS-10 DRS-11 DRS-12                      # Sequential batch"
  echo "  BUILDER_AGENT=aider $0 DRS-10                # Use Aider as builder"
  echo "  REVIEWER_AGENT=claude $0 DRS-10              # Use Claude as reviewer"
  echo ""
  echo "Environment variables:"
  echo "  BUILDER_AGENT   claude|codex|aider|qwen  (default: claude)"
  echo "  REVIEWER_AGENT  claude|codex|aider|qwen  (default: codex)"
  echo "  FIXER_AGENT     claude|codex|aider|qwen  (default: \$BUILDER_AGENT)"
  echo "  NOTIFY_WEBHOOK  Slack/Discord webhook URL"
  echo "  TEST_CMD        Override test command (auto-detected)"
  echo "  LINEAR_TEAM     Override team key (auto-detected)"
  echo "  AIDER_MODEL     Model for Aider (default: openrouter/qwen/qwen3-coder-480b)"
  exit 0
fi

# Pre-flight checks
header "SPRINT EXECUTOR — PRE-FLIGHT"
log "Builder: ${BUILDER_AGENT} | Reviewer: ${REVIEWER_AGENT} | Fixer: ${FIXER_AGENT}"

# Verify Linear CLI
if ! command -v linear &>/dev/null; then
  fail "Linear CLI not found. Install: brew install schpet/tap/linear"
  exit 1
fi
linear auth whoami >/dev/null 2>&1 || { fail "Linear not authenticated. Run: linear auth login"; exit 1; }
ok "Linear CLI authenticated"

# Verify builder agent
case "$BUILDER_AGENT" in
  claude) command -v claude &>/dev/null || { fail "Claude Code not found"; exit 1; } ;;
  codex)  command -v codex &>/dev/null  || { fail "Codex CLI not found"; exit 1; } ;;
  aider)  command -v aider &>/dev/null  || { fail "Aider not found. Install: pip install aider-chat"; exit 1; } ;;
  qwen)   command -v qwen-code &>/dev/null || { fail "Qwen Code not found"; exit 1; } ;;
esac
ok "Builder agent: ${BUILDER_AGENT}"

# Verify reviewer agent
case "$REVIEWER_AGENT" in
  claude) command -v claude &>/dev/null || { fail "Claude Code not found"; exit 1; } ;;
  codex)  command -v codex &>/dev/null  || { fail "Codex CLI not found"; exit 1; } ;;
  aider)  command -v aider &>/dev/null  || { fail "Aider not found"; exit 1; } ;;
  qwen)   command -v qwen-code &>/dev/null || { fail "Qwen Code not found"; exit 1; } ;;
esac
ok "Reviewer agent: ${REVIEWER_AGENT}"

detect_test_cmd
detect_team

mkdir -p .planning

# ─── EXECUTE ISSUES ─────────────────────────────────────────────────────────
TOTAL=$#
COMPLETED=0
FAILED=0
BLOCKED=0

header "EXECUTING ${TOTAL} ISSUE(S)"

for ISSUE_ID in "$@"; do
  log "Issue ${ISSUE_ID} ($(( COMPLETED + FAILED + BLOCKED + 1 ))/${TOTAL})"
  execute_issue "$ISSUE_ID"
  result=$?
  case $result in
    0) COMPLETED=$((COMPLETED + 1)) ;;
    2) BLOCKED=$((BLOCKED + 1)) ;;
    *) FAILED=$((FAILED + 1)) ;;
  esac
done

# ─── FINAL REPORT ───────────────────────────────────────────────────────────
header "SPRINT EXECUTOR — FINAL REPORT"
echo -e "Builder:   ${BUILDER_AGENT}"
echo -e "Reviewer:  ${REVIEWER_AGENT}"
echo -e "Fixer:     ${FIXER_AGENT}"
echo -e ""
echo -e "Total:     ${TOTAL}"
echo -e "${GREEN}Completed: ${COMPLETED}${NC}"
echo -e "${RED}Failed:    ${FAILED}${NC}"
echo -e "${YELLOW}Blocked:   ${BLOCKED}${NC}"

notify "Sprint complete: ${COMPLETED}/${TOTAL} done, ${FAILED} failed, ${BLOCKED} blocked"

# Exit with failure if any issues failed
[ "$FAILED" -eq 0 ] && [ "$BLOCKED" -eq 0 ]
