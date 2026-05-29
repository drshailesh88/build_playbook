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

# Check for planning decision artifacts
PLANNING_DIR="$PROJECT_DIR/.planning"
if [ -d "$PLANNING_DIR" ]; then
  GRILL_LOG="$PLANNING_DIR/grill-log.md"
  DECISION_INDEX="$PLANNING_DIR/decision-index.md"

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
