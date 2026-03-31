---
description: Use when about to claim work is complete, fixed, or passing, before committing or moving to next task — requires running verification commands and confirming output before making any success claims. Evidence before assertions, always.
---

# Verification Before Completion

Adapted from Jesse Vincent's Superpowers verification-before-completion skill.

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## ScholarSync Verification Commands

| Claim | Required Command | Pass Criteria |
|-------|-----------------|---------------|
| TypeScript compiles | `npx tsc --noEmit` | Exit 0, zero errors |
| Lint clean | `npx eslint --max-warnings 0` | Exit 0 |
| Tests pass | `npm test` | All tests pass, exit 0 |
| E2E tests pass | `npm run test:e2e` | All specs pass |
| Quality score held | `node quality-score.mjs` then read `quality-score.json` | Score ≥ previous score |
| Build works | `npm run build` | Exit 0 |
| Feature works | Load the page in browser, verify visually | Specific behavior confirmed |

## Red Flags — STOP Immediately

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Done!", "Perfect!")
- About to commit without verification
- Trusting a subagent's success report without checking VCS diff
- Relying on a previous run instead of a fresh one
- Thinking "just this once"

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter ≠ compiler ≠ tests |
| "Agent said success" | Verify independently |
| "Partial check is enough" | Partial proves nothing |

## When To Apply

**ALWAYS before:**
- Any variation of success/completion claims
- Any expression of satisfaction about work state
- Committing, PR creation, task completion
- Moving to next task or next GSD phase
- Updating STATE.md with "COMPLETE"
- Running `/gsd:complete-milestone`

## The Bottom Line

Run the command. Read the output. THEN claim the result.

This is non-negotiable.
