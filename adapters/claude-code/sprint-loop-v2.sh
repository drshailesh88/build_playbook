#!/bin/bash
# =============================================================================
# SPRINT LOOP V2 — Fresh Context Per Batch with Notifications & Docker
# =============================================================================
# V2 improvements over V1:
# 1. Calls sprint-build-perfect-v2 (worktree isolation, Codex review)
# 2. Machine-readable status (requirements.json + loop-status-v2.json)
# 3. Webhook notifications (Slack/Telegram/Discord)
# 4. Docker sandbox option (--docker flag)
# 5. Live status JSON for monitoring
#
# Usage: ./sprint-loop-v2.sh
# Usage: ./sprint-loop-v2.sh --docker
# Usage: NOTIFY_WEBHOOK=https://hooks.slack.com/... ./sprint-loop-v2.sh
# =============================================================================

set -uo pipefail

MAX_STUCK=5
REQUIREMENTS_FILE=".planning/REQUIREMENTS.md"
REQUIREMENTS_JSON=".planning/requirements.json"
SPRINT_LOG=".planning/sprint-log.md"
LOOP_LOG="sprint-loop-log.txt"
LOOP_STATUS=".planning/loop-status-v2.json"
SESSION=0
CONSECUTIVE_EMPTY=0
NOTIFY_WEBHOOK="${NOTIFY_WEBHOOK:-}"
LOOP_STARTED="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

# ─── Docker flag ────────────────────────────────────────────────────────────
USE_DOCKER=false
if [ "${1:-}" = "--docker" ] 2>/dev/null; then
  USE_DOCKER=true
  shift
fi

# ─── COLORS ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ─── Notification helper ────────────────────────────────────────────────────
notify() {
  local message=$1
  echo "$(date): $message" >> "$LOOP_LOG"
  if [ -n "$NOTIFY_WEBHOOK" ]; then
    curl -s -X POST "$NOTIFY_WEBHOOK" \
      -H "Content-Type: application/json" \
      -d "{\"text\": \"[Sprint Loop V2] $message\"}" \
      2>/dev/null || true
  fi
}

# ─── Machine-readable status readers ────────────────────────────────────────
get_remaining() {
  if [ -f "$REQUIREMENTS_JSON" ]; then
    python3 -c "
import json
with open('$REQUIREMENTS_JSON') as f:
    data = json.load(f)
remaining = sum(1 for r in data['requirements'] if not r['done'] and not r['stuck'])
print(remaining)
"
  elif [ -f "$REQUIREMENTS_FILE" ]; then
    grep -c "^\- \[ \]" "$REQUIREMENTS_FILE" 2>/dev/null || echo "0"
  else
    echo "0"
  fi
}

get_done_count() {
  if [ -f "$REQUIREMENTS_JSON" ]; then
    python3 -c "
import json
with open('$REQUIREMENTS_JSON') as f:
    data = json.load(f)
done = sum(1 for r in data['requirements'] if r['done'])
print(done)
"
  elif [ -f "$REQUIREMENTS_FILE" ]; then
    grep -c "^\- \[x\]" "$REQUIREMENTS_FILE" 2>/dev/null || echo "0"
  else
    echo "0"
  fi
}

get_total_count() {
  if [ -f "$REQUIREMENTS_JSON" ]; then
    python3 -c "
import json
with open('$REQUIREMENTS_JSON') as f:
    data = json.load(f)
print(len(data['requirements']))
"
  elif [ -f "$REQUIREMENTS_FILE" ]; then
    grep -c "^\- \[" "$REQUIREMENTS_FILE" 2>/dev/null || echo "0"
  else
    echo "0"
  fi
}

get_stuck_count() {
  if [ -f "$REQUIREMENTS_JSON" ]; then
    python3 -c "
import json
with open('$REQUIREMENTS_JSON') as f:
    data = json.load(f)
stuck = sum(1 for r in data['requirements'] if r['stuck'])
print(stuck)
"
  else
    grep -c "STUCK" "$SPRINT_LOG" 2>/dev/null || echo "0"
  fi
}

