#!/bin/bash
# =============================================================================
# OVERNIGHT ADVERSARIAL BUILD LOOP — V2
# =============================================================================
#
# Three ML concepts applied to software building (same as V1):
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
# =============================================================================
# V2 CHANGES (improvements over V1):
# =============================================================================
#
# 1. STRUCTURED JSON REQUIREMENTS
#    - Replaces fragile sed-based REQUIREMENTS.md checkbox parsing
#    - Uses .planning/requirements.json with per-requirement metadata
#    - Auto-converts REQUIREMENTS.md to requirements.json on first run
#    - Tracks attempts, stuck state, and last error per requirement
#
# 2. GIT WORKTREE ISOLATION
#    - Each iteration runs in a temporary git worktree branch
#    - Failed iterations: delete worktree (no revert needed)
#    - Successful iterations: merge worktree branch back to main
#    - Eliminates dangerous git checkout -- reverts from V1
#
# 3. API LIMIT AUTO-WAIT WITH RESUME
#    - Detects rate limit errors from codex exec output
#    - Instead of stopping after 3 empty iterations, waits and retries
#    - Polls every 5 minutes until the limit clears, then resumes
#
# 4. MANDATORY MULTI-PASS REVIEW
#    - Pass 1: Adversary review (existing V1 behavior — find bugs)
#    - Pass 2: Architect review (NEW — checks design, patterns, maintainability)
#    - Code must pass both reviews before committing
#
# 5. WEBHOOK NOTIFICATIONS
#    - Set NOTIFY_WEBHOOK env var to a Slack/Discord/Telegram webhook URL
#    - Sends notifications at key points: iteration complete, phase gate,
#      stuck, rate limit, all done
#
# 6. DOCKER SANDBOX OPTION
#    - Pass --docker flag to run codex inside a Docker container
#    - Mounts workspace and passes OPENAI_API_KEY
#    - Useful for untrusted codebases or strict isolation requirements
#
# 7. MACHINE-READABLE LIVE STATUS
#    - Writes .planning/ralph-status.json after every step
#    - Tracks iteration, requirement, phase, scores, ETA, rate limit state
#    - Enables external dashboards and monitoring tools
#
# =============================================================================
# Usage: ./overnight-adversarial-v2.sh [--docker] [iterations]
# Example: ./overnight-adversarial-v2.sh 75
# Example: ./overnight-adversarial-v2.sh --docker 75
# Example: NOTIFY_WEBHOOK=https://hooks.slack.com/... ./overnight-adversarial-v2.sh 75
# =============================================================================

set -uo pipefail
# Note: NOT using set -e because codex exec may return non-zero
# exit codes even on successful completion. We handle errors manually.

# ─── V2 IMPROVEMENT 6: Docker sandbox option ────────────────────────────────
USE_DOCKER=false
if [ "${1:-}" = "--docker" ]; then
  USE_DOCKER=true
  shift
fi

ITERATIONS=${1:-20}
BRANCH="codex/$(date +%Y-%m-%d)"
MAX_HEAL_ATTEMPTS=3
MAX_ADVERSARY_ROUNDS=2
SCORE_FILE=".planning/build-scores.jsonl"
PROGRESS_FILE="progress.txt"
PHASE_SCORES_FILE=".planning/phase-gate-scores.json"
STATUS_FILE=".planning/ralph-status.json"
WORKTREE_BASE=".ralph-worktrees"
START_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# ─── V2 IMPROVEMENT 5: Webhook notifications ────────────────────────────────
NOTIFY_WEBHOOK="${NOTIFY_WEBHOOK:-}"

# ─── COLORS ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ─── V2 IMPROVEMENT 5: Notification helper ───────────────────────────────────
notify() {
  local message=$1
  if [ -n "$NOTIFY_WEBHOOK" ]; then
    curl -s -X POST "$NOTIFY_WEBHOOK" \
      -H "Content-Type: application/json" \
      -d "{\"text\": \"$message\"}" \
      2>/dev/null || true
  fi
  echo "$message" >> "$PROGRESS_FILE"
}

