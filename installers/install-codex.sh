#!/bin/bash
# Build Playbook — Codex CLI installer
# Installs rules (AGENTS.md), skills, hooks, and subagents for OpenAI Codex.

source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

CODEX_DIR="$HOME/.codex"
echo "Installing Build Playbook → Codex CLI"

# ── Rules → ~/.codex/AGENTS.md (marker-merged, user content preserved)
compile_agents_md "$BUILD_DIR/agents-block.md"
merge_marked_block "$CODEX_DIR/AGENTS.md" "$BUILD_DIR/agents-block.md"
say "rules → ~/.codex/AGENTS.md ($(wc -c < "$CODEX_DIR/AGENTS.md" | tr -d ' ') bytes)"

FINAL_SIZE=$(wc -c < "$CODEX_DIR/AGENTS.md" | tr -d ' ')
if [ "$FINAL_SIZE" -gt 31000 ]; then
  say "WARNING: AGENTS.md is ${FINAL_SIZE} bytes; Codex caps instruction docs at 32 KiB."
  say "         Add to ~/.codex/config.toml:  project_doc_max_bytes = 65536"
fi

# ── Skills (shared cross-vendor location, auto-discovered by Codex)
install_shared_skills

# ── Hook scripts + Codex hooks.json
install_hook_scripts

HOOKS_FILE="$CODEX_DIR/hooks.json"
if [ -f "$HOOKS_FILE" ] && ! grep -q "buildplaybook" "$HOOKS_FILE"; then
  cp "$HOOKS_FILE" "$HOOKS_FILE.bak"
  say "WARNING: existing ~/.codex/hooks.json backed up to hooks.json.bak"
fi
mkdir -p "$CODEX_DIR"
# Same event names and stdin protocol as the canonical hooks.json. Codex
# honors permissionDecision allow/deny only — our "ask" outputs degrade to
# advisory warnings, and exit-2 blocking works identically.
cp "$REPO_DIR/hooks/hooks.json" "$HOOKS_FILE"
say "hooks.json → ~/.codex/hooks.json (10 hooks wired)"

# ── Subagents → ~/.codex/agents/*.toml
mkdir -p "$CODEX_DIR/agents"
python3 - "$REPO_DIR/agents" "$CODEX_DIR/agents" <<'PY'
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
    desc = fields.get("description", "").replace('"', "'")
    body = body.strip().replace("'''", "‴")
    out = os.path.join(dst, f"{name}.toml")
    with open(out, "w") as f:
        f.write(f'name = "{name}"\n')
        f.write(f'description = "{desc}"\n')
        f.write(f"developer_instructions = '''\n{body}\n'''\n")
    count += 1
print(f"  {count} subagents → ~/.codex/agents/ (TOML)")
PY

# ── Headless adapter + docs
install_headless_adapter
install_docs

echo ""
echo "Codex install complete. Headless: codex exec --sandbox workspace-write --ask-for-approval never \"<prompt>\""
echo "Invoke methodology steps as skills, e.g.: \$playbook-where-am-i"
