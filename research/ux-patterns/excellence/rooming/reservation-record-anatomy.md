# Pattern: Reservation record anatomy (canonical detail page: status under title, copyable refs, actions one tap away)
**Surface:** rooming · **Observed in:** Booking.com, Uber Eats, TheFork, Viator, Urban Company, Hopper, Marriott
(refs: https://mobbin.com/screens/55a408fc-b5a0-4f4a-a262-30b6c08df874 , https://mobbin.com/screens/61d2b40d-dbed-4707-8bc1-c296072674c2 , https://mobbin.com/screens/fb6d3586-fbd8-436d-b2a4-fcb700b10f43 , https://mobbin.com/flows/fce87f24-b0c5-465a-8f73-dc82f04450dc ; raw: `_raw/by-pattern.md` §P4, `_raw/by-app.md` §A6/A11)

## Flow
1. Status pill immediately under the title, never buried: "✓ Confirmed" (Uber Eats/TheFork).
2. The who/where/when block: dates with check-in/out windows, guest count, room type; address with copy icon + "Get directions"; phone tap-to-call.
3. Reference numbers one-tap copyable with toast ("Copied to clipboard"); dual IDs displayed side by side — platform confirmation vs hotel reservation code (Hopper §A6).
4. Action row right there: Modify / Cancel / Call — cancel in red, never primary; full-width "Manage booking" as the umbrella (Booking.com).
5. Interim states modeled in words: "Booking scheduled — A professional will be assigned to this booking soon" (Urban Company) — the delegate-awaiting-room state verbatim.
6. Policy restated on the record: cancellation deadline with fee in hotel-local time (Marriott §A11); "Contact the property — Discuss changes… or ask about facilities and special requests."

## Use when
The per-delegate accommodation record page — the unit ops and delegates both reason about.

## Avoid when
Cramming list-level tools into the record — the record is one booking's truth; the list owns filters and bulk.

## Sad paths observed
Guest-name validation warning ("hotel might validate the info during check-in"); "assigned later" interim status; cancelled records retain full detail muted.

## Accessibility
Copy controls labeled; status as word+color under the title; destructive action visually isolated.

## Default verdict for our stack
RECOMMENDED — the old app has a basic detail page; the deltas: status under title, copyable dual IDs, awaiting-assignment interim state in words, and policy/cutoff restated on the record.
