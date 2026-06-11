// Build Playbook — OpenCode plugin shim
// Bridges OpenCode's plugin hooks to the canonical Build Playbook hook
// scripts in ~/.buildplaybook/hooks (Claude hook protocol: JSON on stdin,
// exit 2 or permissionDecision:"deny" blocks).
//
// "ask" decisions cannot open an approval dialog from a plugin, so they
// block with a message telling the agent to confirm with the user first.

import { spawnSync } from "node:child_process"
import { homedir } from "node:os"
import { join } from "node:path"

const HOOKS_DIR = join(homedir(), ".buildplaybook", "hooks")

const TOOL_MAP = { bash: "Bash", edit: "Edit", write: "Write" }

const runHook = (script, payload) => {
  const result = spawnSync("bash", [join(HOOKS_DIR, script)], {
    input: JSON.stringify(payload),
    encoding: "utf8",
    timeout: 30_000,
  })
  if (result.error) return { blocked: false, message: "" }

  const stdout = (result.stdout || "").trim()
  let decision = null
  let message = ""
  if (stdout.startsWith("{")) {
    try {
      const out = JSON.parse(stdout)
      decision = out.permissionDecision || null
      message = out.message || ""
    } catch {
      /* non-JSON stdout is advisory only */
    }
  }

  const blocked =
    result.status === 2 || decision === "deny" || decision === "ask"
  return {
    blocked,
    message: message || (result.stderr || "").trim(),
    ask: decision === "ask",
  }
}

const claudePayload = (tool, args) => {
  const toolName = TOOL_MAP[tool]
  if (!toolName) return null
  const toolInput =
    toolName === "Bash"
      ? { command: args?.command ?? "" }
      : { file_path: args?.filePath ?? args?.file_path ?? "" }
  return { tool_name: toolName, tool_input: toolInput }
}

const PRE_HOOKS = {
  Bash: ["careful-check.sh", "tmux-enforce.sh"],
  Edit: ["gateguard-fact-force.sh", "config-protection.sh"],
  Write: ["gateguard-fact-force.sh", "md-blocker.sh"],
}

const POST_HOOKS = {
  Bash: ["pr-url-logger.sh"],
  Edit: ["quality-gate.sh", "console-log-check.sh"],
  Write: ["quality-gate.sh", "console-log-check.sh"],
}

export const BuildPlaybook = async () => {
  return {
    "tool.execute.before": async (input, output) => {
      const payload = claudePayload(input.tool, output.args)
      if (!payload) return
      for (const script of PRE_HOOKS[payload.tool_name] ?? []) {
        const { blocked, message, ask } = runHook(script, payload)
        if (blocked) {
          throw new Error(
            ask
              ? `Build Playbook gate (${script}): ${message} — confirm with the user before retrying this exact call.`
              : `Build Playbook gate (${script}): ${message}`
          )
        }
      }
    },

    "tool.execute.after": async (input, output) => {
      const payload = claudePayload(input.tool, output.args)
      if (!payload) return
      payload.tool_response =
        typeof output.output === "string" ? output.output : ""
      for (const script of POST_HOOKS[payload.tool_name] ?? []) {
        runHook(script, payload)
      }
    },

    event: async ({ event }) => {
      if (event.type === "session.created") {
        runHook("session-start.sh", { hook_event_name: "SessionStart" })
      }
      if (event.type === "session.idle") {
        runHook("session-end.sh", { hook_event_name: "Stop" })
      }
    },
  }
}
