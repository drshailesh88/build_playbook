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
ralph/prd.json                  → Ralph story build / QA / blocked counts
ralph/progress.txt              → Current Ralph story and status
qa/runs/*/summary.md            → Latest QA release verdict
.quality/                       → QA harness state
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

🧭 RECOVERY DASHBOARD
Ralph: [built]/[total] built, [qa]/[total] QA'd, [blocked] blocked | Current: [story] | Status: [status]
QA: Last run [date] — [GREEN/YELLOW/RED/HARD] | [features] features, [blocked gates] blocked gates

✅ NEXT SAFE COMMAND
[One specific command based on Ralph + QA + git state]
```

If `ralph/prd.json` does not exist, omit the Ralph line. If neither `.quality/` nor `qa/` exists, omit the QA line. If both are omitted, still print the `NEXT SAFE COMMAND` section.

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

### 4. Ralph State Aggregation

If `ralph/prd.json` exists in the current project:

1. Count total entries.
2. Count entries where `passes` is `true`.
3. Count entries where `qa_tested` is `true`.
4. Count entries where `blocked_on_spec` is `true` or `blocked_on_contract` is `true`.
5. Read the last 5 lines of `ralph/progress.txt` if it exists.
6. Infer current story and status from those progress lines when possible.

Display:

```
Ralph: 12/18 built, 8/18 QA'd, 2 blocked | Current: auth-flow | Status: building
```

If a value cannot be inferred, use `unknown` for text fields and `0` for counts.

### 5. QA Gate State

If `.quality/` or `qa/` exists:

1. Find the most recent `summary.md` under `qa/runs/*/summary.md`, `.quality/runs/*/summary.md`, or similar run directories.
2. Extract the release verdict: `GREEN`, `YELLOW`, `RED`, or `HARD`.
3. Extract feature counts and blocked gate counts when present.

Display:

```
QA: Last run 2026-05-30 — GREEN | 6/6 features, 0 blocked gates
```

If no summary exists yet, display:

```
QA: Installed | No runs yet
```

### 6. Next Safe Command

After aggregating GSD, Ralph, QA, and git state, recommend ONE command:

| State | Next Safe Command |
|-------|-------------------|
| Ralph has blocked stories and no buildable incomplete stories | `All stories blocked. Run /playbook:contract-pack or fix specs.` |
| Ralph is mid-build | `Continue: ./ralph/run.sh` |
| Latest QA verdict is `RED` or `HARD` | `Fix failures, then: /playbook:qa-run` |
| Uncommitted changes exist | `Commit your work first` |
| Everything is green | `/playbook:ship` |
| None of the above | Use existing routing logic from step 3 |

Prioritize next safe commands in this order:
1. Ralph blocked with no buildable stories
2. Ralph mid-build
3. QA failed
4. Uncommitted changes
5. Everything green
6. Existing routing fallback

### 7. Warn on Staleness

If the most recent commit is older than 48 hours, add:

```
⚠️  Last commit was [N] days ago. Run `/gsd:progress` for a deeper status check.
```

## Rules

- This command should complete in under 10 seconds — read files only, no codebase exploration
- Output is exactly the format above — no extra commentary, no suggestions beyond the one next action and one next safe command
- If quality-score.json doesn't exist, skip that line (don't error)
- If no GSD state exists at all, say so clearly: "No GSD project initialized. Start with `/gsd:map-codebase` then `/prd-to-gsd`."
- NEVER say "I don't know where you are" — always route to a concrete next step
