# {APP_NAME} — Goal Mode Rules

<!-- CUSTOMIZE: Replace {APP_NAME}. Fill CUSTOMIZE sections. Keep under 200 lines total.
     This file replaces CLAUDE.md during /goal runs so the judge (Haiku)
     reads a lean context every evaluation tick. -->

## Identity
{APP_NAME} — built with the Ralph methodology (TDD-first, one story at a time).

## Build Methodology
1. Read the story from ralph/prd.json (first `passes:false` entry, or the one named in the goal).
2. Read ralph/specs/{story-id}.md for full context (if it exists).
3. Read the `behavior` field — all 7 sections: Acceptance Criteria (EARS format), Out of Scope, Escalation Conditions, Risk Flags, Verification Anchors, Completeness Check, Builder Notes.
4. Write failing tests FIRST (TDD). Use exact names from `fail_to_pass`.
5. Implement minimal code to pass tests.
6. Run all checks: `npm run test:run && npx tsc --noEmit && npm run lint --if-present`.
7. Commit with `RALPH: {story-id} - {title}` prefix.
8. Flip `passes:true` in ralph/prd.json.
9. Update ralph/progress.txt.

## Test Naming (fail_to_pass)
The story's `fail_to_pass` field pins exact test names. Match them:
```
fail_to_pass: ["auth.login.returns-jwt"]
→ describe("auth.login") { it("returns-jwt") }
```

## Quality Commands
<!-- CUSTOMIZE: replace with YOUR app's commands -->
```bash
npm run test:run          # unit tests — 0 failures
npx tsc --noEmit          # typecheck — 0 errors
npm run lint --if-present # lint
```

## ABORT Conditions
ABORT immediately (don't work around) when:
- Out-of-memory, disk full, network timeout to external services
- Story requires editing a locked file
- Spec is ambiguous and can't be resolved from prd.json + CLAUDE.md + specs/
- An escalation condition from the behavior field triggers
- You'd build something listed in Out of Scope

## Locked Files — NEVER Modify
<!-- CUSTOMIZE: add app-specific locked paths -->
- `.quality/**`
- `e2e/contracts/**`
- `vitest.config.ts`, `playwright.config.ts`, `stryker.config.json`
- `tsconfig.json`, `.claude/settings.json`, `.claude/hooks/**`
- `ralph/*.sh`, `ralph/*-prompt.md`
- Existing entries in `ralph/prd.json` (only flip `passes:true` for your story)

## Creative Freedom
Fixed by spec: acceptance criteria outcomes, verification anchors, test names, out-of-scope prohibitions.
Your call: file structure, helpers, internals, algorithmic approach.

## App-Specific Rules
<!-- CUSTOMIZE: paste the 5-10 most critical rules from your full CLAUDE.md -->
- Never hardcode secrets. Use env vars.
- Never use `dangerouslySetInnerHTML` or raw SQL interpolation.
<!-- - Every DB query filters by eventId except global tables. -->
<!-- - Every mutation writes to the audit log. -->
<!-- - Dev server port is 4000, never 3000. -->

## Commit Format
```
RALPH: {story-id} - {short title}

{what was built, key files, key decisions in 3-5 sentences}
```

## QA Mode (when running QA goals)
- You are NOT the builder. Verify from first principles.
- Parse EARS acceptance criteria: WHEN = trigger, SHALL = assertion.
- Check every `fail_to_pass` test exists and passes.
- Fix bugs in SOURCE CODE only — never weaken tests.
- Commit with `QA: {story-id} - ...` prefix.
- Flip `qa_tested:true` (not `passes`).
