#!/bin/bash
# Console Log Check Hook (PostToolUse → Edit/Write)
#
# Warns when production TypeScript/JavaScript files contain console.log.
# Informational only; never blocks tool use.

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

if [ "$TOOL_NAME" != "Edit" ] && [ "$TOOL_NAME" != "Write" ]; then
  exit 0
fi

FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
FILE_EXT="${FILE_PATH##*.}"
FILE_NAME=$(basename "$FILE_PATH")

# Only check TypeScript/JavaScript files
case "$FILE_EXT" in
  ts|tsx|js|jsx) ;;
  *) exit 0 ;;
esac

# Skip tests/specs and config files
if echo "$FILE_NAME" | grep -qE '\.(test|spec)\.'; then
  exit 0
fi

if echo "$FILE_NAME" | grep -qE '(^|\.)(config|conf)\.'; then
  exit 0
fi

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

if grep -q 'console\.log' "$FILE_PATH"; then
  echo "CONSOLE: $(basename "$FILE_PATH") contains console.log. Remove debug logging before shipping." >&2
fi

exit 0
