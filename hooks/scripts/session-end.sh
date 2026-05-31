#!/bin/bash
# Session End Hook (Stop)
#
# Saves session state and extracts learnings when Claude finishes responding.
# Ensures the next session can pick up where this one left off.
# Also checks for unsaved planning decisions.

# Determine project directory
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
CANONICAL_DIR=$(cd "$PROJECT_DIR" 2>/dev/null && pwd -P || printf '%s' "$PROJECT_DIR")
PROJECT_BASE=$(basename "$CANONICAL_DIR" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
PROJECT_HASH=$(printf '%s' "$CANONICAL_DIR" | shasum -a 256 | cut -c1-8)
PROJECT_SLUG="${PROJECT_BASE}-${PROJECT_HASH}"

LEARNINGS_DIR="$HOME/.buildplaybook/projects/$PROJECT_SLUG"
mkdir -p "$LEARNINGS_DIR"
LEARNINGS_FILE="$LEARNINGS_DIR/learnings.jsonl"
PLANNING_DIR="$PROJECT_DIR/.planning"
GRILL_LOG="$PLANNING_DIR/grill-log.md"

# Save session state
SESSION_FILE="$LEARNINGS_DIR/last-session.md"
PREVIOUS_DECIDED=$(grep -o "DECIDED: [0-9]*" "$SESSION_FILE" 2>/dev/null | tail -1 | awk '{print $2}')
PREVIOUS_DECIDED=${PREVIOUS_DECIDED:-0}
cat > "$SESSION_FILE" <<EOF
# Last Session State
Updated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
Project: $PROJECT_DIR

## Git State
$(cd "$PROJECT_DIR" 2>/dev/null && git log --oneline -5 2>/dev/null || echo "Not a git repo")

## Modified Files
$(cd "$PROJECT_DIR" 2>/dev/null && git status --short 2>/dev/null || echo "N/A")

## Branch
$(cd "$PROJECT_DIR" 2>/dev/null && git branch --show-current 2>/dev/null || echo "N/A")
EOF

# Extract lightweight learnings
LOCK_DIR="$LEARNINGS_DIR/.learnings.lockdir"
if mkdir "$LOCK_DIR" 2>/dev/null; then
  _unlock() { trap - EXIT INT TERM; rmdir "$LOCK_DIR" 2>/dev/null; }
  trap _unlock EXIT
  trap '_unlock; exit 130' INT
  trap '_unlock; exit 143' TERM

  EXISTING_LEARNINGS=""
  if [ -f "$LEARNINGS_FILE" ]; then
    EXISTING_LEARNINGS=$(cat "$LEARNINGS_FILE")
  fi

  LEARNING_TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  cd "$PROJECT_DIR" 2>/dev/null && git log --oneline --since='4 hours ago' --grep='fix' 2>/dev/null | while IFS= read -r COMMIT; do
    COMMIT_SHORT=$(echo "$COMMIT" | cut -d' ' -f1)
    if echo "$EXISTING_LEARNINGS" | grep -q "$COMMIT_SHORT"; then
      continue
    fi
    CONTENT=$(printf '%s' "Recent fix commit: $COMMIT" | sed 's/\\/\\\\/g; s/"/\\"/g')
    echo "{\"timestamp\":\"$LEARNING_TIMESTAMP\",\"type\":\"pitfall\",\"content\":\"$CONTENT\",\"source\":\"session-auto\",\"confidence\":0.5}" >> "$LEARNINGS_FILE"
  done

  if [ -f "$GRILL_LOG" ]; then
    DECIDED=$(grep -c "Status: DECIDED" "$GRILL_LOG" 2>/dev/null || echo 0)
    GRILL_LAST_FILE="$LEARNINGS_DIR/.grill-decided-last-count"
    GRILL_LAST=$(cat "$GRILL_LAST_FILE" 2>/dev/null || echo "$PREVIOUS_DECIDED")
    if [ "$DECIDED" -gt "$GRILL_LAST" ]; then
      NEW_DECIDED=$((DECIDED - GRILL_LAST))
      CONTENT=$(printf '%s' "$NEW_DECIDED new architecture decisions recorded in grill-log.md" | sed 's/\\/\\\\/g; s/"/\\"/g')
      echo "{\"timestamp\":\"$LEARNING_TIMESTAMP\",\"type\":\"architecture\",\"content\":\"$CONTENT\",\"source\":\"session-auto\",\"confidence\":0.6}" >> "$LEARNINGS_FILE"
      echo "$DECIDED" > "$GRILL_LAST_FILE"
    fi
  fi

  GATEGUARD_SESSION="$HOME/.gstack/gateguard/session-$(date +%Y%m%d).txt"
  if [ -f "$GATEGUARD_SESSION" ]; then
    GATEGUARD_LINES=$(wc -l < "$GATEGUARD_SESSION" | tr -d ' ')
    GATEGUARD_LAST_FILE="$LEARNINGS_DIR/.gateguard-last-count-$(date +%Y%m%d)"
    GATEGUARD_LAST=$(cat "$GATEGUARD_LAST_FILE" 2>/dev/null || echo 0)
    if [ "$GATEGUARD_LINES" -gt "$GATEGUARD_LAST" ]; then
      NEW_INVESTIGATIONS=$((GATEGUARD_LINES - GATEGUARD_LAST))
      CONTENT=$(printf '%s' "GateGuard recorded $NEW_INVESTIGATIONS new investigation lines today" | sed 's/\\/\\\\/g; s/"/\\"/g')
      echo "{\"timestamp\":\"$LEARNING_TIMESTAMP\",\"type\":\"pattern\",\"content\":\"$CONTENT\",\"source\":\"session-auto\",\"confidence\":0.3}" >> "$LEARNINGS_FILE"
      echo "$GATEGUARD_LINES" > "$GATEGUARD_LAST_FILE"
    fi
  fi

  _unlock
fi

# Check for planning decision artifacts
if [ -d "$PLANNING_DIR" ]; then
  DECISION_INDEX="$PLANNING_DIR/decision-index.md"
  NEXT_DEC_ID_FILE="$PLANNING_DIR/next-dec-id"

  if [ -f "$GRILL_LOG" ]; then
    DECIDED=$(grep -c "Status: DECIDED" "$GRILL_LOG" 2>/dev/null || echo 0)
    DEFERRED=$(grep -c "Status: DEFERRED" "$GRILL_LOG" 2>/dev/null || echo 0)
    REJECTED=$(grep -c "Status: REJECTED" "$GRILL_LOG" 2>/dev/null || echo 0)
    TOTAL=$((DECIDED + DEFERRED + REJECTED))

    # Append planning state to session file
    cat >> "$SESSION_FILE" <<EOF

## Planning State
- Grill log: $GRILL_LOG
- Total decisions: $TOTAL (DECIDED: $DECIDED, DEFERRED: $DEFERRED, REJECTED: $REJECTED)
EOF

    # Cross-check: atomic counter vs actual records on disk
    if [ -f "$NEXT_DEC_ID_FILE" ]; then
      NEXT_ID=$(cat "$NEXT_DEC_ID_FILE" 2>/dev/null || echo 1)
      EXPECTED_ON_DISK=$((NEXT_ID - 1))
      if [ "$TOTAL" -lt "$EXPECTED_ON_DISK" ]; then
        MISSING=$((EXPECTED_ON_DISK - TOTAL))
        echo "WARNING: Atomic counter says $EXPECTED_ON_DISK decisions assigned but only $TOTAL found on disk. $MISSING decisions may be UNSAVED (lost to context compaction). Review conversation history." >&2
        cat >> "$SESSION_FILE" <<EOF
- ⚠ UNSAVED DECISIONS: counter=$EXPECTED_ON_DISK, on_disk=$TOTAL, missing=$MISSING
EOF
      fi
    fi

    # Check if decision index exists and is in sync
    if [ -f "$DECISION_INDEX" ]; then
      INDEX_COUNT=$(grep -c "^| DEC-" "$DECISION_INDEX" 2>/dev/null || echo 0)
      if [ "$INDEX_COUNT" -ne "$TOTAL" ]; then
        echo "PLANNING: Decision index ($INDEX_COUNT entries) out of sync with grill log ($TOTAL decisions). Run /grill-me to reconcile." >&2
      fi
    elif [ "$TOTAL" -gt 0 ]; then
      echo "PLANNING: $TOTAL decisions in grill log but no decision-index.md. Run /grill-me to create index." >&2
    fi
  fi

  # Check for CONTEXT.md
  if [ -f "$PLANNING_DIR/CONTEXT.md" ]; then
    GLOSSARY_COUNT=$(grep -c "^| " "$PLANNING_DIR/CONTEXT.md" 2>/dev/null || echo 0)
    cat >> "$SESSION_FILE" <<EOF
- Context glossary: $GLOSSARY_COUNT terms
EOF
  fi
fi

echo "SESSION: State saved to $SESSION_FILE" >&2

# Supermemory: instruct the agent to persist key learnings
echo "SUPERMEMORY: Before ending, call memory() to save this session's key decisions, patterns discovered, and error resolutions. Use containerTag=\"$PROJECT_BASE\". Do NOT save trivial fixes or intermediate debugging steps." >&2

exit 0
