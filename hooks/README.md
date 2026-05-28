# Build Playbook Hooks

Automatic runtime behaviors that fire at precise moments in the Claude Code lifecycle. No human has to remember to run them.

## Hook Inventory

### PreToolUse (fires before tool execution)

| Hook | Trigger | What it Does |
|------|---------|-------------|
| **GateGuard** | Edit/Write | Blocks first edit to a file until you've investigated callers and interface. +2.25 quality improvement. |
| **Config Protection** | Edit | Blocks weakening of tsconfig, eslint, prettier configs. Fix the code, not the config. |
| **Careful Check** | Bash | Warns before destructive commands (rm -rf, DROP TABLE, force push, hard reset). |

### PostToolUse (fires after tool execution)

| Hook | Trigger | What it Does |
|------|---------|-------------|
| **Quality Gate** | Edit/Write | Runs format check + typecheck on the edited file. Catches errors immediately. |

### Stop (fires when Claude finishes responding)

| Hook | Trigger | What it Does |
|------|---------|-------------|
| **Session End** | Always | Saves git state, modified files, and branch to `~/.buildplaybook/projects/`. |

## Installation

Hooks are installed automatically by `install.sh`. They go to:
- Scripts: `~/.buildplaybook/hooks/`
- Configuration: merged into `~/.claude/settings.json` (or project `.claude/settings.json`)

## Disabling Hooks

To disable a specific hook, remove its entry from `.claude/settings.json` under the `hooks` key.

To temporarily disable GateGuard for a session, the agent can set:
```bash
export BUILDPLAYBOOK_GATEGUARD=off
```

## Adding Custom Hooks

1. Create a script in `hooks/scripts/`
2. Add the hook definition to `hooks/hooks.json`
3. Run `./install.sh` to deploy

Hook scripts receive tool input as JSON on stdin and should:
- Exit 0 for no action (allow the tool to proceed)
- Print `{"permissionDecision":"deny","message":"..."}` to block
- Print `{"permissionDecision":"ask","message":"..."}` to warn
