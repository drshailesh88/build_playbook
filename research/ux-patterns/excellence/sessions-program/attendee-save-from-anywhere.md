# Pattern: One-tap save from anywhere (list, detail, speaker page)

**Surface:** sessions-program / attendee-program · **Observed in:** WWDC, DICE, Peloton, Bloom (refs: [WWDC list stars](https://mobbin.com/screens/ee3a8dc6-1947-4aaa-8992-c56123eaaad1), [WWDC detail star](https://mobbin.com/screens/6032ac36-cdd9-4204-9e5d-0ab0b4bbbd97), [DICE artist page hearts](https://mobbin.com/screens/c891468a-a9d6-4596-98aa-7d3e2825dfbf), [Peloton add circle](https://mobbin.com/screens/dea205e1-85f7-4a27-89bf-b0ea6af81816), [Bloom bookmark flow](https://mobbin.com/flows/d50046c2-8284-43f6-930f-a1a1b4e144d0))

## Flow
1. One consistent save glyph (star/heart/circle) on every session row in the list — saving never requires opening the detail page.
2. The same glyph repeats on the detail page nav bar and on the speaker page's session rows (DICE artist page) — save wherever the session is encountered.
3. Peloton's empty circle at row-right is the largest-target variant: tap to add to your schedule directly from the browse list.

## Use when
The personal agenda is a core loop — minimizing save friction is what makes attendees actually build one.

## Avoid when
Saving has side effects (seat reservation, capacity consumption) — then the act needs a confirm step, not a one-tap toggle.

## Sad paths observed
- None surfaced; the failure mode this prevents is abandonment (too much friction to bother saving).

## Accessibility
Save control is a real button at row level with generous tap target (Peloton circle); filled/unfilled state paired with the icon shape.

## Microcopy worth stealing
None needed — the pattern is glyph-only by design.

## Default verdict for our stack
RECOMMENDED — the old app has NO personal agenda at all (attendee program is read-only); if my-schedule ships, row-level save is the only acceptable entry point.
