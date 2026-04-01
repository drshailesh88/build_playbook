# Adversarial Build: Codex Builds, Claude Attacks

Codex is the BUILDER. Claude Code is the ADVERSARY. Codex writes the code cheaply and fast. Claude reviews with deeper reasoning. Two companies, adversarial.

Uses three ML concepts:
1. **Ralph Loop** — iterate through requirements, one per cycle
2. **GAN-inspired** — Builder (Codex) vs Adversary (Claude), adversarial review
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

Read `.planning/REQUIREMENTS.md`. Find the FIRST line matching `- [ ]` (unchecked).
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

#### 1d. BUILD (Codex — call via plugin or subshell)

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

#### 1e. Measure After Build (Autoresearch)

Run `npx tsc --noEmit && npm test`. Count passing tests as AFTER_PASS.

If AFTER_PASS < BEFORE_PASS:
- Score dropped. Send Codex a heal request (up to 3 attempts, each more conservative).
- If still below BEFORE_PASS after 3 attempts: REVERT only files changed in this iteration: `git diff --name-only | xargs git checkout --` and remove new files created this iteration
- Log: "REVERTED: [requirement] — score dropped and could not heal"
- Continue to next iteration

#### 1f. ADVERSARY (Claude — YOU are the attacker)

<IMPORTANT>
This is YOUR job. You are the adversary. Codex built the code. Now you try to BREAK it.
Do NOT be gentle. Do NOT assume the code is correct. ATTACK it.
</IMPORTANT>

Run `git diff` to see what Codex wrote.

Now attack:
1. Read the diff line by line
2. Think like a hacker and a QA engineer combined
3. Look for: edge cases not handled, missing null checks, missing error handling, SQL injection, XSS, race conditions, off-by-one errors, missing validation, broken existing functionality, incorrect logic, type mismatches, missing await on promises
4. For each bug you find, write a FAILING TEST that exposes it
5. Add these tests to the existing test files
6. Run `npm test`
7. Report what you found

If you genuinely cannot find bugs after thorough review, report "NO BUGS FOUND."

#### 1g. Fix Adversary Findings

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

#### 1h. Final Score Check (Autoresearch — the iron law)

Run `npx tsc --noEmit` AND `npm test`. Count passing as FINAL_PASS, failing as FINAL_FAIL.

ALL THREE must be true to commit:
1. TypeScript compiles cleanly (`npx tsc --noEmit` exits 0)
2. Pass count did not drop (FINAL_PASS >= BEFORE_PASS)
3. Zero failing tests (FINAL_FAIL == 0)

If ANY gate fails:
- REVERT only the files changed in this iteration (NOT `git checkout -- .` which destroys unrelated work)
- Use: `git diff --name-only | xargs git checkout --`
- Log: "REVERTED: [requirement] — [which gate failed]"
- Continue to next iteration

If ALL gates pass:
- COMMIT.

#### 1i. Commit

- Edit `.planning/REQUIREMENTS.md` — change `- [ ]` to `- [x]` for this requirement
- Stage only files you changed (NOT `git add -A` which commits unrelated dirty files)
- Use: `git diff --name-only | xargs git add` then `git add .planning/REQUIREMENTS.md`
- Commit with message: `feat: [requirement summary] (Phase N) — score: BEFORE→FINAL (+delta)`
- Log: "COMMITTED: [requirement] | Score: BEFORE → FINAL"

#### 1j. Report and Continue

Report iteration summary:
```
Iteration X/N | Phase P
Requirement: [text]
Builder: Codex | Adversary: Claude
Score: BEFORE → FINAL (+delta)
Status: COMMITTED / REVERTED / BLOCKED
```

Continue to next iteration.

### Step 2: Final Report

After all iterations, report:

```
ADVERSARIAL BUILD COMPLETE
Builder: Codex | Adversary: Claude Code
Baseline: X passing | Final: Y passing | Net: +Z
Committed: N | Reverted: N | Blocked: N
```

## Rules

- NEVER build the code yourself. Codex is the builder. You are the reviewer.
- NEVER go easy on the review. You are the ADVERSARY. Be ruthless.
- NEVER modify tests just to make them pass (unless genuinely wrong).
- NEVER check the requirement box before YOU have reviewed.
- NEVER proceed past a phase boundary if tests regressed.
- ONE requirement per iteration. Not two. Not "while I'm here."
- Your advantage as adversary: you have deeper reasoning than Codex. USE IT. Think about architectural implications, not just syntax bugs.
