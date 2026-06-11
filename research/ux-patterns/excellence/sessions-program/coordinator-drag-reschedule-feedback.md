# Pattern: Drag-reschedule with origin ghost, drop receipt, and edge-resize

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** Motion, Amie, Skiff (refs: [Motion reschedule flow](https://mobbin.com/flows/8f2d65fa-0247-4de3-a3d4-0e7caa9de1c2), [Amie reschedule flow](https://mobbin.com/flows/d71bc3f8-79c4-420c-bd69-63b8af1867f4), [Skiff create+resize flow](https://mobbin.com/flows/278b5778-83b4-4ad3-a5ea-296d26fa2abb))

## Flow
1. During drag, the original chip stays visible as a ghost at the origin while the moving copy follows the pointer (Amie) — the user never loses "where it was".
2. On drop, a receipt toast confirms with the EXACT result: "✓ Created: Schedule medical appointment — 6 Sept 2023, 09:45" (Amie).
3. Duration changes by dragging the chip's bottom edge (Skiff: 6:00–6:30 stretched to 5:30–7:30) — no form round-trip for resize.
4. A current-time red line crosses the grid (Motion); the rail mirrors the grid as a textual agenda with calm/empty states ("All tasks are scheduled on time" / "No upcoming events today").

## Use when
Desktop schedule grids where rescheduling is high-frequency — direct manipulation with unambiguous feedback is the entire value of a grid over a form.

## Avoid when
Touch devices — drag precision fails; use explicit Move/Copy verbs instead (see mobile-grid-adaptation card).

## Sad paths observed
- Empty-day rail state; the receipt toast doubles as the undo anchor point.

## Accessibility
Toast restates the result in text; the textual rail is the non-visual mirror of the grid.

## Microcopy worth stealing
"Created: {title} — {exact date, time}" · "All tasks are scheduled on time"

## Default verdict for our stack
RECOMMENDED — the old app's schedule grid is read-only-plus-links; drag-to-move and edge-resize with receipt toasts is the excellence bar for the admin grid. Composes with move-event-diff (modal fires only when assignments are affected).
