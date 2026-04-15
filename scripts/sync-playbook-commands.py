#!/usr/bin/env python3
"""Sync playbook commands into Codex (+ acc1) and pi skill dirs."""
import os
import shutil
from pathlib import Path

HOME = Path.home()
PLAYBOOK_CMDS = HOME / "Build Playbook" / "commands"

AGENTS = {
    "codex": HOME / ".codex" / "skills",
    "codex-acc1": HOME / ".codex-acc1" / "skills",
    "pi": HOME / ".pi" / "agent" / "skills",
}

# OpenCode uses a FLAT command dir (single .md per command, no nested skill
# folder). Frontmatter wants `description` only; no `name` field. Invoked as
# /<name> in the TUI. No namespace support, so filenames use playbook-<name>
# prefix to avoid colliding with OpenCode-native commands.
OPENCODE_DIR = HOME / ".config" / "opencode" / "commands"
OPENCODE_PREFIX = "playbook-"

# Skills to remove from each agent (archived in playbook-archive).
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

# Playbook commands to ADD as skills. Each has a short description used in
# SKILL.md frontmatter.
TO_ADD = {
    "author-locked-tests":        "Generate acceptance.spec.ts from a frozen contract under source-denied permissions (oracle independence). Use after /playbook:contract-pack freezes the contract and before the builder touches the feature.",
    "classify-check":             "Verify every source file under src/, app/, lib/, components/, pages/ matches a tier glob in .quality/policies/tiers.yaml. Fail-fast per blueprint 6b.iii. Use in pre-push hooks and before qa-run.",
    "classify-modules":           "Interactive tiers.yaml builder. Classifies modules into critical_75 / business_60 / ui_gates_only with service-hint suggestions. Sets unclassified_behavior:fail_fast.",
    "contract-pack":              "Create frozen acceptance tests from spec BEFORE build. Independent oracle that the builder cannot edit. Prevents oracle contamination. The foundation of honest QA.",
    "define-quality-contracts":   "Author ALL quality contracts BEFORE any source code exists. Chains contract-pack + author-locked-tests + initial tiers.yaml across every critical feature in one planning session. Oracle pure by construction.",
    "gsd-to-linear":              "Push GSD REQUIREMENTS.md to Linear as agent-sized subtask issues with dependency mapping. One-way sync.",
    "install-qa-harness":         "Scaffold qa/ + .quality/ into a target Next.js app. Detects services, writes policies, installs enforcement hooks, generates .env.test.example. Idempotent with --upgrade.",
    "prd-to-linear":              "Skip GSD — break a PRD directly into agent-sized Linear issues with dependency mapping. Multi-agent shortcut.",
    "prd-to-ralph":               "Convert PRD + grilling decisions into Huntley's exact prd.json format (flat array with id, category, description, page, ui_details, behavior, data_model, priority, core, passes, tests.{unit,e2e,edge_cases}). The input Ralph consumes.",
    "qa-audit-violations":        "Aggregate .quality/runs/*/violations.jsonl across all runs by pattern. Surfaces which anti-cheat signatures fired most often.",
    "qa-baseline":                "Populate module mutation baselines. Run once after install. Full Stryker + Vitest + Playwright.",
    "qa-baseline-reset":          "Explicit ratchet-down with audit-log entry. Only way to lower a module's mutation baseline.",
    "qa-clean":                   "Clear stale session locks + archive old runs' heavy artifacts (coverage/, stryker-tmp/).",
    "qa-doctor":                  "Drift checks — deprecated commands, contract hashes, providers policy, tier coverage, detected services. Run before qa-run if state.json feels off.",
    "qa-report":                  "List all runs or open a specific run's summary.md. Deterministic snapshot of what the QA pipeline saw.",
    "qa-run":                     "Full QA session: preflight → lock → baseline → feature gates → release gates → summary + state delta. The ungameable judge. Runs every time the feature loop completes.",
    "qa-status":                  "Current state.json snapshot + per-tier floor check. Fast read-only view of where every module stands against its mutation floor.",
    "qa-unblock":                 "Reset a BLOCKED feature → pending + clear the plateau buffer. Use when a feature has stalled in the feature loop and needs a fresh attempt.",
    "ralph-watch":                "Drop ralph/watch.sh + print Slack/Linear env var setup. Pure observer — never writes to files Ralph touches. Posts progress while build/QA runs.",
    "scaffold-ralph":             "Drop adapted Ralph scripts (build.sh, qa.sh, run.sh) + prompt templates (build-prompt, qa-prompt) into target app's ralph/ dir. Do NOT download Huntley's raw scripts — they're product-cloning specific.",
    "wire-selectors":             "Adjust data-testid selectors in acceptance.spec.ts to match the real DOM after the build phase. Assertions are locked by AST diff audit — selector-only changes.",
}

