#!/bin/bash
# Build Playbook — universal headless agent adapter
# One interface for driving any agent CLI non-interactively, so Ralph loops
# and overnight scripts are vendor-independent.
#
# Usage: run-agent.sh [-v vendor] [-m model] "<prompt>"
#   vendor: claude | codex | cursor | opencode | grok   (default: $BP_AGENT or claude)
#   model:  vendor-specific model id; Claude-style ids are dropped with a
#           warning when targeting a different vendor (their CLI default wins)
#
# Prompt portability: Claude's @file references are rewritten for other
# vendors into an explicit "read these files first" instruction.
#
# Env:
#   BP_AGENT          default vendor
#   BP_CODEX_UNSAFE=1 use --dangerously-bypass-approvals-and-sandbox
#                     instead of --full-auto (needed if the loop must
#                     reach the network, e.g. npm install)

set -e

VENDOR="${BP_AGENT:-claude}"
MODEL=""

while getopts "v:m:" opt; do
  case "$opt" in
    v) VENDOR="$OPTARG" ;;
    m) MODEL="$OPTARG" ;;
    *) exit 1 ;;
  esac
done
shift $((OPTIND - 1))

PROMPT="$1"
[ -n "$PROMPT" ] || { echo "run-agent.sh: no prompt given" >&2; exit 1; }

# Claude model ids mean nothing to other vendors — drop, let CLI default win.
if [ "$VENDOR" != "claude" ] && [[ "$MODEL" == claude-* ]]; then
  echo "run-agent.sh: dropping Claude model '$MODEL' for vendor '$VENDOR' (using its default)" >&2
  MODEL=""
fi

# Rewrite @file references for vendors without Claude's @-mention expansion.
if [ "$VENDOR" != "claude" ]; then
  PROMPT="$(python3 -c '
import re, sys
prompt = sys.stdin.read()
refs = re.findall(r"(?:^|\s)@([^\s@]+)", prompt)
if refs:
    prompt = re.sub(r"(^|\s)@([^\s@]+)", r"\1\2", prompt)
    header = "Before doing ANYTHING else, read these files completely: " + ", ".join(refs) + "\n\n"
    prompt = header + prompt
sys.stdout.write(prompt)
' <<< "$PROMPT")"
fi

case "$VENDOR" in
  claude)
    ARGS=(claude -p --dangerously-skip-permissions)
    [ -n "$MODEL" ] && ARGS+=(--model "$MODEL")
    ARGS+=("$PROMPT")
    ;;
  codex)
    if [ "${BP_CODEX_UNSAFE:-0}" = "1" ]; then
      ARGS=(codex exec --dangerously-bypass-approvals-and-sandbox)
    else
      ARGS=(codex exec -s workspace-write)
    fi
    ARGS+=(--skip-git-repo-check)
    [ -n "$MODEL" ] && ARGS+=(-m "$MODEL")
    ARGS+=("$PROMPT")
    exec "${ARGS[@]}" < /dev/null
    ;;
  cursor)
    ARGS=(cursor-agent -p --force)
    [ -n "$MODEL" ] && ARGS+=(--model "$MODEL")
    ARGS+=("$PROMPT")
    ;;
  opencode)
    ARGS=(opencode run)
    [ -n "$MODEL" ] && ARGS+=(--model "$MODEL")
    ARGS+=("$PROMPT")
    ;;
  grok)
    ARGS=(grok --always-approve)
    [ -n "$MODEL" ] && ARGS+=(--model "$MODEL")
    ARGS+=(-p "$PROMPT")
    ;;
  *)
    echo "run-agent.sh: unknown vendor '$VENDOR' (claude|codex|cursor|opencode|grok)" >&2
    exit 1
    ;;
esac

exec "${ARGS[@]}"
