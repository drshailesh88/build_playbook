#!/bin/bash
# Build Playbook — per-project init
# Merges the compiled rules block into <project>/AGENTS.md, which Codex,
# Cursor, OpenCode, and Grok all auto-load from the project root. Existing
# AGENTS.md content outside the markers is preserved; reruns are idempotent.
#
# Usage: init-project.sh [project-dir]   (default: current directory)

source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

PROJECT_DIR="${1:-$(pwd)}"
[ -d "$PROJECT_DIR" ] || { echo "Not a directory: $PROJECT_DIR" >&2; exit 1; }

echo "Initializing Build Playbook in $PROJECT_DIR"

compile_agents_md "$BUILD_DIR/agents-block.md"
merge_marked_block "$PROJECT_DIR/AGENTS.md" "$BUILD_DIR/agents-block.md"
say "rules → $PROJECT_DIR/AGENTS.md (read by Codex, Cursor, OpenCode, Grok)"

mkdir -p "$PROJECT_DIR/.planning"
say ".planning/ ready (durable state lives here, vendor-neutral)"

echo ""
echo "Project initialized. Any installed agent CLI opened in this directory"
echo "now loads the playbook rules. Start with the playbook-where-am-i skill."
