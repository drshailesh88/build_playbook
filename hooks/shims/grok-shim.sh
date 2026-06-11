#!/bin/bash
# Build Playbook — Grok hook shim
# Normalizes Grok's camelCase hook payload (toolName/toolInput, internal tool
# names like run_terminal_cmd) into the Claude hook protocol the canonical
# scripts in ~/.buildplaybook/hooks speak, then maps the decision back to
# Grok's {"decision","reason"} format. Grok hooks fail-open, so blocking
# requires the explicit deny JSON this shim emits.
#
# Usage: grok-shim.sh <canonical-script-name>

SCRIPT="$HOME/.buildplaybook/hooks/$1"
INPUT=$(cat)

[ -x "$SCRIPT" ] || exit 0

NORMALIZED=$(python3 -c '
import json, sys
try:
    p = json.loads(sys.stdin.read() or "{}")
except Exception:
    p = {}

name = p.get("tool_name") or p.get("toolName") or ""
mapping = {
    "run_terminal_cmd": "Bash",
    "search_replace": "Edit",
    "read_file": "Read",
    "create_file": "Write",
    "write_file": "Write",
    "write": "Write",
    "edit": "Edit",
    "bash": "Bash",
}
name = mapping.get(name, name)
tool_input = p.get("tool_input") or p.get("toolInput") or {}
print(json.dumps({"tool_name": name, "tool_input": tool_input}))
' <<< "$INPUT")

OUT=$(echo "$NORMALIZED" | bash "$SCRIPT")
RC=$?

python3 -c '
import json, sys
rc = int(sys.argv[1])
raw = sys.stdin.read().strip()
decision, message = None, ""
if raw.startswith("{"):
    try:
        o = json.loads(raw)
        decision = o.get("permissionDecision")
        message = o.get("message", "")
    except Exception:
        pass
if rc == 2 or decision == "deny":
    print(json.dumps({"decision": "deny", "reason": message or "Blocked by Build Playbook hook"}))
    sys.exit(2)
if decision == "ask":
    print(json.dumps({"decision": "deny",
                      "reason": message + " — Grok cannot prompt for approval from a hook. Confirm with the user, then retry this exact call."}))
    sys.exit(2)
sys.exit(0)
' "$RC" <<< "$OUT"
exit $?
