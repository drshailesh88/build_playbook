---
description: Always-loaded testing standards. Applies when writing, reviewing, or modifying any code.
globs: "**/*.{ts,tsx,js,jsx,test.*,spec.*,py,rb}"
---

# Testing Rules

## The 3-Tier Test System

### Tier 1: Static Validation (free, <2 seconds)
- TypeScript compilation (`npx tsc --noEmit`)
- Linting (`npx eslint --max-warnings 0`)
- Format check (`npx prettier --check .`)
- Runs on every change. No excuses.

### Tier 2: Unit + Integration Tests (~30 seconds)
- Unit tests for all business logic, utilities, and data transformations
- Integration tests for API endpoints, database queries, and service interactions
- Minimum 80% code coverage for new code
- Run after every meaningful change

### Tier 3: E2E + LLM-as-Judge (~minutes)
- End-to-end tests via Playwright for critical user flows
- LLM-as-judge evaluation for semantic correctness where applicable
- Run before PR creation and before deploy

## Test-Driven Development

Write or update tests BEFORE implementing the change. The cycle:

1. **RED** — Write a failing test that describes the desired behavior
2. **GREEN** — Write the minimum code to make it pass
3. **IMPROVE** — Refactor while keeping tests green

One RED-GREEN cycle at a time. Never write multiple failing tests then implement horizontally.

## What Gets Tested

Every function, component, or endpoint must have tests covering:
- **Happy path** — the expected flow works
- **Edge cases** — boundary values, empty inputs, maximum sizes
- **Sad paths** — invalid input, missing data, network failures, permission denied
- **Error messages** — the user sees something actionable, not a stack trace

## Test Structure (AAA Pattern)

```
Arrange — set up test data and preconditions
Act     — execute the function/action under test
Assert  — verify the result matches expectation
```

## Diff-Based Test Selection

When changing a module, only run tests that cover changed code paths. Full suite runs at Tier 3 (pre-PR/pre-deploy). This keeps the feedback loop fast during development.

## Failure Blame Protocol

When a test fails:
1. Never claim "pre-existing" without proof — trace the failure to a specific commit
2. If the failure is in your change, fix it before proceeding
3. If genuinely pre-existing, document the commit that introduced it and file a separate fix
4. Never weaken a test to make it pass — fix the code, not the test

## Anti-Patterns

- Writing tests after implementation ("I'll add tests later" = never)
- Testing implementation details instead of behavior
- Mocking everything (test real behavior where possible)
- Ignoring flaky tests (fix or delete them — flaky tests erode trust)
- Using `skip` or `xit` without a linked issue
- Weakening assertions to make tests pass
