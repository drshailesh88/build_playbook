# Doctor

Check the Build Playbook's own operational integrity. Use this after install, after editing hooks, or when documented playbook behavior does not appear to run.

No arguments needed.

## Process

Run these checks from the Build Playbook repository root and print the report in the exact format below.

### 1. Hook Scripts Deployed

Compare every `hooks/scripts/*.sh` source file with a matching copy in `~/.buildplaybook/hooks/`.

- Pass if every script exists at the deployed path.
- Warn if any deployed script exists but differs from source.
- Fail if any source script is missing from the deployed path.

### 2. hooks.json Deployed

Check that `~/.buildplaybook/hooks.json` exists and matches `hooks/hooks.json`.

- Pass if it exists and matches source.
- Warn if it exists but differs from source.
- Fail if it does not exist.

### 3. Session Start Wired

Check the active hook config for a `UserPromptSubmit` hook entry that runs `session-start.sh`.

- Pass if `UserPromptSubmit` exists and references `session-start.sh`.
- Fail if it is missing.

### 4. Required CLIs

Check that `git`, `gh`, `node`, and `npm` are available on `PATH`.

- Pass if all are available.
- Fail if any are missing.

### 5. Learnings Directory

Check that `~/.buildplaybook/projects/` exists.

- Pass if it exists.
- Fail if it is missing.

### 6. Script Staleness

For each deployed script, compare it to source.

- Pass if all deployed scripts match source.
- Warn for each stale script and suggest re-running `install.sh`.

### 7. MCP Count

If `.mcp.json` exists in the project root, count configured MCPs.

- Pass if the count is 10 or fewer.
- Warn if the count is greater than 10.
- Skip if `.mcp.json` does not exist.

### 8. Tool Count

Estimate total tools across configured MCPs in `.mcp.json`.

- Pass if the estimate is 80 or fewer.
- Warn if the estimate is greater than 80.
- Skip if `.mcp.json` does not exist or the estimate cannot be made.

## Output Format

```
PLAYBOOK DOCTOR
━━━━━━━━━━━━━━
[PASS] Hook scripts deployed (6/6)
[PASS] hooks.json matches source
[FAIL] session-start not wired — add UserPromptSubmit hook
[PASS] Required CLIs available (git, gh, node, npm)
[PASS] Learnings directory exists
[WARN] session-end.sh is stale — re-run install.sh

Summary: 5 PASS, 1 WARN, 1 FAIL
```

## Rules

- Do not modify files.
- Keep checks read-only.
- Use `[PASS]`, `[WARN]`, `[FAIL]`, or `[SKIP]` prefixes.
- Include one summary line with PASS, WARN, and FAIL counts.
- When a deployed file is stale, recommend `./install.sh`.
