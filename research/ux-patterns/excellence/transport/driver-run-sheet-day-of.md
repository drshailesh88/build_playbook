# Pattern: Driver run sheet — accept gate, ordered statuses, one active trip, everything on the card

**Surface:** transport · **Observed in:** Limo Anywhere (DriverAnywhere), Routific, TripShot, Via, Moovs
(refs: P2, P5, F7, F30, A21, A45 — URLs in `_raw/`; key: https://kb.limoanywhere.com/docs/how-to-use-driveranywhere-4-0/, https://kb.limoanywhere.com/docs/how-to-go-through-workflow-of-trip-in-driveranywhere-4-0/)

## Flow
1. Trips arrive in a Pending queue showing confirmation #, pickup date/time, passenger name, locations, flight info; driver must ACCEPT or REJECT before the trip becomes Upcoming.
2. Dashboard groups trips: In Progress / Pending / Upcoming / Completed; the job card carries everything at a glance — tap for Requirements, Passenger Info, Routing, Payment.
3. One-tap utilities on the card: phone icon calls the passenger, direction icon opens the device's map app, flight icon opens live flight tracking (FlightAware).
4. Ordered status progression via a bottom status bar: On The Way → Arrived (wait timer available) → Customer In Car → Dropped Off → Close Out. Airport-specific "Circling" status acknowledges curb reality.
5. "You must close out trip in order to start next trip" — one active trip at a time.
6. Statuses stream to the dispatch grid in real time (Limo Anywhere); rider notifications stay decoupled from driver connectivity (Via "Offline Mode"); Onfleet gives drivers a 2-minute grace window in dead zones, with a "slashed cloud" offline indicator to dispatch.
7. Zero-onboarding variant: driver receives an SMS link to their route — no account, no app install (Routific dispatch).

## Use when
Drivers need their day's work without calling dispatch: per-vehicle manifest with passenger names/phones, hubs, times — even as a printable/tokened web page before any native app exists.

## Avoid when
Drivers are untrusted third-party vendors who shouldn't see full passenger PII — scope the manifest (name + seat, masked phone via relay) rather than skip it.

## Sad paths observed
- Reject path exists at the accept gate (returns to dispatch for reassignment).
- Offline is designed-for, with explicit limits and dispatcher-visible state (Onfleet, Via).
- Status-tap timing is unreliable: Limo Anywhere's on-time report deliberately uses checkpoint data "rather than trip status changes".

## Accessibility
SMS-link delivery (Routific) means any phone works. Driver UIs are glanceable-by-design (large status buttons); not further observable from docs.

## Visual evidence (Mobbin re-sweep 2026-06-11) — STRONG (single-app caveat)
DoorDash Dasher is the only true gig-driver app on Mobbin (Uber Driver / Lyft Driver / Amazon Flex / Bolt Driver absent), but its coverage is deep; nav apps supply the stop-list anatomy (full detail in `_raw/mobbin-resweep.md` §3):
- The run-sheet spine: "Current dash" ordered task list with per-stop deadlines ("Pick up for [name] — by 3:31 PM" tagged "Current task") — exactly one task current (https://mobbin.com/screens/5859ffb5-02a0-45ee-9065-2ea87eaf43fa).
- Per-stop actions: name + call/text + "Directions" handoff, completion gated behind a verification CTA — the tap-to-board analog (https://mobbin.com/screens/8129d89c-6823-4706-b602-d76b35d72304).
- Sad-path copy at the stop: waiting buffer ("Your on-time rate includes a buffer for extra time spent waiting"), ID checks, pickup instructions (https://mobbin.com/screens/5cb6f086-abb8-4751-874a-e2901cb238e3).
- Stop list with projected arrivals + call-from-row + "End Route" terminator (Apple Maps, ADJACENT, https://mobbin.com/screens/e699f8a1-ab48-42a3-8ed2-3b4e6ca43401); lettered drag-to-reorder stops (Google Maps, ADJACENT).

## Default verdict for our stack
RECOMMENDED — legacy had NOTHING driver-facing (done-spec #34 NEVER-ATTEMPTED). V1-honest version: tokened driver manifest web page per vehicle (passengers, phones, hubs, times) + printable trip sheet; status buttons can come later. The stop-row anatomy (deadline, current-task marker, call/navigate actions, waiting-state copy) is now screen-verified; the accept/decline loop remains vendor-doc-based (and is V2 anyway).
