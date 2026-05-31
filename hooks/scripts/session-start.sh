#!/bin/bash
# Session Start Hook (UserPromptSubmit — runs once at start)
#
# Loads project learnings and last session state into context.
# Makes every session smarter than the last.

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
CANONICAL_DIR=$(cd "$PROJECT_DIR" 2>/dev/null && pwd -P || printf '%s' "$PROJECT_DIR")
PROJECT_BASE=$(basename "$CANONICAL_DIR" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
PROJECT_HASH=$(printf '%s' "$CANONICAL_DIR" | shasum -a 256 | cut -c1-8)
PROJECT_SLUG="${PROJECT_BASE}-${PROJECT_HASH}"

# Only run once per project per hour
SESSION_MARKER="$HOME/.buildplaybook/.session-started-${PROJECT_SLUG}-$(date +%Y%m%d%H)"
if [ -f "$SESSION_MARKER" ]; then
  exit 0
fi
touch "$SESSION_MARKER"

LEARNINGS_DIR="$HOME/.buildplaybook/projects/$PROJECT_SLUG"

# Load last session state if it exists
if [ -f "$LEARNINGS_DIR/last-session.md" ]; then
  echo "CONTEXT: Loading last session state..." >&2
  cat "$LEARNINGS_DIR/last-session.md" >&2
  echo "" >&2
fi

# Load recent learnings (last 20)
if [ -f "$LEARNINGS_DIR/learnings.jsonl" ]; then
  LEARNING_COUNT=$(wc -l < "$LEARNINGS_DIR/learnings.jsonl" | tr -d ' ')
  if [ "$LEARNING_COUNT" -gt 0 ]; then
    echo "LEARNINGS: $LEARNING_COUNT project learnings available. Recent:" >&2
    tail -5 "$LEARNINGS_DIR/learnings.jsonl" | while IFS= read -r line; do
      TYPE=$(echo "$line" | grep -o '"type":"[^"]*"' | sed 's/"type":"//;s/"//')
      CONTENT=$(echo "$line" | grep -o '"content":"[^"]*"' | sed 's/"content":"//;s/"//')
      echo "  [$TYPE] $CONTENT" >&2
    done
    echo "" >&2
  fi
fi

exit 0
