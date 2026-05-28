#!/bin/bash
# Quality Gate Hook (PostToolUse → Edit/Write)
#
# After every file edit, automatically runs format check and type check.
# Catches errors immediately instead of discovering them at commit time.

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

if [ "$TOOL_NAME" != "Edit" ] && [ "$TOOL_NAME" != "Write" ]; then
  exit 0
fi

FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
FILE_EXT="${FILE_PATH##*.}"

# Only check TypeScript/JavaScript files
case "$FILE_EXT" in
  ts|tsx|js|jsx|mjs|mts) ;;
  *) exit 0 ;;
esac

# Find project root (look for package.json)
DIR=$(dirname "$FILE_PATH")
PROJECT_ROOT=""
while [ "$DIR" != "/" ]; do
  if [ -f "$DIR/package.json" ]; then
    PROJECT_ROOT="$DIR"
    break
  fi
  DIR=$(dirname "$DIR")
done

if [ -z "$PROJECT_ROOT" ]; then
  exit 0
fi

# Run format check (non-blocking, informational)
if [ -f "$PROJECT_ROOT/node_modules/.bin/prettier" ]; then
  PRETTIER_OUT=$("$PROJECT_ROOT/node_modules/.bin/prettier" --check "$FILE_PATH" 2>&1)
  if [ $? -ne 0 ]; then
    echo "FORMAT: $(basename "$FILE_PATH") needs formatting. Run: npx prettier --write \"$FILE_PATH\"" >&2
  fi
fi

# Run typecheck on the specific file (non-blocking, informational)
if [ -f "$PROJECT_ROOT/tsconfig.json" ] && [ -f "$PROJECT_ROOT/node_modules/.bin/tsc" ]; then
  TSC_OUT=$("$PROJECT_ROOT/node_modules/.bin/tsc" --noEmit 2>&1 | grep "$(basename "$FILE_PATH")" | head -5)
  if [ -n "$TSC_OUT" ]; then
    echo "TYPECHECK: Issues in $(basename "$FILE_PATH"):" >&2
    echo "$TSC_OUT" >&2
  fi
fi

exit 0
