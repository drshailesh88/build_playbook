# Ralph Loop Adversarial — Build→Review→Fix Loop with Linear Tracking

Geoffrey Huntley's Ralph pattern + GAN-inspired adversarial review. Claude Code builds, Codex attacks, Claude fixes. Repeat until Codex finds nothing. Linear tracks every phase transition.

Input: $ARGUMENTS (optional: Linear project name. If not provided, auto-detects from `.planning/STATE.md`)

## What This Does

Runs a bash script that loops through Linear issues in priority order with adversarial review:

1. Fetches next unblocked "unstarted" issue from Linear
2. Marks it "In Progress"
3. **BUILD:** Claude Code builds it (TDD, fresh context)
4. **AUTORESEARCH:** Verifies score didn't drop
5. **ADVERSARY:** Codex reviews — tries to break the code, writes failing tests
6. **FIX:** Claude Code fixes Codex's findings
7. **LOOP:** Steps 5-6 repeat until Codex says "no bugs found" (max 3 rounds)
8. **GATE:** Final check — score >= baseline, zero failures, types clean
9. Pass → commits, marks "Done" in Linear with full audit trail
10. Fail → reverts, marks "Blocked"
11. Next issue

Every issue that gets committed has survived:
- TDD implementation
- Autoresearch score validation
- Up to 3 rounds of adversarial attack by a different AI model
- Final gate (score, failures, types)

## Prerequisites

```bash
brew install schpet/tap/linear   # Linear CLI
linear auth login                 # Authenticate
```

Both Claude Code (`claude` CLI) and Codex (`codex` CLI) must be installed and authenticated.

Issues must exist in Linear first. Create them with `/playbook:prd-to-linear` or `/playbook:gsd-to-linear`.

## How to Run

The Ralph Loop runs as a bash script (not as a slash command) because each iteration needs fresh sessions.

```bash
# From your project directory:
./path/to/Build-Playbook/adapters/linear/ralph-loop-adversarial.sh "My Project"
./path/to/Build-Playbook/adapters/linear/ralph-loop-adversarial.sh "My Project" 30  # max 30 iterations
```

### Environment Variables

```bash
LINEAR_TEAM=DRS                    # Override team (auto-detected)
TEST_CMD="npm test"                # Override test command (auto-detected)
TYPE_CHECK_CMD="npx tsc --noEmit"  # Override type check
NOTIFY_WEBHOOK=https://...         # Slack/Discord webhook
RALPH_LABEL="phase-1"              # Only process issues with this label
MAX_REVIEW_ROUNDS=3                # Max adversarial review→fix cycles (default: 3)
```

## What Shows Up in Linear

For each issue, you'll see comments like:

```
Ralph Adversarial iteration 5 — Claude Code building, Codex reviewing

Builder (Claude) — Build complete. Tests: 42→48 (+6). Sending to adversary.

Adversary (Codex) — Round 1
## Finding 1: Missing null check in notification handler
- File: src/handlers/notify.ts
- Line: 23
- Severity: major
- Test added: Yes — "should handle null recipient"

Builder (Claude) — Fix round 1: 50 passing, 0 failing

Adversary (Codex) — NO BUGS FOUND in round 2. Code is clean.

Ralph Adversarial — COMPLETE ✓
Tests: 42 → 50 (+8)
Adversarial rounds: 2
```

## Monitoring Progress

```bash
# Terminal
linear issue list --team DRS --project "My Project" --all-states

# Machine-readable status
cat .planning/ralph-adversarial-status.json

# Score history with review round counts
cat .planning/ralph-adversarial-scores.jsonl

# From phone
# https://linear.app/[workspace]/project/[slug]
```

## The Three ML Concepts

1. **Autoresearch (Karpathy):** One metric (test pass count). Must never decrease. Revert if it does.
2. **Adversarial (GAN-inspired):** Builder (Claude) vs Adversary (Codex). Two different AI companies, two different blind spots.
3. **Annealing:** When builds break, attempt fixes with increasing conservatism. 3 attempts, each more minimal than the last.

## When to Use This vs Simple

Use **ralph-loop** (simple) when:
- Prototyping, speed over quality
- Simple requirements
- You'll anneal afterwards

Use **ralph-loop-adversarial** (this) when:
- Production features
- Auth, payments, security, data integrity
- You want each feature battle-tested before moving on
- Overnight unattended runs where quality matters
