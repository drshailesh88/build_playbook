# Codex CLI Adapter

Use your Build Playbook with Codex CLI for autonomous building.

## Install Codex CLI

```bash
npm install -g @openai/codex
```

## Setup (one time per project)

After your playbook grilling sessions have produced `.planning/` files:

```bash
cd your-project

# Copy the AGENTS.md into your project root
cp /path/to/Build\ Playbook/adapters/codex/AGENTS.md ./AGENTS.md
```

Codex reads `AGENTS.md` automatically — no extra configuration needed.

## Three Ways to Use Codex

### Way 1: Interactive (you're at the keyboard)

```bash
cd your-project
codex

# Codex opens an interactive session. Type:
> Read .planning/REQUIREMENTS.md and build the next unchecked requirement.
```

Codex reads your `AGENTS.md`, sees the plan, builds one requirement, shows you the changes. You approve or reject. Repeat.

### Way 2: One-shot task (fire and forget)

```bash
codex --full-auto "Read .planning/REQUIREMENTS.md and build the next
  unchecked requirement. Follow AGENTS.md. Run tests. Commit if passing."
```

`--full-auto` means: read files, write code, run commands — no approval needed. Safe because it stays in your project directory with no network access.

### Way 3: Overnight loop (the main event)

```bash
# Copy the overnight script to your project
cp /path/to/Build\ Playbook/adapters/codex/overnight.sh ./overnight.sh
chmod +x overnight.sh

# Run it
./overnight.sh 20    # 20 iterations overnight
```

The script:
1. Creates a branch `codex/YYYY-MM-DD`
2. Loops N times
3. Each iteration: finds next unchecked requirement → runs Codex → verifies → commits
4. Logs everything to `progress.txt`
5. You review in the morning

## The Full Workflow

```
DAYTIME (Claude Code — thinking):
  /playbook:compete-research     → .planning/competition-research.md
  /playbook:ux-brief             → .planning/ux-brief.md
  /playbook:ui-brief             → .planning/ui-brief.md
  /playbook:data-grill           → .planning/data-requirements.md
  /playbook:infra-grill          → .planning/infra-requirements.md
  /write-a-prd                   → PRD
  /playbook:prd-to-gsd           → .planning/REQUIREMENTS.md + ROADMAP.md

  ──────── HANDOFF ────────

EVENING (Codex CLI — building):
  Copy AGENTS.md to project root (once)
  ./overnight.sh 25              ← builds overnight

  ──────── MORNING ────────

MORNING (Claude Code — reviewing):
  git log --oneline codex/$(date +%Y-%m-%d)  ← what Codex built
  cat progress.txt                            ← any problems?
  /playbook:where-am-i                       ← orient yourself
  /playbook:harden                            ← test everything
  /playbook:security-audit                    ← check for issues

  If happy: git merge codex/$(date +%Y-%m-%d)
  If not: cherry-pick good commits, discard bad ones
```

## Parallel Tasks (Advanced — requires worktree isolation)

Codex can run multiple tasks in parallel, but each MUST run in its own git worktree to avoid clobbering:

```bash
# Create isolated worktrees for each task
git worktree add ../parallel-1 -b parallel-req-1
git worktree add ../parallel-2 -b parallel-req-2
git worktree add ../parallel-3 -b parallel-req-3

# Run Codex in each worktree (separate terminals or background)
cd ../parallel-1 && codex exec --full-auto "Build requirement: Users can sign up" &
cd ../parallel-2 && codex exec --full-auto "Build requirement: Password reset flow" &
cd ../parallel-3 && codex exec --full-auto "Build requirement: Dashboard layout" &
wait

# Review each, merge what's good
cd ../your-project
git merge parallel-req-1 --no-edit  # if it looks good
git merge parallel-req-2 --no-edit
git merge parallel-req-3 --no-edit

# Cleanup
git worktree remove ../parallel-1
git worktree remove ../parallel-2
git worktree remove ../parallel-3
```

**Never run parallel Codex agents in the same working directory.** They will race on the same files and git index, producing corrupted commits.

## Switching Models

```bash
# Use a different model
codex --model o3 "Build the next requirement"
codex --model o4-mini "Build the next requirement"   # cheaper

# Or set default in ~/.codex/config.toml:
# model = "o4-mini"
```

## Tips

- Always work on a branch — `overnight.sh` does this automatically
- Review `progress.txt` first thing in the morning
- If Codex gets stuck on a requirement, switch to Claude Code for that one task
- Use `--full-auto` for overnight, interactive mode when you're at the keyboard
- Parallel tasks are great for independent requirements (no shared dependencies)
