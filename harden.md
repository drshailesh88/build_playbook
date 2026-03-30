# Harden — Full Pipeline: Census → Specs → Test → Heal → Done

Run the complete hardening pipeline for a module. One command takes you from "I built something" to "it's tested and every feature works."

Module: $ARGUMENTS (module name)

## What This Does

```
/harden editor
         │
         ▼
    ┌─────────────────┐
    │ FEATURE CENSUS   │  Extract every capability
    │ /feature-census  │  (code + libraries + runtime)
    └────────┬────────┘
             │
             ▼
    ┌─────────────────┐
    │ CENSUS TO SPECS  │  Convert features to testable
    │ /census-to-specs │  checkpoints with pass/fail criteria
    └────────┬────────┘
             │
             ▼
    ┌─────────────────┐
    │ SPEC RUNNER      │  Generate Playwright tests,
    │ /spec-runner     │  run them, record results
    └────────┬────────┘
             │
             ▼
        All passing?
        ┌────┴────┐
        │YES      │NO
        ▼         ▼
    ┌──────┐  ┌─────────────┐
    │ DONE │  │ ANNEAL      │  Fix failures,
    │  ✅  │  │ /anneal     │  re-run, repeat
    └──────┘  └──────┬──────┘
                     │
                     ▼
              Re-run spec-runner
                     │
                     ▼
                All passing?
                ┌────┴────┐
                │YES      │NO
                ▼         ▼
            ┌──────┐  ┌──────────┐
            │ DONE │  │ REPORT   │
            │  ✅  │  │ stuck    │
            └──────┘  │ items    │
                      └──────────┘
```

## Process

### Phase 1: Census

```
Running /feature-census $ARGUMENTS ...
```

Invoke the feature-census skill. Wait for completion.

Expected output: `feature-census/$ARGUMENTS/CENSUS.md` with complete feature inventory.

If census fails (app not running for Layer 3), report which layers succeeded and ask user whether to proceed with partial census or start the app first.

### Phase 2: Specs

```
Running /census-to-specs $ARGUMENTS ...
```

Convert census into spec files.

Expected output: `qa/specs/$ARGUMENTS/spec-*.md` files and `qa/queue.jsonl` updated.

Report: "Generated <N> specs with <N> total checkpoints."

### Phase 3: Test

```
Running /spec-runner $ARGUMENTS ...
```

Execute all specs against the running app.

Expected output: Spec files updated with PASS/FAIL/BLOCKED status.

Report: "<N>/<total> passing (<percentage>%)."

**Gate check:**
- 100% passing → Skip Phase 4. Go to Phase 5 (Report).
- <100% passing → Proceed to Phase 4.

### Phase 4: Heal

```
Running /anneal $ARGUMENTS ...
```

Self-healing loop on all failing checkpoints.

Expected output: Fixes committed, spec files updated.

**After annealing, re-run Phase 3 (spec-runner) ONE more time** to confirm fixes hold and no regressions.

**Second gate check:**
- 100% passing → Go to Phase 5 (Report).
- Still failing → Report stuck items. These need human review.

### Phase 5: Final Report

```
🏗️  HARDENING COMPLETE
━━━━━━━━━━━━━━━━━━━━━
Module: $ARGUMENTS
Pipeline: Census → Specs → Test → Anneal → Verify

📊 Feature Census
   Total capabilities found: <N>
   From your code: <N>
   From libraries (emergent): <N>

📋 Test Specs Generated
   Spec files: <N>
   Total checkpoints: <N>

🧪 Test Results
   Before annealing: <N>/<total> passing (<before%>)
   After annealing:  <N>/<total> passing (<after%>)
   Improvement: +<N> checkpoints fixed

   ✅ Passing:  <N>
   🔧 Stuck:    <N> (need human review)
   ⚠️  Blocked:  <N> (spec issues)

📁 Artifacts
   feature-census/$ARGUMENTS/CENSUS.md     — complete feature inventory
   qa/specs/$ARGUMENTS/spec-*.md           — test specifications
   qa/generated/$ARGUMENTS/*.spec.ts       — Playwright test files
   qa/queue.jsonl                          — test queue with results

🔗 Commits
   <N> commits made during this pipeline
```

If stuck items exist:
```
🔧 STUCK — Needs Human Review
   1. <spec> CP-<N>: <description>
      Tried: <what was attempted>
   2. ...
   
   Fix these manually, then run `/spec-runner $ARGUMENTS` to re-validate.
```

### Phase 6: Commit Summary

```bash
git add feature-census/$ARGUMENTS/ qa/specs/$ARGUMENTS/ qa/generated/$ARGUMENTS/ qa/queue.jsonl
git commit -m "harden($ARGUMENTS): <N>/<total> features tested and passing — pipeline complete"
```

## Quality Score Integration (Optional)

If the project has a quality scorer, run it at the end:

```bash
# ScholarSync pattern
test -f quality-score.mjs && node quality-score.mjs && cat quality-score.json

# Or any custom scorer
test -f run-quality-check.sh && bash run-quality-check.sh
```

Report the score delta (before vs after hardening).

## Portability

To use this system in any new project:

1. Copy these files to your project:
```
.claude/
  skills/
    feature-census/
      SKILL.md
      references/
        library-capabilities.md
  commands/
    census-to-specs.md
    spec-runner.md
    anneal.md
    harden.md
```

2. Install Playwright: `npm install -D @playwright/test && npx playwright install chromium`

3. Create a basic Playwright config if you don't have one:
```typescript
// playwright.config.ts
import { defineConfig } from '@playwright/test';
export default defineConfig({
  testDir: './qa/generated',
  use: { baseURL: 'http://localhost:3000' },
  webServer: { command: 'npm run dev', port: 3000, reuseExistingServer: true },
});
```

4. Run: `/harden <module-name>`

That's it. The system adapts to whatever framework you're using by reading your code and your package.json.

## Rules

- **Run the full pipeline in order** — don't skip census or specs. Each phase feeds the next.
- **The app must be running** — Layer 3 of census and all of spec-runner require a live server.
- **Don't run harden on the entire app at once** — do one module at a time. Each module is a focused hardening session.
- **Stuck items are real** — they need human attention. Don't loop indefinitely.
- **Commit after each phase** — if the pipeline crashes mid-way, you don't lose earlier work.
- **Re-run after fixes** — the final spec-runner pass after annealing catches regressions.
