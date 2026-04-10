#!/bin/bash
# =============================================================================
# MERGE COORDINATOR — Serial Integration of Built Branches
# =============================================================================
#
# After agents build features in parallel (via sprint-executor, ralph-loop,
# or parallel-sprint), this script serially integrates their branches onto
# a single integration branch, running tests after each merge.
#
# Why serial? Parallel builds are fast but produce independent branches.
# Merging them all at once causes conflicts. Serial replay means each
# merge sees the latest integrated state, conflicts are caught early,
# and tests validate the combined result — not just each branch alone.
#
# Flow:
#   1. Find all branches matching "wt/sprint-*" (built by sprint-executor)
#   2. Optionally sort by Linear dependency order
#   3. Create integration branch from main
#   4. For each branch (in order):
#      a. Merge onto integration branch
#      b. If conflict → attempt auto-resolution with Claude
#      c. Run tests after merge
#      d. If tests pass → mark Done in Linear
#      e. If tests fail or conflict unresolvable → mark Blocked, skip
#   5. Report results
#
# Usage:
#   ./merge-coordinator.sh                             # All wt/sprint-* branches
#   ./merge-coordinator.sh --project "My Project"      # Filter by Linear project
#   ./merge-coordinator.sh --branches branch1 branch2  # Specific branches
#   ./merge-coordinator.sh --no-auto-resolve           # Skip auto-resolution
#
# Environment:
#   LINEAR_TEAM=DRS                     Override team key
#   INTEGRATION_BRANCH=release/v2       Override integration branch name
#   TEST_CMD="npm test"                 Override test command
#   TYPE_CHECK_CMD="npx tsc --noEmit"   Override type check
#   NOTIFY_WEBHOOK=https://...          Notification webhook
# =============================================================================

set -uo pipefail

# ─── CONFIGURATION ──────────────────────────────────────────────────────────
LINEAR_TEAM="${LINEAR_TEAM:-}"
TEST_CMD="${TEST_CMD:-}"
TYPE_CHECK_CMD="${TYPE_CHECK_CMD:-npx tsc --noEmit}"
NOTIFY_WEBHOOK="${NOTIFY_WEBHOOK:-}"
INTEGRATION_BRANCH="${INTEGRATION_BRANCH:-integration/$(date +%Y%m%d-%H%M%S)}"
AUTO_RESOLVE=true
PROJECT=""
SPECIFIC_BRANCHES=()
STATUS_FILE=".planning/merge-coordinator-status.json"
LOG_FILE=".planning/merge-coordinator-log.jsonl"

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
header() { echo -e "\n${CYAN}═══════════════════════════════════════════════════${NC}"; echo -e "${CYAN}  $1${NC}"; echo -e "${CYAN}═══════════════════════════════════════════════════${NC}\n"; }

notify() {
  local message=$1
  if [ -n "$NOTIFY_WEBHOOK" ]; then
    curl -s -X POST "$NOTIFY_WEBHOOK" \
      -H "Content-Type: application/json" \
      -d "{\"text\": \"[Merge Coordinator] $message\"}" \
      2>/dev/null || true
  fi
}

