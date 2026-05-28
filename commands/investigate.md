# Investigate — Systematic Debugging

Adapted from gstack's /investigate skill. Enforces root cause analysis before any fix is applied. No band-aids. No "it works now, I don't know why."

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE
```

If you can't explain WHY something broke, you can't prove your fix actually fixes it. You might be hiding the bug, not fixing it.

## Process

### Phase 1: Collect Symptoms

Before touching any code:

1. **Reproduce the bug** — can you trigger it reliably?
2. **Read the error** — full stack trace, not just the message
3. **Check recent changes** — `git log --oneline -10` — did we just break this?
4. **Check learnings** — `/learn search [symptom]` — have we seen this before?
5. **Document what you know** — symptoms, reproduction steps, environment

### Phase 2: Hypothesis Formation

Generate 2-3 hypotheses. For each:
- What would cause this specific symptom?
- What evidence would confirm or reject this hypothesis?
- Where in the code would the bug live?

Common root cause patterns:
| Pattern | Clues |
|---------|-------|
| Race condition | Intermittent, timing-dependent, works in debug mode |
| Null propagation | "cannot read property of undefined/null" |
| State corruption | Works first time, breaks on repeat |
| Integration failure | Works locally, breaks in production/CI |
| Config drift | Works on one machine, not another |
| Stale cache | Works after clearing cache/restarting |

### Phase 3: Hypothesis Testing

For each hypothesis, in order of likelihood:

1. **Read the code** at the suspected location
2. **Add a diagnostic** (log, assertion, or debugger) to confirm
3. **Test the diagnostic** — does it confirm or reject?

**3-Strike Rule:** If 3 hypotheses are rejected, step back. Re-read the symptoms. You're probably looking in the wrong area.

### Phase 4: Root Cause Confirmed

Once you know the cause:

1. **Write a regression test FIRST** that fails with the current code
2. **Apply the minimal fix** — change as few lines as possible
3. **Verify the test passes** with the fix applied
4. **Check for siblings** — does this bug pattern exist elsewhere in the codebase?

### Phase 5: Report

```markdown
## Investigation Report

**Symptom:** [what the user saw]
**Root Cause:** [why it happened]
**Fix:** [what was changed, file:line]
**Regression Test:** [test name and what it covers]
**Siblings:** [other places this pattern might exist]
**Learning:** [what to record for future sessions]
```

### Phase 6: Record Learning

Automatically add the finding to project learnings:
```json
{"type":"pitfall","content":"[root cause description]","source":"investigation"}
```

## Scope Lock

When investigating, auto-detect the narrowest directory containing affected files. Mentally lock your scope to that directory — don't wander into unrelated code during debugging.

## Anti-Patterns

- Fixing the symptom without understanding the cause
- Changing multiple things at once ("shotgun debugging")
- Claiming "pre-existing" without tracing to a specific prior commit
- Adding try/catch to hide the error instead of fixing it
- "It works now" without knowing what changed
