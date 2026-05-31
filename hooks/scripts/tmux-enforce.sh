#!/bin/bash
# Tmux Enforce Hook (PreToolUse → Bash)
#
# Asks before starting long-running dev servers outside tmux.

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

if [ "$TOOL_NAME" != "Bash" ]; then
  exit 0
fi

if [ -n "$TMUX" ]; then
  exit 0
fi

COMMAND=$(printf '%s' "$INPUT" | python3 -c 'import json,sys
try:
    data=json.load(sys.stdin)
except Exception:
    data={}
print(data.get("tool_input", {}).get("command", ""))
')

if echo "$COMMAND" | grep -qE '(^|[;&|[:space:]])(npm[[:space:]]+run[[:space:]]+dev|next[[:space:]]+dev|npx[[:space:]]+next[[:space:]]+dev|npm[[:space:]]+start|npx[[:space:]]+vite|vite[[:space:]]+dev)([;&|[:space:]]|$)'; then
  cat <<GATE
{"permissionDecision":"ask","message":"Dev server outside tmux — long-running servers should run in a tmux session to prevent lost terminals. Consider: tmux new -s dev"}
GATE
  exit 0
fi

exit 0