update_status() {
  local phase=$1 detail=$2 integrated=$3 blocked=$4 remaining=$5
  mkdir -p .planning
  cat > "$STATUS_FILE" << EOF
{
  "phase": "$phase",
  "detail": "$detail",
  "integrationBranch": "$INTEGRATION_BRANCH",
  "integrated": $integrated,
  "blocked": $blocked,
  "remaining": $remaining,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
}

log_entry() {
  local branch=$1 issue_id=$2 action=$3 detail=$4
  mkdir -p .planning
  echo "{\"ts\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"branch\":\"$branch\",\"issue\":\"$issue_id\",\"action\":\"$action\",\"detail\":\"$detail\"}" >> "$LOG_FILE"
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
    warn "Could not detect Linear team. Linear updates will be skipped."
  else
    log "Linear team: ${LINEAR_TEAM}"
  fi
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

# ─── EXTRACT ISSUE ID FROM BRANCH NAME ────────────────────────────────────
extract_issue_id() {
  local branch=$1
  # Branch format: wt/sprint-DRS-10-1234567890
  echo "$branch" | grep -oE '[A-Z]+-[0-9]+' | head -1
}

# ─── FIND BUILT BRANCHES ─────────────────────────────────────────────────
find_built_branches() {
  if [ ${#SPECIFIC_BRANCHES[@]} -gt 0 ]; then
    for b in "${SPECIFIC_BRANCHES[@]}"; do
      echo "$b"
    done
    return
  fi

  # Find all wt/sprint-* branches
  git branch --list "wt/sprint-*" 2>/dev/null | tr -d ' '
}

# ─── SORT BRANCHES BY DEPENDENCY ORDER ────────────────────────────────────
# Uses Linear relations if available, otherwise falls back to branch creation order
sort_by_dependencies() {
  local branches=("$@")

  # If no Linear team detected, return as-is (creation order)
  if [ -z "$LINEAR_TEAM" ]; then
    for b in "${branches[@]}"; do echo "$b"; done
    return
  fi

  # Build dependency graph from Linear relations
  local dep_file="/tmp/merge-coord-deps-$$"
  local all_file="/tmp/merge-coord-all-$$"
  > "$dep_file"
  > "$all_file"

  for branch in "${branches[@]}"; do
    local issue_id
    issue_id=$(extract_issue_id "$branch")
    if [ -z "$issue_id" ]; then continue; fi

    echo "$issue_id $branch" >> "$all_file"

    # Query Linear for blocked-by relations
    local relations
    relations=$(linear issue view "$issue_id" --no-pager 2>/dev/null | grep -i "blocked.by\|depends on" || true)
    local dep_ids
    dep_ids=$(echo "$relations" | grep -oE '[A-Z]+-[0-9]+' || true)

    if [ -n "$dep_ids" ]; then
      for dep in $dep_ids; do
        # Only include if the dependency is also in our branch list
        if grep -q "^$dep " "$all_file" 2>/dev/null; then
          echo "$dep $issue_id" >> "$dep_file"  # tsort format: dependency before dependent
        fi
      done
    fi
  done

  # Topological sort if we have dependencies
  if [ -s "$dep_file" ]; then
    local sorted_issues
    sorted_issues=$(tsort "$dep_file" 2>/dev/null || true)

    if [ -n "$sorted_issues" ]; then
      # Output branches in sorted order, then any that weren't in the graph
      for issue in $sorted_issues; do
        local branch
        branch=$(grep "^$issue " "$all_file" | awk '{print $2}')
        if [ -n "$branch" ]; then
          echo "$branch"
        fi
      done
      # Add any branches not in the dependency graph
      for branch in "${branches[@]}"; do
        local issue_id
        issue_id=$(extract_issue_id "$branch")
        if ! echo "$sorted_issues" | grep -q "^$issue_id$" 2>/dev/null; then
          echo "$branch"
        fi
      done
    else
      # tsort failed (cycle?), return original order
      for b in "${branches[@]}"; do echo "$b"; done
    fi
  else
    # No dependencies found, return original order
    for b in "${branches[@]}"; do echo "$b"; done
  fi

  rm -f "$dep_file" "$all_file"
}

# ─── ATTEMPT AUTO-RESOLUTION ─────────────────────────────────────────────
auto_resolve_conflicts() {
  local issue_id=$1
  local branch=$2

  if [ "$AUTO_RESOLVE" = false ]; then
    return 1
  fi

  if ! command -v claude &>/dev/null; then
    warn "Claude Code not available for auto-resolution"
    return 1
  fi

  local conflicted_files
  conflicted_files=$(git diff --name-only --diff-filter=U 2>/dev/null)

  if [ -z "$conflicted_files" ]; then
    return 1
  fi

  log "Attempting auto-resolution of conflicts in: ${conflicted_files}"

  claude -p "There are merge conflicts in the following files after merging branch ${branch} for Linear issue ${issue_id}:

${conflicted_files}

The integration branch contains previously integrated work from other issues.
The incoming branch (${branch}) contains new work for ${issue_id}.

Resolve the conflicts by PRESERVING BOTH sides of the work:
- Keep all the previously integrated features
- Add the new features from ${branch}
- Do NOT drop either side's changes
- Fix any resulting type errors or import conflicts

After resolving, run: ${TEST_CMD} && ${TYPE_CHECK_CMD}

Mark all conflicts as resolved with: git add <file>" \
    --dangerously-skip-permissions \
    2>&1 || true

  # Check if conflicts are resolved
  local remaining_conflicts
  remaining_conflicts=$(git diff --name-only --diff-filter=U 2>/dev/null | wc -l | tr -d ' ')

  if [ "$remaining_conflicts" -eq 0 ]; then
    # Commit the resolution
    git commit --no-edit 2>/dev/null || true
    ok "Auto-resolved conflicts for ${issue_id}"
    return 0
  else
    warn "Auto-resolution incomplete — ${remaining_conflicts} files still conflicted"
    git merge --abort 2>/dev/null || true
    return 1
  fi
}

# ─── PARSE ARGUMENTS ─────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      PROJECT="$2"
      shift 2
      ;;
    --no-auto-resolve)
      AUTO_RESOLVE=false
      shift
      ;;
    --branches)
      shift
      while [[ $# -gt 0 ]] && [[ "$1" != --* ]]; do
        SPECIFIC_BRANCHES+=("$1")
        shift
      done
      ;;
    -h|--help)
      echo "Usage: $0 [--project \"Name\"] [--branches b1 b2] [--no-auto-resolve]"
      echo ""
      echo "Serial integration of Built branches with conflict resolution."
      echo ""
      echo "Options:"
      echo "  --project \"Name\"    Filter branches by Linear project"
      echo "  --branches b1 b2   Integrate specific branches (in order given)"
      echo "  --no-auto-resolve  Skip Claude auto-resolution, mark conflicts as Blocked"
      echo ""
      echo "Environment:"
      echo "  LINEAR_TEAM           Override team key (auto-detected)"
      echo "  INTEGRATION_BRANCH    Override branch name (default: integration/<timestamp>)"
      echo "  TEST_CMD              Override test command (auto-detected)"
      echo "  TYPE_CHECK_CMD        Override type check (default: npx tsc --noEmit)"
      echo "  NOTIFY_WEBHOOK        Slack/Discord/Telegram webhook"
      exit 0
      ;;
    *)
      # Treat as project name for backwards compatibility
      PROJECT="$1"
      shift
      ;;
  esac
done

# =============================================================================
# PRE-FLIGHT
# =============================================================================

header "MERGE COORDINATOR — PRE-FLIGHT"

# Verify git
if [ -z "$(git rev-parse --git-dir 2>/dev/null)" ]; then
  fail "Not a git repository"
  exit 1
fi
ok "Git repository"

# Check for clean working tree
DIRTY=$(git status --porcelain 2>/dev/null | grep -v "^??" | wc -l | tr -d ' ')
if [ "$DIRTY" -gt 0 ]; then
  fail "Working tree has $DIRTY uncommitted changes. Commit or stash first."
  exit 1
fi
ok "Clean working tree"

# Linear CLI (optional — degrades gracefully)
if command -v linear &>/dev/null; then
  linear auth whoami >/dev/null 2>&1 && ok "Linear CLI authenticated" || warn "Linear not authenticated — updates will be skipped"
  detect_team
else
  warn "Linear CLI not found — branch integration only, no Linear updates"
fi

detect_test_cmd

# Auto-resolve capability
if [ "$AUTO_RESOLVE" = true ]; then
  if command -v claude &>/dev/null; then
    ok "Auto-resolution: enabled (Claude Code)"
  else
    warn "Claude Code not found — auto-resolution disabled"
    AUTO_RESOLVE=false
  fi
else
  log "Auto-resolution: disabled"
fi

mkdir -p .planning

# =============================================================================
# FIND AND SORT BRANCHES
# =============================================================================

header "DISCOVERING BRANCHES"

mapfile -t RAW_BRANCHES < <(find_built_branches)

if [ ${#RAW_BRANCHES[@]} -eq 0 ]; then
  warn "No built branches found (wt/sprint-* pattern)"
  echo -e "Branches are created by sprint-executor.sh or ralph-loop.sh"
  exit 0
fi

log "Found ${#RAW_BRANCHES[@]} branch(es)"
for b in "${RAW_BRANCHES[@]}"; do
  local_issue=$(extract_issue_id "$b")
  log "  ${b} → ${local_issue:-unknown}"
done

log "Sorting by dependency order..."
mapfile -t BRANCHES < <(sort_by_dependencies "${RAW_BRANCHES[@]}")

echo ""
log "Integration order:"
for idx in "${!BRANCHES[@]}"; do
  echo -e "  ${CYAN}$((idx + 1)).${NC} ${BRANCHES[$idx]}"
done
echo ""

# =============================================================================
# CREATE INTEGRATION BRANCH
# =============================================================================

header "CREATING INTEGRATION BRANCH"

MAIN_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")
log "Base: ${MAIN_BRANCH}"
log "Integration branch: ${INTEGRATION_BRANCH}"

git checkout -b "$INTEGRATION_BRANCH" 2>/dev/null || {
  fail "Could not create integration branch: ${INTEGRATION_BRANCH}"
  exit 1
}
ok "Created: ${INTEGRATION_BRANCH}"

# Baseline score on integration branch
BASELINE_PASS=$(count_passing)
ok "Baseline: ${BASELINE_PASS} tests passing"

# =============================================================================
# SERIAL INTEGRATION LOOP
# =============================================================================

INTEGRATED=0
BLOCKED=0
SKIPPED=0
TOTAL=${#BRANCHES[@]}
CURRENT_PASS=$BASELINE_PASS

notify "Merge coordinator started: ${TOTAL} branches to integrate"

for ((idx=0; idx<TOTAL; idx++)); do
  BRANCH="${BRANCHES[$idx]}"
  ISSUE_ID=$(extract_issue_id "$BRANCH")
  STEP=$((idx + 1))

  header "INTEGRATING ${STEP}/${TOTAL}: ${BRANCH}"
  log "Issue: ${ISSUE_ID:-unknown}"
  update_status "integrating" "${BRANCH}" "$INTEGRATED" "$BLOCKED" "$((TOTAL - STEP))"

  # ── Attempt merge ────────────────────────────────────────────────────
  log "Merging ${BRANCH}..."

  MERGE_OUTPUT=$(git merge "$BRANCH" --no-ff -m "integrate: ${ISSUE_ID:-unknown} from ${BRANCH}" 2>&1)
  MERGE_EXIT=$?

  if [ $MERGE_EXIT -ne 0 ]; then
    # ── Merge conflict ───────────────────────────────────────────────
    warn "Merge conflict on ${BRANCH}"

    CONFLICTED_FILES=$(git diff --name-only --diff-filter=U 2>/dev/null || true)
    log "Conflicted files: ${CONFLICTED_FILES}"

    if auto_resolve_conflicts "$ISSUE_ID" "$BRANCH"; then
      ok "Conflicts auto-resolved"
    else
      fail "Could not resolve conflicts for ${BRANCH}"
      git merge --abort 2>/dev/null || true

      if [ -n "$ISSUE_ID" ] && [ -n "$LINEAR_TEAM" ]; then
        linear issue update "$ISSUE_ID" --state "Blocked" 2>/dev/null || true
        linear issue comment add "$ISSUE_ID" --body "**Merge Coordinator** — BLOCKED: merge conflict with integration branch. Conflicted files: ${CONFLICTED_FILES}" 2>/dev/null || true
      fi

      notify "${ISSUE_ID:-$BRANCH} BLOCKED — merge conflict"
      log_entry "$BRANCH" "${ISSUE_ID:-}" "BLOCKED" "merge conflict: ${CONFLICTED_FILES}"

      BLOCKED=$((BLOCKED + 1))
      continue
    fi
  fi

  # ── Post-merge test gate ─────────────────────────────────────────────
  log "Running post-merge tests..."

  AFTER_PASS=$(count_passing)
  TYPE_OK=true
  $TYPE_CHECK_CMD 2>/dev/null || TYPE_OK=false

  log "Tests: ${CURRENT_PASS} → ${AFTER_PASS} | TypeCheck: $([ "$TYPE_OK" = true ] && echo 'PASS' || echo 'FAIL')"

  # Gate: tests must pass and score must not drop
  GATE_FAILED=false
  GATE_REASON=""

  if [ "$TYPE_OK" = false ]; then
    GATE_FAILED=true
    GATE_REASON="TypeScript compilation failed after merge"
  elif [ "$AFTER_PASS" -lt "$CURRENT_PASS" ]; then
    GATE_FAILED=true
    GATE_REASON="Test count dropped from ${CURRENT_PASS} to ${AFTER_PASS} after merge"
  fi

  if [ "$GATE_FAILED" = true ]; then
    warn "Post-merge tests failed: ${GATE_REASON}"

    # Attempt auto-fix with Claude
    if [ "$AUTO_RESOLVE" = true ] && command -v claude &>/dev/null; then
      log "Attempting auto-fix of post-merge test failures..."

      claude -p "After merging branch ${BRANCH} (issue ${ISSUE_ID:-unknown}), tests are failing.
${GATE_REASON}

Fix the test failures WITHOUT removing any tests or features.
The integration branch has multiple merged features — preserve all of them.
Run: ${TEST_CMD} && ${TYPE_CHECK_CMD}" \
        --dangerously-skip-permissions \
        2>&1 || true

      AFTER_PASS=$(count_passing)
      TYPE_OK=true
      $TYPE_CHECK_CMD 2>/dev/null || TYPE_OK=false

      if [ "$AFTER_PASS" -ge "$CURRENT_PASS" ] && [ "$TYPE_OK" = true ]; then
        ok "Auto-fixed post-merge test failures"
        git add -A 2>/dev/null
        git commit -m "fix: resolve integration test failures for ${ISSUE_ID:-$BRANCH}" 2>/dev/null || true
      else
        fail "Could not auto-fix. Rolling back merge."
        git reset --hard HEAD~1 2>/dev/null

        if [ -n "$ISSUE_ID" ] && [ -n "$LINEAR_TEAM" ]; then
          linear issue update "$ISSUE_ID" --state "Blocked" 2>/dev/null || true
          linear issue comment add "$ISSUE_ID" --body "**Merge Coordinator** — BLOCKED: ${GATE_REASON}. Auto-fix failed." 2>/dev/null || true
        fi

        notify "${ISSUE_ID:-$BRANCH} BLOCKED — post-merge test failure"
        log_entry "$BRANCH" "${ISSUE_ID:-}" "BLOCKED" "$GATE_REASON"

        BLOCKED=$((BLOCKED + 1))
        continue
      fi
    else
      fail "Post-merge tests failed. Rolling back."
      git reset --hard HEAD~1 2>/dev/null

      if [ -n "$ISSUE_ID" ] && [ -n "$LINEAR_TEAM" ]; then
        linear issue update "$ISSUE_ID" --state "Blocked" 2>/dev/null || true
        linear issue comment add "$ISSUE_ID" --body "**Merge Coordinator** — BLOCKED: ${GATE_REASON}" 2>/dev/null || true
      fi

      log_entry "$BRANCH" "${ISSUE_ID:-}" "BLOCKED" "$GATE_REASON"

      BLOCKED=$((BLOCKED + 1))
      continue
    fi
  fi

  # ── Success — mark integrated ────────────────────────────────────────
  ok "Integrated: ${BRANCH} | Tests: ${CURRENT_PASS} → ${AFTER_PASS} (+$((AFTER_PASS - CURRENT_PASS)))"

  if [ -n "$ISSUE_ID" ] && [ -n "$LINEAR_TEAM" ]; then
    linear issue update "$ISSUE_ID" --state "Done" 2>/dev/null || true
    linear issue comment add "$ISSUE_ID" --body "**Merge Coordinator** — INTEGRATED into \`${INTEGRATION_BRANCH}\`. Tests: ${CURRENT_PASS}→${AFTER_PASS} (+$((AFTER_PASS - CURRENT_PASS)))." 2>/dev/null || true
  fi

  notify "${ISSUE_ID:-$BRANCH} INTEGRATED (+$((AFTER_PASS - CURRENT_PASS)) tests)"
  log_entry "$BRANCH" "${ISSUE_ID:-}" "INTEGRATED" "tests: ${CURRENT_PASS}→${AFTER_PASS}"

  CURRENT_PASS=$AFTER_PASS
  INTEGRATED=$((INTEGRATED + 1))
done

# =============================================================================
# FINAL REPORT
# =============================================================================

header "MERGE COORDINATOR — COMPLETE"

FINAL_PASS=$(count_passing)

echo -e "Integration branch:  ${CYAN}${INTEGRATION_BRANCH}${NC}"
echo -e "Base branch:         ${CYAN}${MAIN_BRANCH}${NC}"
echo -e ""
echo -e "Baseline score:      ${GREEN}${BASELINE_PASS} passing${NC}"
echo -e "Final score:         ${GREEN}${FINAL_PASS} passing${NC}"
echo -e "Net improvement:     ${GREEN}+$((FINAL_PASS - BASELINE_PASS)) tests${NC}"
echo -e ""
echo -e "Total branches:      ${CYAN}${TOTAL}${NC}"
echo -e "${GREEN}Integrated:          ${INTEGRATED}${NC}"
echo -e "${RED}Blocked:             ${BLOCKED}${NC}"
echo -e "${YELLOW}Skipped:             ${SKIPPED}${NC}"
echo -e ""

if [ "$BLOCKED" -gt 0 ]; then
  echo -e "${RED}Blocked branches need manual attention:${NC}"
  grep '"BLOCKED"' "$LOG_FILE" 2>/dev/null | while IFS= read -r line; do
    local_branch=$(echo "$line" | grep -oE '"branch":"[^"]*"' | cut -d'"' -f4)
    local_detail=$(echo "$line" | grep -oE '"detail":"[^"]*"' | cut -d'"' -f4)
    echo -e "  ${RED}${local_branch}${NC}: ${local_detail}"
  done
  echo ""
fi

echo -e "Next steps:"
echo -e "  1. Review: ${YELLOW}git log --oneline ${MAIN_BRANCH}..${INTEGRATION_BRANCH}${NC}"
echo -e "  2. Merge:  ${YELLOW}git checkout ${MAIN_BRANCH} && git merge ${INTEGRATION_BRANCH} --no-ff${NC}"
if [ "$BLOCKED" -gt 0 ]; then
  echo -e "  3. Fix:    Resolve blocked branches manually, then re-run merge-coordinator"
fi
echo -e ""
echo -e "Log:    ${YELLOW}cat ${LOG_FILE}${NC}"
echo -e "Status: ${YELLOW}cat ${STATUS_FILE}${NC}"

update_status "complete" "${INTEGRATED} integrated, ${BLOCKED} blocked" "$INTEGRATED" "$BLOCKED" "0"
notify "Merge coordinator complete: ${INTEGRATED}/${TOTAL} integrated, ${BLOCKED} blocked. Score: ${BASELINE_PASS}→${FINAL_PASS}"
