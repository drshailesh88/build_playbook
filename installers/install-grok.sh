#!/bin/bash
# Build Playbook — Grok Build installer
# Installs rules (AGENTS.md), skills, hooks (via payload shim), and
# subagents for xAI's Grok CLI.
#
# Verified against the local Grok user guide (~/.grok/docs/user-guide/):
#   rules:  ~/.grok/AGENTS.md (global) + AGENTS.md walked from repo root
#   skills: ~/.grok/skills/ (Grok does NOT read ~/.agents/skills)
#   hooks:  ~/.grok/hooks/*.json, camelCase payload → shim normalizes
#   agents: ~/.grok/agents/*.md (Claude markdown format)

source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

GROK_DIR="$HOME/.grok"
echo "Installing Build Playbook → Grok"

# ── Rules → ~/.grok/AGENTS.md (marker-merged)
compile_agents_md "$BUILD_DIR/agents-block.md"
merge_marked_block "$GROK_DIR/AGENTS.md" "$BUILD_DIR/agents-block.md"
say "rules → ~/.grok/AGENTS.md"

# ── Skills → ~/.grok/skills/ (own copy; Grok skips ~/.agents/skills)
install_shared_skills
mkdir -p "$GROK_DIR/skills"
for d in "$BUILD_DIR/skills/"*/ "$REPO_DIR/skills/"*/; do
  [ -d "$d" ] || continue
  name="$(basename "$d")"
  rm -rf "$GROK_DIR/skills/$name"
  cp -r "$d" "$GROK_DIR/skills/$name"
done
say "skills → ~/.grok/skills/ (invoke as /<skill-name>)"

# ── Hook scripts + shim + hooks JSON
install_hook_scripts
mkdir -p "$BP_DIR/hooks/shims" "$GROK_DIR/hooks"
cp "$REPO_DIR/hooks/shims/grok-shim.sh" "$BP_DIR/hooks/shims/grok-shim.sh"
chmod +x "$BP_DIR/hooks/shims/grok-shim.sh"
cp "$REPO_DIR/hooks/shims/grok-hooks.json" "$GROK_DIR/hooks/buildplaybook.json"
say "hooks → ~/.grok/hooks/buildplaybook.json (10 hooks via payload shim)"

# ── Subagents → ~/.grok/agents/*.md (Claude markdown format works directly)
mkdir -p "$GROK_DIR/agents"
cp "$REPO_DIR/agents/"*.md "$GROK_DIR/agents/"
say "$(ls "$REPO_DIR/agents/"*.md | wc -l | tr -d ' ') subagents → ~/.grok/agents/"

# ── Headless adapter + docs
install_headless_adapter
install_docs

echo ""
echo "Grok install complete. Headless: grok -p \"<prompt>\" --allow 'Bash(git *)' ..."
echo ""
echo "NOTES:"
echo "  - Grok also scans ~/.claude/settings.json and ~/.claude/skills for"
echo "    compatibility. If you have the Claude install too, hooks may fire"
echo "    twice (harmless — they self-dedup). To silence the compat copies:"
echo "    add [compat.claude] hooks = false to ~/.grok/config.toml"
echo "  - Grok hooks FAIL-OPEN: a crashed hook never blocks. The shim emits"
echo "    explicit deny JSON, which is the only thing Grok enforces."
