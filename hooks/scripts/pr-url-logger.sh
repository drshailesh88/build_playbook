#!/bin/bash
# PR URL Logger Hook (PostToolUse → Bash)
#
# Captures GitHub pull request URLs from Bash output into .planning/pr-log.md.
# Informational only; never blocks tool use.

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

if [ "$TOOL_NAME" != "Bash" ]; then
  exit 0
fi

STDOUT=$(printf '%s' "$INPUT" | python3 -c 'import json,sys
def find_stdout(value):
    if isinstance(value, dict):
        if "stdout" in value:
            return value.get("stdout") or ""
        for child in value.values():
            found = find_stdout(child)
            if found:
                return found
    elif isinstance(value, list):
        for child in value:
            found = find_stdout(child)
            if found:
                return found
    return ""
try:
    data=json.load(sys.stdin)
except Exception:
    data={}
print(find_stdout(data), end="")
')

URL=$(printf '%s\n' "$STDOUT" | grep -oE 'https://github\.com/[^/]+/[^/]+/pull/[0-9]+' | head -1)

if [ -z "$URL" ]; then
  exit 0
fi

mkdir -p .planning
LOG_FILE=".planning/pr-log.md"

if [ ! -f "$LOG_FILE" ]; then
  cat > "$LOG_FILE" <<HEADER
# PR Log

HEADER
fi

TIMESTAMP=$(date "+%Y-%m-%d %H:%M")
echo "- [$TIMESTAMP] $URL" >> "$LOG_FILE"

exit 0