def make_skill_md(name: str, description: str, body: str) -> str:
    # Build SKILL.md with frontmatter. Keep description on one line.
    desc_oneline = description.replace("\n", " ").replace('"', '\\"').strip()
    return f'---\nname: {name}\ndescription: "{desc_oneline}"\n---\n\n{body}'

def sync_agent(agent_name: str, skills_dir: Path):
    print(f"\n── {agent_name} @ {skills_dir} ──")
    if not skills_dir.exists():
        print(f"  skip: skills dir not found")
        return

    # Remove archived skills (handles both dirs and symlinks)
    for name in TO_REMOVE:
        target = skills_dir / name
        if target.is_symlink():
            target.unlink()
            print(f"  rm:   {name} (symlink)")
        elif target.exists():
            shutil.rmtree(target)
            print(f"  rm:   {name}")

    # Add new skills from playbook commands
    for name, description in TO_ADD.items():
        cmd_path = PLAYBOOK_CMDS / f"{name}.md"
        if not cmd_path.exists():
            print(f"  MISS: {name}.md not in playbook — skipping")
            continue
        body = cmd_path.read_text()
        skill_dir = skills_dir / name
        # If an existing skill path is a symlink, replace it with a real dir
        if skill_dir.is_symlink():
            skill_dir.unlink()
        skill_dir.mkdir(parents=True, exist_ok=True)
        skill_md = skill_dir / "SKILL.md"
        existed = skill_md.exists()
        skill_md.write_text(make_skill_md(name, description, body))
        print(f"  {'up:  ' if existed else 'add: '}{name}")

def sync_opencode(commands_dir: Path):
    print(f"\n── opencode @ {commands_dir} ──")
    commands_dir.mkdir(parents=True, exist_ok=True)

    # Remove archived commands (playbook-<name>.md form).
    for name in TO_REMOVE:
        target = commands_dir / f"{OPENCODE_PREFIX}{name}.md"
        if target.is_symlink():
            target.unlink()
            print(f"  rm:   {OPENCODE_PREFIX}{name} (symlink)")
        elif target.exists():
            target.unlink()
            print(f"  rm:   {OPENCODE_PREFIX}{name}")

    # Add new commands.
    for name, description in TO_ADD.items():
        cmd_path = PLAYBOOK_CMDS / f"{name}.md"
        if not cmd_path.exists():
            print(f"  MISS: {name}.md not in playbook — skipping")
            continue
        body = cmd_path.read_text()
        desc_oneline = description.replace("\n", " ").replace('"', '\\"').strip()
        content = f'---\ndescription: "{desc_oneline}"\n---\n\n{body}'
        dst = commands_dir / f"{OPENCODE_PREFIX}{name}.md"
        existed = dst.exists()
        dst.write_text(content)
        print(f"  {'up:  ' if existed else 'add: '}{OPENCODE_PREFIX}{name}")

for agent, path in AGENTS.items():
    sync_agent(agent, path)

sync_opencode(OPENCODE_DIR)

print("\nDone.")
