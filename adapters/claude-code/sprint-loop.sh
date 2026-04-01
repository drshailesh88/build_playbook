#!/bin/bash
# =============================================================================
# SPRINT LOOP — Fresh Context Per Batch, Runs Until Done
# =============================================================================
#
# Matt Pocock's Ralph pattern applied to sprint-build-perfect:
# Each iteration = fresh Claude Code session = zero context rot.
# sprint-log.md is the memory between sessions.
#
# Usage: ./sprint-loop.sh
# Stop:  Ctrl+C (safe — all work is in git + sprint-log.md)
#
# =============================================================================

set -uo pipefail

MAX_STUCK=5
REQUIREMENTS_FILE=".planning/REQUIREMENTS.md"
SPRINT_LOG=".planning/sprint-log.md"
LOOP_LOG="sprint-loop-log.txt"
SESSION=0

# ─── COLORS ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== SPRINT LOOP ===${NC}"
echo -e "Each iteration = fresh Claude Code session = zero context rot"
echo -e "Memory between sessions: ${YELLOW}${SPRINT_LOG}${NC}"
echo -e "Stop anytime: Ctrl+C (all work saved in git)"
echo ""

# ─── Check requirements file exists ─────────────────────────────────────────
if [ ! -f "$REQUIREMENTS_FILE" ]; then
  echo -e "${RED}No $REQUIREMENTS_FILE found. Run your playbook workflow first.${NC}"
  exit 1
fi

# ─── Count initial state ────────────────────────────────────────────────────
TOTAL=$(grep -c "^\- \[" "$REQUIREMENTS_FILE" 2>/dev/null || echo "0")
DONE=$(grep -c "^\- \[x\]" "$REQUIREMENTS_FILE" 2>/dev/null || echo "0")
REMAINING=$((TOTAL - DONE))

echo -e "Requirements: ${GREEN}$DONE done${NC} / $TOTAL total / ${YELLOW}$REMAINING remaining${NC}"
echo ""

# ─── The Loop ────────────────────────────────────────────────────────────────
CONSECUTIVE_EMPTY=0
while true; do
  SESSION=$((SESSION + 1))

  # Check if there are unchecked requirements remaining
  REMAINING=$(grep -c "^\- \[ \]" "$REQUIREMENTS_FILE" 2>/dev/null || echo "0")
  if [ "$REMAINING" -eq 0 ]; then
    echo ""
    echo -e "${GREEN}══════════════════════════════════════════${NC}"
    echo -e "${GREEN}  ALL REQUIREMENTS COMPLETE${NC}"
    echo -e "${GREEN}══════════════════════════════════════════${NC}"
    echo ""
    DONE=$(grep -c "^\- \[x\]" "$REQUIREMENTS_FILE" 2>/dev/null || echo "0")
    echo -e "Total built: ${GREEN}$DONE${NC}"
    echo -e "Run ${YELLOW}/playbook:harden${NC} to test everything"
    break
  fi

  # Check stuck count
  STUCK_COUNT=$(grep -c "STUCK" "$SPRINT_LOG" 2>/dev/null || echo "0")
  if [ "$STUCK_COUNT" -ge "$MAX_STUCK" ]; then
    echo ""
    echo -e "${RED}$STUCK_COUNT items stuck. Human review needed.${NC}"
    echo -e "Check: ${YELLOW}grep STUCK $SPRINT_LOG${NC}"
    break
  fi

  echo -e "${BLUE}══════════════════════════════════════════${NC}"
  echo -e "${BLUE}  SESSION $SESSION — $REMAINING requirements remaining${NC}"
  echo -e "${BLUE}══════════════════════════════════════════${NC}"
  echo ""
  echo "$(date): Session $SESSION starting — $REMAINING remaining" >> "$LOOP_LOG"

  # ─── Fresh Claude Code session ───────────────────────────────────────────
  # -p = print mode (non-interactive, exits when done)
  # --dangerously-skip-permissions = YOLO mode (no permission prompts)
  #
  # Claude reads sprint-log.md, finds where to resume,
  # builds up to 5 requirements, then exits.
  # Next iteration starts with ZERO context.

  claude -p "/playbook:sprint-build-perfect" \
    --dangerously-skip-permissions \
    2>&1 || true

  # ─── Post-session check ─────────────────────────────────────────────────
  NEW_DONE=$(grep -c "^\- \[x\]" "$REQUIREMENTS_FILE" 2>/dev/null || echo "0")
  BUILT_THIS_SESSION=$((NEW_DONE - DONE))
  DONE=$NEW_DONE

  echo ""
  echo -e "Session $SESSION complete: ${GREEN}+$BUILT_THIS_SESSION requirements${NC} this session"
  echo "$(date): Session $SESSION ended — built $BUILT_THIS_SESSION, total done: $DONE" >> "$LOOP_LOG"

  # If session built nothing, something might be wrong
  if [ "$BUILT_THIS_SESSION" -eq 0 ]; then
    echo -e "${YELLOW}Warning: No requirements completed this session.${NC}"
    echo -e "Checking if Claude is stuck..."

    # Give it one more try, then stop
    CONSECUTIVE_EMPTY=$((CONSECUTIVE_EMPTY + 1))
    if [ "$CONSECUTIVE_EMPTY" -ge 2 ]; then
      echo -e "${RED}2 consecutive empty sessions. Stopping.${NC}"
      echo "$(date): STOPPED — 2 consecutive empty sessions" >> "$LOOP_LOG"
      break
    fi
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
echo -e "${BLUE}  SPRINT LOOP COMPLETE${NC}"
echo -e "${BLUE}══════════════════════════════════════════${NC}"
echo ""
FINAL_DONE=$(grep -c "^\- \[x\]" "$REQUIREMENTS_FILE" 2>/dev/null || echo "0")
FINAL_REMAINING=$(grep -c "^\- \[ \]" "$REQUIREMENTS_FILE" 2>/dev/null || echo "0")
FINAL_STUCK=$(grep -c "STUCK" "$SPRINT_LOG" 2>/dev/null || echo "0")
echo -e "Sessions run:          $SESSION"
echo -e "Requirements done:     ${GREEN}$FINAL_DONE${NC}"
echo -e "Requirements remaining:${YELLOW}$FINAL_REMAINING${NC}"
echo -e "Items stuck:           ${RED}$FINAL_STUCK${NC}"
echo ""
echo -e "Review: ${YELLOW}git log --oneline -30${NC}"
echo -e "Sprint log: ${YELLOW}cat $SPRINT_LOG${NC}"
echo -e "Loop log: ${YELLOW}cat $LOOP_LOG${NC}"
echo -e "Next: ${YELLOW}/playbook:harden${NC} to test everything"
