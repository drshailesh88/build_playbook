# Ralph Stall Recovery — Runbook

When Ralph stalls, crashes, or a story drags past 30 minutes, follow this
page. In order.

## Quick status check

```bash
# Where was the factory when it stopped (cursor from the pinned GitHub
# tracking issue, falls back to ralph/loop-cursor.json offline) + parked list:
./ralph/gh-state.sh recover
```

```bash
# What story Ralph thinks it's on, and how long it's been running:
ps -o pid,etime,pcpu,command -p $(pgrep -f "claude.*opus-4-6" | head -1) 2>/dev/null

# How many stories are done:
python3 -c "import json; d=json.load(open('ralph/prd.json')); print(sum(1 for x in d if x.get('passes')), '/', len(d))"

# Recent RALPH commits:
git log --grep='^RALPH:' -n 5 --oneline

# Latest build log tail:
tail -30 "$(ls -t ralph/ralph-build-*.log | head -1)"
```

## Decide what kind of stall this is

| Symptom | Diagnosis | Action |
|---|---|---|
| Claude process alive, CPU ~0%, no log movement for 10+ min | Claude waiting on a headless buffered response | Wait 5 more min. `claude -p` doesn't stream. |
| Claude process alive, CPU churning, no new commit in 30 min | Story is too big OR agent is looping on something | Go to "Soft interrupt" below. |
| Claude process gone, `bash build.sh` still alive | Iteration finished (maybe ABORT), loop re-entering | Watch for new iter starting. If nothing in 60s, check log tail for ABORT. |
| Untracked files appearing that aren't in the story's `behavior` | **Scope creep** — Ralph inventing helpers | Go to "Soft interrupt" + review files before restart. |
| `exit 143` / `exit 137` in build log | Test runner killed (OOM, SIGKILL) | Story's spec needs a "partial-OK" ladder. See "Fix the spec" below. |
| `<promise>ABORT</promise>` in output | Ralph correctly escalated | Read the diagnostic. Fix the blocker. Manually mark the story or rewrite its spec, then restart. |

## Soft interrupt (let current iter finish, then pause)

This is the default. Doesn't lose work.

```bash
# Find the parent PIDs:
pgrep -f "ralph/run.sh"    # top-level runner
pgrep -f "ralph/build.sh"  # build loop

# Wait until the current iteration's claude process exits, THEN:
kill <run.sh PID>
```

Ralph commits whatever it's about to commit; the loop exits cleanly.

## Hard interrupt (kill everything right now)

Only if truly stuck AND you don't care about losing the current iteration.

```bash
pkill -f "ralph/run.sh"
pkill -f "ralph/build.sh"
pkill -f "claude.*opus-4-6"
```

Then check `git status` for any partial work Ralph was mid-commit on. If
anything looks half-done and UNcommitted, `git restore .` to discard it —
those changes are unsafe to keep (no passing tests, no commit).

## After the interrupt — triage

1. **Check what's untracked.** `git status --short` will show any file
   Ralph created that isn't committed. If the current story doesn't
   mention that file in its `behavior`, delete it:
   ```bash
   rm <unexpected-file>
   ```
2. **Check what's uncommitted but modified.** If source files were
   modified but no `RALPH:` commit landed for the current story, either
   the story mid-failed or it was about to commit. `git diff` to review;
   `git restore .` to discard if it's unsalvageable.
3. **Read the log.** `tail -100 ralph/ralph-build-*.log | less`. Look
   for ABORT rationale, error messages, or what the agent was doing.

## Fix the spec (when Stryker-style OOMs recur)

Many Ralph stories implicitly assume full-system resources. On a laptop,
that's not always true. The fix is to add a ladder of acceptable outcomes
to the story's `behavior` in `prd.json`:

```
Preferred: full baseline with all 107 files scored.
Acceptable: partial baseline with >=60 modules scored; record a note in
  qa/baselines/ explaining which modules were skipped and why.
Unacceptable: zero-module baseline, or inventing workaround config files
  to mask the failure. ABORT in that case.
```

Then flip `passes:false` for that story and restart. Ralph will reread the
updated `behavior` on the next iteration and act accordingly.

## Restart

```bash
./ralph/run.sh 999 0
```

Two args:
- First = max build iterations (`999` = until done).
- Second = max QA iterations (`0` = skip QA phase for now; fire QA only
  after build fully completes).

## When to call it a day vs keep trying

- **Keep trying**: ABORT happened, you fixed the spec or reverted a
  workaround, restart and it ships. Normal.
- **Call it a day**: same story ABORTs twice in a row after spec fixes.
  Something is structurally wrong (missing schema, missing dep, spec
  assumes something false). Bring it to a human — write the diagnosis in
  `ralph/STUCK.md` and pause Ralph until resolved.

## Judge rejections (story keeps flipping back to passes:false)

The judge ladder (`ralph/judge.sh`) reverts a story's `passes` flag when a
tier fails. Diagnose from the verdict, not the log:

```bash
# Why was the story rejected:
python3 -m json.tool ralph/verdicts/<story-id>.json

# How many times has it been rejected:
python3 -c "import json; d=json.load(open('ralph/prd.json')); print(next(x.get('judge_failures',0) for x in d if x['id']=='<story-id>'))"
```

- **T0 failure** — an invariant broke (locked path touched, secret pattern,
  contract hash mismatch). The builder cannot fix a contract mismatch; a
  human must decide: restore the contract file (`git checkout -- ralph/contracts/`)
  or sign a refreeze (`FREEZE_ACK=<id> ./ralph/freeze-contracts.sh --refreeze <id>`).
- **T1 failure** — tests/tsc/lint. Normal; the builder retries with the
  verdict as feedback. Worry only after 3 rejections.
- **T2 ESCALATE** — the semantic judge found an unauthorized decision or a
  contradictory contract. This is for YOU, not the loop. Read the verdict's
  reasons, decide, then either fix the contract (refreeze) or add the
  decision to `.planning/` and re-run.
- **Recurring same-class rejection** — promote it: append a rule to
  `ralph/t0-rules.jsonl` so the mistake becomes structurally impossible
  (the ratchet rule).

## Known stall patterns

- **Full Stryker baseline** (story cert-code-005-style) tends to OOM on a
  laptop. Run on CI or add partial-OK ladder to the spec.
- **Full Playwright suite** against local dev server can hang if the dev
  server crashes mid-run. Check the dev server log if Playwright times
  out.
- **First iteration of a new block** is slower — Ralph is exploring new
  module conventions. Give it 15 min before worrying.