# ─── Live status writer ─────────────────────────────────────────────────────
write_status() {
  local session_num=$1
  local done=$2
  local remaining=$3
  local stuck=$4
  local empty=$5
  local built=$6
  local status=$7

  mkdir -p .planning
  cat > "$LOOP_STATUS" <<STATUSEOF
{
  "loop_started": "$LOOP_STARTED",
  "session_number": $session_num,
  "total_done": $done,
  "total_remaining": $remaining,
  "total_stuck": $stuck,
  "consecutive_empty": $empty,
  "last_session_built": $built,
  "status": "$status"
}
STATUSEOF
}

# ─── Run Claude session (local or Docker) ────────────────────────────────────
run_claude_session() {
  if [ "$USE_DOCKER" = true ]; then
    docker run --rm -v "$(pwd):/workspace" -w /workspace \
      -e ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY" \
      node:22 npx -y @anthropic-ai/claude-code -p "/playbook:sprint-build-perfect-v2" \
      --dangerously-skip-permissions 2>&1 || true
  else
    claude -p "/playbook:sprint-build-perfect-v2" \
      --dangerously-skip-permissions \
      2>&1 || true
  fi
}

# ─── Banner ──────────────────────────────────────────────────────────────────
echo -e "${BLUE}=== SPRINT LOOP V2 ===${NC}"
echo -e "Each iteration = fresh Claude Code session = zero context rot"
echo -e "Memory between sessions: ${YELLOW}${SPRINT_LOG}${NC}"
if [ "$USE_DOCKER" = true ]; then
  echo -e "Mode: ${YELLOW}Docker sandbox${NC}"
fi
if [ -n "$NOTIFY_WEBHOOK" ]; then
  echo -e "Notifications: ${GREEN}enabled${NC}"
fi
echo -e "Stop anytime: Ctrl+C (all work saved in git)"
echo ""

# ─── Check requirements exist ───────────────────────────────────────────────
if [ ! -f "$REQUIREMENTS_JSON" ] && [ ! -f "$REQUIREMENTS_FILE" ]; then
  echo -e "${RED}No requirements found. Need $REQUIREMENTS_JSON or $REQUIREMENTS_FILE.${NC}"
  echo -e "Run your playbook workflow first."
  exit 1
fi

# ─── Count initial state ────────────────────────────────────────────────────
TOTAL=$(get_total_count)
DONE=$(get_done_count)
REMAINING=$(get_remaining)

echo -e "Requirements: ${GREEN}$DONE done${NC} / $TOTAL total / ${YELLOW}$REMAINING remaining${NC}"
echo ""

write_status 0 "$DONE" "$REMAINING" "$(get_stuck_count)" 0 0 "RUNNING"
notify "Loop started — $DONE done / $REMAINING remaining / $TOTAL total"

