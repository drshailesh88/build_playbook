# Pattern: People-allocation grid with draft→publish lifecycle and exception legend
**Surface:** rooming · **Observed in:** Deputy, 7shifts, Workable, Asana, Aboard, Wrangle
(refs: https://mobbin.com/flows/857e1417-10e1-4a5b-9b4b-8a4a8a6fa6a5 , https://mobbin.com/flows/0598f4b9-3db5-4fae-96bb-c6f73711fe61 , https://mobbin.com/screens/dcc6b94e-b619-4d43-9149-4e712eca95a3 , https://mobbin.com/screens/0773086c-2875-4071-a373-d1c07f44d554 ; raw: `_raw/by-flow.md` §F18/F19, `_raw/by-pattern.md` §P6/P11)

## Flow
1. 2-D grid: rows = areas/people, columns = days; every empty cell a "+" target; left rail people with running totals (Deputy).
2. Cell popover to assign: person picker, time/date, notes, running total, Save; overflow per cell: "Repeat for rest of the week / Split shift / Find replacement / View history / Delete" (Deputy).
3. State legend as a footer checklist: "0 empty / 0 unpublished / N published / 0 require confirmation / 0 open shifts / 0 warnings / 0 leave pending / 0 unavailable" — every exception class enumerated (Deputy).
4. Drafts = outlined cards; "Publish N shifts" turns them green; "OPEN" badge = unassigned slot; unpublished-drift flagged ("Multiple last published dates") (Deputy/7shifts).
5. Tentative vs committed visual grammar: dashed pending bars vs solid approved bars (Aboard); over-allocation as red negative capacity, data not dialog (Asana "Remaining capacity −50h 27m").
6. Kanban variant: columns with live counts as occupancy, "No items yet — Drag items here", "1 issue hidden by filters · Clear Filters" (Wrangle/Linear/Notion).

## Use when
Ops assigns many people into bounded slots over a date range and the assignment set must be staged (draft) before anyone is notified (publish).

## Avoid when
Volume is small enough that a list with an Assign action covers it — grids cost real build effort and need keyboard alternatives.

## Sad paths observed
- Conflict/overtime/time-off chips at header AND offending cells; "Fix warnings" link (7shifts).
- Cards never silently disappear: hidden-by-filters disclosure (Linear).
- Unfilled slots are first-class ("OPEN", "0 empty").

## Accessibility
Dashed-vs-solid plus text labels for tentative vs confirmed; grid needs full keyboard path (cell focus + assign popover) — none of the observed apps demonstrate this well, plan it explicitly.

## Default verdict for our stack
RECOMMENDED as the donor grammar — swap rows for rooms, columns for nights, cells for delegates and this IS the rooming grid. No app shows named-people-into-named-rooms (confirmed gap, `first-principles-gaps.md` #1); this card + `unit-picker-person-to-slot.md` are the assembly kit.
