---
description: Always-loaded rules governing persistent memory (Supermemory). Controls when to save, recall, and forget across sessions and projects.
---

# Persistent Memory Rules

Supermemory is the durable memory layer. It handles cross-session recall, cross-project knowledge transfer, contradiction resolution, and automatic forgetting. Local JSONL is the fast fallback. Both run.

## When to Save (call `memory` with action: "save")

Save after these events. One memory per concept — do not batch.

| Event | What to Save | containerTag |
|-------|-------------|--------------|
| Architecture decision made | The decision, reasoning, and alternatives rejected | project slug |
| Error resolved after investigation | Root cause, fix, and what was misleading | project slug |
| Codebase pattern discovered | The pattern, where it applies, and example | project slug |
| QA finding confirmed | What broke, why, and the fix | project slug |
| User corrects the agent | The correction and the wrong assumption | project slug |
| Library quirk found | The behavior, version, and workaround | project slug |
| Cross-project pattern | Coding style, framework preference, error handling philosophy | NO tag (global) |
| Tool behavior learned | CLI flag, config option, or integration pattern | NO tag (global) |

## When to Recall (call `recall`)

| Situation | Query | containerTag |
|-----------|-------|--------------|
| Session start | "project context and recent decisions" | project slug |
| Before editing unfamiliar file | "past changes and issues with {filename}" | project slug |
| Before implementing a pattern | "how was {pattern} implemented before" | project slug |
| When hitting an error | "error: {error message or type}" | project slug |
| Starting a new feature | "prior work related to {feature domain}" | project slug |
| Cross-project question | "how did I handle {concept}" | omit (searches all) |

## When to Inject Profile (call `/context` prompt)

Call once at session start, after loading local state. The profile contains stable preferences (stack, style, conventions) and recent activity (what you worked on last).

## What NOT to Save

- Trivial fixes (typo corrections, import reordering, formatting)
- Intermediate debug steps ("tried X, didn't work" — only save the resolution)
- Full code blocks (save the pattern or approach, not the code)
- Temporary state ("currently debugging the payment flow")
- File paths or branch names (these change — save the concept, not the pointer)
- Anything already in CLAUDE.md or project rules (don't duplicate config)

## Container Tag Convention

The containerTag scopes memories to a project. Use the same slug as the session hooks:

```
containerTag = basename of canonical project path, lowercased, spaces→dashes
```

This matches `$PROJECT_SLUG` from `session-start.sh` / `session-end.sh`.

Patterns that apply to ALL projects (your coding style, framework preferences, tool behaviors) are saved WITHOUT a containerTag so they're accessible globally.

## Contradiction Handling

Supermemory handles contradictions automatically via temporal reasoning. When you save "Using Prisma for ORM", it supersedes any prior "Using Drizzle for ORM" memory. You do not need to explicitly forget the old memory — just save the new truth.

If you need to explicitly remove outdated information, call `memory` with action: "forget".

## Graceful Degradation

If the Supermemory API is unavailable (network error, auth expired, service down):
1. Log a warning: "Supermemory unavailable — using local memory only"
2. Continue with local JSONL learnings (always available)
3. Do not retry or block on the failure
4. Do not treat this as an error — local memory is fully functional

## Ethos Alignment

This implements Ethos #5: "Every Session Leaves the System Smarter." Local JSONL fulfills the letter. Supermemory fulfills the spirit — durable, cross-machine, cross-project, self-correcting knowledge that compounds over months, not just sessions.
