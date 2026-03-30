# Where Am I

Resume context after a break. Read project state, quality score, and recent git history, then tell me exactly where I am and what to do next. Use this every time you come back to work.

No arguments needed.

## Why This Exists

When you work in scattered time blocks — 15 minutes here, an hour there — the biggest cost is re-establishing context. This command reads durable state from files (not from memory) and gives you a 10-line situational summary with a clear next action.

Adapted from:
- GSD progress command (Routes A-F for intelligent next-action routing)
- runesleo's memory-flush pattern (today.md as hot data layer for crash recovery)

## Process

### 1. Read State (fast — no exploration, just files)

Read these files in order. If a file doesn't exist, skip it.

```
.planning/STATE.md              → Current milestone, phase, status
.planning/ROADMAP.md            → Phase completion checkboxes
quality-score.json              → Annealing score and weakest dimension
.planning/decisions/            → List files (most recent planning sessions)
```

Then run:
```bash
git log --oneline -5             # Last 5 commits
git status --short               # Uncommitted changes
gh issue list --state open --limit 5 2>/dev/null  # Open issues
```

### 2. Produce the Summary

Output exactly this format — no more, no less:

```
📍 WHERE YOU ARE
━━━━━━━━━━━━━━━
Milestone: [name] | Phase [N]/[total]: [title]
Phase status: [NOT STARTED / IN PROGRESS / BLOCKED / COMPLETE]
Quality score: [XX.XX] ([TEMPERATURE]) | Weakest: [dimension] ([score])

📋 RECENT WORK
[Last 3 commit messages, one line each]

⚡ NEXT ACTION
[One specific command to run — not a menu of options]
[One sentence explaining why this is the right next step]
```

### 3. Route to Next Action

Use this routing logic (adapted from GSD progress Routes A-F):

| State | Next Action |
|-------|-------------|
| No `.planning/` directory | `/gsd:map-codebase` — "Map your existing codebase before starting" |
| `.planning/` exists but no ROADMAP.md | `/gsd:new-milestone` or `/prd-to-gsd` — "Create your first milestone" |
| Phase has no CONTEXT.md | `/gsd:discuss-phase [N]` — "Flesh out decisions before planning" |
| Phase has CONTEXT.md but no PLAN files | `/gsd:plan-phase [N]` — "Create implementation plans" |
| Phase has PLAN files, some incomplete | `/gsd:execute-phase [N]` — "Continue execution" |
| Phase complete, next phase exists | `/gsd:discuss-phase [N+1]` — "Move to next phase" |
| All phases complete | `/gsd:complete-milestone` — "Wrap up and tag the release" |
| Open GitHub issues exist | `/gsd:quick '[first issue title]'` — "Fix the open issue" |
| Quality score dropped | `/anneal-check` — "Quality regression detected, investigate" |
| Uncommitted changes | `git add . && git commit` — "You have uncommitted work" |

If multiple conditions are true, prioritize: uncommitted changes > quality regression > current phase work > open issues.

### 4. Warn on Staleness

If the most recent commit is older than 48 hours, add:

```
⚠️  Last commit was [N] days ago. Run `/gsd:progress` for a deeper status check.
```

## Rules

- This command should complete in under 10 seconds — read files only, no codebase exploration
- Output is exactly the format above — no extra commentary, no suggestions beyond the one next action
- If quality-score.json doesn't exist, skip that line (don't error)
- If no GSD state exists at all, say so clearly: "No GSD project initialized. Start with `/gsd:map-codebase` then `/prd-to-gsd`."
- NEVER say "I don't know where you are" — always route to a concrete next step
