#!/bin/bash
# Build Playbook — Cursor CLI installer
# Installs skills, hooks (via payload shim), and subagents for Cursor.
# Rules: Cursor has no documented on-disk global rules location — run
# installers/init-project.sh inside each project to merge rules into the
# project-root AGENTS.md (which Cursor reads), or paste rules into
# Cursor Settings → Rules once.

source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

CURSOR_DIR="$HOME/.cursor"
echo "Installing Build Playbook → Cursor"

# ── Skills (Cursor reads ~/.agents/skills and ~/.cursor/skills)
install_shared_skills

# ── Hook scripts + shim + hooks.json
install_hook_scripts
mkdir -p "$CURSOR_DIR/hooks"
cp "$REPO_DIR/hooks/shims/cursor-shim.sh" "$CURSOR_DIR/hooks/cursor-shim.sh"
chmod +x "$CURSOR_DIR/hooks/cursor-shim.sh"

HOOKS_FILE="$CURSOR_DIR/hooks.json"
if [ -f "$HOOKS_FILE" ] && ! grep -q "cursor-shim" "$HOOKS_FILE"; then
  cp "$HOOKS_FILE" "$HOOKS_FILE.bak"
  say "WARNING: existing ~/.cursor/hooks.json backed up to hooks.json.bak"
fi
cp "$REPO_DIR/hooks/shims/cursor-hooks.json" "$HOOKS_FILE"
say "hooks.json + shim → ~/.cursor/ (10 hooks wired via payload translation)"

# ── Subagents (Cursor reads Claude-format markdown agents natively)
mkdir -p "$CURSOR_DIR/agents"
cp "$REPO_DIR/agents/"*.md "$CURSOR_DIR/agents/"
say "$(ls "$REPO_DIR/agents/"*.md | wc -l | tr -d ' ') subagents → ~/.cursor/agents/"

# ── Headless adapter + docs
install_headless_adapter
install_docs

echo ""
echo "Cursor install complete."
echo "  Rules are PER-PROJECT for Cursor: run installers/init-project.sh in each"
echo "  project root (writes/merges AGENTS.md — also read by Codex/OpenCode/Grok)."
echo "  Headless: cursor-agent -p --force \"<prompt>\""
