# Pattern: Related sessions / other occurrences — no dead-end detail pages

**Surface:** sessions-program / attendee-program · **Observed in:** WWDC, Front, Apple Store (refs: [WWDC related lists](https://mobbin.com/screens/6032ac36-cdd9-4204-9e5d-0ab0b4bbbd97), [Front More Sessions](https://mobbin.com/screens/9c36ddbe-c23d-40e5-914f-f6f79d04358c), [Apple summary flow](https://mobbin.com/flows/8e5181ae-f8f6-427d-945a-9cee14e267de))

## Flow
1. Below the session description: "Related Sessions" list (title + time + hall) and "Related Labs" with type badges per row (WWDC).
2. Recurring/repeated sessions: "More Sessions" rail listing future occurrences as clickable rows (Front); "See other times and locations" link on the reservation (Apple).
3. Relatedness axes observed: same track/topic (WWDC), same series (Front), same speaker ("MORE WITH MANOJ", Open — see speaker-profile card).

## Use when
Programs with tracks, repeated workshops, or multi-part sessions — after reading one session the attendee should be routed onward, never stranded.

## Avoid when
Relatedness would be computed weakly (random same-day sessions) — a wrong "related" rail erodes trust; omit until track/topic data is real.

## Sad paths observed
- "See other times and locations" doubles as the recovery path when the chosen slot no longer fits.

## Accessibility
Related lists are standard rows with full text; type badges are words.

## Microcopy worth stealing
"Related Sessions" / "Related Labs" · "More Sessions" · "See other times and locations"

## Default verdict for our stack
VIABLE — cheap once track + parent/child session data exists (it does: tracks and one-level sub-sessions are in the schema); same-track and same-parent are honest relatedness axes from day one.
