#!/bin/bash
# Build Playbook — OpenCode installer
# Installs rules (AGENTS.md), native commands, skills, hooks (JS plugin
# shim), and subagents for OpenCode.

source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

OC_DIR="$HOME/.config/opencode"
echo "Installing Build Playbook → OpenCode"

# ── Rules → ~/.config/opencode/AGENTS.md (marker-merged)
compile_agents_md "$BUILD_DIR/agents-block.md"
merge_marked_block "$OC_DIR/AGENTS.md" "$BUILD_DIR/agents-block.md"
say "rules → ~/.config/opencode/AGENTS.md"

# ── Commands → native OpenCode commands (/playbook-<name>, $ARGUMENTS works as-is)
mkdir -p "$OC_DIR/commands"
CMD_COUNT=0
for f in "$REPO_DIR/commands/"*.md; do
  name="$(basename "$f" .md)"
  desc="$(grep -m1 '^# ' "$f" | sed 's/^# //; s/"/'"'"'/g')"
  {
    echo "---"
    echo "description: \"$desc\""
    echo "---"
    echo ""
    cat "$f"
  } > "$OC_DIR/commands/playbook-$name.md"
  CMD_COUNT=$((CMD_COUNT + 1))
done
say "$CMD_COUNT commands → ~/.config/opencode/commands/ (invoke as /playbook-<name>)"

# ── Skills (OpenCode also reads ~/.agents/skills and ~/.claude/skills)
install_shared_skills

# ── Hook scripts + JS plugin shim
install_hook_scripts
mkdir -p "$OC_DIR/plugins"
cp "$REPO_DIR/hooks/shims/opencode-buildplaybook.js" "$OC_DIR/plugins/buildplaybook.js"
say "hook plugin → ~/.config/opencode/plugins/buildplaybook.js (10 hooks bridged)"

# ── Subagents → ~/.config/opencode/agents/*.md (mode: subagent)
mkdir -p "$OC_DIR/agents"
python3 - "$REPO_DIR/agents" "$OC_DIR/agents" <<'PY'
import sys, os, re, glob

src, dst = sys.argv[1], sys.argv[2]
count = 0
for path in sorted(glob.glob(os.path.join(src, "*.md"))):
    text = open(path).read()
    m = re.match(r"^---\n(.*?)\n---\n(.*)$", text, re.S)
    if not m:
        continue
    front, body = m.groups()
    fields = dict(
        (k.strip(), v.strip())
        for k, v in (line.split(":", 1) for line in front.splitlines() if ":" in line)
    )
    name = fields.get("name", os.path.basename(path)[:-3])
    desc = fields.get("description", "")
    with open(os.path.join(dst, f"{name}.md"), "w") as f:
        f.write(f"---\ndescription: {desc}\nmode: subagent\n---\n{body}")
    count += 1
print(f"  {count} subagents → ~/.config/opencode/agents/")
PY

# ── Headless adapter + docs
install_headless_adapter
install_docs

echo ""
echo "OpenCode install complete. Headless: opencode run \"<prompt>\""
echo "Invoke methodology steps as /playbook-<name> or via skills."
