# Adversarial Build: Claude Builds, Codex Attacks

Claude Code is the BUILDER. Codex is the ADVERSARY. Two different AI companies, two different models, two different blind spots. What Claude misses, Codex catches.

Uses three ML concepts:
1. **Ralph Loop** — iterate through requirements, one per cycle
2. **GAN-inspired** — Builder (Claude) vs Adversary (Codex), adversarial review
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
- If pass count DROPPED: STOP. Report "REGRESSION DETECTED at phase boundary. Do not build on broken foundation." Do not continue.
- If pass count held or improved: continue

#### 1c. Measure Before (Autoresearch)

Run `npm test`, count passing tests. Record as BEFORE_PASS.

#### 1d. BUILD (Claude — you are the builder)

Read the requirement text. Read relevant code files. Follow existing patterns.

Build this ONE requirement:
- Write implementation code
- Write tests for what you built
- Do NOT check the box yet
- Do NOT commit yet

#### 1e. Measure After Build (Autoresearch)

Run `npx tsc --noEmit && npm test`. Count passing tests as AFTER_PASS.

If AFTER_PASS < BEFORE_PASS:
- Score dropped. Try to fix (up to 3 attempts, each MORE CONSERVATIVE than the last).
- Attempt 1: fix the obvious bug
- Attempt 2: smaller fix, only touch lines that caused failure
- Attempt 3: minimal change, revert if can't fix
- If still below BEFORE_PASS after 3 attempts: revert ALL changes with `git checkout -- .`
- Log: "REVERTED: [requirement] — score dropped and could not heal"
- Continue to next iteration

#### 1f. ADVERSARY (Codex — call via Codex plugin)

<IMPORTANT>
Call the Codex plugin/tool with this exact prompt. Do NOT skip this step. Do NOT review the code yourself instead — the whole point is a DIFFERENT model reviews it.
</IMPORTANT>

Get the diff with `git diff`.

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

#### 1g. Fix Adversary Findings

If Codex found bugs and wrote failing tests:
- Read the new failing tests
- Fix the CODE (not the tests) to make them pass
- Run `npm test` to verify
- Up to 2 fix rounds

#### 1h. Final Score Check (Autoresearch — the iron law)

Run `npm test`. Count passing as FINAL_PASS.

If FINAL_PASS < BEFORE_PASS:
- Score STILL below baseline. REVERT all changes: `git checkout -- .`
- Log: "REVERTED: [requirement] — final score below baseline"
- Continue to next iteration

If FINAL_PASS >= BEFORE_PASS:
- Score held or improved. COMMIT.

#### 1i. Commit

- Edit `.planning/REQUIREMENTS.md` — change `- [ ]` to `- [x]` for this requirement
- `git add -A`
- Commit with message: `feat: [requirement summary] (Phase N) — score: BEFORE→FINAL (+delta)`
- Log: "COMMITTED: [requirement] | Score: BEFORE → FINAL"

#### 1j. Report and Continue

Report iteration summary:
```
Iteration X/N | Phase P
Requirement: [text]
Builder: Claude | Adversary: Codex
Score: BEFORE → FINAL (+delta)
Status: COMMITTED / REVERTED / BLOCKED
```

Continue to next iteration.

### Step 2: Final Report

After all iterations, report:

```
ADVERSARIAL BUILD COMPLETE
Builder: Claude Code | Adversary: Codex
Baseline: X passing | Final: Y passing | Net: +Z
Committed: N | Reverted: N | Blocked: N
```

## Rules

- NEVER skip the adversary step. The cross-model review is the whole point.
- NEVER modify tests just to make them pass (unless genuinely wrong).
- NEVER check the requirement box before the adversary reviews.
- NEVER proceed past a phase boundary if tests regressed.
- ONE requirement per iteration. Not two. Not "while I'm here."
- If Codex plugin is unavailable, fall back to `codex exec --full-auto` in a Bash subshell.
