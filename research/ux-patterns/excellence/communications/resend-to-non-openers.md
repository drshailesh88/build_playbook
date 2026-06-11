# Pattern: Resend to non-engagers — one-toggle follow-up and outcome-tab re-targeting
**Surface:** post-send ops · **Observed in:** Square, Pipedrive, folk (refs: [Square reminder toggle](https://mobbin.com/screens/1ce7c729-82db-4fdb-b4be-e25580d2c0c1), [Pipedrive recipients](https://mobbin.com/flows/ffff2c8d-5da8-402a-906a-f05b96fb3e09), [folk outcome tabs](https://mobbin.com/flows/087543d6-7221-46d9-94b8-3eca45fbddca))

## Flow
1. Cheapest form — a toggle on the pre-send review page: "Reminder — If the email is not opened, resend the email 5 days after the original delivery date" (Square). One decision, no new UI surface.
2. Data form — recipient outcome tabs include the negative classes: Unopened (2) (Pipedrive), Not opened 8 / Not clicked 10 (folk) — the re-target audience is already a visible, countable list.
3. Sequence form — folk's "Stop if replies" toggle inverts it for follow-up sequences: engagement halts the next step.

## Use when
Response-critical sends with a deadline: faculty confirmation requests, registration-payment reminders, RSVP chasing — conference comms are full of "didn't respond" workflows.

## Avoid when
Open tracking is unreliable for the channel/audience (image-blocking, plain-text mail) — folk's own tooltip warns opens are approximate; never auto-resend on opens alone where false negatives spam engaged people. Never apply to transactional confirmations.

## Sad paths observed
- folk pairs the feature with the honesty tooltip about open-rate reliability — the vendor disclaims its own trigger signal.
- Square's delay (5 days) is stated in the toggle copy, not hidden in settings.

## Accessibility
Toggle with full-sentence label; outcome tabs are counted text tabs.

## Default verdict for our stack
VIABLE (V2-leaning) — WhatsApp read receipts (we already ingest READ status) make this MORE reliable for us than for email-only tools; the v1 floor is the Unopened/Not-delivered outcome tab in campaign metrics so ops can re-target manually.
