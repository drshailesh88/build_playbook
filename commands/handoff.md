# /handoff — compact this session into a document the next agent can pick up

**Provenance:** adapted from Matt Pocock's `handoff` skill
(github.com/mattpocock/skills, `skills/productivity/handoff`, vendored verbatim at
`vendor/mattpocock-skills/handoff/SKILL.md`). Adapted for the factory: repo-local
durable storage instead of OS temp dir, dump/DEC/lacunae awareness, and the
decision-leak doctrine made explicit.

**Argument:** what the next session will be used for. Tailor the entire document
to that purpose — a handoff for "run the comms wow-grill" looks nothing like a
handoff for "debug the judge ladder". If no argument, ask for one before writing;
an untargeted handoff is a summary, and summaries rot.

**This is also the overnight pause button — and the token economics say use
it.** An idle session costs nothing, but its prompt cache expires within
minutes: resuming a long stale session in-place re-reads the entire
conversation uncached at full price on every message. Checkpointing to
artifacts + closing + resuming FRESH (the new session reads only the handoff
+ the artifacts it cites) is both the cheap path and the lossless one. When
the founder says "pausing for the night", that means: flush pending writes to
their proper artifacts (DECs to the ledger, verdicts to their files), commit
scoped, write this handoff with a resume point, confirm the commit hash, done.

## Output

Write to `.planning/handoffs/YYYY-MM-DD-<purpose-slug>.md` in the current repo.
Repo-local, not OS temp: this factory spans laptop, VPS, and parallel cmux
agents — a temp file doesn't travel. Handoffs are committable planning artifacts.

## Rules (the upstream three, kept verbatim in spirit)

1. **Never duplicate what an artifact already holds.** PRDs, plans, DEC ledger
   entries, WOW-DELTAs, pathways, coverage audits, issues, commits, diffs —
   reference them by path or URL. The handoff carries only what lives nowhere
   else: in-flight reasoning, unwritten conclusions, the why behind the next
   step. This is the decision-leak rule applied to session state: if a decision
   matters, it belongs in the ledger, not the handoff. If you find yourself
   writing a decision into the handoff, stop and write the DEC first.
2. **Suggested skills/commands section.** Name the commands the next agent
   should invoke, in order, with the arguments to pass.
3. **Redact secrets and PII.** API keys, tokens, passwords, personal data —
   never enter the handoff.

## Factory additions — check and report each

- **Unconsumed dumps:** scan `.planning/dumps/INDEX.md` for fragments tagged to
  the next session's topic with empty CONSUMED-BY. List them; the next agent
  must open with them.
- **DEC state:** current value of `.planning/next-dec-id`; any DECs allocated
  but not yet written (these are leaks — flag loudly).
- **Pending founder decisions:** open questions only the founder can answer,
  each with the recommendation already on the table.
- **Lacunae touched:** any `L-xxx` entries opened, progressed, or closed this
  session (`.planning/FACTORY-LACUNAE.md`).
- **Uncommitted state:** files this session created/modified but did not
  commit, and whether the next agent should commit or leave them (parallel
  agents may own them).

## Structure

```
# Handoff: <purpose>          (date, source session one-liner)
## Where things stand          (outcome-first, 5-10 lines max)
## What the next session does  (the purpose, made concrete)
## Artifacts — read these, don't re-derive   (paths + one-line why each)
## In-flight / unwritten       (the ONLY prose section — what no artifact holds)
## Unconsumed dumps / pending DECs / open founder questions
## Suggested commands          (ordered, with args)
## Do NOT                      (re-litigate listed DECs, touch parallel agents' files, etc.)
```

Keep it under ~120 lines. A handoff the next agent won't finish reading is a
handoff that failed.
