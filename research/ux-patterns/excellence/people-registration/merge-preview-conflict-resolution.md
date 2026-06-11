# Pattern: Merge as result-preview with per-conflict pickers (and honest irreversibility)

**Surface:** people-registration / merge execution · **Observed in:** Front, folk, Clay (refs: https://mobbin.com/flows/6cd12873-6ff6-401c-a5d0-e312ea3be131 , https://mobbin.com/flows/b4c3bac2-0e97-461c-bd67-3a18e4fd2981 , https://mobbin.com/flows/78502e69-41ed-4e62-86f5-66cf2f7298d2)

## Flow
1. Entry points: from the duplicates queue; from a record's panel; or multi-select 2 rows in the list → "Merge People" with a keyboard shortcut (Clay) — never "paste the other record's UUID".
2. An explainer box states the rules up front (Front): "Fields that can have multiple values are all preserved. If there are conflicting values for a unique field, you'll get to pick the one to keep. **Merging cannot be undone.**"
3. Conflicts are counted and flagged ("⚠ 1 conflict found for name"); the UI renders the MERGED RESULT as a preview record — conflicted fields become inline pickers on that preview (Front dropdown; folk per-value checkboxes with a star for primary). You stare at the future record, not a 3-column diff.
4. Multi-value fields union by default (both emails kept — Front, Clay); confirm button stays disabled until every conflict has an explicit choice.
5. Post-merge: success toast with "Open profile" link (folk); survivor's timeline contains BOTH histories (Clay).

## Use when
Always, for human-reviewed merges — the preview-with-pickers model scales from 2-field to 20-field records.

## Avoid when
Single-value schemas where union semantics are impossible (GEM's single email/phone columns force pick-one or separator-join — calling that out beats pretending to union). Avoid burying merge behind admin-only tools if coordinators own the data quality.

## Sad paths observed
- Self-merge and missing-counterpart are structurally impossible from queue/multi-select entry (you merge a SET, not typed IDs).
- "Merging cannot be undone" stated before, not after; GEM's merge-warning copy is the same family and worth keeping.
- Mid-merge failure is the known GEM scar (transaction removed in fe640e1) — rebuild restores atomicity server-side; no observed app exposes partial-merge states to the UI.

## Accessibility
Conflict pickers are labeled selects/radio groups on the preview; the conflict count is announced.

## Default verdict for our stack
RECOMMENDED — keep GEM's explicit left/right/both conflict resolution (already proven) but reframe the UI as merged-result preview, replace UUID paste with search/queue/multi-select entry (done-spec §34), and union tags (already) while flagging the email/phone single-value limitation to the data grill.
