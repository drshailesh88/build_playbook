# Pattern: Timed passenger notification ladder (booked → driver assigned → arriving → outcome)

**Surface:** transport · **Observed in:** Uber Central, Welcome Pickups, Circuit/Spoke, Moovs, SAS/Hoppa, Limo Anywhere
(refs: F8, A40, A31, P9, A14, F10 — URLs in `_raw/`; key: https://help.uber.com/business/article/text-messages-riders-receive?nodeId=1d773c1e-db7c-4a9a-bb98-7c8a8f89eb23, https://help.spoke.com/en/articles/7041450-how-to-set-up-recipient-notifications)

## Flow
1. Fixed ladder per ride type (Uber Central): (a) booking confirmation naming WHO arranged it ("notifies rider that their company scheduled a ride"); (b) reminders at documented times ("9am the day before and 30 minutes before"); (c) driver assigned/arriving — "driver's first name, vehicle information, license plate, estimated arrival time" + tracking link; (d) cancellation notice routing the rider back to the arranging company.
2. Trigger-based variant (Circuit, three stages): route started → "your stop is next in queue" → outcome (success OR failure), with template variables: Customer name, Driver name, Tracking link, Position in queue, Earliest/Latest time.
3. Recipient matrix with per-trip override (Moovs): defaults say passengers/booking-contacts/both per notification class; "More > Notify" overrides one trip; "If no triggers are selected no status update notifications will be sent" — zero-trigger = zero-send is explicit.
4. Driver change re-notifies: "your designated driver may change... in which case a new driver confirmation email will be sent" (Welcome Pickups).
5. Channel reality: SMS is the documented backbone; WhatsApp documented only as SAS/Hoppa "1 hour prior to your pick up time"; messages localize to the booker's language (Uber).

## Use when
Telling attendees their pickup details (vehicle, driver, time, hub) and keeping them current through changes — coordinator-booked, no app installed.

## Avoid when
Details aren't stable yet — notifying off an unconfirmed suggestion teaches attendees to ignore messages. Gate the first send on batch confirmation (`ready` or explicit "send pickup details" action).

## Sad paths observed
- Missing contact info = documented silent skip ("If no details are provided, no recipient notifications can be sent" — Circuit) — surface this to ops as a flag, not a mystery.
- Cancellation has its own message in every Uber ride type; failure outcome is a first-class stage-3 notification (Circuit).
- Inbound replies and STOP opt-outs are first-class events (Onfleet webhooks: `smsRecipientResponseMissed`, `SMSRecipientOptOut`) — passenger texts back must land somewhere.

## Accessibility
SMS-first design is itself the accessibility play — no app, no smartphone assumption (automated voice call documented as an Uber Central option).

## Visual evidence (Mobbin re-sweep 2026-06-11) — STRONG
Screen-level confirmation of the rider-facing surfaces (full detail in `_raw/mobbin-resweep.md` §1):
- Arrived/nearby states with vehicle identity: Grab lock-screen Live Activity ("Driver has arrived" + plate + vehicle, https://mobbin.com/screens/9a700872-7aee-4cde-9fc4-17603d866cde); plate rendered as the LARGEST element at the arrived moment (https://mobbin.com/screens/f157d309-d94b-4750-96dd-74cc946b7cde); Bolt plate badge + color named in words (https://mobbin.com/screens/ba45f249-6dba-4711-86e3-0c06c07af24c).
- No-show grace stated as a clock time: "Meet your driver by 6:48 PM to avoid extra fees or cancellation." (Grab, https://mobbin.com/screens/915e0c83-1168-4c7f-9dea-a7905123b483).
- Wrong-car prevention: Uber ride PIN tiles + "I've arrived" self-report (https://mobbin.com/screens/d72a83f6-0ca5-4415-ad39-14f58c8bf092).
- Static meeting-point page (the no-app trip-details shape): GetYourGuide — address + "Arrive by 15.45" + human-recognizable landmark instructions + cancellation sad path (ADJACENT, https://mobbin.com/screens/068c3193-5700-477c-a862-6dd863ee2238).
- Delay notice: DoorDash old-vs-new time juxtaposition ("Original arrival time" inset box, ADJACENT, https://mobbin.com/screens/9e3be4f0-fbc1-4a10-9cd8-608569a9d4a6); "Estimated" vs "Latest arrival by" dual-time framing (Uber Eats web).

## Default verdict for our stack
RECOMMENDED — legacy never sent a single transport notification (enum existed, zero sends). Steal the ladder shape, who-arranged-this context, driver-change re-send, and the explicit zero-trigger/no-contact rules. Message CONTENT anatomy (vehicle/plate prominence, clock-time grace, old-vs-new delay framing) is now screen-verified; the batch-send orchestration (when each rung fires) remains vendor-doc-based.
