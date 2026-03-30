# Verify With Codex

Generate a structured review of recent work for cross-verification by a second model (Codex, or any other LLM). Use after completing a feature, before merging, or when you don't trust the output.

Optional: $ARGUMENTS (number of commits to review, default 5. Pass "all-phase" to review an entire GSD phase.)

## Why This Exists

Claude Code builds. But Claude reviewing its own work is like grading your own exam. A second model catches blind spots, hallucinated completions, and subtle logic bugs that the builder missed. This command packages the work into a review-ready format.

Adapted from:
- levnikolaevich's 4-level quality gate — PASS / CONCERNS / REWORK / FAIL (not just "looks ok")
- Jesse Vincent's two-stage review — spec compliance first, then code quality (order matters)
- runesleo's task routing — "Codex for cross-verification, second opinions"

## Process

### 1. Gather the Diff

Determine scope:
- If `$ARGUMENTS` is a number: `git diff HEAD~$ARGUMENTS..HEAD`
- If `$ARGUMENTS` is "all-phase": read the most recent GSD phase's SUMMARY files to find the commit range
- If no argument: default to last 5 commits

```bash
COMMIT_COUNT=${ARGUMENTS:-5}
git log --oneline -$COMMIT_COUNT
git diff HEAD~$COMMIT_COUNT..HEAD --stat
git diff HEAD~$COMMIT_COUNT..HEAD
```

Also gather:
```bash
# What was the intent?
cat .planning/phases/*-PLAN.md 2>/dev/null | tail -100   # Most recent plan
cat .planning/REQUIREMENTS.md 2>/dev/null | head -50      # Requirements
```

### 2. Build the Review Prompt

Create a file at `.planning/reviews/review-YYYY-MM-DD-HH.md`:

```markdown
# Code Review Request
**Date:** [timestamp]
**Commits:** [range]
**Files changed:** [N]
**Lines added/removed:** [+N/-N]

## What Was Built
_From GSD plan/summary:_
[Summary of the intended feature/fix]

## Acceptance Criteria
_From GSD requirements/plan:_
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- ...

## The Diff
```diff
[Full diff output]
```

## Review Instructions

You are reviewing code written by an AI coding agent. The agent may have:
- Marked work as complete without actually finishing it
- Written code that passes TypeScript but has logic errors
- Added unnecessary complexity or dead code
- Missed edge cases from the requirements
- Made changes that look correct but break existing functionality

### Stage 1: Spec Compliance Review
For each acceptance criterion above, check:
- [ ] Is this criterion actually met by the code? (not just claimed)
- [ ] Is anything EXTRA built that wasn't requested? (scope creep)
- [ ] Is anything MISSING that should be there?

### Stage 2: Code Quality Review
- [ ] Are there any logic errors or incorrect assumptions?
- [ ] Are error cases handled properly?
- [ ] Are there hardcoded values that should be configurable?
- [ ] Is there dead code or unused imports?
- [ ] Do the types accurately represent the data?
- [ ] Are there obvious performance problems?

### Verdict
Rate as one of:
- **PASS** — Ship it. No issues found.
- **CONCERNS** — Minor issues. List them. Can ship with fixes.
- **REWORK** — Significant problems. List them. Needs another pass.
- **FAIL** — Fundamental issues. Describe what's wrong.
```

### 3. Output for the User

Tell the user:

```
📋 Review package created: .planning/reviews/review-[date].md

To cross-verify:
1. Open Codex terminal: codex
2. Paste: "Read .planning/reviews/review-[date].md and perform the review"

Or copy the review prompt to ChatGPT / any other model.

Waiting for verdict? Paste the response back here and I'll apply fixes.
```

### 4. Process the Verdict (When User Returns)

When the user pastes back a review response, parse the verdict:

- **PASS**: "✅ Cross-verification passed. Safe to continue."
- **CONCERNS**: List the concerns. Ask: "Want me to fix these now? `/gsd:quick` can handle minor fixes."
- **REWORK**: List the problems. Create GitHub issues for each one (using Matt Pocock's QA skill format — durable, no file paths, behavior descriptions).
- **FAIL**: "❌ Fundamental issues found. Do NOT merge. Problems: [list]. Recommend: re-run the GSD phase or rethink the approach."

## Rules

- NEVER skip Stage 1 (spec compliance) — code quality means nothing if the wrong thing was built
- NEVER generate the verdict yourself — the whole point is a SECOND model reviews it
- ALWAYS include the full diff in the review file — the reviewer needs complete context
- ALWAYS include acceptance criteria — without them, the reviewer can't judge spec compliance
- If the diff is too large (>5000 lines), split into logical chunks and create multiple review files
- The review file is committed to the repo — it's a durable record of what was reviewed and when
