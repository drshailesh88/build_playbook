#!/usr/bin/env python3
"""Sync ALL playbook commands into every installed agent's skill/command dir.

Targets (skipped silently when the agent isn't installed on this machine):
  SKILL.md-dir convention:  codex, codex-acc1, pi, grok, cursor
  flat-file convention:     opencode (playbook-<name>.md, no namespacing)

Runs on laptop and VPS alike — paths resolve relative to this script, not a
hardcoded repo location. Re-run after adding/renaming commands; renamed
commands leave a stale entry behind (clean those by adding the old name to
TO_REMOVE).
"""
import re
import shutil
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
PLAYBOOK_CMDS = REPO / "commands"
HOME = Path.home()

# SKILL.md convention: <skills_dir>/<name>/SKILL.md
# Grok also auto-scans ~/.claude/skills and ~/.cursor/skills (compat mode),
# and dedups by name with its own dir winning — syncing both is harmless.
SKILL_AGENTS = {
    "codex": HOME / ".codex" / "skills",
    "codex-acc1": HOME / ".codex-acc1" / "skills",
    "pi": HOME / ".pi" / "agent" / "skills",
    "grok": HOME / ".grok" / "skills",
    "cursor": HOME / ".cursor" / "skills",
}

OPENCODE_DIR = HOME / ".config" / "opencode" / "commands"
OPENCODE_PREFIX = "playbook-"

# Archived in playbook-archive — removed from every agent.
TO_REMOVE = [
    "adversarial-claude-builds",
    "adversarial-claude-builds-v2",
    "adversarial-codex-builds",
    "adversarial-codex-builds-v2",
    "anneal",
    "anneal-check",
    "census-to-specs",
    "generate-feature-doc",
    "harden",
    "merge-coordinator",
    "mutation-gate",
    "ralph-loop",
    "ralph-loop-adversarial",
    "spec-runner",
    "sprint-build-perfect",
    "sprint-build-perfect-v2",
]


def derive_description(body: str, name: str) -> str:
    """First prose paragraph after the H1; fall back to the H1 tail."""
    lines = body.splitlines()
    h1 = next((l for l in lines if l.startswith("# ")), f"# {name}")
    paragraph: list[str] = []
    seen_h1 = False
    for line in lines:
        if line.startswith("# ") and not seen_h1:
            seen_h1 = True
            continue
        if not seen_h1:
            continue
        stripped = line.strip()
        if stripped.startswith(("#", ">", "```", "---", "|", "**Provenance")):
            if paragraph:
                break
            continue
        if not stripped:
            if paragraph:
                break
            continue
        paragraph.append(stripped)
    text = " ".join(paragraph) if paragraph else h1.lstrip("# ").strip()
    text = re.sub(r"\s+", " ", text).strip()
    return (text[:240] + "…") if len(text) > 240 else text


def make_skill_md(name: str, description: str, body: str) -> str:
    desc = description.replace('"', '\\"')
    return f'---\nname: {name}\ndescription: "{desc}"\n---\n\n{body}'


def all_commands() -> dict[str, str]:
    return {
        p.stem: p.read_text()
        for p in sorted(PLAYBOOK_CMDS.glob("*.md"))
        if p.stem not in TO_REMOVE
    }


def sync_skill_agent(agent_name: str, skills_dir: Path, commands: dict[str, str]):
    if not skills_dir.parent.exists():
        print(f"── {agent_name}: not installed — skip")
        return
    skills_dir.mkdir(parents=True, exist_ok=True)
    print(f"── {agent_name} @ {skills_dir}")
    for name in TO_REMOVE:
        target = skills_dir / name
        if target.is_symlink():
            target.unlink()
        elif target.exists():
            shutil.rmtree(target)
    added = updated = 0
    for name, body in commands.items():
        skill_dir = skills_dir / name
        if skill_dir.is_symlink():
            skill_dir.unlink()
        skill_dir.mkdir(parents=True, exist_ok=True)
        skill_md = skill_dir / "SKILL.md"
        content = make_skill_md(name, derive_description(body, name), body)
        if skill_md.exists():
            if skill_md.read_text() != content:
                skill_md.write_text(content)
                updated += 1
        else:
            skill_md.write_text(content)
            added += 1
    print(f"   {added} added, {updated} updated, {len(commands)} total")


def sync_opencode(commands_dir: Path, commands: dict[str, str]):
    if not commands_dir.parent.exists():
        print("── opencode: not installed — skip")
        return
    commands_dir.mkdir(parents=True, exist_ok=True)
    print(f"── opencode @ {commands_dir}")
    for name in TO_REMOVE:
        target = commands_dir / f"{OPENCODE_PREFIX}{name}.md"
        if target.exists() or target.is_symlink():
            target.unlink()
    added = updated = 0
    for name, body in commands.items():
        desc = derive_description(body, name).replace('"', '\\"')
        content = f'---\ndescription: "{desc}"\n---\n\n{body}'
        dst = commands_dir / f"{OPENCODE_PREFIX}{name}.md"
        if dst.exists():
            if dst.read_text() != content:
                dst.write_text(content)
                updated += 1
        else:
            dst.write_text(content)
            added += 1
    print(f"   {added} added, {updated} updated, {len(commands)} total")


commands = all_commands()
print(f"{len(commands)} playbook commands from {PLAYBOOK_CMDS}\n")
for agent, path in SKILL_AGENTS.items():
    sync_skill_agent(agent, path, commands)
sync_opencode(OPENCODE_DIR, commands)
print("\nDone.")
