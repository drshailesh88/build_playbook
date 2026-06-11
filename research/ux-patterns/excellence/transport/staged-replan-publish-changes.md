# Pattern: Staged re-plan with an explicit "Publish Changes" gate and graduated blast radius

**Surface:** transport · **Observed in:** Routific, Circuit/Spoke, Dispatch, Moovs
(refs: A26, A27, A29, A30, F22, F23, F24, F32 — URLs in `_raw/`; key: https://academy.routific.com/en/articles/1317942-make-last-minute-changes-to-routes-after-dispatch, https://help.spoke.com/en/articles/6208915-how-to-make-changes-to-an-optimized-route)

## Flow
1. Any edit to a dispatched/active plan enters an explicit editing mode — banner: "Route has unsaved changes - Discard or preview changes to continue"; changed stops get pencil markers on list and map (Circuit).
2. Edits accumulate as a draft; a red unpublished-changes badge marks pending state (Routific). "Any changes you make aren't officially published to your drivers until you click 'Publish Changes'."
3. Before committing, the human chooses re-optimization blast radius (Circuit, verbatim): "Reorder changed stops" / "Reorder all stops" / "Redistribute stops between drivers" — first two preserve driver bindings, the third may not.
4. On publish, driver apps refresh automatically; live-route edits notify the driver with the "option to view those changes now or later" — no screen-yanking mid-drive.
5. Only people still awaiting service are re-notified of new ETAs (Routific) — completed passengers never get stale messages.
6. Removing a stop post-dispatch pushes a notification to the driver (Dispatch); Moovs batches vehicle-timeline drag-drop edits behind a "pending changes bar — save them all at once".

## Use when
Re-planning after a travel change, cancellation, or vehicle loss on a batch that's already `ready`/`in_progress` — anything where drivers or passengers have already seen a version of the plan.

## Avoid when
The batch is still `planned` and nothing has been communicated — a draft gate over an unpublished plan is ceremony; direct edits are fine.

## Sad paths observed
- "Discard changes... cannot be undone" — discard is itself destructive and warned (Circuit).
- Dispatch is one-way: "A dispatch cannot be undone... re-dispatch the route with any necessary modifications"; drivers can't "unstart" a route (Routific) — irreversibility is documented, not hidden.
- Customer ETAs assume in-order execution; out-of-order driving silently invalidates them (Routific) — name your ordering assumption.

## Accessibility
Not observable from documentation sources.

## Default verdict for our stack
RECOMMENDED — answers transport OPEN QUESTION 4 (batch-cancel fallout UX) and the PATH-transport-004 resolve loop: edits stage, human picks blast radius, one atomic publish, scoped re-notification.
