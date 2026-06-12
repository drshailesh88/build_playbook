#!/bin/bash
# Build Playbook — Global Install Script
# Installs commands, skills, rules, agents, hooks, and references into ~/.claude/ and ~/.buildplaybook/

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
BP_DIR="$HOME/.buildplaybook"

echo "Installing Build Playbook..."
echo ""

# ─────────────────────────────────────
# Phase 1: Commands
# ─────────────────────────────────────
mkdir -p "$CLAUDE_DIR/commands/playbook"
# Remove stale symlinks before copying
find "$CLAUDE_DIR/commands/playbook" -maxdepth 1 -type l -delete 2>/dev/null || true
rsync -a --delete "$SCRIPT_DIR/commands/" "$CLAUDE_DIR/commands/playbook/"
CMD_COUNT=$(ls "$SCRIPT_DIR/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')
echo "  $CMD_COUNT commands → ~/.claude/commands/playbook/"

# ─────────────────────────────────────
# Phase 2: Custom Skills
# ─────────────────────────────────────
for skill in feature-census db-architect infra-architect verification-before-completion gateguard continuous-learning; do
  if [ -d "$SCRIPT_DIR/skills/$skill" ]; then
    mkdir -p "$CLAUDE_DIR/skills/$skill"
    cp -r "$SCRIPT_DIR/skills/$skill/"* "$CLAUDE_DIR/skills/$skill/"
  fi
done
cp "$SCRIPT_DIR/skills/founders-design-rules.md" "$CLAUDE_DIR/skills/" 2>/dev/null || true
echo "  7 custom skills → ~/.claude/skills/"

# ─────────────────────────────────────
# Phase 3: Matt Pocock Skills
# ─────────────────────────────────────
if [ -d "$SCRIPT_DIR/vendor/mattpocock-skills" ]; then
  for skill in "$SCRIPT_DIR/vendor/mattpocock-skills/"*/; do
    skill_name=$(basename "$skill")
    mkdir -p "$CLAUDE_DIR/skills/$skill_name"
    cp -r "$skill"* "$CLAUDE_DIR/skills/$skill_name/"
  done
  echo "  10 Matt Pocock skills → ~/.claude/skills/"
fi

# ─────────────────────────────────────
# Phase 4: Rules (always-loaded guidelines)
# ─────────────────────────────────────
mkdir -p "$CLAUDE_DIR/rules"
cp "$SCRIPT_DIR/rules/"*.md "$CLAUDE_DIR/rules/"
RULE_COUNT=$(ls "$SCRIPT_DIR/rules/"*.md 2>/dev/null | wc -l | tr -d ' ')
echo "  $RULE_COUNT rules → ~/.claude/rules/"

# ─────────────────────────────────────
# Phase 5: Agents (subagent delegation)
# ─────────────────────────────────────
mkdir -p "$CLAUDE_DIR/agents"
cp "$SCRIPT_DIR/agents/"*.md "$CLAUDE_DIR/agents/"
AGENT_COUNT=$(ls "$SCRIPT_DIR/agents/"*.md 2>/dev/null | wc -l | tr -d ' ')
echo "  $AGENT_COUNT agents → ~/.claude/agents/"

# ─────────────────────────────────────
# Phase 6: Hooks (automatic runtime behaviors)
# ─────────────────────────────────────
mkdir -p "$BP_DIR/hooks"
cp "$SCRIPT_DIR/hooks/scripts/"*.sh "$BP_DIR/hooks/"
chmod +x "$BP_DIR/hooks/"*.sh
HOOK_COUNT=$(ls "$SCRIPT_DIR/hooks/scripts/"*.sh 2>/dev/null | wc -l | tr -d ' ')
echo "  $HOOK_COUNT hooks → ~/.buildplaybook/hooks/"

# Install hook configuration into Claude settings
# Note: hooks.json is a reference. Users should merge into their .claude/settings.json
cp "$SCRIPT_DIR/hooks/hooks.json" "$BP_DIR/hooks.json"
echo "  hooks.json → ~/.buildplaybook/hooks.json"
echo "  NOTE: Merge hooks.json into your project's .claude/settings.json to activate hooks"

# ─────────────────────────────────────
# Phase 7: Ethos + Reference Docs
# ─────────────────────────────────────
cp "$SCRIPT_DIR/ETHOS.md" "$CLAUDE_DIR/"
cp "$SCRIPT_DIR/THE-PLAYBOOK.md" "$CLAUDE_DIR/"
cp "$SCRIPT_DIR/WORKFLOW-REFERENCE.md" "$CLAUDE_DIR/"
cp "$SCRIPT_DIR/MASTER-REPO-GUIDE.md" "$CLAUDE_DIR/"
echo "  4 reference guides → ~/.claude/"

# ─────────────────────────────────────
# Phase 8: Initialize learnings directory
# ─────────────────────────────────────
mkdir -p "$BP_DIR/projects"
echo "  learnings store → ~/.buildplaybook/projects/"

# ─────────────────────────────────────
# Phase 9: Persistent Memory Layer
# ─────────────────────────────────────
echo ""
echo "Installing Supermemory MCP (persistent memory)..."
if command -v npx &>/dev/null; then
  npx -y install-mcp@latest https://mcp.supermemory.ai/mcp --client claude --oauth=yes 2>/dev/null || {
    echo "  Supermemory MCP install failed. Memory will use local-only mode."
    echo "  Run manually: npx -y install-mcp@latest https://mcp.supermemory.ai/mcp --client claude --oauth=yes"
  }
  echo "  Supermemory MCP → persistent cross-session memory"
else
  echo "  npx not found. Skipping Supermemory MCP."
fi

echo ""
echo "─────────────────────────────────────"
echo "Build Playbook installed."
echo ""
echo "  Commands:  $CMD_COUNT  (invoke with /playbook:command-name)"
echo "  Skills:    17  (auto-triggered by description match)"
echo "  Rules:     $RULE_COUNT   (always loaded, steer every session)"
echo "  Agents:    $AGENT_COUNT   (delegate with subagent_type)"
echo "  Hooks:     $HOOK_COUNT   (automatic, fire on tool lifecycle)"
echo ""
echo "To activate hooks, merge ~/.buildplaybook/hooks.json"
echo "into your project's .claude/settings.json"
echo ""
echo "Start with: /playbook:where-am-i"
echo "─────────────────────────────────────"

# ─────────────────────────────────────
# Phase 10: Universal headless adapter (vendor-neutral Ralph driver)
# ─────────────────────────────────────
mkdir -p "$BP_DIR/bin"
cp "$SCRIPT_DIR/adapters/headless/run-agent.sh" "$BP_DIR/bin/run-agent.sh"
chmod +x "$BP_DIR/bin/run-agent.sh"
echo "  headless adapter → ~/.buildplaybook/bin/run-agent.sh"

# ─────────────────────────────────────
# Phase 11: Autoresearch assets (/improve, /lazy-dev need these in target projects)
# ─────────────────────────────────────
mkdir -p "$BP_DIR/goal-md"
cp -r "$SCRIPT_DIR/vendor/goal-md/template" "$SCRIPT_DIR/vendor/goal-md/examples" "$BP_DIR/goal-md/"
cp "$SCRIPT_DIR/scripts/score.sh" "$BP_DIR/goal-md/score.sh"
chmod +x "$BP_DIR/goal-md/score.sh"
echo "  goal-md templates + reference scorer → ~/.buildplaybook/goal-md/"
