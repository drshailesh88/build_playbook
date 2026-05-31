# Compact Context

Save durable session context before the conversation auto-compacts. Use this manually when the current session has useful state that should survive into the next working block.

No arguments needed.

## Why This Exists

Auto-compaction preserves the conversation, but the best recovery signal lives in files: planning state, decisions, commits, working tree status, glossary, and project learnings. This command writes a concise `.planning/session-summary.md` snapshot that future sessions can read first.

## Process

### 1. Read Current State

Read these files if they exist. If a file doesn't exist, use the fallback noted below.

```
.planning/STATE.md              → Current milestone, phase, status
.planning/grill-log.md          → DECIDED / DEFERRED / REJECTED decisions
.planning/CONTEXT.md            → Glossary terms
~/.buildplaybook/projects/{slug}/learnings.jsonl  → Last 3 learnings
```

Then run:
```bash
git log --oneline -10            # Recent commits
git status --short               # Uncommitted work
```

### 2. Derive Project Slug

Use the current repository directory name as `{slug}`. Normalize it the same way other learnings commands do: lowercase, replace spaces with hyphens, and strip characters that are not letters, numbers, dots, underscores, or hyphens.

If `~/.buildplaybook/projects/{slug}/learnings.jsonl` doesn't exist, write `None`.

### 3. Extract Decision Data

From `.planning/grill-log.md`:
- Count decisions with status `DECIDED`, `DEFERRED`, and `REJECTED`
- List the last 5 decisions in chronological file order
- Include any `DEFERRED` decisions under Blockers

If `.planning/grill-log.md` doesn't exist:
- Use zero counts
- Write `None` for Active Decisions
- Write `None` for Blockers

### 4. Count Glossary Terms

From `.planning/CONTEXT.md`, count glossary terms. Prefer obvious glossary table rows or heading entries. If the file doesn't exist, write `0 terms in CONTEXT.md`.

### 5. Write Session Summary

Create `.planning/` if needed, then overwrite `.planning/session-summary.md` with:

```markdown
# Session Summary
Updated: [ISO timestamp]

## Current Phase
[from STATE.md, or "No STATE.md — run /playbook:prd-to-gsd to create"]

## Active Decisions (last 5)
| DEC | Question | Selected | Status |
|-----|----------|----------|--------|
[from grill-log.md]

## Decision Counts
DECIDED: N | DEFERRED: N | REJECTED: N

## Recent Commits
[git log --oneline -10]

## Uncommitted Work
[git status --short, or "Working tree clean"]

## Glossary
[N terms in CONTEXT.md]

## Recent Learnings
[last 3 from learnings.jsonl]

## Blockers
[any DEFERRED decisions, or "None"]

## Recommended Next Command
[based on current state]
```

### 6. Recommend the Next Command

Use one concrete recommendation:

| State | Recommended Next Command |
|-------|--------------------------|
| No `.planning/STATE.md` | `/playbook:prd-to-gsd` |
| Ralph exists and has buildable incomplete stories | `./ralph/run.sh` |
| Ralph exists and all stories are built but QA is not complete | `/playbook:qa-run` |
| `.quality/` or `qa/` exists with a failed latest run | `/playbook:qa-run` after fixing failures |
| Uncommitted work exists | `git add . && git commit` |
| State says current phase is complete | `/playbook:where-am-i` |
| Default | `/playbook:where-am-i` |

## Output

After writing the file, print:

```
Session summary written to .planning/session-summary.md
Recommended next command: [command]
```

## Rules

- This is a manual command, not a hook
- Read files and git state only; do not explore the codebase
- Do not modify files other than `.planning/session-summary.md`
- If any optional file is missing, use the documented fallback instead of erroring
- Keep the summary deterministic and concise