# ─── V2 IMPROVEMENT 7: Live status writer ────────────────────────────────────
update_status() {
  local iteration=${1:-0}
  local total_iterations=${2:-$ITERATIONS}
  local current_req=${3:-""}
  local current_phase=${4:-1}
  local status=${5:-"INITIALIZING"}
  local baseline_score=${6:-0}
  local current_score=${7:-0}
  local last_commit=${8:-""}
  local rate_limited=${9:-false}

  # Count requirements from JSON
  local reqs_done=0
  local reqs_stuck=0
  local reqs_remaining=0
  if [ -f ".planning/requirements.json" ]; then
    reqs_done=$(python3 -c "
import json
with open('.planning/requirements.json') as f:
    data = json.load(f)
print(sum(1 for r in data['requirements'] if r.get('done', False) or r.get('status', '') == 'done'))
" 2>/dev/null || echo "0")
    reqs_stuck=$(python3 -c "
import json
with open('.planning/requirements.json') as f:
    data = json.load(f)
print(sum(1 for r in data['requirements'] if r.get('stuck', False) or r.get('status', '') == 'stuck'))
" 2>/dev/null || echo "0")
    reqs_remaining=$(python3 -c "
import json
with open('.planning/requirements.json') as f:
    data = json.load(f)
print(sum(1 for r in data['requirements'] if not (r.get('done', False) or r.get('status', '') == 'done') and not (r.get('stuck', False) or r.get('status', '') == 'stuck')))
" 2>/dev/null || echo "0")
  fi

  # Estimate ETA based on iterations remaining and average time
  local elapsed_seconds=0
  local eta_minutes=0
  if [ "$iteration" -gt 0 ]; then
    local now_epoch
    now_epoch=$(date +%s)
    local start_epoch
    start_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$START_TIME" +%s 2>/dev/null || date -d "$START_TIME" +%s 2>/dev/null || echo "$now_epoch")
    elapsed_seconds=$((now_epoch - start_epoch))
    local avg_per_iter=$((elapsed_seconds / iteration))
    local remaining_iters=$((total_iterations - iteration))
    eta_minutes=$(( (avg_per_iter * remaining_iters) / 60 ))
  fi

  mkdir -p .planning
  cat > "$STATUS_FILE" <<STATUSEOF
{
  "started": "$START_TIME",
  "iteration": $iteration,
  "total_iterations": $total_iterations,
  "current_requirement": "$current_req",
  "current_phase": $current_phase,
  "status": "$status",
  "requirements_done": $reqs_done,
  "requirements_stuck": $reqs_stuck,
  "requirements_remaining": $reqs_remaining,
  "baseline_score": $baseline_score,
  "current_score": $current_score,
  "last_commit": "$last_commit",
  "rate_limited": $rate_limited,
  "eta_minutes": $eta_minutes
}
STATUSEOF
}

# ─── HELPER: Capture test score (same as V1) ────────────────────────────────
capture_score() {
  local typecheck_pass=0
  local pass_count=0
  local fail_count=0
  local total=0
  local test_exit_code=0

  # Run typecheck (ScholarSync uses npx tsc directly, no npm script)
  if npx tsc --noEmit 2>/dev/null; then
    typecheck_pass=1
  fi

  # Run tests with JSON reporter for reliable parsing
  # Try Vitest JSON first, fall back to grep parsing
  local json_output=""
  json_output=$(npx vitest run --reporter=json 2>/dev/null || true)

  if echo "$json_output" | python3 -c "import json,sys; d=json.load(sys.stdin); print('OK')" 2>/dev/null; then
    # Parse structured JSON — reliable
    pass_count=$(echo "$json_output" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('numPassedTests',0))" 2>/dev/null || echo "0")
    fail_count=$(echo "$json_output" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('numFailedTests',0))" 2>/dev/null || echo "0")
  else
    # Fallback: run npm test and grep (less reliable but works for non-Vitest)
    local test_output=""
    test_output=$(npm test 2>&1; test_exit_code=$?)
    pass_count=$(echo "$test_output" | grep -oE '[0-9]+ passed' | tail -1 | grep -oE '[0-9]+' || echo "0")
    fail_count=$(echo "$test_output" | grep -oE '[0-9]+ failed' | tail -1 | grep -oE '[0-9]+' || echo "0")
  fi

  total=$((pass_count + fail_count))

  # FAIL CLOSED: if we couldn't parse anything AND test command failed, assume failure
  if [ "$total" -eq 0 ]; then
    # Try running npm test just for exit code
    if npm test 2>/dev/null; then
      pass_count=1
      total=1
    else
      # Tests failed but we can't parse output — fail closed
      fail_count=1
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

# ─── V2 IMPROVEMENT 1: Structured JSON requirements ─────────────────────────
# Auto-convert REQUIREMENTS.md to requirements.json if needed
convert_requirements_to_json() {
  if [ ! -f ".planning/requirements.json" ] && [ -f ".planning/REQUIREMENTS.md" ]; then
    echo -e "${YELLOW}Converting REQUIREMENTS.md to requirements.json...${NC}"
    python3 -c "
import re, json
with open('.planning/REQUIREMENTS.md') as f:
    lines = f.readlines()
reqs = []
phase = 1
for i, line in enumerate(lines):
    # Format 1: ### Phase N or ### Phase N: title
    phase_match = re.match(r'###?\s+.*[Pp]hase\s+(\d+)', line)
    if phase_match:
        phase = int(phase_match.group(1))
        continue

    # Format 2: ## Must Have (v1) -> phase 1, ## Should Have (v1.1) -> phase 2
    must_have = re.match(r'##\s+Must Have', line)
    if must_have:
        phase = 1
        continue

    should_have = re.match(r'##\s+Should Have', line)
    if should_have:
        phase = 2
        continue

    # Format 3: ## Section headings (track but don't override phase)
    section_match = re.match(r'###\s+\w', line)
    if section_match and not phase_match:
        # Track sections as sub-phases within the current phase
        pass

    check = re.match(r'^- \[([ x])\] (.+)', line)
    if check:
        reqs.append({
            'id': f'REQ-{len(reqs)+1:03d}',
            'text': check.group(2).strip(),
            'phase': phase,
            'done': check.group(1) == 'x',
            'stuck': False,
            'status': 'done' if check.group(1) == 'x' else 'pending',
            'attempts': 0,
            'last_error': None,
            'markdown_line': i + 1
        })

# After conversion, check if phase assignment worked
phases_found = set(r['phase'] for r in reqs)
if len(phases_found) == 1 and len(reqs) > 5:
    print(f'WARNING: All {len(reqs)} requirements assigned to Phase {list(phases_found)[0]}.')
    print('Phase detection could not find explicit phase markers in REQUIREMENTS.md.')
    print('Phase gates will be DISABLED for this run (all requirements treated as same phase).')
    print('To enable phase gates, add explicit \"### Phase N\" headings to REQUIREMENTS.md')
    print('or ensure ROADMAP.md phases match requirement sections.')
    # DO NOT redistribute — keep all in phase 1, which effectively disables phase gates
    # This is safer than guessing wrong phase assignments

with open('.planning/requirements.json', 'w') as f:
    json.dump({'requirements': reqs}, f, indent=2)
print(f'Converted {len(reqs)} requirements')
"
  fi
}

get_next_requirement() {
  python3 -c "
import json, sys
with open('.planning/requirements.json') as f:
    data = json.load(f)
if not data.get('requirements') or len(data['requirements']) == 0:
    print('ERROR: requirements.json is empty', file=sys.stderr)
    sys.exit(1)
sample = data['requirements'][0]
if 'text' not in sample or ('done' not in sample and 'status' not in sample):
    print(f\"ERROR: requirements.json has unexpected schema. Expected 'text' + 'done' or 'status'. Got: {list(sample.keys())}\", file=sys.stderr)
    sys.exit(1)
for r in data['requirements']:
    # Support both schema formats
    is_done = r.get('done', False) or r.get('status', '') == 'done'
    is_stuck = r.get('stuck', False) or r.get('status', '') == 'stuck'
    if not is_done and not is_stuck:
        print(f\"{r['id']}|{r.get('phase', 1)}|{r['text']}\")
        break
else:
    pass  # No requirement found — print nothing
" 2>/dev/null || echo ""
}

mark_requirement_done() {
  local req_id=$1
  python3 -c "
import json
with open('.planning/requirements.json') as f:
    data = json.load(f)
for r in data['requirements']:
    if r['id'] == '$req_id':
        r['done'] = True
        r['status'] = 'done'  # Support both formats
        r['attempts'] = r.get('attempts', 0) + 1
        break
with open('.planning/requirements.json', 'w') as f:
    json.dump(data, f, indent=2)
"
}

mark_requirement_stuck() {
  local req_id=$1
  local reason=$2
  python3 -c "
import json
with open('.planning/requirements.json') as f:
    data = json.load(f)
for r in data['requirements']:
    if r['id'] == '$req_id':
        r['stuck'] = True
        r['status'] = 'stuck'  # Support both formats
        r['last_error'] = '''$reason'''
        r['attempts'] = r.get('attempts', 0) + 1
        break
with open('.planning/requirements.json', 'w') as f:
    json.dump(data, f, indent=2)
"
}

sync_json_to_markdown() {
  python3 -c "
import json
with open('.planning/requirements.json') as f:
    data = json.load(f)
with open('.planning/REQUIREMENTS.md') as f:
    lines = f.readlines()
for r in data['requirements']:
    line_num = r.get('markdown_line')
    if line_num and line_num <= len(lines):
        idx = line_num - 1
        line = lines[idx]
        if r.get('done', False) or r.get('status', '') == 'done':
            lines[idx] = line.replace('- [ ]', '- [x]', 1)
        elif r.get('stuck', False) or r.get('status', '') == 'stuck':
            # Mark stuck in markdown with a comment
            if '<!-- STUCK' not in line and '<!-- BLOCKED' not in line:
                error = r.get('last_error', 'unknown reason')
                lines[idx] = line.rstrip() + ' <!-- STUCK: ' + str(error)[:80] + ' -->\n'
with open('.planning/REQUIREMENTS.md', 'w') as f:
    f.writelines(lines)
" 2>/dev/null || true
}

increment_requirement_attempts() {
  local req_id=$1
  python3 -c "
import json
with open('.planning/requirements.json') as f:
    data = json.load(f)
for r in data['requirements']:
    if r['id'] == '$req_id':
        r['attempts'] = r.get('attempts', 0) + 1
        break
with open('.planning/requirements.json', 'w') as f:
    json.dump(data, f, indent=2)
"
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

# ─── V2 IMPROVEMENT 6: Docker-aware codex runner ────────────────────────────
run_codex() {
  local prompt=$1
  if [ "$USE_DOCKER" = true ]; then
    docker run --rm -v "$(pwd):/workspace" -w /workspace \
      -e OPENAI_API_KEY="$OPENAI_API_KEY" \
      node:22 npx -y @openai/codex exec --full-auto "$prompt" || true
  else
    codex exec --full-auto "$prompt" || true
  fi
}

# ─── V2 IMPROVEMENT 3: Rate-limit-aware codex runner ────────────────────────
run_codex_with_retry() {
  local prompt=$1
  local output=""

  output=$(run_codex "$prompt" 2>&1)
  echo "$output"

  # Check for rate limit indicators
  if echo "$output" | grep -qi "usage limit\|rate limit\|try again at"; then
    local wait_until=""
    wait_until=$(echo "$output" | grep -oE '[0-9]+:[0-9]+ [AP]M' | head -1)
    if [ -n "$wait_until" ]; then
      echo -e "${YELLOW}Rate limited. Waiting until $wait_until...${NC}"
      notify "Rate limited. Waiting until $wait_until..."
    else
      echo -e "${YELLOW}Rate limited. Waiting for limit to clear...${NC}"
      notify "Rate limited. Waiting for limit to clear..."
    fi

    update_status "$CURRENT_ITER" "$ITERATIONS" "$CURRENT_REQ_ID" "$CURRENT_PHASE_NUM" "RATE_LIMITED" "$BASELINE_PASS" "$CURRENT_SCORE" "" true

    # Poll every 5 minutes until the rate limit clears
    while true; do
      echo -e "${YELLOW}Still rate limited. Waiting 5 minutes...${NC}"
      sleep 300
      local health_check=""
      health_check=$(run_codex "echo healthy" 2>&1)
      if ! echo "$health_check" | grep -qi "limit\|error"; then
        echo -e "${GREEN}Rate limit cleared. Resuming.${NC}"
        notify "Rate limit cleared. Resuming build."
        update_status "$CURRENT_ITER" "$ITERATIONS" "$CURRENT_REQ_ID" "$CURRENT_PHASE_NUM" "RESUMED" "$BASELINE_PASS" "$CURRENT_SCORE" "" false
        # Re-run the original prompt now that the limit is cleared
        output=$(run_codex "$prompt" 2>&1)
        echo "$output"
        break
      fi
    done
  fi
}

# Global state for rate-limit-aware runner
CURRENT_ITER=0
CURRENT_REQ_ID=""
CURRENT_PHASE_NUM=1
CURRENT_SCORE=0

# =============================================================================
# MAIN LOOP
# =============================================================================

echo -e "${BLUE}=== OVERNIGHT ADVERSARIAL BUILD LOOP — V2 ===${NC}"
echo -e "Iterations: $ITERATIONS"
echo -e "Branch: $BRANCH"
echo -e "Docker: $USE_DOCKER"
echo -e "Webhook: $([ -n "$NOTIFY_WEBHOOK" ] && echo "configured" || echo "none")"
echo -e "Max heal attempts per requirement: $MAX_HEAL_ATTEMPTS"
echo -e "Max adversary rounds per requirement: $MAX_ADVERSARY_ROUNDS"
echo ""

# ─── SAFETY: Require clean working tree (BEFORE branch switch) ───────────────
DIRTY_FILES=$(git status --porcelain 2>/dev/null | grep -v "^??" | wc -l | tr -d ' ')
if [ "$DIRTY_FILES" -gt 0 ]; then
  echo -e "${RED}Working tree has $DIRTY_FILES uncommitted changes.${NC}"
  echo -e "${RED}Commit or stash them first. This script must start from a clean tree${NC}"
  echo -e "${RED}to avoid committing unrelated files or destroying local work on revert.${NC}"
  echo ""
  echo -e "Run: ${YELLOW}git stash${NC} or ${YELLOW}git add -A && git commit -m 'wip: save before overnight run'${NC}"
  exit 1
fi

git checkout -b "$BRANCH" 2>/dev/null || git checkout "$BRANCH" 2>/dev/null

# Verify we're on the correct branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)
if [ "$CURRENT_BRANCH" != "$BRANCH" ]; then
  echo -e "${RED}FATAL: Failed to switch to branch '$BRANCH'. Currently on '$CURRENT_BRANCH'.${NC}"
  echo -e "${RED}Cannot proceed — overnight changes would land on the wrong branch.${NC}"
  exit 1
fi

# ─── V2 IMPROVEMENT 1: Convert requirements to JSON if needed ────────────────
convert_requirements_to_json

if [ ! -f ".planning/requirements.json" ]; then
  echo -e "${RED}No .planning/requirements.json found and no REQUIREMENTS.md to convert.${NC}"
  echo -e "${RED}Create one of these files before running this script.${NC}"
  exit 1
fi

# ─── Create worktree base directory ──────────────────────────────────────────
mkdir -p "$WORKTREE_BASE"

# ─── Capture baseline score (autoresearch: know where you started) ───────────
echo -e "${YELLOW}Capturing baseline score...${NC}"
BASELINE=$(capture_score)
BASELINE_PASS=$(echo "$BASELINE" | cut -d: -f2)
BASELINE_FAIL=$(echo "$BASELINE" | cut -d: -f3)
echo -e "Baseline: ${GREEN}$BASELINE_PASS passing${NC}, ${RED}$BASELINE_FAIL failing${NC}"
echo ""

CURRENT_SCORE=$BASELINE_PASS

update_status 0 "$ITERATIONS" "" 1 "STARTING" "$BASELINE_PASS" "$BASELINE_PASS" "" false
notify "Overnight adversarial build V2 started. Baseline: $BASELINE_PASS passing. $ITERATIONS iterations planned."

PREV_PHASE=$(get_current_phase)
PHASE_START_PASS=$BASELINE_PASS
LAST_REQ_ID=""
REPEAT_COUNT=0
LAST_COMMIT_HEAD=""
CONSECUTIVE_SKIPS=0
MAIN_DIR=$(pwd)

for ((i=1; i<=$ITERATIONS; i++)); do

  CURRENT_ITER=$i
  CURRENT_PHASE_NUM=$(get_current_phase)
  NEXT_REQ_RAW=$(get_next_requirement)

  # ─── Nothing left to build ───────────────────────────────────────────────
  if [ -z "$NEXT_REQ_RAW" ]; then
    echo -e "${GREEN}=== ALL REQUIREMENTS COMPLETE ===${NC}"
    notify "All requirements complete!"
    update_status "$i" "$ITERATIONS" "" "$CURRENT_PHASE_NUM" "ALL_COMPLETE" "$BASELINE_PASS" "$CURRENT_SCORE" "" false
    break
  fi

  # Parse the requirement fields (V2: structured JSON format)
  REQ_ID=$(echo "$NEXT_REQ_RAW" | cut -d'|' -f1)
  REQ_PHASE=$(echo "$NEXT_REQ_RAW" | cut -d'|' -f2)
  REQ_TEXT=$(echo "$NEXT_REQ_RAW" | cut -d'|' -f3-)

  CURRENT_REQ_ID="$REQ_ID"
  CURRENT_PHASE_NUM="$REQ_PHASE"

  # ─── Phase boundary gate (autoresearch: score must not regress) ──────────
  if [ "$REQ_PHASE" != "$PREV_PHASE" ]; then
    echo ""
    echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  PHASE GATE: Phase $PREV_PHASE → Phase $REQ_PHASE${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"

    update_status "$i" "$ITERATIONS" "$REQ_ID" "$REQ_PHASE" "PHASE_GATE" "$BASELINE_PASS" "$CURRENT_SCORE" "" false

    GATE_SCORE=$(capture_score)
    GATE_PASS=$(echo "$GATE_SCORE" | cut -d: -f2)
    GATE_FAIL=$(echo "$GATE_SCORE" | cut -d: -f3)

    echo -e "Phase $PREV_PHASE start: ${GREEN}$PHASE_START_PASS passing${NC}"
    echo -e "Phase $PREV_PHASE end:   ${GREEN}$GATE_PASS passing${NC}, ${RED}$GATE_FAIL failing${NC}"

    if [ "$GATE_PASS" -lt "$PHASE_START_PASS" ]; then
      echo -e "${RED}REGRESSION DETECTED. Pass count dropped from $PHASE_START_PASS to $GATE_PASS.${NC}"
      echo -e "${RED}STOPPING. Do not build Phase $REQ_PHASE on broken Phase $PREV_PHASE.${NC}"
      notify "PHASE GATE FAILED: Phase $PREV_PHASE regressed from $PHASE_START_PASS to $GATE_PASS passing. Stopping."
      log_score "$i" "$PREV_PHASE" "PHASE_GATE" "$GATE_PASS" "$GATE_FAIL" "STOPPED_REGRESSION"
      update_status "$i" "$ITERATIONS" "$REQ_ID" "$REQ_PHASE" "PHASE_GATE_FAILED" "$BASELINE_PASS" "$GATE_PASS" "" false
      break
    fi

    echo -e "${GREEN}PHASE GATE PASSED. No regression. Advancing to Phase $REQ_PHASE.${NC}"
    notify "Phase gate passed. Advancing to Phase $REQ_PHASE. Score: $GATE_PASS passing."
    log_score "$i" "$REQ_PHASE" "PHASE_GATE" "$GATE_PASS" "$GATE_FAIL" "PASSED"
    PHASE_START_PASS=$GATE_PASS
    PREV_PHASE=$REQ_PHASE
    echo ""
  fi

  # ─── Deduplication: detect stuck loop vs legitimate partial work ────────
  if [ "$REQ_ID" = "$LAST_REQ_ID" ]; then
    REPEAT_COUNT=$((REPEAT_COUNT + 1))

    # Check if there was actual progress (new commits) since last attempt
    CURRENT_HEAD=$(git rev-parse HEAD 2>/dev/null)
    if [ "$CURRENT_HEAD" != "$LAST_COMMIT_HEAD" ]; then
      # Progress was made — this is legitimate partial work, reset counter
      echo -e "${YELLOW}Same requirement, but progress was made. Continuing partial work.${NC}"
      REPEAT_COUNT=1
    fi

    if [ "$REPEAT_COUNT" -ge 3 ]; then
      echo -e "${RED}STUCK: Same requirement 3 times with no progress. Marking stuck.${NC}"
      mark_requirement_stuck "$REQ_ID" "3 consecutive attempts with no forward progress"
      sync_json_to_markdown
      echo "[$i] STUCK: $REQ_TEXT — 3 attempts, no progress" >> "$PROGRESS_FILE"
      LAST_REQ_ID=""
      REPEAT_COUNT=0
      continue
    else
      echo -e "${YELLOW}Requirement repeated ($REPEAT_COUNT/3). Continuing — may be partial work.${NC}"
    fi
  else
    REPEAT_COUNT=0
  fi
  LAST_REQ_ID="$REQ_ID"
  LAST_COMMIT_HEAD=$(git rev-parse HEAD 2>/dev/null)

  echo -e "${BLUE}=== Iteration $i/$ITERATIONS | Phase $REQ_PHASE | $REQ_ID ===${NC}"
  echo -e "Requirement: $REQ_TEXT"
  echo ""

  # ─── SCORE BEFORE (autoresearch: measure before changing) ────────────────
  BEFORE=$(capture_score)
  BEFORE_PASS=$(echo "$BEFORE" | cut -d: -f2)

  # =========================================================================
  # V2 IMPROVEMENT 2: Git worktree isolation
  # =========================================================================
  WORKTREE_DIR="$WORKTREE_BASE/iter-$i"
  WORKTREE_BRANCH="ralph-iter-$i"

  echo -e "${YELLOW}[WORKTREE] Creating isolated worktree for iteration $i...${NC}"

  # Create worktree for this iteration
  if ! git worktree add "$WORKTREE_DIR" -b "$WORKTREE_BRANCH" 2>/dev/null; then
    echo -e "${RED}[WORKTREE] Failed to create worktree. Cleaning up stale refs...${NC}"
    git worktree prune 2>/dev/null || true
    git branch -D "$WORKTREE_BRANCH" 2>/dev/null || true
    if ! git worktree add "$WORKTREE_DIR" -b "$WORKTREE_BRANCH" 2>/dev/null; then
      echo -e "${RED}[WORKTREE] Still failed. Skipping iteration — running without isolation is unsafe.${NC}"
      echo "[$i] SKIPPED: worktree creation failed" >> "$PROGRESS_FILE"
      LAST_REQ_ID=""  # Clear so transient failure doesn't mark next attempt as stuck
      continue
    fi
  fi

  # Copy the requirements.json into the worktree so the builder can reference it
  cp .planning/requirements.json "$WORKTREE_DIR/.planning/requirements.json" 2>/dev/null || true

  # Verify we're actually in the worktree
  pushd "$WORKTREE_DIR" > /dev/null || {
    echo -e "${RED}[WORKTREE] Failed to enter worktree directory. Skipping iteration.${NC}"
    # Persist attempt count in main checkout before discarding worktree
    python3 -c "
import json
with open('.planning/requirements.json') as f:
    data = json.load(f)
for r in data['requirements']:
    if r['id'] == '$REQ_ID':
        r['attempts'] = r.get('attempts', 0) + 1
        r['last_error'] = 'Failed to enter worktree directory'
        break
with open('.planning/requirements.json', 'w') as f:
    json.dump(data, f, indent=2)
" 2>/dev/null || true
    git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
    git branch -D "$WORKTREE_BRANCH" 2>/dev/null || true
    echo "[$i] SKIPPED: could not enter worktree" >> "$PROGRESS_FILE"
    LAST_REQ_ID=""  # Clear so transient failure doesn't mark next attempt as stuck
    continue
  }

  # Double-check we're not in the main checkout
  if [ "$(pwd)" = "$MAIN_DIR" ]; then
    echo -e "${RED}[WORKTREE] Still in main directory despite pushd. Aborting iteration.${NC}"
    echo "[$i] SKIPPED: worktree isolation verification failed" >> "$PROGRESS_FILE"
    LAST_REQ_ID=""  # Clear so transient failure doesn't mark next attempt as stuck
    continue
  fi

  update_status "$i" "$ITERATIONS" "$REQ_ID" "$REQ_PHASE" "BUILDING" "$BASELINE_PASS" "$CURRENT_SCORE" "" false

  # =========================================================================
  # LAYER 1: BUILDER — Codex writes the code
  # =========================================================================
  echo -e "${GREEN}[BUILDER] Writing code...${NC}"

  run_codex_with_retry \
    "You are the BUILDER agent.

Read AGENTS.md for project rules.
Read .planning/REQUIREMENTS.md or .planning/requirements.json — find this requirement: $REQ_TEXT ($REQ_ID)
Read .planning/STATE.md for current phase context.
Read relevant .planning/ files (ux-brief, ui-brief, data-requirements) for decisions.

BUILD this ONE requirement:
1. Read existing code first — follow established patterns
2. Write the implementation code
3. Write tests for what you built
4. Run: npx tsc --noEmit && npm test
5. Do NOT check the box yet — the Adversary reviews first
6. Do NOT commit yet

If the requirement is too big, build the smallest meaningful slice."

  echo "[BUILDER] Finished building: $REQ_ID $REQ_TEXT" >> "$PROGRESS_FILE"

  # ─── Check if Codex actually produced changes ─────────────────────────────
  if [ -z "$(git diff --name-only 2>/dev/null)" ] && [ -z "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
    echo -e "${RED}[BUILDER] No code changes detected. Codex may have errored.${NC}"
    echo "[$i] SKIPPED: No code changes from builder ($REQ_ID)" >> "$PROGRESS_FILE"

    CONSECUTIVE_SKIPS=$((CONSECUTIVE_SKIPS + 1))

    # V2: Instead of stopping at 3 skips, the rate-limit retry in run_codex_with_retry handles waits.
    # But if we still get 5 empty iterations, something is genuinely wrong.
    if [ "$CONSECUTIVE_SKIPS" -ge 5 ]; then
      echo -e "${RED}5 consecutive empty iterations. Something is wrong. STOPPING.${NC}"
      notify "STOPPED: 5 consecutive empty builder iterations."
      update_status "$i" "$ITERATIONS" "$REQ_ID" "$REQ_PHASE" "STOPPED_EMPTY" "$BASELINE_PASS" "$CURRENT_SCORE" "" false
      popd > /dev/null
      # Persist attempt count in main checkout before discarding worktree
      increment_requirement_attempts "$REQ_ID"
      git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
      git branch -D "$WORKTREE_BRANCH" 2>/dev/null || true
      break
    fi

    popd > /dev/null
    # Persist attempt count in main checkout (after popd, before worktree removal)
    increment_requirement_attempts "$REQ_ID"
    git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
    git branch -D "$WORKTREE_BRANCH" 2>/dev/null || true
    LAST_REQ_ID=""  # Clear so transient failure doesn't mark next attempt as stuck
    continue
  fi
  CONSECUTIVE_SKIPS=0

  # =========================================================================
  # LAYER 2: TEST — Automated score capture
  # =========================================================================
  echo ""
  echo -e "${YELLOW}[TEST] Running test suite...${NC}"
  update_status "$i" "$ITERATIONS" "$REQ_ID" "$REQ_PHASE" "TESTING" "$BASELINE_PASS" "$CURRENT_SCORE" "" false

  AFTER_BUILD=$(capture_score)
  AFTER_BUILD_TC=$(echo "$AFTER_BUILD" | cut -d: -f1)
  AFTER_BUILD_PASS=$(echo "$AFTER_BUILD" | cut -d: -f2)
  AFTER_BUILD_FAIL=$(echo "$AFTER_BUILD" | cut -d: -f3)

  echo -e "Before: ${GREEN}$BEFORE_PASS passing${NC} | After build: ${GREEN}$AFTER_BUILD_PASS passing${NC}, ${RED}$AFTER_BUILD_FAIL failing${NC}, TypeCheck: $([ "$AFTER_BUILD_TC" = "1" ] && echo "${GREEN}PASS${NC}" || echo "${RED}FAIL${NC}")"

  # ─── TYPECHECK GATE: TypeScript errors block everything ──────────────────
  if [ "$AFTER_BUILD_TC" != "1" ]; then
    echo -e "${RED}[TYPECHECK] TypeScript compilation failed. Cannot proceed.${NC}"
    echo -e "${YELLOW}[ANNEAL] Attempting to fix type errors...${NC}"

    run_codex_with_retry \
      "TypeScript compilation is failing (npx tsc --noEmit returns errors).
Fix ALL type errors. Do not change any logic — only fix types.
Run: npx tsc --noEmit"

    # Re-check typecheck
    if ! npx tsc --noEmit 2>/dev/null; then
      echo -e "${RED}[TYPECHECK] Still failing after fix attempt. DISCARDING worktree.${NC}"
      echo "[$i] DISCARDED: $REQ_ID $REQ_TEXT — TypeScript compilation failed" >> "$PROGRESS_FILE"
      log_score "$i" "$REQ_PHASE" "$REQ_TEXT" "$AFTER_BUILD_PASS" "$AFTER_BUILD_FAIL" "DISCARDED_TYPECHECK"

      # V2: Just discard the worktree — no dangerous reverts
      popd > /dev/null
      # Persist attempt count in main checkout (after popd, before worktree removal)
      increment_requirement_attempts "$REQ_ID"
      git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
      git branch -D "$WORKTREE_BRANCH" 2>/dev/null || true
      LAST_REQ_ID=""  # Clear so transient failure doesn't mark next attempt as stuck
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
    update_status "$i" "$ITERATIONS" "$REQ_ID" "$REQ_PHASE" "HEALING" "$BASELINE_PASS" "$AFTER_BUILD_PASS" "" false

    HEALED=false
    for ((heal=1; heal<=$MAX_HEAL_ATTEMPTS; heal++)); do
      echo -e "${YELLOW}[ANNEAL] Heal attempt $heal/$MAX_HEAL_ATTEMPTS (cooling down)...${NC}"

      run_codex_with_retry \
        "You are the HEALER agent. Tests are failing after building: $REQ_TEXT

The test pass count DROPPED from $BEFORE_PASS to $AFTER_BUILD_PASS.
This is attempt $heal of $MAX_HEAL_ATTEMPTS. Be MORE CONSERVATIVE with each attempt.

Attempt 1: Fix the obvious bug.
Attempt 2: Smaller fix. Only touch the lines that caused the failure.
Attempt 3: Minimal change. If you can't fix it, revert your changes to the failing file.

Run: npx tsc --noEmit && npm test
Fix ONLY what's broken. Do NOT add new features. Do NOT refactor."

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
      echo -e "${RED}[ANNEAL] Could not heal after $MAX_HEAL_ATTEMPTS attempts. DISCARDING worktree.${NC}"
      echo "[$i] DISCARDED: $REQ_ID $REQ_TEXT — score dropped and could not heal" >> "$PROGRESS_FILE"
      log_score "$i" "$REQ_PHASE" "$REQ_TEXT" "$BEFORE_PASS" "0" "DISCARDED"
      notify "Iteration $i DISCARDED: $REQ_ID could not heal after $MAX_HEAL_ATTEMPTS attempts."

      # V2: Discard worktree — clean isolation
      popd > /dev/null
      # Persist attempt count in main checkout (after popd, before worktree removal)
      increment_requirement_attempts "$REQ_ID"
      git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
      git branch -D "$WORKTREE_BRANCH" 2>/dev/null || true
      LAST_REQ_ID=""  # Clear so transient failure doesn't mark next attempt as stuck
      continue
    fi
  fi

  # =========================================================================
  # LAYER 3: ADVERSARY — Second agent tries to break the code (V1 behavior)
  # =========================================================================
  echo ""
  echo -e "${RED}[ADVERSARY] Attacking the code...${NC}"
  update_status "$i" "$ITERATIONS" "$REQ_ID" "$REQ_PHASE" "ADVERSARY_REVIEW" "$BASELINE_PASS" "$AFTER_BUILD_PASS" "" false

  for ((adv_round=1; adv_round<=$MAX_ADVERSARY_ROUNDS; adv_round++)); do
    echo -e "${RED}[ADVERSARY] Round $adv_round/$MAX_ADVERSARY_ROUNDS${NC}"

    # Get the diff of what was built
    DIFF=$(git diff --no-color 2>/dev/null | head -500)

    run_codex_with_retry \
      "You are the ADVERSARY agent. Your job is to BREAK the code that was just written.

The BUILDER just implemented: $REQ_TEXT ($REQ_ID)

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
If you genuinely cannot find any bugs, say 'NO BUGS FOUND' and stop."

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

    run_codex_with_retry \
      "You are the BUILDER agent. The ADVERSARY found bugs in your code.

There are $ADV_FAIL failing tests. Fix the CODE (not the tests) to make them pass.
The adversary's tests are valid — they found real bugs.

Run: npx tsc --noEmit && npm test
Fix the bugs. Do not delete or modify the adversary's tests."

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
  # V2 IMPROVEMENT 4: ARCHITECT REVIEW — Second review pass
  # =========================================================================
  echo ""
  echo -e "${BLUE}[ARCHITECT] Reviewing code quality and patterns...${NC}"
  update_status "$i" "$ITERATIONS" "$REQ_ID" "$REQ_PHASE" "ARCHITECT_REVIEW" "$BASELINE_PASS" "$AFTER_BUILD_PASS" "" false

  DIFF_FOR_ARCHITECT=$(git diff --no-color 2>/dev/null | head -500)

  ARCHITECT_OUTPUT=$(run_codex_with_retry \
    "You are the ARCHITECT reviewer. The code below was built and survived adversarial testing.
Now check: Does it follow existing patterns? Is it maintainable? Are there unnecessary abstractions?
Would a senior engineer approve this in a PR review?

Requirement: $REQ_TEXT ($REQ_ID)

Here is what changed:
$DIFF_FOR_ARCHITECT

If the code is fine architecturally, say 'ARCHITECTURE APPROVED'.
If not, list specific concerns and fix them. Then run: npx tsc --noEmit && npm test" 2>&1)

  echo "[ARCHITECT] Review complete" >> "$PROGRESS_FILE"

  # Check if architect approved
  if echo "$ARCHITECT_OUTPUT" | grep -qi "ARCHITECTURE APPROVED\|APPROVED\|no concerns\|looks good\|NO ISSUES"; then
    echo -e "${GREEN}[ARCHITECT] Design approved.${NC}"
  else
    echo -e "${YELLOW}[ARCHITECT] Design concerns raised. Attempting fix...${NC}"

    # Send concerns back to builder for one fix attempt
    run_codex "You are the BUILDER. The ARCHITECT reviewer raised these concerns:
$ARCHITECT_OUTPUT

Fix the design issues raised. Do NOT change functionality — only improve code structure,
naming, patterns, and maintainability. Run: npx tsc --noEmit && npm test" || true

    # Re-run tests to make sure fix didn't break anything
    ARCH_FIX_SCORE=$(capture_score)
    ARCH_FIX_PASS=$(echo "$ARCH_FIX_SCORE" | cut -d: -f2)

    if [ "$ARCH_FIX_PASS" -lt "$BEFORE_PASS" ]; then
      echo -e "${RED}[ARCHITECT] Fix caused regression. Reverting architect changes only.${NC}"
      # The worktree isolation handles this — if we're in a worktree,
      # the merge won't happen. Just note it.
      echo "[$i] ARCHITECT: fix caused regression, keeping pre-architect code" >> "$PROGRESS_FILE"
    else
      echo -e "${GREEN}[ARCHITECT] Design concerns addressed.${NC}"
    fi
  fi

  # Re-capture score after architect review (architect may have made changes)
  ARCH_SCORE=$(capture_score)
  ARCH_PASS=$(echo "$ARCH_SCORE" | cut -d: -f2)
  ARCH_FAIL=$(echo "$ARCH_SCORE" | cut -d: -f3)

  if [ "$ARCH_PASS" -lt "$BEFORE_PASS" ] || [ "$ARCH_FAIL" -gt 0 ]; then
    echo -e "${YELLOW}[ARCHITECT] Changes caused issues. Score: $ARCH_PASS passing, $ARCH_FAIL failing.${NC}"
    # Architect broke something — this is rare, but discard if so
    if [ "$ARCH_PASS" -lt "$BEFORE_PASS" ]; then
      echo -e "${RED}[ARCHITECT] Score regression after architect review. DISCARDING.${NC}"
      echo "[$i] DISCARDED: $REQ_ID $REQ_TEXT — architect review caused regression" >> "$PROGRESS_FILE"
      log_score "$i" "$REQ_PHASE" "$REQ_TEXT" "$ARCH_PASS" "$ARCH_FAIL" "DISCARDED_ARCHITECT"

      popd > /dev/null
      # Persist attempt count in main checkout (after popd, before worktree removal)
      increment_requirement_attempts "$REQ_ID"
      git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
      git branch -D "$WORKTREE_BRANCH" 2>/dev/null || true
      LAST_REQ_ID=""  # Clear so transient failure doesn't mark next attempt as stuck
      continue
    fi
  fi

  AFTER_BUILD_PASS=$ARCH_PASS
  AFTER_BUILD_FAIL=$ARCH_FAIL

  # =========================================================================
  # FINAL AUTORESEARCH CHECK: Is the score better than or equal to before?
  # =========================================================================
  FINAL=$(capture_score)
  FINAL_TC=$(echo "$FINAL" | cut -d: -f1)
  FINAL_PASS=$(echo "$FINAL" | cut -d: -f2)
  FINAL_FAIL=$(echo "$FINAL" | cut -d: -f3)

  echo ""
  echo -e "FINAL SCORE: Before=$BEFORE_PASS | After=${FINAL_PASS} passing, ${FINAL_FAIL} failing, TypeCheck: $([ "$FINAL_TC" = "1" ] && echo "PASS" || echo "FAIL")"

  # Gate on ALL THREE: typecheck pass + pass count held + zero failures
  GATE_FAILED=false
  GATE_REASON=""

  if [ "$FINAL_TC" != "1" ]; then
    GATE_FAILED=true
    GATE_REASON="TypeScript compilation failed"
  elif [ "$FINAL_PASS" -lt "$BEFORE_PASS" ]; then
    GATE_FAILED=true
    GATE_REASON="Pass count dropped from $BEFORE_PASS to $FINAL_PASS"
  elif [ "$FINAL_FAIL" -gt 0 ]; then
    GATE_FAILED=true
    GATE_REASON="$FINAL_FAIL tests still failing"
  fi

  if [ "$GATE_FAILED" = true ]; then
    echo -e "${RED}[GATE FAILED] $GATE_REASON. DISCARDING worktree.${NC}"

    # V2: Just discard the worktree — no file-by-file revert
    echo "[$i] DISCARDED: $REQ_ID $REQ_TEXT — $GATE_REASON" >> "$PROGRESS_FILE"
    log_score "$i" "$REQ_PHASE" "$REQ_TEXT" "$FINAL_PASS" "$FINAL_FAIL" "DISCARDED"

    popd > /dev/null
    # Persist attempt count in main checkout (after popd, before worktree removal)
    increment_requirement_attempts "$REQ_ID"
    git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
    git branch -D "$WORKTREE_BRANCH" 2>/dev/null || true
    LAST_REQ_ID=""  # Clear so transient failure doesn't mark next attempt as stuck
    continue
  fi

  # =========================================================================
  # COMMIT — Only if score held or improved
  # =========================================================================
  echo -e "${GREEN}[COMMIT] Score held or improved. Committing in worktree.${NC}"

  # Stage and commit all changes in the worktree
  git add -A 2>/dev/null || true
  COMMIT_RESULT=$(git commit -m "feat: $REQ_ID $(echo "$REQ_TEXT" | head -c 50) (Phase $REQ_PHASE)

Ralph V2 iteration $i. Score: $FINAL_PASS passing ($((FINAL_PASS - BEFORE_PASS)) net).
Builder → Tests → Adversary ($MAX_ADVERSARY_ROUNDS rounds) → Architect → Verified." 2>&1)
  COMMIT_EXIT=$?

  if [ "$COMMIT_EXIT" -ne 0 ]; then
    echo -e "${RED}[COMMIT] git commit failed in worktree. Aborting iteration.${NC}"
    echo "[$i] COMMIT FAILED: $COMMIT_RESULT" >> "$PROGRESS_FILE"
    # Persist attempt count before discarding worktree
    python3 -c "
import json
with open('.planning/requirements.json') as f:
    data = json.load(f)
for r in data['requirements']:
    if r['id'] == '$REQ_ID':
        r['attempts'] = r.get('attempts', 0) + 1
        r['last_error'] = 'Commit failed in worktree'
        break
with open('.planning/requirements.json', 'w') as f:
    json.dump(data, f, indent=2)
" 2>/dev/null || true
    popd > /dev/null 2>/dev/null || true
    # Copy attempt state back to main checkout before removing worktree
    if [ -f "$WORKTREE_DIR/.planning/requirements.json" ]; then
      cp "$WORKTREE_DIR/.planning/requirements.json" .planning/requirements.json 2>/dev/null || true
    fi
    git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
    git branch -D "$WORKTREE_BRANCH" 2>/dev/null || true
    LAST_REQ_ID=""
    continue
  fi

  WORKTREE_HEAD=$(git rev-parse HEAD)
  LAST_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")

  # ─── V2 IMPROVEMENT 2: Merge worktree back to main branch ─────────────
  popd > /dev/null

  echo -e "${YELLOW}[WORKTREE] Merging iteration $i back to $BRANCH...${NC}"
  if ! git merge "$WORKTREE_BRANCH" --no-edit 2>/dev/null; then
    echo -e "${RED}[MERGE] Failed to merge worktree branch. Aborting iteration.${NC}"
    echo "[$i] MERGE FAILED for $REQ_TEXT" >> "$PROGRESS_FILE"
    git merge --abort 2>/dev/null || true
    log_score "$i" "$REQ_PHASE" "$REQ_TEXT" "$FINAL_PASS" "$FINAL_FAIL" "MERGE_CONFLICT"
    # Persist attempt count in main checkout after failed merge
    python3 -c "
import json
with open('.planning/requirements.json') as f:
    data = json.load(f)
for r in data['requirements']:
    if r['id'] == '$REQ_ID':
        r['attempts'] = r.get('attempts', 0) + 1
        r['last_error'] = 'Merge failed back to main branch'
        break
with open('.planning/requirements.json', 'w') as f:
    json.dump(data, f, indent=2)
" 2>/dev/null || true
    git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
    git branch -D "$WORKTREE_BRANCH" 2>/dev/null || true
    LAST_REQ_ID=""
    continue
  fi

  # Clean up worktree
  git worktree remove "$WORKTREE_DIR" 2>/dev/null || true
  git branch -d "$WORKTREE_BRANCH" 2>/dev/null || true

  # Only NOW mark requirement done (after confirmed commit + merge)
  mark_requirement_done "$REQ_ID"
  sync_json_to_markdown

  # Commit the updated requirements.json and REQUIREMENTS.md
  git add .planning/requirements.json .planning/REQUIREMENTS.md .planning/build-scores.jsonl .planning/ralph-status.json progress.txt 2>/dev/null || true
  git commit -m "chore: mark $REQ_ID done, update tracking files" 2>/dev/null || true

  CURRENT_SCORE=$FINAL_PASS

  echo "[$i] COMMITTED: $REQ_ID $REQ_TEXT | Score: $BEFORE_PASS → $FINAL_PASS" >> "$PROGRESS_FILE"
  log_score "$i" "$REQ_PHASE" "$REQ_TEXT" "$FINAL_PASS" "$FINAL_FAIL" "COMMITTED"
  update_status "$i" "$ITERATIONS" "$REQ_ID" "$REQ_PHASE" "COMMITTED" "$BASELINE_PASS" "$FINAL_PASS" "$LAST_COMMIT" false
  notify "Iteration $i COMMITTED: $REQ_ID | Score: $BEFORE_PASS → $FINAL_PASS (+$((FINAL_PASS - BEFORE_PASS)))"

  echo -e "${GREEN}Done. Score: $BEFORE_PASS → $FINAL_PASS (+$((FINAL_PASS - BEFORE_PASS)))${NC}"
  echo ""
done

# =============================================================================
# CLEANUP: Remove any remaining worktrees
# =============================================================================
echo -e "${YELLOW}Cleaning up worktrees...${NC}"
for wt in "$WORKTREE_BASE"/iter-*; do
  if [ -d "$wt" ]; then
    git worktree remove --force "$wt" 2>/dev/null || true
  fi
done
rmdir "$WORKTREE_BASE" 2>/dev/null || true

# Clean up any lingering ralph-iter branches
git branch --list 'ralph-iter-*' 2>/dev/null | while read -r branch; do
  git branch -D "$branch" 2>/dev/null || true
done

# =============================================================================
# FINAL REPORT
# =============================================================================
echo ""
echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  OVERNIGHT BUILD V2 COMPLETE${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
echo ""

FINAL_TOTAL=$(capture_score)
FINAL_TOTAL_PASS=$(echo "$FINAL_TOTAL" | cut -d: -f2)
COMMITTED=$(grep -c "COMMITTED" "$PROGRESS_FILE" 2>/dev/null || echo "0")
DISCARDED=$(grep -c "DISCARDED" "$PROGRESS_FILE" 2>/dev/null || echo "0")

# Get stuck/done counts from requirements.json
REQS_DONE=$(python3 -c "
import json
with open('.planning/requirements.json') as f:
    data = json.load(f)
print(sum(1 for r in data['requirements'] if r.get('done', False) or r.get('status', '') == 'done'))
" 2>/dev/null || echo "?")

REQS_STUCK=$(python3 -c "
import json
with open('.planning/requirements.json') as f:
    data = json.load(f)
print(sum(1 for r in data['requirements'] if r.get('stuck', False) or r.get('status', '') == 'stuck'))
" 2>/dev/null || echo "?")

REQS_REMAINING=$(python3 -c "
import json
with open('.planning/requirements.json') as f:
    data = json.load(f)
print(sum(1 for r in data['requirements'] if not (r.get('done', False) or r.get('status', '') == 'done') and not (r.get('stuck', False) or r.get('status', '') == 'stuck')))
" 2>/dev/null || echo "?")

echo -e "Baseline score:    ${GREEN}$BASELINE_PASS passing${NC}"
echo -e "Final score:       ${GREEN}$FINAL_TOTAL_PASS passing${NC}"
echo -e "Net improvement:   ${GREEN}+$((FINAL_TOTAL_PASS - BASELINE_PASS)) tests${NC}"
echo ""
echo -e "Iterations committed: ${GREEN}$COMMITTED${NC}"
echo -e "Iterations discarded: ${RED}$DISCARDED${NC}"
echo ""
echo -e "Requirements done:      ${GREEN}$REQS_DONE${NC}"
echo -e "Requirements stuck:     ${YELLOW}$REQS_STUCK${NC}"
echo -e "Requirements remaining: ${BLUE}$REQS_REMAINING${NC}"
echo ""
echo -e "Review: git log --oneline $BRANCH"
echo -e "Scores: cat $SCORE_FILE"
echo -e "Status: cat $STATUS_FILE"
echo -e "Progress: cat $PROGRESS_FILE"
echo ""
echo -e "${BLUE}Every committed requirement survived:${NC}"
echo -e "  1. Builder wrote code + tests (in isolated worktree)"
echo -e "  2. Autoresearch verified score didn't drop"
echo -e "  3. Adversary tried to break it"
echo -e "  4. Builder fixed what adversary found"
echo -e "  5. Architect reviewed for quality and patterns"
echo -e "  6. Final score >= baseline (or worktree discarded)"
echo -e "  7. Worktree merged back cleanly"
echo -e "  8. Phase gates blocked regression between phases"

update_status "$ITERATIONS" "$ITERATIONS" "" "$CURRENT_PHASE_NUM" "COMPLETE" "$BASELINE_PASS" "$FINAL_TOTAL_PASS" "" false

SUMMARY="Overnight V2 complete. Baseline: $BASELINE_PASS → Final: $FINAL_TOTAL_PASS (+$((FINAL_TOTAL_PASS - BASELINE_PASS))). Committed: $COMMITTED, Discarded: $DISCARDED. Done: $REQS_DONE, Stuck: $REQS_STUCK, Remaining: $REQS_REMAINING."
notify "$SUMMARY"
