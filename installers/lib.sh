#!/bin/bash
# Build Playbook — shared installer helpers
# Sourced by installers/install-<vendor>.sh. Not executable on its own.

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BP_DIR="$HOME/.buildplaybook"
BUILD_DIR="$REPO_DIR/build"

BP_MARKER_BEGIN="<!-- BEGIN BUILD-PLAYBOOK (auto-generated — do not edit between markers; reinstall overwrites) -->"
BP_MARKER_END="<!-- END BUILD-PLAYBOOK -->"

say() { echo "  $*"; }

# ─────────────────────────────────────
# compile_agents_md <output-file>
# Concatenates rules/*.md into one vendor-neutral AGENTS.md block with a
# preamble that maps Claude-specific vocabulary to vendor equivalents.
# ─────────────────────────────────────
compile_agents_md() {
  local out="$1"
  mkdir -p "$(dirname "$out")"

  cat > "$out" <<'PREAMBLE'
# Build Playbook — Operating Rules

These rules are the always-on methodology layer of the Build Playbook
(https://github.com/shaileshsingh — master repo: "Build Playbook"). They are
vendor-neutral: the same rules drive Claude Code, Codex, Cursor, OpenCode,
and Grok. Durable state lives on disk (.planning/, .quality/, .gsd/, git),
never in any one vendor's session.

Vendor mapping notes:
- Model tiers named "Haiku / Sonnet / Opus" mean: fast-cheap tier / balanced
  tier / deep-reasoning tier. Use your runtime's equivalents.
- "Skills" and "slash commands" refer to Agent Skills (SKILL.md folders in
  ~/.agents/skills or your runtime's skills directory). Invoke the
  playbook-* skills by name for every methodology phase.
- Memory rules that reference the Supermemory MCP apply only when that MCP
  server is connected in this runtime. Fallback: append learnings to
  ~/.buildplaybook/projects/<project-slug>/learnings.jsonl.
- The phase guide is at ~/.buildplaybook/docs/THE-PLAYBOOK.md. If you do not
  know where you are in a project, read it and the project's .planning/
  directory before acting.

PREAMBLE

  local f name
  for f in "$REPO_DIR/rules/"*.md; do
    name="$(basename "$f" .md)"
    {
      echo "---"
      echo ""
      echo "<!-- rule: $name -->"
      echo ""
      cat "$f"
      echo ""
    } >> "$out"
  done
}

# ─────────────────────────────────────
# merge_marked_block <target-file> <content-file>
# Idempotently installs content into target between BP markers.
# Preserves everything the user already has outside the markers.
# ─────────────────────────────────────
merge_marked_block() {
  local target="$1" content="$2"
  mkdir -p "$(dirname "$target")"
  touch "$target"

  local tmp
  tmp="$(mktemp)"

  if grep -qF "$BP_MARKER_BEGIN" "$target"; then
    awk -v begin="$BP_MARKER_BEGIN" -v end="$BP_MARKER_END" '
      $0 == begin { skip = 1; next }
      $0 == end   { skip = 0; next }
      !skip { print }
    ' "$target" > "$tmp"
  else
    cat "$target" > "$tmp"
  fi

  {
    cat "$tmp"
    [ -s "$tmp" ] && echo ""
    echo "$BP_MARKER_BEGIN"
    cat "$content"
    echo "$BP_MARKER_END"
  } > "$target"

  rm -f "$tmp"
}

# ─────────────────────────────────────
# build_skills_from_commands <output-dir>
# Wraps each commands/*.md into <output-dir>/playbook-<name>/SKILL.md with
# Agent Skills frontmatter. Title and first prose paragraph become the
# description. Body is kept verbatim below the frontmatter.
# ─────────────────────────────────────
build_skills_from_commands() {
  local outdir="$1"
  mkdir -p "$outdir"

  local f name title desc skill_dir
  for f in "$REPO_DIR/commands/"*.md; do
    name="$(basename "$f" .md)"
    skill_dir="$outdir/playbook-$name"
    mkdir -p "$skill_dir"

    title="$(grep -m1 '^# ' "$f" | sed 's/^# //')"
    [ -z "$title" ] && title="$name"

    # First non-empty, non-heading line = description seed
    desc="$(awk '/^#/ {next} /^[[:space:]]*$/ {next} {print; exit}' "$f" \
      | sed 's/\*\*//g; s/"/'"'"'/g' | cut -c1-400)"
    [ -z "$desc" ] && desc="$title"

    {
      echo "---"
      echo "name: playbook-$name"
      echo "description: \"$desc Part of the Build Playbook methodology. Invoke for the '$name' phase step. Arguments (if any) follow the skill name; treat them as \$ARGUMENTS in the instructions below.\""
      echo "---"
      echo ""
      cat "$f"
    } > "$skill_dir/SKILL.md"
  done
}

# ─────────────────────────────────────
# install_shared_skills
# Publishes playbook skills + repo skill folders into ~/.agents/skills/,
# the cross-vendor location read by Codex, Cursor, OpenCode, and Grok.
# ─────────────────────────────────────
install_shared_skills() {
  local agents_skills="$HOME/.agents/skills"
  mkdir -p "$agents_skills"

  build_skills_from_commands "$BUILD_DIR/skills"

  local d name
  for d in "$BUILD_DIR/skills/"*/; do
    name="$(basename "$d")"
    rm -rf "$agents_skills/$name"
    cp -r "$d" "$agents_skills/$name"
  done

  for d in "$REPO_DIR/skills/"*/; do
    name="$(basename "$d")"
    rm -rf "$agents_skills/$name"
    cp -r "$d" "$agents_skills/$name"
  done

  local cmd_count skill_count
  cmd_count="$(ls "$REPO_DIR/commands/"*.md | wc -l | tr -d ' ')"
  skill_count="$(ls -d "$REPO_DIR/skills/"*/ | wc -l | tr -d ' ')"
  say "$cmd_count command-skills + $skill_count skills → ~/.agents/skills/"
}

# ─────────────────────────────────────
# install_hook_scripts
# Canonical hook scripts live in ~/.buildplaybook/hooks (vendor-neutral,
# Claude hooks stdin/stdout protocol).
# ─────────────────────────────────────
install_hook_scripts() {
  mkdir -p "$BP_DIR/hooks"
  cp "$REPO_DIR/hooks/scripts/"*.sh "$BP_DIR/hooks/"
  chmod +x "$BP_DIR/hooks/"*.sh
  say "$(ls "$REPO_DIR/hooks/scripts/"*.sh | wc -l | tr -d ' ') hook scripts → ~/.buildplaybook/hooks/"
}

# ─────────────────────────────────────
# install_headless_adapter
# Universal non-interactive agent driver for Ralph loops and scripts.
# ─────────────────────────────────────
install_headless_adapter() {
  mkdir -p "$BP_DIR/bin"
  cp "$REPO_DIR/adapters/headless/run-agent.sh" "$BP_DIR/bin/run-agent.sh"
  chmod +x "$BP_DIR/bin/run-agent.sh"
  say "headless adapter → ~/.buildplaybook/bin/run-agent.sh"
}

# ─────────────────────────────────────
# install_docs
# Vendor-neutral home for the methodology guides.
# ─────────────────────────────────────
install_docs() {
  mkdir -p "$BP_DIR/docs"
  cp "$REPO_DIR/THE-PLAYBOOK.md" "$REPO_DIR/ETHOS.md" \
     "$REPO_DIR/WORKFLOW-REFERENCE.md" "$REPO_DIR/MASTER-REPO-GUIDE.md" \
     "$BP_DIR/docs/"
  [ -f "$REPO_DIR/PORTABILITY.md" ] && cp "$REPO_DIR/PORTABILITY.md" "$BP_DIR/docs/"
  say "methodology guides → ~/.buildplaybook/docs/"
}
