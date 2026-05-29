#!/bin/bash
# Goal acceptance gate — Stop hook for /goal deterministic verification.
#
# The /goal judge (Haiku) cannot run commands — it only evaluates what the
# worker surfaced in the conversation transcript. This Stop hook compensates
# by running deterministic checks after each worker turn and feeding results
# back into the transcript.
#
# Tracking file format: "mode:story_id:pid" (written by goal-build.sh / goal-qa.sh)
#   mode = "build" or "qa"
#   story_id = prd.json story ID
#   pid = PID of the goal script (staleness check)
#
# Exit codes:
#   0  → allow the response
#   2  → block (verification failed — worker should keep working)

set -u

TRACKING_FILE="ralph/goal-current-story.txt"
if [ ! -f "$TRACKING_FILE" ]; then
  exit 0
fi

TRACKING=$(cat "$TRACKING_FILE" 2>/dev/null || echo "")
if [ -z "$TRACKING" ]; then
  exit 0
fi

# Parse mode:story_id:pid
GOAL_MODE=$(echo "$TRACKING" | cut -d: -f1)
STORY_ID=$(echo "$TRACKING" | cut -d: -f2)
GOAL_PID=$(echo "$TRACKING" | cut -d: -f3)

if [ -z "$STORY_ID" ]; then
  exit 0
fi

# Staleness check: if the PID that wrote this file is dead, ignore
if [ -n "$GOAL_PID" ] && ! kill -0 "$GOAL_PID" 2>/dev/null; then
  rm -f "$TRACKING_FILE"
  exit 0
fi

# Validate story exists in prd.json
PRD="ralph/prd.json"
STORY_EXISTS=$(python3 -c "
import json
try:
    prd = json.load(open('$PRD'))
    story = next((s for s in prd if s['id'] == '$STORY_ID'), None)
    print('yes' if story else 'no')
except Exception:
    print('no')
" 2>/dev/null)

if [ "$STORY_EXISTS" = "no" ]; then
  echo "[goal-gate] story '$STORY_ID' not found in prd.json — removing stale tracking file" >&2
  rm -f "$TRACKING_FILE"
  exit 0
fi

# The worker's response comes via $1 for Claude Code hooks
RESPONSE="${1:-}"

# Quick check: is the worker signaling completion?
if [ "$GOAL_MODE" = "build" ]; then
  if ! echo "$RESPONSE" | grep -qiE "(RALPH:|passes.*true|story.*complete|all.*tests.*pass)"; then
    exit 0
  fi
elif [ "$GOAL_MODE" = "qa" ]; then
  if ! echo "$RESPONSE" | grep -qiE "(QA:|qa_tested.*true|qa.*complete|verification.*pass)"; then
    exit 0
  fi
else
  exit 0
fi

# ─── Worker claims completion — run deterministic verification ───

ERRORS=()

if [ "$GOAL_MODE" = "build" ]; then
  # BUILD MODE: check passes:true + fail_to_pass + tsc + lint

  STORY_PASSES=$(python3 -c "
import json
try:
    prd = json.load(open('$PRD'))
    story = next((s for s in prd if s['id'] == '$STORY_ID'), None)
    print('yes' if story and story.get('passes', False) else 'no')
except Exception:
    print('error')
" 2>/dev/null)

  if [ "$STORY_PASSES" != "yes" ]; then
    ERRORS+=("passes:true not yet set in prd.json for $STORY_ID")
  fi

elif [ "$GOAL_MODE" = "qa" ]; then
  # QA MODE: check qa_tested:true + qa-report entry

  QA_STATUS=$(python3 -c "
import json
try:
    prd = json.load(open('$PRD'))
    story = next((s for s in prd if s['id'] == '$STORY_ID'), None)
    qa_tested = story and story.get('qa_tested', False)

    report = json.load(open('ralph/qa-report.json'))
    has_report = any(e.get('story_id') == '$STORY_ID' for e in report)

    if qa_tested and has_report:
        print('yes')
    elif not qa_tested:
        print('no_flag')
    else:
        print('no_report')
except Exception as e:
    print('error')
" 2>/dev/null)

  case "$QA_STATUS" in
    no_flag)  ERRORS+=("qa_tested:true not yet set in prd.json for $STORY_ID") ;;
    no_report) ERRORS+=("no entry for $STORY_ID in ralph/qa-report.json") ;;
    error)    ERRORS+=("could not read prd.json or qa-report.json") ;;
  esac
fi

# Check fail_to_pass test names (both build and QA modes)
FAIL_TO_PASS=$(python3 -c "
import json
try:
    prd = json.load(open('$PRD'))
    story = next((s for s in prd if s['id'] == '$STORY_ID'), None)
    if story:
        for t in story.get('fail_to_pass', []):
            print(t)
except Exception:
    pass
" 2>/dev/null)

if [ -n "$FAIL_TO_PASS" ]; then
  TEST_EXIT=0
  TEST_OUTPUT=$(npm run test:run -- --reporter=verbose 2>&1) || TEST_EXIT=$?

  if [ "$TEST_EXIT" -ne 0 ]; then
    ERRORS+=("test suite exited with code $TEST_EXIT — pinned tests cannot be verified while the suite is red")
  fi

  TOTAL_FTP=0
  FOUND_FTP=0
  MISSING_FTP=""
  while IFS= read -r test_name; do
    TOTAL_FTP=$((TOTAL_FTP + 1))
    LAST_SEGMENT="${test_name##*.}"
    # Verify test name appears in a PASSING context (✓ or PASS prefix),
    # not just anywhere in output (failing tests also print their name)
    if echo "$TEST_OUTPUT" | grep -F "$test_name" | grep -qE '✓|✔|PASS|pass'; then
      FOUND_FTP=$((FOUND_FTP + 1))
    elif echo "$TEST_OUTPUT" | grep -F "$LAST_SEGMENT" | grep -qE '✓|✔|PASS|pass'; then
      FOUND_FTP=$((FOUND_FTP + 1))
    else
      MISSING_FTP="${MISSING_FTP}  - ${test_name}\n"
    fi
  done <<< "$FAIL_TO_PASS"

  if [ "$FOUND_FTP" -lt "$TOTAL_FTP" ]; then
    ERRORS+=("fail_to_pass: $FOUND_FTP/$TOTAL_FTP pinned tests PASSED. Missing or failing:\n$MISSING_FTP")
  fi
fi

# Typecheck
if [ -f "tsconfig.json" ]; then
  if ! npx tsc --noEmit >/dev/null 2>&1; then
    ERRORS+=("typecheck: npx tsc --noEmit failed")
  fi
fi

# Lint
if ! npm run lint --if-present >/dev/null 2>&1; then
  ERRORS+=("lint: npm run lint failed")
fi

# ─── Report results ───

if [ ${#ERRORS[@]} -eq 0 ]; then
  echo "[goal-gate] OK: $STORY_ID ($GOAL_MODE mode) — all checks pass (fail_to_pass: ${FOUND_FTP:-0}/${TOTAL_FTP:-0}, tsc: clean, lint: clean)" >&2
  exit 0
fi

echo "[goal-gate] BLOCKED: $STORY_ID ($GOAL_MODE mode) — verification failed:" >&2
for err in "${ERRORS[@]}"; do
  printf "  - %b\n" "$err" >&2
done
echo "[goal-gate] Keep working — fix the above before completion." >&2
exit 2
