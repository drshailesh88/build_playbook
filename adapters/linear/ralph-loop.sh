#!/bin/bash
# =============================================================================
# RALPH LOOP — Simple Build Loop with Linear Tracking
# =============================================================================
#
# Geoffrey Huntley's Ralph pattern: sit ON the loop, not IN it.
# Each iteration = one Linear issue = fresh Claude Code session = zero context rot.
# Linear is the scoreboard. Watch progress from your phone.
#
# Flow per iteration:
#   1. Query Linear for next unblocked "unstarted" issue
#   2. Mark "In Progress" in Linear
#   3. Claude Code builds it (TDD, fresh context)
#   4. Verify: tests pass, types clean, score didn't drop
#   5. Pass → mark Done in Linear, commit
#   6. Fail → heal attempts → if still failing, mark Blocked
#   7. Next issue
#
# Usage:
#   ./ralph-loop.sh                                    # Auto-detect project
#   ./ralph-loop.sh "My Project"                       # Specify project
#   ./ralph-loop.sh "My Project" 30                    # Max 30 iterations
#
# Environment:
#   LINEAR_TEAM=DRS                 Override team key (auto-detected)
#   TEST_CMD="npm test"             Override test command (auto-detected)
#   TYPE_CHECK_CMD="npx tsc --noEmit"  Override type check
#   NOTIFY_WEBHOOK=https://...      Slack/Discord/Telegram webhook
#   RALPH_LABEL="phase-1"           Only process issues with this label
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
SCORE_FILE=".planning/ralph-scores.jsonl"
STATUS_FILE=".planning/ralph-status.json"

# ─── COLORS ─────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

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
      -d "{\"text\": \"[Ralph Loop] $message\"}" \
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
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
}

log_score() {
  local iteration=$1 issue_id=$2 pass_before=$3 pass_after=$4 action=$5
  mkdir -p .planning
  echo "{\"ts\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"iter\":$iteration,\"issue\":\"$issue_id\",\"before\":$pass_before,\"after\":$pass_after,\"action\":\"$action\"}" >> "$SCORE_FILE"
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
  # Try to get from .planning/STATE.md
  if [ -f ".planning/STATE.md" ]; then
    PROJECT=$(grep -i "project\|milestone" .planning/STATE.md | head -1 | sed 's/.*: *//' | sed 's/#.*//' | xargs)
  fi
  if [ -z "$PROJECT" ]; then
    # List projects and ask
    echo -e "${YELLOW}Available Linear projects:${NC}"
    linear project list --no-pager 2>/dev/null
    echo ""
    echo -e "${YELLOW}Specify project: ./ralph-loop.sh \"Project Name\"${NC}"
    exit 1
  fi
  log "Project: ${PROJECT}"
}

# ─── COUNT PASSING TESTS ──────────────────────────────────────────────────
count_passing() {
  local output
  output=$($TEST_CMD 2>&1) || true
  local count=0

  # Vitest/Jest: "X passed"
  count=$(echo "$output" | grep -oE '[0-9]+ passed' | grep -oE '[0-9]+' | head -1)
  if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then echo "$count"; return; fi

  # Go: count "ok" lines
  count=$(echo "$output" | grep -c '^ok' || true)
  if [ "$count" -gt 0 ] 2>/dev/null; then echo "$count"; return; fi

  # Fallback: count checkmarks or PASS lines
  count=$(echo "$output" | grep -cE '(✓|✔|PASS)' || true)
  echo "${count:-0}"
}

# ─── GET NEXT ISSUE FROM LINEAR ───────────────────────────────────────────
get_next_issue() {
  local list_cmd="linear issue list --team $LINEAR_TEAM --project \"$PROJECT\" --state unstarted --sort priority --no-pager --limit 10"

  if [ -n "$RALPH_LABEL" ]; then
    list_cmd="$list_cmd --label \"$RALPH_LABEL\""
  fi

  # Get first issue ID from the list (skip header line)
  local issue_line
  issue_line=$(eval "$list_cmd" 2>/dev/null | tail -n +2 | head -1)

  if [ -z "$issue_line" ]; then
    echo ""
    return
  fi

  # Extract issue ID (format: DRS-10 or similar)
  echo "$issue_line" | grep -oE '[A-Z]+-[0-9]+' | head -1
}

# ─── GET ISSUE TITLE ──────────────────────────────────────────────────────
get_issue_title() {
  local issue_id=$1
  linear issue view "$issue_id" --no-pager 2>/dev/null | head -1 | sed 's/^# //'
}

