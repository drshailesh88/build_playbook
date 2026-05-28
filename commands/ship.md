# Ship — Automated Deployment Pipeline

Adapted from gstack's /ship workflow. Takes code from "reviewed" to "deployed and monitored" with zero manual steps.

## Prerequisites

- `/review` completed with APPROVED or CLEAN verdict
- On a feature branch (not main)
- All changes committed

## Process

### Step 1: Pre-Flight Check

```bash
# Branch status
git branch --show-current
git status --short
git log --oneline main..HEAD

# Ensure we're not on main
BRANCH=$(git branch --show-current)
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
  echo "ERROR: Cannot ship from main. Create a feature branch first."
  exit 1
fi
```

Verify:
- [ ] Branch is up-to-date with main (merge main before shipping)
- [ ] No uncommitted changes
- [ ] At least one commit ahead of main
- [ ] Review completed (check for recent review report)

### Step 2: Merge Main

```bash
git fetch origin main
git merge origin/main
```

If conflicts arise, resolve them. Re-run Tier 1 checks after merge.

### Step 3: Run Full Test Suite

Execute all three tiers:

```bash
# Tier 1: Static
npx tsc --noEmit && npx eslint --max-warnings 0

# Tier 2: Unit + Integration
npm test

# Tier 3: E2E (if available)
npm run test:e2e 2>/dev/null || echo "No E2E tests configured"
```

If ANY test fails:
1. Classify: is this our change or pre-existing?
2. If ours: fix it. Do not proceed.
3. If pre-existing: document the commit that introduced it, file a note, proceed with caution.

### Step 4: Coverage Check

```bash
npm test -- --coverage 2>/dev/null
```

- New code must have 80%+ coverage
- Overall coverage must not decrease
- Critical paths (auth, payments, data mutation) must have 100%

### Step 5: Push and Create PR

```bash
git push -u origin $(git branch --show-current)
```

Create PR with:
- Title: conventional commit format
- Body: what changed, why, test results, review summary
- Labels: based on change type

```bash
gh pr create --title "[type]: summary" --body "$(cat <<'EOF'
## Summary
[from review report]

## Test Results
- Tier 1 (static): PASS
- Tier 2 (unit/integration): PASS [X/Y tests]
- Tier 3 (E2E): PASS/N/A
- Coverage: X%

## Review
[from /review verdict]

## Deployment Notes
[any special considerations]
EOF
)"
```

### Step 6: Post-Ship

After merge:
- Monitor for errors (suggest `/canary` for production monitoring)
- Update `.planning/STATE.md` if applicable
- Mark task as done if using task management

## Output

Report:
```
SHIP COMPLETE
  Branch: feat/feature-name
  PR: #123
  Tests: 45 passed, 0 failed
  Coverage: 87%
  Review: CLEAN

  Next: Run /canary to monitor production
```
