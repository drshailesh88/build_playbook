#!/bin/bash
# Careful Check Hook (PreToolUse → Bash)
#
# Warns before executing destructive commands.
# Adapted from gstack's /careful skill.

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

if [ "$TOOL_NAME" != "Bash" ]; then
  exit 0
fi

COMMAND=$(echo "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"command"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Safe exceptions — build artifacts are OK to delete
if echo "$COMMAND" | grep -qE 'rm -rf (node_modules|\.next|dist|__pycache__|\.cache|build|\.turbo|coverage|\.parcel-cache)'; then
  exit 0
fi

# Check for destructive patterns
DESTRUCTIVE=""

if echo "$COMMAND" | grep -qE 'rm\s+-(r|rf|fr)\s'; then
  DESTRUCTIVE="Recursive file deletion"
elif echo "$COMMAND" | grep -qi 'DROP TABLE\|DROP DATABASE'; then
  DESTRUCTIVE="Database table/database deletion"
elif echo "$COMMAND" | grep -qi 'TRUNCATE'; then
  DESTRUCTIVE="Database table truncation"
elif echo "$COMMAND" | grep -qE 'git push\s+(-f|--force)'; then
  DESTRUCTIVE="Force push (rewrites remote history)"
elif echo "$COMMAND" | grep -qE 'git reset\s+--hard'; then
  DESTRUCTIVE="Hard reset (discards uncommitted changes)"
elif echo "$COMMAND" | grep -qE 'git checkout\s+\.\s*$'; then
  DESTRUCTIVE="Discard all working tree changes"
elif echo "$COMMAND" | grep -qE 'git clean\s+-f'; then
  DESTRUCTIVE="Delete untracked files"
elif echo "$COMMAND" | grep -qi 'kubectl delete'; then
  DESTRUCTIVE="Kubernetes resource deletion"
elif echo "$COMMAND" | grep -qE 'docker (rm -f|system prune)'; then
  DESTRUCTIVE="Docker container/system cleanup"
fi

if [ -n "$DESTRUCTIVE" ]; then
  echo "CAREFUL: Destructive operation detected — $DESTRUCTIVE" >&2
  echo "Command: $COMMAND" >&2
  cat <<GATE
{"permissionDecision":"ask","message":"Destructive operation: $DESTRUCTIVE. Are you sure?"}
GATE
  exit 0
fi

exit 0
