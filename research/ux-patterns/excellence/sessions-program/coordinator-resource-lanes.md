# Pattern: Resource lanes — rows per department/person/room with per-lane unassigned row

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** 7shifts, Deputy, Workable, Fresha (refs: [7shifts dept lanes](https://mobbin.com/flows/a188ab96-5d5c-4917-bb42-e27d16942411), [Deputy area lanes](https://mobbin.com/flows/a426e08b-cd76-4cd5-a684-0830b4744e1d), [Workable people lanes](https://mobbin.com/screens/e3ef1c9a-a0f1-40b4-90a6-e11722b779cd), [Fresha staff columns](https://mobbin.com/screens/ac5e971e-8cfb-47ca-9b36-bb6ae392b53f))

## Flow
1. Grid rows = resources (departments with role sub-rows, areas, people); columns = days. Fresha rotates it: day view with one COLUMN per staff resource — the closest shape to a room×time conference grid.
2. Each lane group carries its own "Open Shifts" row — unassigned work lives in the lane it belongs to, not a global pile.
3. Every empty cell shows a "+" affordance on hover; multi-day items span columns (Workable "Emergency Leave · 2 days").
4. Unavailability is hatched background zones; placement into them produces an inline soft warning — "⚠ Alex Smith is not working between 7:00am and 7:45am" — while still allowing Apply (Fresha).
5. Optional data overlays per lane: "Show coverage in areas / Show hours in areas" (Deputy Insights).

## Use when
Scheduling against finite parallel resources — halls/rooms as lanes for one day, tracks as lanes for the week.

## Avoid when
More than ~10 lanes without grouping — observed grids group lanes under parents (location → department → role) before they grow wide.

## Sad paths observed
- Hatched unavailable zones; pending-state badges on chips; multi-day spanning blocks; soft out-of-hours warning.

## Accessibility
Lane headers are text + avatar; hatching is a pattern fill, not hue; warnings are inline text boxes.

## Microcopy worth stealing
"{Resource} is not working between {start} and {end}" · "Open Shifts" row label

## Default verdict for our stack
RECOMMENDED (as raw material) — no true room×time conference grid exists on Mobbin (first-principles candidate, flagged); build it from Fresha's resource-columns day view + 7shifts/Deputy lane mechanics + per-hall "Unassigned" row.
