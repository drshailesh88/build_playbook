---
description: Always-loaded development workflow rules. Applies to how work is planned, executed, and verified.
---

# Development Workflow Rules

## Search Before Building

Before implementing anything, check three layers of knowledge in order:

1. **Context7 (current docs)** — Before writing ANY library/framework API call, verify the signature with Context7 (`npx ctx7@latest library` then `npx ctx7@latest docs`). Training data goes stale. Docs don't.
2. **Runtime/stdlib** — Does the language, framework, or platform already handle this?
3. **Ecosystem** — Is there a well-maintained package or established pattern?
4. **First principles** — Only build from scratch after layers 1-3 are exhausted

Spend 5 minutes verifying before spending 50 minutes debugging a hallucinated API.

## Feature Implementation Phases

Every non-trivial feature follows this sequence:

```
RESEARCH  → Understand the problem space, existing patterns, constraints
PLAN      → Break into steps, identify risks, define success criteria
IMPLEMENT → Write tests first, then code, one RED-GREEN cycle at a time
REVIEW    → Self-review the diff, then invoke specialist agents
VERIFY    → Run all tiers of tests, check in browser, verify edge cases
```

Skipping RESEARCH or PLAN is the #1 cause of rework.

## The Boil-the-Lake Checklist

Before marking any feature complete, verify:

- [ ] All happy paths tested
- [ ] All sad paths tested (invalid input, missing data, permission denied, network failure)
- [ ] All edge cases tested (empty arrays, null values, maximum sizes, concurrent access)
- [ ] Error messages are actionable (what happened, why, what to do)
- [ ] Loading states handled
- [ ] Empty states handled
- [ ] Accessibility basics covered (labels, keyboard nav, contrast)
- [ ] Mobile responsiveness verified (if applicable)
- [ ] API error responses follow consistent format
- [ ] Database migrations are reversible

## Token Optimization

Match the model to the task:

| Task | Model | Why |
|------|-------|-----|
| File search, exploration | Haiku | Fast, cheap, sufficient |
| Simple single-file edits | Haiku | Clear instructions, low complexity |
| Multi-file implementation | Sonnet | Best balance for production coding |
| Architecture decisions | Opus | Deep reasoning needed |
| Security review | Opus | Cannot miss vulnerabilities |
| Code review | Sonnet | Good pattern detection |
| Documentation | Haiku | Structure is straightforward |
| Complex debugging | Opus | Full system context needed |

Default to Sonnet for 90% of work. Upgrade to Opus when the first attempt fails, the task spans 5+ files, requires architecture decisions, or touches security.

## Parallelization Patterns

### Fork (non-overlapping tasks)
Use for research, exploration, or questions that don't touch the same files.

### Git Worktree (overlapping code changes)
```bash
git worktree add ../project-auth feat/auth
git worktree add ../project-api feat/api
```
Each worktree gets its own Claude instance with its own context.

### Cascade (focus management)
Open new tasks in new tabs. Sweep left to right. Maximum 3-4 concurrent tasks.

### Two-Instance Kickoff
- Instance 1 (Scaffolding): project structure, config, CLAUDE.md, rules
- Instance 2 (Research): PRD, architecture docs, service connections

## Context Hygiene

- Use `/clear` between unrelated tasks
- Save session state before context compaction
- Load relevant learnings at session start
- Keep the main context lean — delegate heavy analysis to subagents
