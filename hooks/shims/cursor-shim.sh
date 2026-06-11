#!/bin/bash
# Build Playbook — Cursor hook shim
# Translates Cursor's hook payloads to the Claude hook protocol the canonical
# scripts in ~/.buildplaybook/hooks speak, runs the script, and translates the
# response back. Exit code 2 (block) passes through unchanged.
#
# Usage: cursor-shim.sh <kind> <canonical-script-name>
#   kind: pretool | postedit | posttool | session-start | session-end

KIND="$1"
SCRIPT="$HOME/.buildplaybook/hooks/$2"
INPUT=$(cat)

[ -x "$SCRIPT" ] || exit 0

translate_in() {
  python3 -c '
import json, sys
kind = sys.argv[1]
try:
    p = json.loads(sys.stdin.read() or "{}")
except Exception:
    p = {}
if kind == "pretool":
    name = p.get("tool_name", "")
    if name == "Shell":
        name = "Bash"
    print(json.dumps({"tool_name": name, "tool_input": p.get("tool_input", {})}))
elif kind == "postedit":
    print(json.dumps({"tool_name": "Edit", "tool_input": {"file_path": p.get("file_path", "")}}))
elif kind == "posttool":
    print(json.dumps({"tool_name": "Bash",
                      "tool_input": {"command": p.get("command", "")},
                      "tool_response": p.get("output", "")}))
else:
    print(json.dumps(p))
' "$1" <<< "$INPUT"
}

translate_out() {
  python3 -c '
import json, sys
raw = sys.stdin.read().strip()
if not raw:
    sys.exit(0)
try:
    o = json.loads(raw)
except Exception:
    sys.exit(0)
decision = o.get("permissionDecision")
if decision:
    msg = o.get("message", "")
    print(json.dumps({"permission": decision,
                      "user_message": msg,
                      "agent_message": msg}))
else:
    print(raw)
'
}

case "$KIND" in
  session-start)
    # Canonical script emits context on stderr; Cursor wants additional_context JSON.
    CTX=$(echo "$INPUT" | bash "$SCRIPT" 2>&1 >/dev/null)
    if [ -n "$CTX" ]; then
      python3 -c 'import json,sys; print(json.dumps({"additional_context": sys.stdin.read()}))' <<< "$CTX"
    fi
    exit 0
    ;;
  session-end)
    echo "$INPUT" | bash "$SCRIPT" >/dev/null 2>&1 || true
    exit 0
    ;;
  pretool|postedit|posttool)
    OUT=$(translate_in "$KIND" | bash "$SCRIPT")
    RC=$?
    [ -n "$OUT" ] && echo "$OUT" | translate_out
    exit $RC
    ;;
  *)
    exit 0
    ;;
esac
