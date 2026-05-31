#!/bin/bash
# Markdown Blocker Hook (PreToolUse → Write)
#
# Prevents stray markdown files outside designated project directories.

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

if [ "$TOOL_NAME" != "Write" ]; then
  exit 0
fi

FILE_PATH=$(printf '%s' "$INPUT" | python3 -c 'import json,sys
try:
    data=json.load(sys.stdin)
except Exception:
    data={}
print(data.get("tool_input", {}).get("file_path", ""))
')

case "$FILE_PATH" in
  *.md) ;;
  *) exit 0 ;;
esac

REL_PATH="$FILE_PATH"
case "$REL_PATH" in
  *"/Build Playbook/"*) REL_PATH="${REL_PATH#*"/Build Playbook/"}" ;;
esac
REL_PATH="${REL_PATH#./}"
REL_PATH="${REL_PATH#/}"

case "$REL_PATH" in
  docs/*|.planning/*|commands/*|agents/*|playbook/*|skills/*|rules/*|.quality/*|qa/*|ralph/*|.canary/*|vendor/*|.taskmaster/*|hooks/*)
    exit 0
    ;;
  README.md|CHANGELOG.md|CLAUDE.md|THE-PLAYBOOK.md|MASTER-REPO-GUIDE.md)
    exit 0
    ;;
esac

cat <<GATE
{"permissionDecision":"deny","message":"Markdown files must be in designated directories (docs/, .planning/, commands/, agents/, playbook/). Use /playbook:doctor to see allowed locations."}
GATE

exit 0
