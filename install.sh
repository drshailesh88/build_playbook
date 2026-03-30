#!/bin/bash
# Build Playbook — Global Install Script
# Copies all commands, skills, and references into ~/.claude/

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Installing Build Playbook to $CLAUDE_DIR..."

# Commands
mkdir -p "$CLAUDE_DIR/commands/playbook"
cp "$SCRIPT_DIR/commands/"*.md "$CLAUDE_DIR/commands/playbook/"
echo "  16 commands → ~/.claude/commands/playbook/"

# Custom skills
for skill in feature-census db-architect infra-architect verification-before-completion; do
  mkdir -p "$CLAUDE_DIR/skills/$skill"
  cp -r "$SCRIPT_DIR/skills/$skill/"* "$CLAUDE_DIR/skills/$skill/"
done
cp "$SCRIPT_DIR/skills/founders-design-rules.md" "$CLAUDE_DIR/skills/"
echo "  5 custom skills → ~/.claude/skills/"

# Matt Pocock skills
if [ -d "$SCRIPT_DIR/vendor/mattpocock-skills" ]; then
  for skill in "$SCRIPT_DIR/vendor/mattpocock-skills/"*/; do
    skill_name=$(basename "$skill")
    mkdir -p "$CLAUDE_DIR/skills/$skill_name"
    cp -r "$skill"* "$CLAUDE_DIR/skills/$skill_name/"
  done
  echo "  10 Matt Pocock skills → ~/.claude/skills/"
fi

# Reference docs
cp "$SCRIPT_DIR/THE-PLAYBOOK.md" "$CLAUDE_DIR/"
cp "$SCRIPT_DIR/WORKFLOW-REFERENCE.md" "$CLAUDE_DIR/"
cp "$SCRIPT_DIR/MASTER-REPO-GUIDE.md" "$CLAUDE_DIR/"
echo "  3 reference guides → ~/.claude/"

echo ""
echo "Done. Go to any project directory and type /playbook:where-am-i"
