#!/bin/bash
# GateGuard Fact-Forcing Gate (PreToolUse → Edit/Write)
#
# Before Claude edits any file for the first time in a session, it must first:
# 1. Grep for every file that imports/requires this file
# 2. List the public interface being changed
# 3. Quote the user's instruction verbatim
#
# This single hook improved code quality by +2.25 points in A/B testing (ECC).
# Adapted from ECC's GateGuard system.

# Read tool input from stdin
INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Only gate Edit and Write operations
if [ "$TOOL_NAME" != "Edit" ] && [ "$TOOL_NAME" != "Write" ]; then
  exit 0
fi

# Extract file path from tool input
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Track which files have been investigated this session
STATE_DIR="${HOME}/.gstack/gateguard"
mkdir -p "$STATE_DIR"
SESSION_FILE="${STATE_DIR}/session-$(date +%Y%m%d).txt"

# Check if this file was already investigated
if grep -qF "$FILE_PATH" "$SESSION_FILE" 2>/dev/null; then
  exit 0
fi

# File not yet investigated — require investigation first
echo "GATEGUARD: First edit to $(basename "$FILE_PATH") this session." >&2
echo "Before editing, you must:" >&2
echo "  1. grep for files that import/require this file" >&2
echo "  2. Read the file to understand its current public interface" >&2
echo "  3. State which function/export you're changing and why" >&2
echo "" >&2
echo "After investigating, retry the edit." >&2

# Mark as investigated for next attempt (the investigation happens in between)
echo "$FILE_PATH" >> "$SESSION_FILE"

# Return deny decision
cat <<'GATE'
{"permissionDecision":"deny","message":"GateGuard: Investigate this file's callers and interface before editing. Read the file, grep for imports, then retry."}
GATE
