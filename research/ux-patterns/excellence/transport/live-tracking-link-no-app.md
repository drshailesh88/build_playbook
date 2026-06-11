# Pattern: Live tracking link — branded web page, no app install, time-boxed access

**Surface:** transport · **Observed in:** Limo Anywhere (Passenger Link), Onfleet, Moovs, Uber Central
(refs: P8, A7, F9, A39 — URLs in `_raw/`; key: https://kb.limoanywhere.com/docs/passenger-link/)

## Flow
1. Passenger receives SMS/email with a link, triggered either when the trip hits a chosen status (e.g. "On the Way") or N minutes before pickup (Limo Anywhere).
2. The link opens a mobile WEB page — no app: live driver position, trip status/progress, company branding; Onfleet's page adds one-tap call/SMS to the driver.
3. Link access is time-boxed: admins set "the desired time frame for your passenger to access trip information" — it expires after the trip.
4. The operator controls what the page reveals (which driver/order details — Onfleet/Circuit).
5. Notification triggers tied to real driver state: "Task Started", ETA-below-threshold, "Driver Arriving" within 150m (Onfleet) — not schedule guesses.

## Use when
Attendees ask "where is my shuttle?" — a tracking link in the pickup notification removes those calls from the ops desk. Works for any attendee with SMS, no onboarding.

## Avoid when
There's no live vehicle position to show (V1 without driver GPS) — a "live" page showing nothing erodes trust. A static trip-details page (vehicle, driver name/phone, pickup time/hub) is the honest V1 fallback; the same token-link mechanic applies.

## Sad paths observed
- Limo Anywhere: a missing `%URL-TRIP-CUST%` placeholder silently breaks the link in the message — template validation is required, not optional.
- Expired links must fail with an explanation, not a blank page (access window is deliberate).

## Accessibility
Web page over app is the accessible default; ensure the page works without JS-heavy maps for low-end devices (not observable from docs — flag for design).

## Default verdict for our stack
VIABLE — full live tracking needs driver position (V2 with driver surface); the time-boxed tokened trip-details page is V1-viable and matches our existing tokened-access patterns (cross-ref playbook card `tokened-access-landing`).
