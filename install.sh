#!/bin/bash
# Build Playbook — multi-vendor install dispatcher
# The methodology is vendor-neutral; this installs it into each agent CLI.
#
# Usage:
#   ./install.sh                       # Claude Code only (original behavior)
#   ./install.sh --target codex        # one vendor
#   ./install.sh --target all          # every vendor with a CLI installed
#   ./install.sh --target codex,grok   # comma-separated list
#
# Per-project setup (rules for Codex/Cursor/OpenCode/Grok via AGENTS.md):
#   ./installers/init-project.sh /path/to/project

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALLERS="$SCRIPT_DIR/installers"

TARGETS="claude"
if [ "$1" = "--target" ] && [ -n "$2" ]; then
  TARGETS="$2"
elif [ -n "$1" ]; then
  echo "Unknown argument: $1" >&2
  echo "Usage: ./install.sh [--target claude|codex|cursor|opencode|grok|all]" >&2
  exit 1
fi

cli_for() {
  case "$1" in
    claude) echo "claude" ;;
    codex) echo "codex" ;;
    cursor) echo "cursor-agent" ;;
    opencode) echo "opencode" ;;
    grok) echo "grok" ;;
  esac
}

if [ "$TARGETS" = "all" ]; then
  TARGETS=""
  for v in claude codex cursor opencode grok; do
    if command -v "$(cli_for "$v")" >/dev/null 2>&1; then
      TARGETS="$TARGETS $v"
    else
      echo "Skipping $v — $(cli_for "$v") not found on PATH"
    fi
  done
fi

FAILED=""
for vendor in $(echo "$TARGETS" | tr ',' ' '); do
  installer="$INSTALLERS/install-$vendor.sh"
  if [ ! -f "$installer" ]; then
    echo "No installer for '$vendor' (expected $installer)" >&2
    FAILED="$FAILED $vendor"
    continue
  fi
  echo ""
  echo "═══ $vendor ═══"
  if ! bash "$installer"; then
    echo "FAILED: $vendor installer exited non-zero" >&2
    FAILED="$FAILED $vendor"
  fi
done

echo ""
echo "─────────────────────────────────────"
if [ -n "$FAILED" ]; then
  echo "Done with failures:$FAILED"
  exit 1
fi
echo "Done. Per-project rules for non-Claude vendors:"
echo "  ./installers/init-project.sh /path/to/project   (merges AGENTS.md)"
echo "Capability matrix and degradation notes: PORTABILITY.md"
echo "─────────────────────────────────────"
