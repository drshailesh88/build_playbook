# Pattern: Unscheduled-items parking-lot tray at the grid edge

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** Jobber, ClickUp (refs: [Jobber unscheduled drawer](https://mobbin.com/flows/32be4a4f-22b7-4f85-9e51-db3e905b25f0), [ClickUp unscheduled tab](https://mobbin.com/screens/76da241a-f40f-4569-b9b7-1a82360d27db))

## Flow
1. A collapsible edge tray labeled with a count — "Unscheduled 19" (ClickUp vertical tab), "Unscheduled 1" (Jobber side drawer) — holds items that exist but have no time/place yet.
2. Items drag from the tray onto the grid to get scheduled; the tray count decrements live.
3. The tray collapses out of the way when not in use — backlog visible on demand, never lost.

## Use when
Sessions are created before they're placed (accepted abstracts, planned symposia awaiting hall/slot) — the draft backlog needs a home ON the scheduling surface.

## Avoid when
Everything is created in place (in-grid composer only) — an always-empty tray is dead chrome.

## Sad paths observed
- The count badge is the honesty mechanism: 19 unscheduled items can't hide.

## Accessibility
Tray is a labeled expandable region; count as text in the tab.

## Microcopy worth stealing
"Unscheduled {n}"

## Default verdict for our stack
RECOMMENDED — maps directly onto draft-status sessions without hall/time; the schedule grid gets an "Unscheduled" tray, making draft→scheduled a drag instead of form-editing dates. Composes with the session status FSM (draft→scheduled).
