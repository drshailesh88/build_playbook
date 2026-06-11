# Pattern: Person-to-unit picker (seat-map grammar: claim a specific slot, per-person turn-taking, completeness check)
**Surface:** rooming · **Observed in:** Booking.com flights, Hopper, American Airlines, Singapore Airlines, Expedia, Trip.com
(refs: https://mobbin.com/flows/72cb6bf2-bf63-476e-b11d-ea8353685c64 , https://mobbin.com/flows/bb3a8fc0-90c4-4dba-a6a8-70fb9b09c178 , https://mobbin.com/screens/bdb3990f-c5a3-4d4d-9de9-d41d842e28e3 , https://mobbin.com/screens/ce7bacb5-e107-4a4f-815e-e18052e17917 ; raw: `_raw/by-app.md` §A12, `_raw/by-flow.md` §F20/F21, `_raw/by-pattern.md` §P35)

## Flow
1. Spatial grid of labeled units with a legend carrying state + price ("Available seat ($18.31 – $46.31) / Unavailable / Selected"); taken units = ✕, visible not hidden.
2. Tap unit → assignment sheet binding it to a named person: "Seat 3C — $36.31 — Assign seat to: Traveler 1 (adult) — [Assign]" (Booking.com).
3. Per-person turn-taking when assigning several people: header dropdowns segment + "Judy Smith — Selecting"; auto-advance to next person/segment (Hopper).
4. Per-person progress tray: "Seats: 1 of 2 selected"; completion gate "All set! All passengers have a seat for this flight." (Booking.com).
5. Skip path with stated default: "If you decide to skip this step, seats will be assigned at check-in." / "We'll auto-assign seats at no charge after you check in." (Hopper/AA).

## Use when
Assigning a named delegate to a specific room/bed; pairing roommates one bed at a time; any "every person needs a slot" completeness validation.

## Avoid when
Specific unit identity doesn't matter yet (room numbers unknown until hotel allocates) — assign to room TYPE instead and don't fake precision.

## Sad paths observed
- Unavailable units visible as ✕; time-boxed holds ("14:53 left to finish your booking!"); non-refundable selection warnings ("Cannot be canceled. Invalid after flight tickets have been changed.").
- Turn-taking prevents two people claiming one unit.

## Accessibility
Each unit needs a complete accessible label ("42C, Standard Seat, SGD 12.80, available"); selection echoed in a persistent footer.

## Default verdict for our stack
RECOMMENDED — "all N delegates have a bed" is the module's completeness check, and auto-assign-fallback is the right default for delegate self-serve preference. No hotel floor-plan picker exists on Mobbin (`first-principles-gaps.md` #7); airlines own this pattern and it transfers as assembly.
