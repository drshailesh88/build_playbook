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

## Default verdict for our stack
RECOMMENDED — legacy never sent a single transport notification (enum existed, zero sends). Steal the ladder shape, who-arranged-this context, driver-change re-send, and the explicit zero-trigger/no-contact rules.
