# Pattern: Import history with per-import breakdown and bounded revert

**Surface:** people-registration / import aftermath · **Observed in:** Pipedrive, Remote, Attio, Clay (refs: https://mobbin.com/flows/7338268f-021e-412f-a4c2-fae6e36bf06a , https://mobbin.com/flows/041cbcfd-0a61-451e-995a-8c5d09713f26 , https://mobbin.com/flows/26fb94ff-71e9-44ea-a21d-6aa6cd5fdb94)

## Flow
1. Import page has tabs: New import / Import history (Pipedrive; Attio keeps "Import history" in object settings).
2. Last-import summary card: filename, importer (avatar + name), timestamp, and outcome counters "+52 Items added [View] · 0 Items updated · 0 Items merged · 0 Rows skipped" — every row of the file is accounted for in exactly one bucket.
3. History table for past imports: file, date, user, status, "Details", per-row **Revert**; copy states the bound: "Imports can be reverted within 48 hours after their upload."
4. Import detail page: tabbed breakdown of the records each import created (People 12 / Organizations 12 / …) with links to the live records; red Revert here too.
5. Error visibility at batch level: Remote's history rows carry a red "CONTAINS ERRORS" badge with successful/incomplete counts.
6. Clay auto-creates a group per import batch ("CSV Import - 2025-02-24") — the batch stays addressable as a cohort after import.

## Use when
Imports are recurring and operator-error-prone (wrong file, wrong event, stale list) — which is every conference cycle.

## Avoid when
Revert is unimplementable honestly (imported rows already mutated/merged downstream) — then ship history + per-import cohort WITHOUT a revert button rather than a revert that lies; Pipedrive's 48h bound exists for exactly this reason.

## Sad paths observed
- Partial failure is a first-class outcome (incomplete counts, CONTAINS ERRORS badge), not a generic failure toast — answers done-spec §33 ("which rows imported, which never ran") at the UI level.
- Revert is per-import, time-bounded, and confirmed; never a global undo.

## Accessibility
Counters are labeled text, not icon-only; revert confirms with explicit record counts.

## Default verdict for our stack
RECOMMENDED for history + per-import cohort + accounted-for counters (GEM already returns per-row results — they're just discarded after the success page). Revert is VIABLE-V2: requires import-batch FK on created rows and a no-downstream-writes check before offering it.
