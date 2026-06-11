# Pattern: Favorites-first schedule home with time-aware empty copy

**Surface:** sessions-program / attendee-program · **Observed in:** WWDC, Bloom (refs: [WWDC schedule home](https://mobbin.com/screens/bd3a46fa-7ae1-4f44-839a-c758faedf372), [Bloom bookmarked sessions](https://mobbin.com/flows/ea66ab38-1f51-421f-a70e-e670ba355369))

## Flow
1. Schedule landing sectioned "Favorites" / "Sessions" / "Labs", each with "See All" — and Favorites is FIRST.
2. Empty favorites shows inline, time-aware copy instead of hiding the section: "You have no more favorites coming up today." ("no more … today", not a generic "nothing here").
3. Bloom variant for the personal library: "Session History" and "Bookmarked Sessions" as separate entries; completed items swap the play glyph for a ✓ — saved vs attended distinguished in one icon slot.

## Use when
A personal agenda exists — saved items are the user's highest-intent content and earn top billing over the full program.

## Avoid when
Most users never save anything — a permanently empty first section pushes real content below the fold; promote Favorites only once non-empty.

## Sad paths observed
- Empty personal agenda handled with time-aware copy that implies the feature worked ("no MORE… coming up TODAY").

## Accessibility
Section list with See All links; no horizontal gestures required.

## Microcopy worth stealing
"You have no more favorites coming up today."

## Default verdict for our stack
RECOMMENDED (with my-schedule) — the attendee program home becomes "My agenda" + "Full program" sections; the time-aware empty state is a free polish win.
