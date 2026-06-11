# Pattern: Attention flags as an overlay + counted, click-to-filter exception queue

**Surface:** transport · **Observed in:** Limo Anywhere, Onfleet, Samsara, RideCo, Circuit/Spoke, Moovs
(refs: P12, A3, A15, A30 — URLs in `_raw/`; key: https://kb.limoanywhere.com/docs/new-dispatch-grid/, https://help.spoke.com/en/articles/6962409-how-to-make-changes-to-a-live-route)

## Flow
1. Exception state is an OVERLAY on lifecycle state, not a state: Onfleet's delayed tasks get "a small gold dot on the top right corner of the task's icon" while remaining Assigned/Active.
2. Flagged rows show a red ❗ in a dedicated Attention column of the grid; an Attention tab shows full reasons and a COUNT of currently flagged trips; clicking it FILTERS the grid to flagged-only (Limo Anywhere).
3. Flag conditions span data-completeness (missing flight number, unpaid) and execution risk (late vehicle, skipped stop) — both feed the same queue.
4. Predictive variant: "Orange dot = The stop is at risk of being early or late" (Circuit) — at-risk before failed.
5. Per-passenger operational icons (wheelchair, VIP, luggage) are toggleable Dispatch Alerts that propagate to the driver app as glanceable icons (Moovs).
6. Roll-up variant: a command dashboard with quick stats + a sortable table "to help surface routes that may need your attention" (Onfleet Command Center).

## Use when
Surfacing travel-change red flags on the transport board (PATH-transport-004): indicator on the affected card + a counted, filterable queue so ops works the list instead of scanning the board.

## Avoid when
Everything is flagged — a queue that's always full is a queue nobody reads; thresholds (see flight-alert-taxonomy card) keep it actionable. Avoid making the flag a lifecycle state — it must coexist with planned/ready/in_progress.

## Sad paths observed
- Samsara: stops not completed by window end are auto-marked skipped — exceptions get auto-resolved into terminal states, not left dangling.
- Limo Anywhere counts flags so the queue's size is visible at a glance — zero is a meaningful, visible number.

## Accessibility
Not observable from documentation sources. Red-❗-only signaling fails WCAG 1.4.1 — keep the count + text reasons (the products do this too).

## Default verdict for our stack
RECOMMENDED — this is the missing UI half of PATH-transport-004 (legacy wrote flags to DB, showed nothing). Indicator + count badge + "show flagged only" filter + reason detail = the documented industry shape.
