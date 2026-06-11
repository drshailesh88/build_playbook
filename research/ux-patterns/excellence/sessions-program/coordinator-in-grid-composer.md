# Pattern: In-grid session composer — click/paint a slot, edit beside the grid

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** Motion, Front, Skiff (refs: [Motion quick popover flow](https://mobbin.com/flows/7fb07f5b-e929-4bf3-8e40-4ffc86c9577c), [Front side-panel flow](https://mobbin.com/flows/15d5b8d3-7685-4275-b3a1-7cc1274ae027), [Skiff inline editor flow](https://mobbin.com/flows/278b5778-83b4-4ad3-a5ea-296d26fa2abb))

## Flow
1. Click (or paint a range on) an empty slot → composer opens IN CONTEXT: popover at the slot (Motion) or right side panel (Front) — the grid stays visible behind.
2. Composer carries the full field set: title, date, time range with 15-min increments, all-day, repeat, guests, location — and Front has a dedicated "Add meeting room" field (room as first-class, not free-text location).
3. Keyboard path advertised on the button itself: "Create ⌘↵", Esc to cancel (Motion).
4. The created chip lands immediately; refinement continues by direct manipulation (drag/resize).

## Use when
Grid-first scheduling — creating a session where it belongs in time beats filling a form that asks for date and time as abstract fields.

## Avoid when
Sessions need heavy structured input at creation (role requirements, CME, tracks) — then the popover creates a minimal draft and hands off to the full form, never duplicates it.

## Sad paths observed
- Disconnected data source labeled honestly in the rail: "[DISCONNECTED]" account (Front).

## Accessibility
Composer is a focusable panel; keyboard shortcuts printed in the UI, not hidden.

## Microcopy worth stealing
"Create ⌘↵" · "Add meeting room" as a dedicated field

## Default verdict for our stack
RECOMMENDED — click-empty-slot-to-create on the schedule grid, with hall pre-filled from the lane clicked; minimal draft (title/time/hall) then open the existing full session form for the rest.
