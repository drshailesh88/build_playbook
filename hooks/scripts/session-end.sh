#!/bin/bash
# Session End Hook (Stop)
#
# Saves session state and extracts learnings when Claude finishes responding.
# Ensures the next session can pick up where this one left off.

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

echo "SESSION: State saved to $SESSION_FILE" >&2
exit 0
