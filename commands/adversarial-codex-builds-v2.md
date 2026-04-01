# Adversarial Build V2: Codex Builds, Claude Attacks + Architect Review

V2 improvements over V1:
- Git worktree isolation (zero-risk reverts)
- Two-pass review: Adversary (find bugs) + Architect (check design)
- Structured JSON requirements support
- No destructive git commands

Codex is the BUILDER. Claude Code is the ADVERSARY and the ARCHITECT. Codex writes the code cheaply and fast. Claude reviews with deeper reasoning — first for bugs, then for design. Two companies, adversarial.

Uses three ML concepts:
1. **Ralph Loop** — iterate through requirements, one per cycle
2. **GAN-inspired** — Builder (Codex) vs Adversary (Claude), adversarial review + architect review
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
- If pass count DROPPED: STOP. Report "REGRESSION DETECTED at phase boundary." Do not continue.
- If pass count held or improved: continue

#### 1c. Measure Before (Autoresearch)

Run `npm test`, count passing tests. Record as BEFORE_PASS.

#### 1d. CREATE WORKTREE

Create a git worktree for this iteration. All build work happens in isolation.

```bash
BRANCH_NAME="wt/adversarial-[iteration]-[short-slug]"
git worktree add "../worktree-adversarial-[iteration]" -b "$BRANCH_NAME"
```

All subsequent steps for this iteration happen inside the worktree.

#### 1e. BUILD (Codex — call via plugin or subshell)

<IMPORTANT>
Do NOT build the code yourself. Codex is the builder. Call it via plugin or subshell.
</IMPORTANT>

Read the requirement text. Send to Codex:

```
codex exec --full-auto "You are the BUILDER agent.

Read AGENTS.md for project rules.
Read .planning/REQUIREMENTS.md — find this requirement: [REQUIREMENT TEXT]
Read .planning/STATE.md for current phase context.

BUILD this ONE requirement:
1. Read existing code first — follow established patterns
2. Write the implementation code
3. Write tests for what you built
4. Run: npx tsc --noEmit && npm test
5. Do NOT check the box yet — the Adversary reviews first
6. Do NOT commit yet

If the requirement is too big, build the smallest meaningful slice."
```

Wait for Codex to finish.

#### 1f. Measure After Build (Autoresearch)

Run `npx tsc --noEmit && npm test`. Count passing tests as AFTER_PASS.

**TypeScript Hard Gate:** `npx tsc --noEmit` MUST exit 0. If it does not, send Codex a fix request for type errors before proceeding. Do not skip this.

If AFTER_PASS < BEFORE_PASS:
- Score dropped. Send Codex a heal request (up to 3 attempts, each more conservative).
- If still below BEFORE_PASS after 3 attempts: DELETE THE WORKTREE (zero mess)
  ```bash
  cd [main-project-dir]
  git worktree remove "../worktree-adversarial-[iteration]" --force
  git branch -D "$BRANCH_NAME"
  ```
- Log: "REVERTED (worktree deleted): [requirement] — score dropped and could not heal"
- Continue to next iteration

#### 1g. ADVERSARY PASS (Claude — YOU are the attacker)

<IMPORTANT>
This is YOUR job. You are the adversary. Codex built the code. Now you try to BREAK it.
Do NOT be gentle. Do NOT assume the code is correct. ATTACK it.
</IMPORTANT>

Run `git diff main` to see what Codex wrote.

Now attack:
1. Read the diff line by line
2. Think like a hacker and a QA engineer combined
3. Look for: edge cases not handled, missing null checks, missing error handling, SQL injection, XSS, race conditions, off-by-one errors, missing validation, broken existing functionality, incorrect logic, type mismatches, missing await on promises
4. For each bug you find, write a FAILING TEST that exposes it
5. Add these tests to the existing test files
6. Run `npm test`
7. Report what you found

If you genuinely cannot find bugs after thorough review, report "NO BUGS FOUND."

#### 1h. Fix Adversary Findings

If you (Claude) found bugs and wrote failing tests:
- Send Codex the failing tests and ask it to fix the CODE:

```
codex exec --full-auto "The ADVERSARY found bugs in your code.
There are N failing tests. Fix the CODE (not the tests) to make them pass.
The adversary's tests are valid — they found real bugs.
Run: npx tsc --noEmit && npm test
Fix the bugs. Do not delete or modify the adversary's tests."
```

- Run `npm test` to verify
- Up to 2 rounds of fix-then-verify

#### 1i. ARCHITECT PASS (Claude — YOU are the architect)

<IMPORTANT>
This is the V2 addition. After the adversary pass, YOU do an ARCHITECT review. Do NOT skip this.
</IMPORTANT>

Run `git diff main` to see the full set of changes.

Now review as a senior architect:
1. **Pattern consistency** — does it match the existing codebase style?
2. **Maintainability** — will this be easy to modify in 6 months?
3. **Unnecessary complexity** — any over-engineering or premature abstraction?
4. **Naming** — are variables, functions, and files named clearly?
5. **Separation of concerns** — is business logic mixed with presentation?

Your advantage as architect: you have deeper reasoning than Codex. USE IT. Think about architectural implications, not just syntax bugs.

If MUST FIX concerns are found:
- Send Codex a fix request with specific instructions:
  ```
  codex exec --full-auto "The ARCHITECT reviewer found design concerns in your code.
  MUST FIX:
  [list concerns]
  Fix these issues while keeping all tests passing.
  Run: npx tsc --noEmit && npm test"
  ```
- Verify the fixes
- Re-review (max 1 re-review)

SHOULD FIX and NICE TO HAVE are logged but do not block the merge.

Report: "ARCHITECTURE APPROVED" or list unresolved concerns.

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
Builder: Codex | Adversary: Claude | Architect: Claude
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
Builder: Codex | Adversary: Claude Code | Architect: Claude Code
Baseline: X passing | Final: Y passing | Net: +Z
Committed: N | Reverted: N | Blocked: N
Architect concerns resolved: N
Worktrees created: N | Merged: N | Deleted: N
```

## Rules

- NEVER build the code yourself. Codex is the builder. You are the reviewer.
- NEVER go easy on the review. You are the ADVERSARY. Be ruthless.
- NEVER skip the architect step. Design review catches what tests cannot.
- NEVER modify tests just to make them pass (unless genuinely wrong).
- NEVER check the requirement box before BOTH adversary and architect review.
- NEVER proceed past a phase boundary if tests regressed.
- NEVER use destructive git commands on the main tree — worktrees isolate all risk.
- NEVER use `git checkout -- .` or `git reset --hard` — delete the worktree instead.
- ONE requirement per iteration. Not two. Not "while I'm here."
- TypeScript MUST compile cleanly before any review step. This is a hard gate.
- Your advantage as adversary AND architect: you have deeper reasoning than Codex. USE IT. Think about architectural implications, not just syntax bugs.
- If Codex plugin is unavailable, fall back to `codex exec --full-auto` in a Bash subshell.
