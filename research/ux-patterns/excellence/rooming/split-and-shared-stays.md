# Pattern: Split-stay timeline rendering + shared-room disclosure language
**Surface:** rooming · **Observed in:** Pangea, Vrbo, Tripsy, Wanderlog, Airbnb, Booking.com (dorms)
(refs: https://mobbin.com/screens/be9c7323-d039-4171-8e8e-312b9f3216d5 , https://mobbin.com/screens/04ca4e80-4441-49b5-8333-fcf9a93e392c , https://mobbin.com/screens/f44f2d94-0764-493e-8a8b-a3d42f2acd99 , https://mobbin.com/screens/62a4e3c6-22eb-425e-a710-46796944c22a ; raw: `_raw/by-app.md` §A1/A21, `_raw/by-pattern.md` §P33, `_raw/by-flow.md` §F29)

## Flow
1. A multi-night stay renders as TWO boundary events on the day timeline — "Monday 12 Jan · Check-in 01:00 pm" and "Tuesday 20 Jan · Check-out 10:00 am" — same card repeated at both nodes (Pangea/Vrbo); day-of-event ordinals alongside dates ("Day 1").
2. Consecutive stays chain with a suggestion, not a warning: "Extend your trip at another stay" (Vrbo); transfer logistics seeded in notes ("Luggage storage available after checkout") (Wanderlog).
3. Shared-room taxonomy in plain language: "An entire place / A room — own room plus shared spaces / A shared room — may be shared with you or others"; "Will guests have the place to themselves?" (Airbnb).
4. Roommate-adjacent add-guest flow: capacity-capped "Add a guest (9 left)", "Guests you add get emailed the reservation details.", price-delta review (Airbnb §F29).
5. Dorm-bed inventory as rows with gendered variants ("6 Bed Mixed Room" / "6 Bed Female Room") and bed-count steppers (Booking.com hostel table) — the only shared-sleeping inventory UI on Mobbin.

## Use when
A delegate spans two hotels (block exhausted mid-range); shared twins need explicit disclosure to both occupants; gendered shared-room policies apply.

## Avoid when
Hiding the split — one opaque "Oct 10–14" range over two hotels guarantees a delegate stranded at the wrong front desk.

## Sad paths observed
Same-day check-out/check-in pairs need a transfer note; nobody warns on itinerary gaps (suggestion-only) — an ops tool should.

## Accessibility
Each boundary event self-contained (hotel, time, address) so a screen-reader pass at day level is complete.

## Default verdict for our stack
VIABLE — split-stay display grammar and sharing disclosure are ready steals; the ops-side DECISION to split (who, where, when to break the stay) is unmodeled anywhere — `first-principles-gaps.md` #8.
