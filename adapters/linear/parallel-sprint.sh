#!/bin/bash
# =============================================================================
# PARALLEL SPRINT — Run multiple Linear issues across terminals simultaneously
# =============================================================================
#
# Reads the execution plan from .planning/linear-execution-plan.md or takes
# issue IDs directly. Runs independent issues in parallel, respects dependency
# groups, and waits for each group to complete before starting the next.
#
# Usage:
#   ./parallel-sprint.sh --group A                    # Run all Group A issues
#   ./parallel-sprint.sh --group B                    # Run all Group B issues
#   ./parallel-sprint.sh --all                        # Run all groups sequentially
#   ./parallel-sprint.sh DRS-10 DRS-11 DRS-12         # Run specific issues in parallel
#
# Environment (same as sprint-executor.sh):
#   BUILDER_AGENT=claude|codex|aider|qwen
#   REVIEWER_AGENT=claude|codex|aider|qwen
#   NOTIFY_WEBHOOK=https://...
# =============================================================================

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXECUTOR="${SCRIPT_DIR}/sprint-executor.sh"
PLAN_FILE=".planning/linear-execution-plan.md"
NOTIFY_WEBHOOK="${NOTIFY_WEBHOOK:-}"
LOG_DIR=".planning/parallel-logs"

# ─── COLORS ─────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

notify() {
  local message=$1
  if [ -n "$NOTIFY_WEBHOOK" ]; then
    curl -s -X POST "$NOTIFY_WEBHOOK" \
      -H "Content-Type: application/json" \
      -d "{\"text\": \"[Parallel Sprint] $message\"}" \
      2>/dev/null || true
  fi
}

# ─── EXTRACT GROUP ISSUES FROM EXECUTION PLAN ──────────────────────────────
extract_group_issues() {
  local group=$1
  if [ ! -f "$PLAN_FILE" ]; then
    echo ""
    return
  fi

  # Extract issue IDs from the group's table in the execution plan
  # Looks for "### Group X" section and extracts DRS-NN patterns from the table
  awk -v group="$group" '
    /^### Group '"$group"'/ { found=1; next }
    /^### Group [^'"$group"']/ { found=0 }
    /^##[^#]/ { found=0 }
    found && /\|.*[A-Z]+-[0-9]+/ {
      match($0, /[A-Z]+-[0-9]+/)
      if (RSTART > 0) print substr($0, RSTART, RLENGTH)
    }
  ' "$PLAN_FILE"
}

# ─── RUN ISSUES IN PARALLEL ────────────────────────────────────────────────
run_parallel() {
  local issues=("$@")
  local count=${#issues[@]}

  if [ "$count" -eq 0 ]; then
    echo -e "${YELLOW}No issues to run${NC}"
    return 0
  fi

  echo -e "\n${CYAN}═══════════════════════════════════════════════════${NC}"
  echo -e "${CYAN}  PARALLEL: Running ${count} issues simultaneously${NC}"
  echo -e "${CYAN}═══════════════════════════════════════════════════${NC}\n"

  mkdir -p "$LOG_DIR"
  local pids=()
  local issue_map=()

  for issue in "${issues[@]}"; do
    local log_file="${LOG_DIR}/${issue}.log"
    echo -e "${BLUE}[$(date +%H:%M:%S)]${NC} Launching: ${issue} → ${log_file}"
    "$EXECUTOR" "$issue" > "$log_file" 2>&1 &
    pids+=($!)
    issue_map+=("$issue")
  done

  notify "Launched ${count} parallel issues: ${issues[*]}"

  # Wait for all and collect results
  local completed=0
  local failed=0

  for i in "${!pids[@]}"; do
    local pid=${pids[$i]}
    local issue=${issue_map[$i]}
    wait "$pid"
    local exit_code=$?

    if [ "$exit_code" -eq 0 ]; then
      echo -e "${GREEN}[$(date +%H:%M:%S)] ✓ ${issue} completed${NC}"
      completed=$((completed + 1))
    else
      echo -e "${RED}[$(date +%H:%M:%S)] ✗ ${issue} failed (exit: ${exit_code})${NC}"
      echo -e "${YELLOW}  See log: ${LOG_DIR}/${issue}.log${NC}"
      failed=$((failed + 1))
    fi
  done

  echo -e "\n${CYAN}Results: ${completed} completed, ${failed} failed out of ${count}${NC}\n"
  notify "Group complete: ${completed}/${count} done, ${failed} failed"

  [ "$failed" -eq 0 ]
}

# ─── MAIN ───────────────────────────────────────────────────────────────────

if [ $# -eq 0 ]; then
  echo "Usage: $0 [--group A|B|C|...] [--all] [ISSUE_ID...]"
  echo ""
  echo "Run Linear issues in parallel with dependency awareness."
  echo ""
  echo "Options:"
  echo "  --group A      Run all issues in execution Group A"
  echo "  --group B      Run all issues in execution Group B"
  echo "  --all          Run all groups sequentially (A, then B, then C...)"
  echo "  ISSUE_ID...    Run specific issues in parallel (ignores groups)"
  echo ""
  echo "Reads groups from: ${PLAN_FILE}"
  echo "Logs written to:   ${LOG_DIR}/"
  exit 0
fi

# Check executor exists
if [ ! -x "$EXECUTOR" ]; then
  echo -e "${RED}Sprint executor not found at: ${EXECUTOR}${NC}"
  echo "Run: chmod +x ${EXECUTOR}"
  exit 1
fi

case "${1:-}" in
  --all)
    echo -e "${CYAN}Running all execution groups sequentially...${NC}"
    for group_letter in A B C D E F G H; do
      issues=($(extract_group_issues "$group_letter"))
      if [ ${#issues[@]} -eq 0 ]; then
        continue
      fi
      echo -e "\n${CYAN}══ GROUP ${group_letter} ══${NC}"
      run_parallel "${issues[@]}"
      if [ $? -ne 0 ]; then
        echo -e "${RED}Group ${group_letter} had failures. Continue to next group? (y/n)${NC}"
        read -r answer
        if [ "$answer" != "y" ]; then
          echo "Stopping."
          exit 1
        fi
      fi
    done
    ;;
  --group)
    group="${2:-}"
    if [ -z "$group" ]; then
      echo -e "${RED}Specify a group letter: --group A${NC}"
      exit 1
    fi
    issues=($(extract_group_issues "$group"))
    if [ ${#issues[@]} -eq 0 ]; then
      echo -e "${YELLOW}No issues found for Group ${group}${NC}"
      echo "Check ${PLAN_FILE} for available groups."
      exit 1
    fi
    run_parallel "${issues[@]}"
    ;;
  *)
    # Direct issue IDs
    run_parallel "$@"
    ;;
esac
