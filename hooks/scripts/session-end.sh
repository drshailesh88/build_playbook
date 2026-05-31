#!/bin/bash
# Session End Hook (Stop)
#
# Saves session state and extracts learnings when Claude finishes responding.
# Ensures the next session can pick up where this one left off.
# Also checks for unsaved planning decisions.

# Determine project directory
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
PROJECT_SLUG=$(basename "$PROJECT_DIR" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')

LEARNINGS_DIR="$HOME/.buildplaybook/projects/$PROJECT_SLUG"
mkdir -p "$LEARNINGS_DIR"

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
LEARNING_TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

cd "$PROJECT_DIR" 2>/dev/null && git log --oneline --since='4 hours ago' --grep='fix' 2>/dev/null | while IFS= read -r COMMIT; do
  CONTENT=$(printf '%s' "Recent fix commit: $COMMIT" | sed 's/\\/\\\\/g; s/"/\\"/g')
  echo "{\"timestamp\":\"$LEARNING_TIMESTAMP\",\"type\":\"pitfall\",\"content\":\"$CONTENT\",\"source\":\"session-auto\",\"confidence\":0.5}" >> "$LEARNINGS_DIR/learnings.jsonl"
done

PLANNING_DIR="$PROJECT_DIR/.planning"
GRILL_LOG="$PLANNING_DIR/grill-log.md"
if [ -f "$GRILL_LOG" ]; then
  DECIDED=$(grep -c "Status: DECIDED" "$GRILL_LOG" 2>/dev/null || echo 0)
  if [ "$DECIDED" -gt "$PREVIOUS_DECIDED" ]; then
    NEW_DECIDED=$((DECIDED - PREVIOUS_DECIDED))
    CONTENT=$(printf '%s' "$NEW_DECIDED new architecture decisions recorded in grill-log.md" | sed 's/\\/\\\\/g; s/"/\\"/g')
    echo "{\"timestamp\":\"$LEARNING_TIMESTAMP\",\"type\":\"architecture\",\"content\":\"$CONTENT\",\"source\":\"session-auto\",\"confidence\":0.6}" >> "$LEARNINGS_DIR/learnings.jsonl"
  fi
fi

GATEGUARD_SESSION="$HOME/.gstack/gateguard/session-$(date +%Y%m%d).txt"
if [ -f "$GATEGUARD_SESSION" ]; then
  GATEGUARD_LINES=$(wc -l < "$GATEGUARD_SESSION" | tr -d ' ')
  if [ "$GATEGUARD_LINES" -gt 0 ]; then
    CONTENT=$(printf '%s' "GateGuard recorded $GATEGUARD_LINES investigation lines today" | sed 's/\\/\\\\/g; s/"/\\"/g')
    echo "{\"timestamp\":\"$LEARNING_TIMESTAMP\",\"type\":\"pattern\",\"content\":\"$CONTENT\",\"source\":\"session-auto\",\"confidence\":0.3}" >> "$LEARNINGS_DIR/learnings.jsonl"
  fi
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
exit 0
