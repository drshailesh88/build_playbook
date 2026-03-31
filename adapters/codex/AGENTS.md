# Project Build Instructions

## Your Job

You are building this project from a structured plan. All decisions have already been made. Your job is to write code, not make product decisions.

## Where to Find the Plan

Read these files in order before writing any code:

1. `.planning/STATE.md` — where the project is right now (current phase, what's done)
2. `.planning/ROADMAP.md` — the phases in order (build Phase 1 before Phase 2)
3. `.planning/REQUIREMENTS.md` — the full checklist of what to build

Then read these for context:

4. `.planning/ux-brief.md` — how the app should feel (navigation, interactions, speed)
5. `.planning/ui-brief.md` — how the app should look (fonts, colors, spacing, CSS variables)
6. `.planning/data-requirements.md` — what data the app stores and how it relates
7. `.planning/infra-requirements.md` — where the app runs and what constraints exist
8. `UBIQUITOUS_LANGUAGE.md` — what terms mean in this project (if exists)
9. `SCHEMA_DECISIONS.md` — database design decisions (if exists)

## How to Build

### Finding the Next Task

1. Open `.planning/REQUIREMENTS.md`
2. Find the current phase from `.planning/STATE.md`
3. Find the FIRST unchecked `- [ ]` requirement for that phase
4. That is your task. Build ONLY that one requirement.

### Building the Task

1. Read existing code first — follow established patterns
2. Write the code for this one requirement
3. Write or update tests for what you built
4. Run verification: `npm run typecheck && npm test && npm run lint`
5. If all pass: check the box `- [x]` in REQUIREMENTS.md
6. Commit: `feat: [requirement summary] (Phase N)`

### When All Requirements in a Phase Are Done

1. Update `.planning/STATE.md` — change current phase to next phase
2. Commit: `milestone: Phase N complete, advancing to Phase N+1`
3. Pick up the first unchecked requirement in the new phase

### When a Requirement is Too Big

If you realize a requirement will take more than one session:
1. Build the smallest meaningful slice of it
2. Do NOT check the box — leave it `- [ ]`
3. Add a comment below it: `<!-- PARTIAL: built X, remaining: Y, Z -->`
4. Commit what you have
5. The next session picks up where you left off

## Rules

- ONE requirement per task. Not two. Not "while I'm here."
- Follow existing code patterns. Do not invent new architectures.
- Never modify tests just to make them pass (unless the test is genuinely wrong).
- Never skip verification. If typecheck or tests fail, fix before committing.
- Never delete or reduce scope of requirements.
- If stuck, add a comment: `<!-- BLOCKED: reason -->` and move to next requirement.
- Use the project's ubiquitous language (check UBIQUITOUS_LANGUAGE.md).
- Respect the UI brief — use the specified fonts, colors, spacing. Don't freestyle.
- Respect the UX brief — follow the navigation pattern, feedback intensity, and interaction models specified.

## Test Commands

```bash
npm run typecheck          # Type checking
npm test                   # Unit + integration tests
npm run lint               # Linting
npx playwright test        # E2E tests (if configured)
```

## Commit Message Format

```
feat: [what you built] (Phase N)
fix: [what you fixed] (Phase N)
refactor: [what you changed] (Phase N)
```
