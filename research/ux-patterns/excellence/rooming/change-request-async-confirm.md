# Pattern: Change-as-request with async confirmation (modify hub + tracked request states)
**Surface:** rooming · **Observed in:** Trip.com, Booking.com, TravelPerk, BlaBlaCar, Airbnb
(refs: https://mobbin.com/flows/70684c67-9353-48bc-b9cf-0b734417e78f , https://mobbin.com/flows/e67add4a-00b7-42fa-9598-ec93e0b4f721 , https://mobbin.com/flows/64971d3f-f207-4b24-8588-9fb4e87eff98 ; raw: `_raw/by-flow.md` §F9/F8, `_raw/by-app.md` §A2/A10/A13, `_raw/by-pattern.md` §P32)

## Flow
1. Modify hub decomposes the booking into independently editable facets with current values: "Contact Info / Guests / Dates / Rooms — Modify >" (Trip.com); "What would you like to change about your reservation?" constrained intent menu, inapplicable options disabled not hidden (Airbnb).
2. Honest async framing where a third party must agree: "ⓘ Modification requests need to be confirmed. The hotel adjusts room rates based on demand… Please recheck your selection." (Trip.com).
3. Pending requests are trackable: "Track your requests >" row on the booking (Booking.com).
4. Change-approval tiers configured by policy: "Executive travel — We make all changes when we get the request" vs "Simple reschedule (Recommended) — date/time changes auto-applied, approver notified" vs "Admin out-of-hours — all changes need approval, exception if trip starts in next 48h" (TravelPerk).
5. Terminal state with receipt: "Your booking has been successfully updated — We sent a confirmation email to…".

## Use when
Delegates request changes against contracted inventory: the hotel (or ops) must confirm before the change is real.

## Avoid when
Ops edits their own draft data — request ceremony on self-owned drafts is bureaucracy.

## Sad paths observed
- Rate/availability consequences warned before entry; un-actionable axes disabled with visible reason; request-vs-instant split made explicit per change class (TravelPerk tiers).

## Accessibility
Facet rows summarize current values inline so screen-reader users hear state before choosing to edit.

## Default verdict for our stack
RECOMMENDED — the delegate-side change loop: axis menu → availability re-check against the block → diff confirm (`change-diff-confirmation.md`) → tracked "pending hotel ack" state. TravelPerk's tier model answers "which changes auto-apply vs queue for ops" precisely.
