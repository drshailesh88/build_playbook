# Pattern: Inventory scarcity signals + occupancy/displacement guards
**Surface:** rooming · **Observed in:** Booking.com, Shopee, Klook, HotelTonight, Eight Sleep, Viator
(refs: https://mobbin.com/screens/3449164d-4bbe-4127-896d-2e73b9f4e8c1 , https://mobbin.com/flows/4b416fa8-669a-410e-a2d5-f76b3e588874 , https://mobbin.com/screens/f41e8515-5a2d-474d-b9bb-3326eae68223 , https://mobbin.com/flows/4bd78a36-4243-4649-965c-dfc478db5351 ; raw: `_raw/by-pattern.md` §P2/P3, `_raw/by-app.md` §A7/A14, `_raw/by-flow.md` §F4)

## Flow
1. Remaining count inline on the option card at decision time: "Only 4 rooms left" (Shopee), "We have 1 left" (Booking.com), "1 room left" (HotelTonight).
2. Occupancy mismatch guard — disabled but visible with the reason: grayed rate card overlaid "These options won't accommodate your entire group" (Booking.com).
3. Capacity ceiling stated before it's hit: "This activity allows a maximum of 9 travelers." (Viator); steppers floor/ceiling-disabled.
4. Displacement warning when assigning over an occupied slot: "[A] and [B] will be removed from Eight Sleep Pod" (Eight Sleep) — the closest observed analogue to roommate-conflict messaging.
5. Capacity caveats carried in policy text: "Each room is guaranteed to fit 2 people. Extra guests are at the hotel's discretion…" (HotelTonight).

## Use when
Assigning against finite block inventory; warning ops/delegates that an action displaces someone or exceeds room capacity.

## Avoid when
Manufacturing urgency — scarcity numbers must be real inventory math, not marketing pressure (HotelTonight's "29 people viewing" is the anti-model for an ops tool).

## Sad paths observed
Sold-out countdowns and booking-hold timers (Klook "Pay within 14:23"); disabled options always carry the reason; ceiling pre-stated beats error-after-attempt.

## Accessibility
Disabled-with-reason beats hidden; counts as text adjacent to controls.

## Default verdict for our stack
RECOMMENDED — "2 of 2 beds filled" disabling further assignment, "Only 3 Twins left in the Hilton block", and the Eight Sleep displacement sentence on reassignment are direct steals. Pure-urgency theatrics: AVOID.
