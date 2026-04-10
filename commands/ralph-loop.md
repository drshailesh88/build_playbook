# Ralph Loop — Simple Build Loop with Linear Tracking

Geoffrey Huntley's Ralph pattern: sit ON the loop, not IN it. Each iteration = one Linear issue = fresh Claude Code session = zero context rot. Linear is the live scoreboard.

Input: $ARGUMENTS (optional: Linear project name. If not provided, auto-detects from `.planning/STATE.md`)

## What This Does

Runs a bash script that loops through Linear issues in priority order:
1. Fetches next unblocked "unstarted" issue from Linear
2. Marks it "In Progress"
3. Launches a fresh Claude Code session to build it (TDD)
4. Verifies: tests pass, types clean, score didn't drop
5. Pass → commits, marks "Done" in Linear
6. Fail → heals (3 attempts) → if still failing, marks "Blocked"
7. Next issue. Repeat until all done.

No adversarial review. Just build→verify→commit. Fast throughput.

## Prerequisites

```bash
brew install schpet/tap/linear   # Linear CLI
linear auth login                 # Authenticate
```

Issues must exist in Linear first. Create them with `/playbook:prd-to-linear` or `/playbook:gsd-to-linear`.

## How to Run

The Ralph Loop runs as a bash script (not as a slash command) because each iteration needs a fresh Claude Code session to prevent context rot.

```bash
# From your project directory:
~/.claude/commands/playbook/../../..  # (adjust path to Build Playbook)

# Or if Build Playbook is cloned:
./path/to/Build-Playbook/adapters/linear/ralph-loop.sh "My Project"
./path/to/Build-Playbook/adapters/linear/ralph-loop.sh "My Project" 30  # max 30 iterations
```

### Environment Variables

```bash
LINEAR_TEAM=DRS                    # Override team (auto-detected)
TEST_CMD="npm test"                # Override test command (auto-detected)
TYPE_CHECK_CMD="npx tsc --noEmit"  # Override type check
NOTIFY_WEBHOOK=https://...         # Slack/Discord webhook for phone notifications
RALPH_LABEL="phase-1"              # Only process issues with this label
```

## Monitoring Progress

```bash
# From terminal
linear issue list --team DRS --project "My Project" --all-states

# Machine-readable status (updated each step)
cat .planning/ralph-status.json

# Score history
cat .planning/ralph-scores.jsonl

# From phone/browser
# https://linear.app/[workspace]/project/[slug]
```

## When to Use This vs Adversarial

Use **ralph-loop** (this) when:
- Prototyping or early phases where speed matters more than bulletproofing
- Simple requirements (schema changes, seed data, basic CRUD)
- You'll run `/playbook:anneal` afterwards to catch issues

Use **ralph-loop-adversarial** when:
- Building production features
- Requirements touch auth, payments, or security
- You want each feature battle-tested before moving on
