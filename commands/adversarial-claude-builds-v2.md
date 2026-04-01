# Adversarial Build V2: Claude Builds, Codex Attacks + Architect Review

V2 improvements over V1:
- Git worktree isolation (zero-risk reverts)
- Two-pass review: Adversary (find bugs) + Architect (check design)
- Structured JSON requirements support
- No destructive git commands

Claude Code is the BUILDER. Codex is the ADVERSARY and the ARCHITECT. Two different AI companies, two different models, two different blind spots. What Claude misses, Codex catches — first for bugs, then for design.

Uses three ML concepts:
1. **Ralph Loop** — iterate through requirements, one per cycle
2. **GAN-inspired** — Builder (Claude) vs Adversary (Codex), adversarial review + architect review
3. **Autoresearch (Karpathy)** — test pass count is the metric, must never decrease, revert if it does

Input: $ARGUMENTS (number of iterations, default 10)

## Process

Set ITERATIONS to $ARGUMENTS or 10 if not provided.
Set BASELINE_PASS to 0.

### Step 0: Capture Baseline Score

Run `npm test` and count passing/failing tests. Record as BASELINE_PASS.
Run `npx tsc --noEmit` to check types.
Report: "Baseline: X passing, Y failing"

### Step 1: Start the Ralph Loop

For each iteration (1 to ITERATIONS):

#### 1a. Find Next Requirement

**If `.planning/requirements.json` exists (structured JSON):**
Read the file. Find the first requirement where `"status"` is `"pending"` or unchecked.

**Otherwise, fall back to `.planning/REQUIREMENTS.md`:**
Find the FIRST line matching `- [ ]` (unchecked).

If no unchecked requirements remain, report "ALL REQUIREMENTS COMPLETE" and stop.

Read `.planning/STATE.md` to know the current phase.

#### 1b. Phase Gate (Autoresearch)

If the current phase changed from the previous iteration:
- Run full test suite
- Compare pass count to phase start
- If pass count DROPPED: STOP. Report "REGRESSION DETECTED at phase boundary. Do not build on broken foundation." Do not continue.
- If pass count held or improved: continue

#### 1c. Measure Before (Autoresearch)

Run `npm test`, count passing tests. Record as BEFORE_PASS.

#### 1d. CREATE WORKTREE

Create a git worktree for this iteration. All build work happens in isolation.

```bash
BRANCH_NAME="wt/adversarial-[iteration]-[short-slug]"
git worktree add "../worktree-adversarial-[iteration]" -b "$BRANCH_NAME"
cd "../worktree-adversarial-[iteration]"
```

All subsequent steps for this iteration happen inside the worktree.

#### 1e. BUILD (Claude — you are the builder)

Read the requirement text. Read relevant code files. Follow existing patterns.

Build this ONE requirement:
- Write implementation code
- Write tests for what you built
- Do NOT check the box yet
- Do NOT merge yet

#### 1f. Measure After Build (Autoresearch)

Run `npx tsc --noEmit && npm test`. Count passing tests as AFTER_PASS.

**TypeScript Hard Gate:** `npx tsc --noEmit` MUST exit 0. If it does not, fix type errors before proceeding. Do not skip this.

If AFTER_PASS < BEFORE_PASS:
- Score dropped. Try to fix (up to 3 attempts, each MORE CONSERVATIVE than the last).
- Attempt 1: fix the obvious bug
- Attempt 2: smaller fix, only touch lines that caused failure
- Attempt 3: minimal change
- If still below BEFORE_PASS after 3 attempts: DELETE THE WORKTREE (zero mess)
  ```bash
  cd [main-project-dir]
  git worktree remove "../worktree-adversarial-[iteration]" --force
  git branch -D "$BRANCH_NAME"
  ```
- Log: "REVERTED (worktree deleted): [requirement] — score dropped and could not heal"
- Continue to next iteration

#### 1g. ADVERSARY PASS (Codex — call via Codex plugin)

<IMPORTANT>
Call the Codex plugin/tool with this exact prompt. Do NOT skip this step. Do NOT review the code yourself instead — the whole point is a DIFFERENT model reviews it.
</IMPORTANT>

Get the diff with `git diff main`.

Send to Codex (via the Codex plugin or by running `codex exec --full-auto` in a subshell):

```
You are the ADVERSARY agent. Your job is to BREAK the code that was just written.

Here is what changed:
[paste the git diff]

Your mission:
1. Read the diff carefully
2. Find bugs: edge cases not handled, missing null checks, missing error handling,
   SQL injection, XSS, race conditions, off-by-one errors, missing validation,
   broken existing functionality
3. For each bug you find, write a FAILING TEST that exposes it
4. Add these tests to the existing test files
5. Run: npm test
6. Report what you found

Be ruthless. Think like a hacker and a QA engineer combined.
If you genuinely cannot find any bugs, say "NO BUGS FOUND" and stop.
```

