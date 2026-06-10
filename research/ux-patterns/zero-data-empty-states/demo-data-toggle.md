# Pattern: Reversible demo-data toggle on the real dashboard
**Surface:** zero-data-empty-states · **Observed in:** 7shifts (refs: https://mobbin.com/flows/2d670805-d1b6-411c-832e-4256f354c04e)

## Flow
1. The real (empty/near-empty) dashboard carries an inline switch in its header: "Try engage with demo data" (7shifts Engage page, off by default, sitting next to "Give us feedback").
2. Toggling ON repaints the same dashboard with fake employees and metrics ("Most Reliable: Leonard Kim", engagement breakdowns) — the page layout is identical, only the data source swaps.
3. Toggling OFF instantly restores the user's real (sparse) data. No separate workspace, no cleanup, no residue.
4. The toggle remains visible while demo data is shown, so the state is always one click from exit.

## Use when
- You want to demo a single dashboard/report, not the whole product — cheapest possible demo scope.
- The view is read-only analytics where fake data can't contaminate anything (no writes flow from the view).

## Avoid when
- The page allows actions on rows (message attendee, refund) — demo rows with live actions are dangerous; 7shifts uses it only on a reporting surface.
- The toggle state could persist silently across sessions/users — a manager screenshotting fake "Most Often Late: Sam Lee" data is a real-world harm; demo names look entirely real here.

## Sad paths observed
- Single-app evidence; treat as a candidate, not a norm.
- While ON, nothing except the small toggle marks the data as fake — no banner, no watermark on the charts themselves; screenshots lose the context entirely.

## Accessibility
- A switch labeled with visible text ("Try engage with demo data") is good; state change repaints the whole page — announce the change, not just the toggle state.
- Add a persistent "showing demo data" indicator near the data, not only in the header, for users who zoom/scroll past the toggle.

## Default verdict for our stack
VIABLE — attractive for Event State's per-event analytics tab pre-registrations ("preview with sample registrations" toggle), but only with an added always-visible sample watermark; AVOID for any view with row-level actions.
