# Pattern: Group room-block sourcing (RFP → hotel bids → award/stop lifecycle + shareable attendee page)
**Surface:** rooming · **Observed in:** Expedia Groups, TravelPerk, Navan
(refs: https://mobbin.com/flows/8c7e207c-f722-4c64-9190-d2591cf1eb2c , https://mobbin.com/flows/556d44a2-58b4-43f4-af98-5ed45ac0dc03 , https://mobbin.com/screens/e402101c-86bc-4441-90b8-635b11dc2fda , https://mobbin.com/flows/2e2fe01b-2540-40d7-a35c-60bb6a4013e9 ; raw: `_raw/by-flow.md` §F23, `_raw/by-app.md` §A18/A22)

## Flow
1. RFP form: destination, dates, group type, "# ROOMS PER NIGHT", star-rating target, nightly-budget slider, room types ("2 Double Beds (1-2 People)"), optional meeting/banquet space with specs (Expedia Groups).
2. Request dashboard: Reservation ID, Status Active, named human agent with phone, per-night per-room-type count grid, "Modify Request" / "Stop Hotel Bidding".
3. Bid inbox with status filter rail: "New (1) / No Action Yet / Contacted / Declined Bids / Unavailable Hotels / No Bid Yet (192)"; bid cards with weekday/weekend rates, tax %, inclusions ("Rate includes breakfast. Each room bed type can be arranged individually later"), actions "Contact Hotel / Decline Bid / Instant Book".
4. Shareable attendee booking page: "…specially negotiated group rates that you can send to your guests without setting up a group hotel block" + "Customize This Page / Invite Attendees".
5. Structured close: "Stop Hotel Bidding" requires a reason ("WE SELECTED [hotel] / WE DO NOT NEED THE ROOMS ANYMORE / …"); closed requests re-activatable/copyable with a bid tally.
6. Self-serve threshold to humans: "Need 9 or more rooms for your group? Request a group booking — …our dedicated in-house team… will handle everything" (TravelPerk).

## Use when
Sourcing blocks before an event; offering delegates a self-book page against negotiated rates instead of (or alongside) ops assignment.

## Avoid when
Blocks are already contracted offline — then EventState's job starts at recording the block (`block-inventory-grid.md`), not sourcing it.

## Sad paths observed
Decline-bid and "No Availability" hotel states; structured stop reasons; closed-with-reactivate lifecycle; per-night counts tapering mid-stay.

## Accessibility
Bid cards carry rates as text tables; status filters word+count.

## Default verdict for our stack
VIABLE (likely post-V1 scope) — the negotiation/award loop itself is invisible even here (`first-principles-gaps.md` #9), but the RFP data shape (rooms-per-night per room type) is exactly the block record EventState should store, and the attendee self-book page is a powerful V2 concept.
