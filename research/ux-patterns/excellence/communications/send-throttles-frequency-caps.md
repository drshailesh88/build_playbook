# Pattern: Send-safety valves — frequency caps, batch delivery, visible quotas
**Surface:** send-safety · **Observed in:** Klaviyo, Mailchimp, Eventbrite, GoDaddy, AutoSend (refs: [Klaviyo smart sending](https://mobbin.com/screens/1f67f4a3-aa78-4551-b069-559c09aeeb50), [Mailchimp batch](https://mobbin.com/screens/554f232d-8ca4-4844-b76f-d03618bc2cc5), [Eventbrite quota](https://mobbin.com/screens/c659ef6e-f76b-4dfc-8f07-34b10072b6e8), [GoDaddy credits](https://mobbin.com/flows/c40e72cd-b6b0-4492-a917-737219725395), [AutoSend buffer](https://mobbin.com/screens/34d2c4f5-0fa8-4789-946e-c343627cd5c4))

## Flow
1. Recipient-level frequency cap as a per-message setting: "☑ Skip recently emailed profiles — Smart Sending will skip anyone who received an email within the last 16 hours" (Klaviyo flow email node).
2. Infrastructure-level batching at schedule time: "Send in [2] batches of subscribers [5 minutes] apart — to prevent website-crushing click floods" (Mailchimp).
3. Quota made visible where sending happens: "Daily limit 4/250" meter on the campaign page (Eventbrite); "97 of 100 email credits remaining this month" gauge beside the campaign list (GoDaddy).
4. Send-time undo window: "We'll have a 2-minute buffer before sending the campaign, just to play it safe" (AutoSend).
5. Skips are logged as a distinct status (Suppressed/Skipped), not silently dropped (AutoSend funnel strip).

## Use when
Multiple automations + manual broadcasts can hit the same person in one day (exactly the conference cascade situation: travel update + program update + reminder).

## Avoid when
Critical operational messages (gate change, pickup time) — a frequency cap must never eat these; safety valves need a message-class exemption.

## Sad paths observed
- The cap is per-node opt-in with the window stated (16 hours) — authors know what they're trading.
- Quota exhaustion is foreseeable (meters) instead of a surprise provider rejection.

## Accessibility
Checkboxes and meters with text values; nothing color-only.

## Default verdict for our stack
VIABLE — we already debounce per-record cascades; the deltas worth stealing are the per-trigger "skip if messaged in last N hours" option with operational-class exemption, and a visible per-event send counter.
