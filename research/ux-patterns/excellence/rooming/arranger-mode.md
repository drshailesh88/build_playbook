# Pattern: Arranger mode (booking on behalf of someone else, unmissably)
**Surface:** rooming · **Observed in:** KAYAK for Business, Hopper, Booking.com, Navan, Urban Company
(refs: https://mobbin.com/flows/c90ce0c5-2eb0-4c3d-91ff-d7695b190c71 , https://mobbin.com/flows/c6e0d41a-4675-4019-b1c8-7b4c30b901c9 , https://mobbin.com/flows/2cc6d54f-cb9a-43ef-9985-735fa38a6014 , https://mobbin.com/flows/187c952e-572b-48d6-8ae7-08d9f14752ce ; raw: `_raw/by-flow.md` §F3/F15, `_raw/by-app.md` §A6)

## Flow
1. Mode entry: toggle "Book for yourself / Book for traveler"; entering traveler mode swaps the account chip to "Booking for John" AND pins a full-width banner "You are searching on behalf of John Smith" with "Exit mode" on every screen (KAYAK).
2. Guest record selection as an explicit step: "Who is booking? — This reservation will be under:" with person rows + "+ New Guest" (Hopper).
3. Inline variant for one-off: radio "Who are you booking for? — I'm the main guest / I'm booking for someone else" + "Full Guest Name" field (Booking.com).
4. The arranged record names its subject everywhere: "Reserved for Jane Doe" on detail and cancel screens (Navan); "Booked for >" person row (Urban Company).
5. Identity-match warning where it bites: "hotel might validate the info during check-in" (Shopee, §P4); "The name on the credit card used at check-in… must be the primary name on the guest room reservation" (TravelPerk, §F5).

## Use when
Ops acts as/for a delegate (editing their booking, submitting their preference); any flow where the actor ≠ the subject.

## Avoid when
The actor is always the subject — mode chrome with nothing to confuse is noise.

## Sad paths observed
Wrong-identity booking is the #1 arranger error this prevents; disabled "Not available for this result" cells in someone else's policy context; out-of-policy approval reminders in-mode.

## Accessibility
Mode banner is persistent, named, and dismissible only by exiting; chip + banner = two redundant signals.

## Default verdict for our stack
RECOMMENDED — when ops opens a delegate's record to act for them ("acting for Dr. Chen — Exit"), and the dual-ID display from Hopper (§A6: internal allocation ID vs hotel confirmation number side by side) rides along with it.
