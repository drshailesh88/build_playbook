#!/usr/bin/env bash
# witness.sh — liveness watchdog for the factory (DEC-009 item 4, Yegge's Witness)
#
# Circuit breakers catch loops that fail; the Witness catches loops that are
# ALIVE BUT STUCK — a claude/codex process idling on a prompt, a hung dev
# server, an iteration that will never time out. It runs OUTSIDE the loop
# (cron or systemd timer, every ~10 min) and never trusts the loop's own
# opinion of its health.
#
# Checks, in order:
#   1. Heartbeat freshness — loops write ralph/.heartbeat every iteration.
#      Stale heartbeat + live loop process = STALLED.
#      Stale heartbeat + dead loop + cursor not idle = CRASHED.
#   2. Disk space — >90% used on the project filesystem = notify.
#   3. Run budget — RALPH_DEADLINE passed but loop still running = OVERDUE.
#
# Actions are conservative by default: notify (Slack webhook + gh tracking
# note) and report. Opt-in remediation:
#   WITNESS_AUTOKILL=1   kill the stuck agent child process (claude -p /
#                        codex exec whose cwd is THIS project) so the loop's
#                        iteration handling takes over. Never kills the loop.
#
# Usage:  ./ralph/witness.sh            (run once; exit 0 healthy, 1 findings)
# Env:    HEARTBEAT_MAX_AGE=2700        seconds before a heartbeat is stale
#         WITNESS_AUTOKILL=0|1
#         NOTIFY_WEBHOOK=...            Slack-compatible webhook
#
# Schedule (pick one):
#   crontab:  */10 * * * * cd /path/to/app && ./ralph/witness.sh >> ralph/witness.log 2>&1
#   systemd:  ralph-witness.timer (see ralph/systemd/)

set -uo pipefail
cd "$(dirname "$0")/.."
PROJECT_DIR=$(pwd)

HEARTBEAT=ralph/.heartbeat
HEARTBEAT_MAX_AGE="${HEARTBEAT_MAX_AGE:-2700}"
WITNESS_AUTOKILL="${WITNESS_AUTOKILL:-0}"
FINDINGS=0

say() { echo "[witness $(date -u +%H:%M:%SZ)] $*"; }

notify() {
  say "$1"
  FINDINGS=1
  if [ -n "${NOTIFY_WEBHOOK:-}" ]; then
    curl -s -X POST "$NOTIFY_WEBHOOK" -H "Content-Type: application/json" \
      -d "{\"text\": \"[witness] $1\"}" >/dev/null 2>&1 || true
  fi
  if [ -x ./ralph/gh-state.sh ]; then
    ./ralph/gh-state.sh note "**Witness:** $1" >/dev/null 2>&1 || true
  fi
}

# PIDs of agent children (claude -p / codex exec / grok) whose cwd is THIS
# project — never touch agents belonging to other projects on the box.
agent_pids_here() {
  for pid in $(pgrep -f 'claude -p|codex exec|grok --prompt-file|grok -p' 2>/dev/null); do
    cwd=$(readlink "/proc/$pid/cwd" 2>/dev/null || lsof -p "$pid" 2>/dev/null | awk '$4=="cwd"{print $NF}')
    [ "$cwd" = "$PROJECT_DIR" ] && echo "$pid"
  done
}

loop_alive() { pgrep -f "ralph/(run|build|qa|review-quorum|harden)" >/dev/null 2>&1; }

cursor_phase() {
  python3 -c "
import json
try: print(json.load(open('ralph/loop-cursor.json')).get('phase', 'unknown'))
except Exception: print('unknown')" 2>/dev/null
}

# ── 1. Heartbeat ─────────────────────────────────────────────────────────────
if [ -f "$HEARTBEAT" ]; then
  AGE=$(( $(date +%s) - $(stat -c %Y "$HEARTBEAT" 2>/dev/null || stat -f %m "$HEARTBEAT") ))
  BEAT=$(cat "$HEARTBEAT" 2>/dev/null | head -c 300)
  if [ "$AGE" -gt "$HEARTBEAT_MAX_AGE" ]; then
    PHASE=$(cursor_phase)
    if loop_alive; then
      notify "STALLED: loop process alive but heartbeat is ${AGE}s old (limit ${HEARTBEAT_MAX_AGE}s). Last beat: $BEAT"
      if [ "$WITNESS_AUTOKILL" = "1" ]; then
        PIDS=$(agent_pids_here)
        if [ -n "$PIDS" ]; then
          say "AUTOKILL: terminating stuck agent process(es) in $PROJECT_DIR: $PIDS"
          kill $PIDS 2>/dev/null || true
          notify "AUTOKILL: killed stuck agent pid(s) $PIDS — loop will continue with the next iteration"
        else
          say "AUTOKILL requested but no agent process found with cwd=$PROJECT_DIR (loop may be sleeping between iterations)"
        fi
      fi
    elif [ "$PHASE" != "idle" ] && [ "$PHASE" != "unknown" ]; then
      notify "CRASHED: no loop process, heartbeat ${AGE}s old, cursor phase='$PHASE'. Resume: ./ralph/gh-state.sh recover, then ./ralph/run.sh (or let systemd Restart= handle it)"
    fi
  else
    say "OK: heartbeat ${AGE}s old ($BEAT)"
  fi
else
  if loop_alive; then
    say "loop running but no heartbeat file yet (first iteration?)"
  else
    say "idle: no heartbeat, no loop process"
  fi
fi

# ── 2. Disk ──────────────────────────────────────────────────────────────────
DISK_PCT=$(df -P . | awk 'NR==2 {gsub("%",""); print $5}')
if [ "${DISK_PCT:-0}" -gt 90 ]; then
  notify "DISK: ${DISK_PCT}% used on the project filesystem — runs will start failing soon"
fi

# ── 3. Run budget overdue ────────────────────────────────────────────────────
DEADLINE=$(python3 -c "
import json
try: print(json.load(open('ralph/loop-cursor.json')).get('deadline', ''))
except Exception: print('')" 2>/dev/null)
if [ -n "$DEADLINE" ] && [ "$DEADLINE" != "0" ] && loop_alive; then
  NOW=$(date +%s)
  if [ "$NOW" -gt "$DEADLINE" ]; then
    notify "OVERDUE: run budget deadline passed $((NOW - DEADLINE))s ago but the loop is still running — it should self-stop at the next iteration boundary; investigate if this repeats"
  fi
fi

exit "$FINDINGS"