# ─── CHECK IF ISSUE HAS UNRESOLVED DEPENDENCIES ──────────────────────────
check_dependencies() {
  local issue_id=$1
  local body
  body=$(linear issue view "$issue_id" --no-pager 2>/dev/null)

  local depends_line
  depends_line=$(echo "$body" | grep -i "depends on:\|blocked.by:" | head -1 || true)

  if [ -z "$depends_line" ]; then
    return 0  # No dependencies
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

header "RALPH LOOP — PRE-FLIGHT"

# Verify Linear CLI
if ! command -v linear &>/dev/null; then
  fail "Linear CLI not found. Install: brew install schpet/tap/linear"
  exit 1
fi
linear auth whoami >/dev/null 2>&1 || { fail "Linear not authenticated. Run: linear auth login"; exit 1; }
ok "Linear CLI authenticated"

# Verify Claude Code
if ! command -v claude &>/dev/null; then
  fail "Claude Code CLI not found."
  exit 1
fi
ok "Claude Code available"

detect_team
detect_project
detect_test_cmd

# Clean working tree check
DIRTY=$(git status --porcelain 2>/dev/null | grep -v "^??" | wc -l | tr -d ' ')
if [ "$DIRTY" -gt 0 ]; then
  fail "Working tree has $DIRTY uncommitted changes."
  echo -e "Run: ${YELLOW}git stash${NC} or ${YELLOW}git add -A && git commit -m 'wip: save before ralph loop'${NC}"
  exit 1
fi
ok "Clean working tree"

# Baseline score
log "Measuring baseline..."
BASELINE_PASS=$(count_passing)
ok "Baseline: ${BASELINE_PASS} tests passing"

mkdir -p .planning

# =============================================================================
# THE RALPH LOOP
# =============================================================================

header "RALPH LOOP — STARTING"
echo -e "Project:        ${CYAN}${PROJECT}${NC}"
echo -e "Team:           ${CYAN}${LINEAR_TEAM}${NC}"
echo -e "Max iterations: ${CYAN}${MAX_ITERATIONS}${NC}"
echo -e "Test command:   ${CYAN}${TEST_CMD}${NC}"
echo -e "Baseline:       ${GREEN}${BASELINE_PASS} passing${NC}"
echo ""

COMPLETED=0
FAILED=0
SKIPPED=0
CONSECUTIVE_EMPTY=0

notify "Ralph Loop started: project=${PROJECT}, baseline=${BASELINE_PASS} passing"

for ((i=1; i<=MAX_ITERATIONS; i++)); do

  # ── Get next issue ──────────────────────────────────────────────────────
  ISSUE_ID=$(get_next_issue)

  if [ -z "$ISSUE_ID" ]; then
    header "ALL ISSUES COMPLETE"
    notify "All issues done! ${COMPLETED} completed, ${FAILED} failed, ${SKIPPED} skipped"
    break
  fi

  ISSUE_TITLE=$(get_issue_title "$ISSUE_ID")

  header "ITERATION ${i}/${MAX_ITERATIONS}: ${ISSUE_ID}"
  log "Issue: ${ISSUE_TITLE}"
  update_status "$ISSUE_ID" "starting" "$ISSUE_TITLE" "$i"

  # ── Check dependencies ─────────────────────────────────────────────────
  if ! check_dependencies "$ISSUE_ID"; then
    warn "Skipping ${ISSUE_ID} — has unresolved dependencies"
    linear issue update "$ISSUE_ID" --state "Blocked" 2>/dev/null || true
    linear issue comment add "$ISSUE_ID" --body "Ralph Loop: skipped — unresolved dependencies" 2>/dev/null || true
    log_score "$i" "$ISSUE_ID" "$BASELINE_PASS" "$BASELINE_PASS" "SKIPPED_DEPS"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  # ── Mark In Progress ───────────────────────────────────────────────────
  linear issue update "$ISSUE_ID" --state "In Progress" 2>/dev/null || true
  linear issue comment add "$ISSUE_ID" --body "**Ralph Loop** iteration ${i} — Claude Code building" 2>/dev/null || true

  # ── Create feature branch ────────────────────────────────────────────
  BRANCH_NAME="wt/sprint-${ISSUE_ID}-$(date +%s)"
  git checkout -b "$BRANCH_NAME" 2>/dev/null || {
    fail "Could not create branch ${BRANCH_NAME}"
    SKIPPED=$((SKIPPED + 1))
    continue
  }
  log "Branch: ${BRANCH_NAME}"

  # ── Measure before ─────────────────────────────────────────────────────
  BEFORE_PASS=$(count_passing)
  update_status "$ISSUE_ID" "building" "Claude Code implementing" "$i"

  # ── Read full issue body for the prompt ─────────────────────────────────
  ISSUE_BODY=$(linear issue view "$ISSUE_ID" --no-pager 2>/dev/null)

  # ── BUILD: Fresh Claude Code session ────────────────────────────────────
  log "Building with Claude Code..."

  # Write the prompt to a temp file (avoids shell escaping issues with issue body)
  PROMPT_FILE="/tmp/ralph-prompt-${ISSUE_ID}.md"
  cat > "$PROMPT_FILE" << PROMPT
You are the BUILDER in a Ralph Loop. Build ONE Linear issue.

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
- Follow existing code patterns
- Do NOT over-engineer or add unrelated changes
- If the issue is too big, build the smallest meaningful slice
- If stuck, write what you learned to /tmp/ralph-stuck-${ISSUE_ID}.txt and stop
PROMPT

  claude -p "$(cat "$PROMPT_FILE")" \
    --dangerously-skip-permissions \
    2>&1 || true

  rm -f "$PROMPT_FILE"

  # ── Check if anything was built ────────────────────────────────────────
  CHANGED=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  NEW_FILES=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

  if [ "$CHANGED" -eq 0 ] && [ "$NEW_FILES" -eq 0 ]; then
    warn "No code changes. Claude may have errored or the issue is unclear."
    # Switch back to main and delete empty branch
    git checkout main 2>/dev/null || git checkout - 2>/dev/null
    git branch -D "$BRANCH_NAME" 2>/dev/null || true

    linear issue comment add "$ISSUE_ID" --body "**Ralph Loop** — No code changes produced. May need manual attention." 2>/dev/null || true
    log_score "$i" "$ISSUE_ID" "$BEFORE_PASS" "$BEFORE_PASS" "NO_CHANGES"

    CONSECUTIVE_EMPTY=$((CONSECUTIVE_EMPTY + 1))
    if [ "$CONSECUTIVE_EMPTY" -ge 3 ]; then
      fail "3 consecutive empty iterations. Stopping."
      notify "Ralph Loop stopped: 3 consecutive empty iterations"
      break
    fi
    SKIPPED=$((SKIPPED + 1))
    continue
  fi
  CONSECUTIVE_EMPTY=0

  # ── Verify: tests + types ──────────────────────────────────────────────
  update_status "$ISSUE_ID" "verifying" "Running tests and type check" "$i"
  log "Verifying..."

  AFTER_PASS=$(count_passing)
  TYPE_OK=true
  $TYPE_CHECK_CMD 2>/dev/null || TYPE_OK=false

  log "Score: ${BEFORE_PASS} → ${AFTER_PASS} | TypeCheck: $([ "$TYPE_OK" = true ] && echo 'PASS' || echo 'FAIL')"

  # ── Heal if score dropped or types broken ──────────────────────────────
  if [ "$AFTER_PASS" -lt "$BEFORE_PASS" ] || [ "$TYPE_OK" = false ]; then
    warn "Issues detected. Attempting to heal..."
    update_status "$ISSUE_ID" "healing" "Self-healing attempt" "$i"

    HEALED=false
    for ((heal=1; heal<=MAX_HEAL_ATTEMPTS; heal++)); do
      warn "Heal attempt ${heal}/${MAX_HEAL_ATTEMPTS}"

      local_reason=""
      if [ "$TYPE_OK" = false ]; then
        local_reason="TypeScript compilation failing."
      fi
      if [ "$AFTER_PASS" -lt "$BEFORE_PASS" ]; then
        local_reason="${local_reason} Test count dropped from ${BEFORE_PASS} to ${AFTER_PASS}."
      fi

      claude -p "Tests or types are broken after building ${ISSUE_ID}.
${local_reason}
Fix attempt ${heal} of ${MAX_HEAL_ATTEMPTS}. Be MORE CONSERVATIVE each attempt.
Attempt 1: Fix the obvious bug.
Attempt 2: Smaller fix, only touch failing lines.
Attempt 3: Minimal change. If can't fix, revert the breaking file.
Run: ${TEST_CMD} && ${TYPE_CHECK_CMD}" \
        --dangerously-skip-permissions \
        2>&1 || true

      AFTER_PASS=$(count_passing)
      TYPE_OK=true
      $TYPE_CHECK_CMD 2>/dev/null || TYPE_OK=false

      if [ "$AFTER_PASS" -ge "$BEFORE_PASS" ] && [ "$TYPE_OK" = true ]; then
        ok "Healed on attempt ${heal}"
        HEALED=true
        break
      fi
    done

    if [ "$HEALED" = false ]; then
      fail "Could not heal after ${MAX_HEAL_ATTEMPTS} attempts. Discarding branch."

      # Switch back to main and delete the failed branch
      git checkout main 2>/dev/null || git checkout - 2>/dev/null
      git branch -D "$BRANCH_NAME" 2>/dev/null || true

      linear issue update "$ISSUE_ID" --state "Blocked" 2>/dev/null || true
      linear issue comment add "$ISSUE_ID" --body "**Ralph Loop** — BUILD FAILED. Score dropped ${BEFORE_PASS}→${AFTER_PASS}, could not heal after ${MAX_HEAL_ATTEMPTS} attempts. Branch deleted. Needs manual attention." 2>/dev/null || true
      notify "${ISSUE_ID} BLOCKED — score regression, could not heal"
      log_score "$i" "$ISSUE_ID" "$BEFORE_PASS" "$AFTER_PASS" "REVERTED"

      FAILED=$((FAILED + 1))
      continue
    fi
  fi

  # ── COMMIT ─────────────────────────────────────────────────────────────
  update_status "$ISSUE_ID" "committing" "Score held, committing" "$i"
  ok "Score held: ${BEFORE_PASS} → ${AFTER_PASS} (+$((AFTER_PASS - BEFORE_PASS)))"

  git add -A 2>/dev/null
  COMMIT_MSG="feat: ${ISSUE_TITLE} (${ISSUE_ID})

Ralph Loop iteration ${i}. Tests: ${BEFORE_PASS} → ${AFTER_PASS} (+$((AFTER_PASS - BEFORE_PASS)))."

  if git commit -m "$COMMIT_MSG" 2>/dev/null; then
    ok "Committed to branch: ${BRANCH_NAME}"
  else
    warn "Nothing to commit (changes may have been empty)"
  fi

  # ── Switch back to main ────────────────────────────────────────────────
  git checkout main 2>/dev/null || git checkout - 2>/dev/null

  # ── Update Linear: Built (not Done — merge-coordinator integrates) ────
  linear issue update "$ISSUE_ID" --label "built" 2>/dev/null || true
  linear issue comment add "$ISSUE_ID" --body "**Ralph Loop** — BUILT. Branch: \`${BRANCH_NAME}\`. Tests: ${BEFORE_PASS} → ${AFTER_PASS} (+$((AFTER_PASS - BEFORE_PASS))). Iteration ${i}. Ready for merge-coordinator." 2>/dev/null || true
  notify "${ISSUE_ID} BUILT — ${ISSUE_TITLE} — branch ${BRANCH_NAME}"
  log_score "$i" "$ISSUE_ID" "$BEFORE_PASS" "$AFTER_PASS" "BUILT"

  COMPLETED=$((COMPLETED + 1))

  echo ""
  log "Cooling down 3s before next iteration..."
  sleep 3
done

# =============================================================================
# FINAL REPORT
# =============================================================================

header "RALPH LOOP — COMPLETE"

FINAL_PASS=$(count_passing)

echo -e "Project:           ${CYAN}${PROJECT}${NC}"
echo -e "Iterations run:    ${CYAN}${i}${NC}"
echo -e ""
echo -e "Baseline score:    ${GREEN}${BASELINE_PASS} passing${NC}"
echo -e "Final score:       ${GREEN}${FINAL_PASS} passing${NC}"
echo -e "Net improvement:   ${GREEN}+$((FINAL_PASS - BASELINE_PASS)) tests${NC}"
echo -e ""
echo -e "${GREEN}Completed:         ${COMPLETED}${NC}"
echo -e "${RED}Failed:            ${FAILED}${NC}"
echo -e "${YELLOW}Skipped:           ${SKIPPED}${NC}"
echo -e ""
echo -e "Scores:  ${YELLOW}cat ${SCORE_FILE}${NC}"
echo -e "Status:  ${YELLOW}cat ${STATUS_FILE}${NC}"
echo -e "Linear:  ${YELLOW}linear issue list --team ${LINEAR_TEAM} --project \"${PROJECT}\" --all-states${NC}"
echo -e ""
echo -e "Built branches (ready for integration):"
git branch --list "wt/sprint-*" 2>/dev/null | while read -r b; do echo -e "  ${GREEN}${b}${NC}"; done
echo -e ""
echo -e "Next: ${YELLOW}./adapters/linear/merge-coordinator.sh${NC} to integrate branches"

notify "Ralph Loop complete: ${COMPLETED} built, ${FAILED} failed, ${SKIPPED} skipped. Score: ${BASELINE_PASS}→${FINAL_PASS}"
