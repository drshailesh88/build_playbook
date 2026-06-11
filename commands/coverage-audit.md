# coverage-audit — Prove incompleteness can't hide (run after pathways, before PRD)

Completeness cannot be proven; it can only be made falsifiable. This audit
mechanically enumerates everything the product COULD need, demands that
every cell point at a pathway/story/DEC or an explicit out-of-scope mark,
and then attacks the result adversarially. Unmarked emptiness is the
finding. Run it after `/extract-pathways` and before `/write-a-prd`; rerun
whenever a later layer (build, QA, UAT, support) finds a gap — with the
post-mortem question "which generator should have caught this?"

Input: `$ARGUMENTS` — optional focus (`matrix`, `states`, `triggers`,
`time`, `adversarial`) to run one stage; default runs all five.

## Sources (read first)

- `UBIQUITOUS_LANGUAGE.md` / `.planning/CONTEXT.md` — the noun inventory
- Roles from the decision ledger + origin docs — the actor inventory
- `.planning/pathways/` (pathways.json + per-module files) — the coverage claims
- `docs/done-spec/*.DONE.md` (from `/done-spec`, if present) — every DONE-MEANS
  statement with no covering pathway is a GAP; oracle confidence per module
  comes from these, not from legacy status files
- `.planning/decision-index.md` + decisions/ — DECIDED and REJECTED scope
- The deferral register — explicitly postponed items
- Feature census + origin request — generator cross-check

## Stage 1 — Actor × Object × Lifecycle matrix

Actors MUST include every human role AND non-human actors: **the system
itself** (cron jobs, expiry timers, webhooks, background jobs), external
services (payment provider callbacks, email bounce webhooks), and the
platform operator (you, the SaaS staff) — the forgotten actors are where
coverage dies.

Verbs: create, view/list, search, edit, delete, archive, restore, export,
import, share/send, revoke, expire, transfer, duplicate.

Build the full matrix as `.planning/coverage/matrix.md` (one table per
object). Each cell gets exactly one mark:

| Mark | Meaning |
|---|---|
| `PATH-xxx-NNN` | covered by a pathway |
| `DEC-NNN` | covered by a decision (e.g., explicitly designed surface) |
| `OOS: <reason or DEC>` | deliberately out of scope — must cite why |
| `DEFER: <register entry>` | postponed, tracked |
| `N/A: <one-line reason>` | semantically impossible (faculty cannot archive an org) |
| **`GAP`** | none of the above — this is a finding |

Rules: an `N/A` without a reason is a `GAP`. Do not silently skip cells.
Emit the GAP list ranked by (actor reach × data sensitivity).

## Stage 2 — State-machine closure

For every stateful entity (from pathways + schema decisions: event,
invite, import batch, token link, entitlement, message, certificate...):

1. Draw the state graph as decided (cite DECs).
2. Every legal transition → must have a pathway (who/what triggers it,
   what's observable).
3. Every ILLEGAL transition attempt → must have a designed rejection
   (error surface, not a 500). "What happens if someone archives an event
   with scheduled comms?" is a cell, not a shrug.
4. Cross-entity products where one entity's transition touches another
   (the red-flag propagation class): list the pairs and the pathway that
   covers each.

Output: `.planning/coverage/states.md` with the same mark scheme.

## Stage 3 — Trigger catalog closure

Every outbound communication (email, WhatsApp, webhook, notification) the
system can send. For each: the pathway that fires it, its failure branch
(bounce/invalid number/template rejected), its stale-link branch (clicked
after expiry/revocation/role change), and its consent/suppression status.
A message with no failure branch is a GAP.

## Stage 4 — Time as an actor

Enumerate every time-driven behavior (auto-transitions, expiries, grace
windows, retention, scheduled sends, token TTLs). Each needs: the pathway,
the user-visible warning BEFORE it fires (if destructive), and the
recovery path AFTER (if any). Time-driven destructive actions without a
prior warning surface are GAPs ranked high.

## Stage 5 — Adversarial pass (never self-graded)

Hand the completed matrices to INDEPENDENT reviewers (Codex and/or Grok —
different context, read-only):

1. **Cell attack:** "Find cells wrongly marked N/A or OOS. Find objects
   missing from the noun inventory. Find actors missing from the actor
   list." (The noun/actor lists themselves are coverage claims.)
2. **Persona-season simulation:** for each primary persona, simulate a
   realistic season hour-by-hour (e.g., coordinator: six weeks pre-event →
   event days → post-event close-out; faculty: invite → confirm → travel →
   speak → certificate). Log every action the persona needs; diff against
   the pathway inventory. Personas catch JOURNEYS; matrices catch CELLS;
   both are required.
3. Verdict per reviewer: COVERAGE HOLDS or N gaps with evidence.

## Output + the ratchet

`.planning/coverage/AUDIT-<date>.md`: counts per stage (cells total /
covered / OOS / deferred / GAP), the ranked GAP list, reviewer verdicts.
Then the founder triages each GAP: becomes a pathway (back to
/extract-pathways for that module), a DEC (decided out), or a deferral
register entry. **Zero GAPs may remain unmarked.**

Ratchet rule: when ANY later layer (build, QA, UAT, support ticket) finds
a coverage gap, append to `.planning/coverage/escapes.jsonl`:
`{"date", "gap", "found_by", "generator_that_should_have_caught_it", "generator_fix"}`
— and apply the generator fix (a new noun, a new actor, a new verb, a new
trigger class) so the same CLASS of gap cannot escape twice.

## Rules

- Enumeration is mechanical — build the matrix BEFORE judging it; never
  prune cells during generation
- N/A requires a reason; OOS requires a citation; emptiness is never silent
- The adversarial pass is non-optional and never done by the agent that
  built the matrix
- This audit measures the PLAN's coverage. It says nothing about whether
  the build matches the plan — that's the judge ladder's job
- Honest framing in the report: this establishes "no gap we know how to
  generate," not "no gap exists." The escapes ledger is where the
  difference lives.
