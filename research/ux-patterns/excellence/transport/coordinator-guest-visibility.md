# Pattern: Coordinator books, guest rides app-less, responsible party gets milestones

**Surface:** transport · **Observed in:** Uber Central, Zūm, HopSkipDrive, Onfleet (Courier Client View)
(refs: F27, F28, A39, A40, A41, A44 — URLs in `_raw/`; key: https://help.uber.com/business/article/arranging-uber-central-rides?nodeId=a459906c-5ed2-4d48-b09d-90e5196cb3af, https://www.hopskipdrive.com/blog/hopskipdrive-ride-experience/)

## Flow
1. Coordinator books on the guest's behalf ("New ride": rider count, preferred language, pickup/dropoff, vehicle type, driver notes); the guest gets SMS with trip details + tracking link — "no Uber app required".
2. The coordinator monitors live ("Today's activity"/"Upcoming"), edits up to a hard cutoff ("scheduled rides can only be edited up to 25 minutes prior"), cancels per leg, and re-books past trips in one click.
3. The responsible party receives milestone events: driver on the way → arriving → picked up → dropped off, with scheduled-vs-actual times (Zūm); closing message confirms "your rider has arrived safely at their destination" (HopSkipDrive).
4. Identity is verified at pickup when the passenger isn't the booker: driver states a code word, rider confirms an identifier — mutual authentication against wrong-car/wrong-passenger (HopSkipDrive).
5. Scoped third-party portals: clients see and manage THEIR orders only, with their own branding/notifications, never the whole board (Onfleet Courier Client View).

## Use when
Conference ops books VIP/faculty transport; event coordinators or agencies need visibility into their own people's trips without ops-level access.

## Avoid when
Self-managed staff shuttles — milestone spam to a coordinator who didn't ask for it. Scope: milestones go to the explicit booking contact, not every admin.

## Sad paths observed
- Edit cutoff (25 min) and per-leg cancellation are explicit guardrails (Uber Central).
- Cancellation messages route the guest back to the ARRANGER, not the platform — the coordinator owns the relationship.
- "preferred language" is a booking field (Uber) — international attendees get messages they can read.

## Accessibility
SMS + automated voice-call option (Uber Central) covers non-smartphone guests.

## Default verdict for our stack
VIABLE — the booking side already exists (ops assigns passengers); the deltas are milestone notifications to a booking contact and read-only scoped visibility. Pickup verification (code word) is conference-relevant for VIP cars.