# ─── The Loop ────────────────────────────────────────────────────────────────
while true; do
  SESSION=$((SESSION + 1))

  # Check if there are requirements remaining
  REMAINING=$(get_remaining)
  if [ "$REMAINING" -eq 0 ]; then
    echo ""
    echo -e "${GREEN}══════════════════════════════════════════${NC}"
    echo -e "${GREEN}  ALL REQUIREMENTS COMPLETE${NC}"
    echo -e "${GREEN}══════════════════════════════════════════${NC}"
    echo ""
    DONE=$(get_done_count)
    echo -e "Total built: ${GREEN}$DONE${NC}"
    echo -e "Run ${YELLOW}/playbook:harden${NC} to test everything"
    write_status "$SESSION" "$DONE" 0 "$(get_stuck_count)" "$CONSECUTIVE_EMPTY" 0 "COMPLETE"
    notify "ALL DONE — $DONE requirements complete in $SESSION sessions"
    break
  fi

  # Check stuck count
  STUCK_COUNT=$(get_stuck_count)
  if [ "$STUCK_COUNT" -ge "$MAX_STUCK" ]; then
    echo ""
    echo -e "${RED}$STUCK_COUNT items stuck. Human review needed.${NC}"
    echo -e "Check: ${YELLOW}grep STUCK $SPRINT_LOG${NC}"
    write_status "$SESSION" "$(get_done_count)" "$REMAINING" "$STUCK_COUNT" "$CONSECUTIVE_EMPTY" 0 "STUCK"
    notify "STUCK LIMIT — $STUCK_COUNT items stuck, human review needed"
    break
  fi

  echo -e "${BLUE}══════════════════════════════════════════${NC}"
  echo -e "${BLUE}  SESSION $SESSION — $REMAINING requirements remaining${NC}"
  echo -e "${BLUE}══════════════════════════════════════════${NC}"
  echo ""
  notify "Session $SESSION starting — $REMAINING remaining"

  # ─── Fresh Claude Code session ───────────────────────────────────────────
  # -p = print mode (non-interactive, exits when done)
  # --dangerously-skip-permissions = YOLO mode (no permission prompts)
  #
  # Claude reads sprint-log.md, finds where to resume,
  # builds up to 5 requirements, then exits.
  # Next iteration starts with ZERO context.

  run_claude_session

  # ─── Post-session check ─────────────────────────────────────────────────
  NEW_DONE=$(get_done_count)
  BUILT_THIS_SESSION=$((NEW_DONE - DONE))
  DONE=$NEW_DONE
  REMAINING=$(get_remaining)
  STUCK_COUNT=$(get_stuck_count)

  echo ""
  echo -e "Session $SESSION complete: ${GREEN}+$BUILT_THIS_SESSION requirements${NC} this session"
  notify "Session $SESSION ended — built $BUILT_THIS_SESSION, total done: $DONE, remaining: $REMAINING"

  write_status "$SESSION" "$DONE" "$REMAINING" "$STUCK_COUNT" "$CONSECUTIVE_EMPTY" "$BUILT_THIS_SESSION" "RUNNING"

  # If session built nothing, something might be wrong
  if [ "$BUILT_THIS_SESSION" -eq 0 ]; then
    echo -e "${YELLOW}Warning: No requirements completed this session.${NC}"
    echo -e "Checking if Claude is stuck..."

    CONSECUTIVE_EMPTY=$((CONSECUTIVE_EMPTY + 1))
    if [ "$CONSECUTIVE_EMPTY" -ge 2 ]; then
      echo -e "${RED}2 consecutive empty sessions. Stopping.${NC}"
      write_status "$SESSION" "$DONE" "$REMAINING" "$STUCK_COUNT" "$CONSECUTIVE_EMPTY" 0 "EMPTY_SESSIONS"
      notify "STOPPED — 2 consecutive empty sessions (done: $DONE, remaining: $REMAINING)"
      break
    fi

    notify "WARNING — Empty session $CONSECUTIVE_EMPTY/2 (no requirements completed)"
  else
    CONSECUTIVE_EMPTY=0
  fi

  echo ""
  echo -e "${YELLOW}Starting fresh session in 3 seconds...${NC}"
  sleep 3
done

# ─── Final Report ────────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}══════════════════════════════════════════${NC}"
echo -e "${BLUE}  SPRINT LOOP V2 COMPLETE${NC}"
echo -e "${BLUE}══════════════════════════════════════════${NC}"
echo ""
FINAL_DONE=$(get_done_count)
FINAL_REMAINING=$(get_remaining)
FINAL_STUCK=$(get_stuck_count)
echo -e "Sessions run:          $SESSION"
echo -e "Requirements done:     ${GREEN}$FINAL_DONE${NC}"
echo -e "Requirements remaining:${YELLOW}$FINAL_REMAINING${NC}"
echo -e "Items stuck:           ${RED}$FINAL_STUCK${NC}"
echo ""
echo -e "Review: ${YELLOW}git log --oneline -30${NC}"
echo -e "Sprint log: ${YELLOW}cat $SPRINT_LOG${NC}"
echo -e "Loop log: ${YELLOW}cat $LOOP_LOG${NC}"
echo -e "Live status: ${YELLOW}cat $LOOP_STATUS${NC}"
echo -e "Next: ${YELLOW}/playbook:harden${NC} to test everything"