#### 1h. Fix Adversary Findings

If Codex found bugs and wrote failing tests:
- Read the new failing tests
- Fix the CODE (not the tests) to make them pass
- Run `npm test` to verify
- Up to 2 fix rounds

#### 1i. ARCHITECT PASS (Codex — second review)

<IMPORTANT>
This is the V2 addition. After the adversary pass, Codex does an ARCHITECT review. Do NOT skip this.
</IMPORTANT>

Get the updated diff with `git diff main`.

Send to Codex (via the Codex plugin or by running `codex exec --full-auto` in a subshell):

```
You are the ARCHITECT reviewer. This code survived adversarial testing.
Now check: Does it follow existing patterns? Is it maintainable? No unnecessary abstractions?
Would a senior engineer approve this in PR review? Say ARCHITECTURE APPROVED or list concerns.

Here is the full diff from main:
[paste the git diff]

Review for:
1. Pattern consistency — does it match the existing codebase style?
2. Maintainability — will this be easy to modify in 6 months?
3. Unnecessary complexity — any over-engineering or premature abstraction?
4. Naming — are variables, functions, and files named clearly?
5. Separation of concerns — is business logic mixed with presentation?

If all checks pass: say "ARCHITECTURE APPROVED"
If concerns exist: list them with severity (MUST FIX / SHOULD FIX / NICE TO HAVE)
```

If MUST FIX concerns are raised:
- Address them in the worktree
- Run tests again to verify nothing broke
- Re-send for architect review (max 1 re-review)

SHOULD FIX and NICE TO HAVE are logged but do not block the commit.

#### 1j. Final Score Check (Autoresearch — the iron law)

Run `npx tsc --noEmit` AND `npm test`. Count passing as FINAL_PASS, failing as FINAL_FAIL.

ALL FOUR must be true to merge:
1. TypeScript compiles cleanly (`npx tsc --noEmit` exits 0)
2. Pass count did not drop (FINAL_PASS >= BEFORE_PASS)
3. Zero failing tests (FINAL_FAIL == 0)
4. Architect review passed (no unresolved MUST FIX concerns)

If ANY gate fails:
- DELETE THE WORKTREE (zero mess in main tree):
  ```bash
  cd [main-project-dir]
  git worktree remove "../worktree-adversarial-[iteration]" --force
  git branch -D "$BRANCH_NAME"
  ```
- Log: "REVERTED (worktree deleted): [requirement] — [which gate failed]"
- Continue to next iteration

If ALL gates pass:
- MERGE to main.

#### 1k. Merge and Commit

```bash
cd [main-project-dir]
git merge "$BRANCH_NAME" --no-ff -m "feat: [requirement summary] (Phase N) — score: BEFORE→FINAL (+delta), adversary+architect approved"
git worktree remove "../worktree-adversarial-[iteration]"
git branch -d "$BRANCH_NAME"
```

- Update requirements: change `- [ ]` to `- [x]` (or update `requirements.json` status to `"done"`)
- Commit the requirements update: `git add .planning/REQUIREMENTS.md && git commit -m "chore: mark [requirement] complete"`
- Log: "COMMITTED: [requirement] | Score: BEFORE → FINAL | Adversary: PASS | Architect: PASS"

#### 1l. Report and Continue

Report iteration summary:
```
Iteration X/N | Phase P
Requirement: [text]
Builder: Claude | Adversary: Codex | Architect: Codex
Score: BEFORE → FINAL (+delta)
Adversary: [N bugs found / NO BUGS FOUND]
Architect: [APPROVED / N concerns addressed]
Status: COMMITTED / REVERTED / BLOCKED
Isolation: worktree [merged / deleted]
```

Continue to next iteration.

### Step 2: Final Report

After all iterations, report:

```
ADVERSARIAL BUILD V2 COMPLETE
Builder: Claude Code | Adversary: Codex | Architect: Codex
Baseline: X passing | Final: Y passing | Net: +Z
Committed: N | Reverted: N | Blocked: N
Architect concerns resolved: N
Worktrees created: N | Merged: N | Deleted: N
```

## Rules

- NEVER skip the adversary step. The cross-model review is the whole point.
- NEVER skip the architect step. Design review catches what tests cannot.
- NEVER modify tests just to make them pass (unless genuinely wrong).
- NEVER check the requirement box before BOTH adversary and architect review.
- NEVER proceed past a phase boundary if tests regressed.
- NEVER use destructive git commands on the main tree — worktrees isolate all risk.
- NEVER use `git checkout -- .` or `git reset --hard` — delete the worktree instead.
- ONE requirement per iteration. Not two. Not "while I'm here."
- TypeScript MUST compile cleanly before any review step. This is a hard gate.
- If Codex plugin is unavailable, fall back to `codex exec --full-auto` in a Bash subshell.
