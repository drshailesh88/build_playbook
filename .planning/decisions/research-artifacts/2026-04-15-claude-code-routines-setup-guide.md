# Your Claude Code Routines Setup Guide

A step-by-step guide to setting up three routines that will watch your repo, catch problems, and fix them — all while you sleep.

---

## Before You Start

**You need:**
- A Claude Pro or Max subscription
- Claude Code on the web enabled (claude.ai/code)
- Your GitHub repo connected to Claude Code
- About 20 minutes

**Go to:** [claude.ai/code/routines](https://claude.ai/code/routines)

---

## Routine 1: CI Failure Auto-Fixer (Most Important)

**What it does:** Every time a pull request is opened or updated, Claude reviews it. If CI fails, it reads the errors and pushes a fix automatically.

**Trigger:** GitHub → `pull_request.opened`

### Setup Steps

1. Click **New routine**
2. **Name:** `CI Failure Fixer`
3. **Prompt** — paste this exactly:

```
You are a CI failure fixer for a TypeScript project.

When triggered by a pull request:

1. First, check if CI has run on this PR. If CI hasn't completed yet, wait 2 minutes and check again.

2. If CI passed (all green), add a comment: "✅ All CI checks passed. No action needed."

3. If CI failed, do the following:
   a. Read the full CI logs and annotations
   b. Identify every error. Common errors in this project include:
      - "Cannot find module" — a file is being imported that doesn't exist or has the wrong path
      - "Parameter implicitly has an 'any' type" — TypeScript strict mode requires explicit types
      - "Node.js 20 actions are deprecated" — update the workflow to use Node.js 22
   c. Fix ALL errors, not just the first one
   d. Run `npx tsc --noEmit` locally to verify your fixes pass type checking
   e. Run `npm test` to verify unit tests still pass
   f. If your fixes break any existing tests, fix those too
   g. Commit with message: "fix: resolve CI failures [automated]"
   h. Push to the same PR branch

4. After pushing fixes, monitor CI for the new commit. If it fails again:
   a. Read the new errors
   b. Fix them
   c. Push again
   d. Maximum 2 fix attempts. If still failing after 2 attempts, add a comment explaining what's still broken and tag it for human review.

5. IMPORTANT: Never modify the core logic or business behavior of the code. Only fix type errors, import paths, missing types, and test issues.

Success = CI is green on this PR.
```

4. **Repository:** Select your repo
5. **Environment:** Default (or set up one with `npm ci` as the setup script)
6. **Trigger:** GitHub event → Pull request → `opened` and `synchronized`
7. **Filter:** Is draft = `false` (skip draft PRs)
8. Click **Create**

---

## Routine 2: Nightly Code Health Check

**What it does:** Every night at 2 AM, Claude scans your codebase for problems that might not trigger CI failures but still matter — unused imports, TODO comments piling up, outdated dependencies, and potential security issues.

**Trigger:** Scheduled → Daily at 2:00 AM

### Setup Steps

1. Click **New routine**
2. **Name:** `Nightly Code Health`
3. **Prompt** — paste this:

```
You are a nightly code health checker for a TypeScript project.

Run the following checks and create a summary:

1. TYPE SAFETY
   - Run `npx tsc --noEmit` and report any errors
   - If there are errors, fix them and commit

2. DEPENDENCY HEALTH
   - Run `npm audit` and report any vulnerabilities
   - If there are fix-able vulnerabilities, run `npm audit fix` and commit
   - Check for outdated packages with `npm outdated`

3. CODE QUALITY SCAN
   - Look for files with more than 300 lines (potential refactoring targets)
   - Count TODOs and FIXMEs across the codebase
   - Check for any console.log statements that shouldn't be in production code

4. TEST COVERAGE
   - Run tests with coverage: `npm test -- --coverage` (adjust command if needed)
   - Report the overall coverage percentage

5. SUMMARY
   - If you made any fixes, open a PR titled "chore: nightly health fixes [DATE]"
   - If no fixes needed, just log: "Nightly check: all clear"
   - If there are issues you can't auto-fix, create a GitHub issue titled "Code health items - [DATE]" listing them

Keep changes minimal and safe. Never refactor working code. Only fix clear errors and vulnerabilities.
```

4. **Repository:** Select your repo
5. **Trigger:** Schedule → Daily
6. Click **Create**

---

## Routine 3: PR Quality Reviewer

**What it does:** When any PR is opened, Claude reviews the code for quality issues before a human looks at it — checking for common AI-generated code problems, missing tests, security issues, and style.

**Trigger:** GitHub → `pull_request.opened`

### Setup Steps

1. Click **New routine**
2. **Name:** `PR Quality Reviewer`
3. **Prompt** — paste this:

```
You are a code reviewer for a TypeScript project. When a pull request is opened, review it thoroughly.

Review the diff and leave inline comments on the PR for:

1. CORRECTNESS
   - Do all imports reference files that actually exist?
   - Are all function parameters properly typed?
   - Are there any obvious logic errors?
   - Does error handling cover edge cases?

2. AI CODE SMELL DETECTION
   - Overly complex solutions where a simpler one exists
   - Hallucinated imports (referencing packages or files that don't exist)
   - Inconsistent naming conventions
   - Dead code or unused variables
   - Duplicated code that could be extracted

3. SECURITY
   - Hardcoded secrets, API keys, or tokens
   - SQL injection or XSS vulnerabilities
   - Unsafe use of eval() or similar
   - Missing input validation

4. TESTING
   - Does this PR include tests for new functionality?
   - If not, mention that tests should be added
   - Do existing tests still make sense with the changes?

5. SUMMARY COMMENT
   Post a single summary comment at the top of the PR with:
   - 🟢 PASS / 🟡 CONCERNS / 🔴 ISSUES FOUND
   - A 2-3 sentence summary of findings
   - List of specific items to address (if any)

Be constructive, not harsh. Remember the developer may be non-technical and building with AI assistance. Explain WHY something is a problem, not just WHAT is wrong.

Do NOT make changes. Only review and comment.
```

4. **Repository:** Select your repo
5. **Trigger:** GitHub event → Pull request → `opened`
6. **Filter:** Is draft = `false`
7. Click **Create**

---

## Important: Set Up Branch Protection First

Before these routines are useful, you need to stop pushing directly to `main`. Here's how:

1. Go to your repo on GitHub
2. **Settings** → **Branches** → **Add branch protection rule**
3. Branch name pattern: `main`
4. Enable:
   - ✅ Require a pull request before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require conversation resolution before merging
5. Click **Create**

Now your workflow becomes:
- Code goes to a branch (not main)
- PR is opened
- Routine 3 reviews it automatically
- CI runs
- If CI fails, Routine 1 fixes it
- You review and merge when everything is green

---

## Your New Daily Workflow

```
Morning:
  Check your phone for notifications from GitHub
  ├── Routine 2 ran overnight → any health PRs to approve?
  ├── Routine 3 reviewed any open PRs → read the summary comments
  └── Routine 1 fixed any CI failures → check if PRs are green

During the day:
  You (or Ralph) write code → push to a branch → open PR
  ├── Routine 3 automatically reviews within minutes
  ├── CI runs → if it fails, Routine 1 auto-fixes
  └── You approve and merge when ready

That's it. You're the project manager. The routines are your team.
```

---

## Usage Limits to Know

| Plan | Daily routine runs |
|------|-------------------|
| Pro  | 5 per day         |
| Max  | 15 per day        |
| Team | 25 per day        |

With 3 routines, Pro gives you room for ~2 PRs per day to be auto-reviewed and auto-fixed, plus the nightly check. If you're actively building, Max is worth it for the headroom.

---

## Troubleshooting

**Routine didn't trigger?**
- Make sure the Claude GitHub App is installed on your repo (the setup flow prompts you)
- Check that you're not opening draft PRs (if you filtered those out)
- Visit claude.ai/code/routines to see run history

**Routine ran but didn't fix anything?**
- Click into the run session to see exactly what Claude did
- You can continue the conversation in that session to guide it

**Too many routine runs eating your daily limit?**
- Remove the `synchronized` trigger from Routine 1 (it fires on every push to the PR)
- Keep only `opened` if you want it to run once per PR

---

## What This Gives You

Before routines:
  You push code → CI fails → you see errors → you paste them to AI → AI fixes → you push again → repeat

After routines:
  You push code → routines handle everything → you get a notification when it's ready → you approve

You went from being the developer AND the QA team to being the person who approves work. That's the whole point.
