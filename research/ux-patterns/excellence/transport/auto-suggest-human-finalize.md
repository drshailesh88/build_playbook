# Pattern: Auto-suggestion the human finalizes (optimize → edit → accept), with "not scheduled + reasons"

**Surface:** transport · **Observed in:** Routific, OptimoRoute, Onfleet, RideCo, miMeetings
(refs: P10, A24, A9, A2, A4, F5, F36 — URLs in `_raw/`; key: https://academy.routific.com/en/articles/1317935-how-to-make-changes-to-your-routes, https://docs.onfleet.com/reference/team-auto-dispatch.md)

## Flow
1. The system proposes a plan (clustered routes/batches) — never silently applies it. Onfleet route optimization results join routes only when a human "Accepts".
2. The proposal is fully hand-editable before anything reaches drivers: add/edit/delete stops, drag to reorder, drag onto a driver name to let the machine pick the slot, shift-select to move many, "Unschedule" back to the pool.
3. Items that don't fit constraints are NOT force-assigned — they land in a "Not Scheduled" tab "which shows the specific reasons why each order was excluded" (OptimoRoute).
4. "Reoptimize" re-balances after manual edits; "lock routes" shields human-finished work from the machine.
5. Auto-runs respect existing human assignments: Onfleet Team Auto-Dispatch interleaves new tasks but "tasks already assigned to the driver remain with them"; a `dispatchId` records how the plan was computed (suggestion provenance).
6. Events vertical (miMeetings): a validation pass (duplicate/missing flight data) runs BEFORE clustering — data quality gates the suggestion.

## Use when
Generating suggested batches from travel records (PATH-transport-007). The accept step, the editable draft, the locked-finished-work rule, and reasons-for-exclusion are the contract.

## Avoid when
Volumes are trivial (3 cars) — a suggestion layer over nothing erodes trust; or when constraints are unknown (garbage clustering teaches users to ignore suggestions).

## Sad paths observed
- Unfittable items surface with explicit reasons, then remain manually draggable onto a route — human override of the constraint outcome is allowed but deliberate (OptimoRoute).
- Validation failures (duplicate/missing flight data) are surfaced pre-clustering (miMeetings).
- Post-acceptance edits are tier-gated in Routific — decide our equivalent boundary explicitly rather than inherit it by accident.

## Accessibility
Not observable from documentation sources.

## Default verdict for our stack
RECOMMENDED — this is PATH-transport-007's documented industry shape; the two pieces the legacy engine lacked are "not scheduled + reasons" (travelers the clusterer skipped, with why) and lock-confirmed-batches-from-refresh.
