# Pattern: Bulk reassignment & vehicle swap — whole-run moves with pre-commit checks

**Surface:** transport · **Observed in:** Motive, Route4Me, Routific, Bringg, Moovs, Turns, Limo Anywhere
(refs: P14, F4, F32, F33, A29 — URLs in `_raw/`; key: https://academy.routific.com/en/articles/4128126-how-to-swap-routes-between-drivers, https://intercom.help/moovs-05c940f1970e/en/articles/13764934-vehicle-availability-view)

## Flow
1. Whole-run swap: click the swap icon by a driver's name → popup lists all drivers → pick the destination — "the entire route transfers to the new driver" (Routific). Multi-select routes → "Reassign" → send (Motive).
2. Pre-commit constraint checks: Bringg shows capacity, time-window, team, and skills checkmarks in the reassignment summary BEFORE the Assign/Merge/Create-New action.
3. Visual variant: Vehicle Availability timeline — vehicles as rows, trips as colored blocks on a 24-hour axis; drag blocks between vehicles; "review your edits in the pending changes bar and save them all at once" (Moovs).
4. Live-route driver change is possible (Turns) but driver identity freezes once the route STARTS elsewhere (Routific) — know your lock point.
5. Offer-timeout recovery: trips stuck in "Offered to Driver" are detectable by status and manually reassignable (Limo Anywhere).

## Use when
A vehicle breaks down or a driver cancels: move ALL its passengers to another vehicle in one act, with capacity checked at commit — instead of N drags.

## Avoid when
Partial moves (2 of 12 passengers) — that's the normal kanban drag; bulk tools that grab everything by default cause overshoot.

## Sad paths observed
- Merged-route capacity must fit the combined load or the action is blocked (Bringg).
- Vehicle-cancel fallout in our domain: passengers become unassigned, never deleted (legacy rule, PATH-transport-006 step 3) — the swap pattern is the better path because passengers keep an assignment.

## Accessibility
Timeline drag-drop needs a non-pointer equivalent (the swap-popup variant IS that equivalent — keep both).

## Default verdict for our stack
RECOMMENDED — legacy's only answer to a dead vehicle was cancel-it-and-re-drag-everyone. "Move all passengers to…" on a vehicle column + capacity pre-check is small surface, big ops win.
