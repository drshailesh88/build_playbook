#!/bin/bash
# Tier 1 quality gate — installed by /playbook:install-qa-harness.
#
# Claude Code PreToolUse hook. Fires before every Bash invocation and
# intercepts `git commit` calls. When a commit is detected, runs
# typecheck (tsc --noEmit) and lint (npm run lint) first. If either
# fails the tool call is blocked — the agent must fix the issue before
# committing.
#
# Exit codes:
#   0  -> allow the Bash call
#   2  -> BLOCK (PreToolUse hooks that exit 2 refuse the tool call in
#         Claude Code)
#
# Bypass: set SKIP_QUALITY_GATE=1 in the environment for emergencies.
#
# Run by Claude Code; not intended to be invoked directly by users.

set -u

TOOL_INPUT="${1:-}"

# Emergency bypass
if [ "${SKIP_QUALITY_GATE:-0}" = "1" ]; then
  exit 0
fi

# Only intercept commands that contain `git commit`
if ! echo "$TOOL_INPUT" | grep -q 'git commit'; then
  exit 0
fi

# --- Tier 1: TypeScript typecheck ---
if [ -f "tsconfig.json" ]; then
  echo "pre-commit-quality-gate: running typecheck (npx tsc --noEmit)..." >&2
  if ! npx tsc --noEmit 2>&1; then
    echo "" >&2
    echo "pre-commit-quality-gate: BLOCKED — typecheck failed." >&2
    echo "Fix type errors before committing." >&2
    exit 2
  fi
  echo "pre-commit-quality-gate: typecheck passed." >&2
fi

# --- Tier 1: Lint ---
echo "pre-commit-quality-gate: running lint (npm run lint --if-present)..." >&2
if ! npm run lint --if-present 2>&1; then
  echo "" >&2
  echo "pre-commit-quality-gate: BLOCKED — lint failed." >&2
  echo "Fix lint errors before committing." >&2
  exit 2
fi
echo "pre-commit-quality-gate: lint passed." >&2

# Both gates passed
exit 0
