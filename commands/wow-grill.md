# wow-grill — Ratify a module's excellence delta into scope (the anti-feature-poverty grill)

PRD→features produces modules that technically exist and practically
disappoint (the GEM India certificates lesson: a Canva-proficient founder
couldn't generate one certificate in his own app). This grill closes the
gap per module: the founder confronts the best-at-the-job patterns
(WOW-DELTA from the excellence harvest), their own domain testimony, and
their thought dumps — and decides, item by item, what enters scope. Wow
enters deliberately as DECs, never by drift; mediocrity exits deliberately
too (a rejected wow item gets a REJECTED record, not silence).

Input: `$ARGUMENTS` — module name. One module per session.

## Read first (the agenda builds itself)

0. **Resume check:** if a grill-log for this module already exists with a
   `RESUME-FROM-HERE` marker, this is a resumed grill — load the
   already-stamped WOW-DELTA verdicts + the marker, confirm the resume
   point to the founder in one line, and continue from the next undecided
   item. NEVER re-ask ruled items.
1. `.planning/ux-patterns/excellence/<module>.WOW-DELTA.md` — the ranked
   stolen-pattern candidates with V1-CORE / V1-POLISH / V2 recommendations
2. `.planning/dumps/INDEX.md` — unconsumed fragments tagged module:<name>
   or wow-candidate; these OPEN the grill, quoted verbatim
3. `docs/done-spec/<module>.DONE.md` (old repo) — UNFINISHED and
   NEVER-ATTEMPTED items, and SCARS
4. The module's pathways + existing DECs — what's already decided
5. Counter discipline: allocate DEC IDs at WRITE time via
   `scripts/next-dec.sh` (parallel sessions race otherwise)

## Session shape

**Open with testimony, not candidates.** First question, always:
"From your own experience of this job [as attendee/operator], what did the
best implementations FEEL like, and where did the old module humiliate
you?" Record the answer as `testimony` in the grill log — it outranks any
pattern card and often re-ranks the whole WOW-DELTA.

**Then walk the WOW-DELTA, highest-rank first.** Per item:
- Show the pattern (cite cards), the harvest's recommendation, effort guess
- Cross-check: does a done-spec NEVER-ATTEMPTED or a dump fragment touch
  this? Say so.
- Founder verdict: **V1-CORE** (module is feature-poor without it) /
  **V1-POLISH** (ships if schedule allows, never blocks) / **V2** /
  **REJECTED** (recorded with reason — future grills consult rejections)
- Each verdict = one DEC (full record for V1-CORE; tactical tier for the
  rest). V1-CORE items also get: which pathway(s) need an addendum, and
  the one-sentence DONE-MEANS statement the story contract will carry.

**Close with the poverty check.** Before ending, ask: "If a peer in your
field used ONLY this module tomorrow, what would make them quietly give
up?" Anything surfaced that no candidate covered becomes a first-principles
item (designed, not harvested) or an explicit deferral.

## Outputs

- DEC records appended (grill-log + decision-index + dated decisions file)
- `.planning/ux-patterns/excellence/<module>.WOW-DELTA.md` updated in
  place: each item stamped with its verdict + DEC id
- Dump fragments marked CONSUMED-BY in `.planning/dumps/INDEX.md`
- A pathway-addendum task list for /extract-pathways (V1-CORE items only)
- One-line module verdict for the kickoff doc: "certificates: 4 V1-CORE,
  2 polish, 3 V2, 1 rejected — feature-poverty risk cleared/remaining"

## Pausing mid-grill (overnight / founder fatigue / long gaps)

A grill pauses whenever the founder says so — fatigue is a valid reason
and stopping clean beats grinding tired. Token economics make the HOW
non-negotiable: an idle session costs nothing, but its prompt cache
expires within minutes — typing into a long stale session re-reads the
entire conversation uncached at full price, every message. So never
resume in-place after hours away. Instead:

1. **Checkpoint NOW:** write every verdict ruled so far to disk — DECs,
   grill-log entries, WOW-DELTA items stamped — and commit (scoped add).
2. **Append a `RESUME-FROM-HERE` block** to the grill-log: which fork the
   session stopped at + the next undecided question, verbatim.
3. **Confirm commit hash + resume point in one line**, then the founder
   closes the session.

Resume = run this command again in a FRESH session; step 0 of "Read
first" picks up from the marker. Cheap (reads only artifacts), lossless
(everything ruled is already on disk).

## Verdict audit (mandatory close, DEC-012)

The grill author never audits its own verdicts. After outputs are written,
run a read-only Codex pass over the session's verdicts:

```bash
codex exec --sandbox read-only - <<'PACKET'
You are auditing scope DECs from a founder grill (module: <module>).
Read the dated decisions file, the stamped WOW-DELTA, and the prior DEC
index. Try to BREAK the verdicts:
1. Which V1-CORE acceptances rest on no card/done-spec/testimony evidence?
2. Which V2/REJECTED deferral leaves a V1 pathway or DONE-MEANS dangling?
3. Which new DEC contradicts a prior DEC (cite both ids)?
4. What did the founder wave through that a skeptic would re-open?
Report findings only — no fixes. Cite DEC ids and file paths.
PACKET
```

Codex findings go to the FOUNDER, never back to the grill agent to
self-adjudicate. Disagreement escalates; it never auto-resolves. Append
the audit outcome (clean / N findings / escalated) to the module's
one-line verdict.

## Before grilling: harvester retirement check (DEC-012)

Grills run in FRESH sessions reading committed artifacts — never inside
the harvest agent's session (the advocate must not judge). Before the
grill starts, confirm the module's harvest terminal was retired cleanly:
open questions, founder answers, and judgment calls flushed into the
WOW-DELTA or a handoff doc. Chat-only context is treated as nonexistent.

## Scope guards (non-negotiable)

- **Steal the pattern, not the product** — "Canva-grade certificate
  editing" means template gallery + live preview + brand-kit-bound field
  placement, not Canva
- Every V1-CORE must name its pathway addendum before the session ends —
  an accepted wow item with no pathway is decision leak in reverse
- The founder can promote/demote any item against the harvest's
  recommendation — record the disagreement and the founder's reason
  (anti-sycophancy: the agent states its position once, then records)
- Respect pushback twice = DEFERRED (standard grill escape hatch)
- Coverage-audit reruns after all wow-grills — new DONE-MEANS statements
  without pathways are GAPs
