# Pattern: Day-grouped trip timeline (mixed segment types, chronological)
**Surface:** travel · **Observed in:** TravelPerk trip builder (ref: https://mobbin.com/screens/e45e030b-3194-49f5-9a55-9459d23b893f), KAYAK Trips (refs: https://mobbin.com/screens/502ae32f-542e-48bd-a5a4-98e5243ab275, https://mobbin.com/screens/0ff459ce-f3f3-407c-a8de-8328f65a809e), Navan trip rail (ref: https://mobbin.com/screens/51f3a7c8-4cc1-4ce5-94c1-8f8afe68ab37), Pangea (ref: https://mobbin.com/flows/e0ac31b9-b908-47ef-9242-d489cab802f6)

## Flow
1. One chronological spine grouped by day headers ("Tuesday, May 27"); each entry is a typed card (flight/train/car/hotel) with its own icon, key times, and per-card actions (Edit / Share / Delete).
2. Hotel spans render as check-in and check-out entries on their respective days (Pangea), not one blob.
3. Gaps become suggestions: "Add a place to stay in Chicago, Illinois — Wed, May 28 - Thu, May 29 [Search stays]" (TravelPerk infers the city+nights from surrounding segments).
4. Empty days stay visible: "No scheduled activities yet" + add affordance (KAYAK).
5. Trip-level chrome: total cost panel, share, map flyout with segment pins.

## Use when
A person has 2+ travel records in an event — the per-delegate itinerary view (and the delegate-facing page); answers "what does Dr. Rao's journey look like end to end".

## Avoid when
Single-segment travelers (a lone card needs no timeline); ops cross-person triage (use the manifest/list, not N timelines).

## Sad paths observed
- Out-of-order entry insertion is automatic (chronology is computed, never hand-sorted).
- Date-less items quarantined in a separate "Saves/Wishlist" tab, never faked onto a day.

## Accessibility
Day headers are headings; cards are list items — screen-reader walk reads as an agenda.

## Default verdict for our stack
RECOMMENDED — oracle has a flat list + per-person sort (A7) but no journey view; this is the natural per-person travel detail and the skeleton of the delegate-facing itinerary.
