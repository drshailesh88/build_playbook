---
description: Always-loaded git discipline. Applies to all commits, branches, and PRs.
---

# Git Workflow Rules

## Commits

Use conventional commits. The format tells the reader what changed and why without reading the diff.

```
feat(auth): add JWT refresh token rotation
fix(api): handle null response from payment provider
refactor(db): extract query builder from user service
docs(readme): add deployment instructions
test(auth): add sad-path tests for expired tokens
chore(deps): upgrade Playwright to 1.45
```

- One logical change per commit. If the commit message needs "and", split it.
- Write the message so `git log --oneline` tells the story of the feature
- Reference issue numbers in the body, not the subject line
- Never commit generated files (build output, lock files from wrong package manager)

## Branches

- `main` is always deployable. Never push broken code to main.
- Feature branches: `feat/short-description`
- Fix branches: `fix/short-description`
- Delete branches after merge

## Pull Requests

- PR title = conventional commit format
- PR body: what changed, why, how to test
- One PR per feature/fix. If the PR touches 10+ files across unrelated concerns, split it.
- Every PR must pass Tier 1 (static) + Tier 2 (unit/integration) tests before merge
- Request review from the appropriate specialist agent before merging

## Never Do

- Force-push to main/shared branches
- Commit secrets, credentials, or .env files
- Use `--no-verify` to skip hooks
- Amend published commits (create a new commit instead)
- Commit with "WIP" or "fix" as the only message
- Rebase public branches that others are working on

## Before Every Commit

1. `git diff --staged` — review exactly what you're committing
2. Tier 1 checks pass (typecheck + lint)
3. Tests covering the changed code pass
4. No secrets in the diff
