# Pattern: Scheduled report subscriptions (email/Slack digest)

**Surface:** dashboard-reports / scheduled reports · **Observed in:** Amplitude, Eventbrite, Circle, Fabric, Hotjar, Frame.io (refs: https://mobbin.com/screens/6289030e-f575-44f9-91a3-cc56ec59cb32, https://mobbin.com/flows/547761cd-3c73-424c-b57a-aac81ec386a1, https://mobbin.com/screens/95f30b50-c3ae-46cb-a2f2-816a0ae53926, https://mobbin.com/screens/3bb015cd-1682-477d-a923-880641a4a5d6, https://mobbin.com/screens/f9a70dd3-b0af-4a79-9ebd-8aa15305465b)

## Flow
1. Amplitude's "Subscribe to Dashboard Reports" modal: Email / Slack tabs, timezone selector ("Showing times as (UTC-05:00) America/Detroit"), a schedule table — each subscriber row gets frequency ("Every Tuesday at 12AM") and an optional CSV attachment toggle — plus "Add new subscriber(s)" by name or email.
2. Eventbrite scopes it to the domain: "Schedule Reporting Emails — you can schedule up to 10 custom reports for your organization's active events."
3. Digest-style variants (Circle/Fabric): enable toggle, frequency (Daily/Weekly) + day + time + timezone, content-section toggles (hide stats / hide new members), customizable introduction text.
4. Confirmation is explicit: "Your schedules have been updated successfully."

## Use when
The same person pulls the same report every Monday — committee chairs, department heads, the registration lead during the pre-event ramp. Subscriptions convert pull into push and make the product the heartbeat of the event's ops cadence.

## Avoid when
Notification infrastructure (sender domain, unsubscribe, bounce handling) isn't solid yet — a digest that lands in spam or can't be killed damages trust; ship after the communications module's sender setup is proven.

## Sad paths observed
- Recipient without account access — Amplitude allows external emails but the report content is then a static attachment, not a login wall (decide deliberately for PII-bearing reports; attendee lists must NOT auto-attach to external emails).
- Cap stated upfront (Eventbrite's "up to 10") instead of a surprise error at #11.

## Accessibility
Plain form controls; the digest email itself needs a text-first layout.

## Default verdict for our stack
VIABLE (V2-leaning) — extremely strong fit for conference ramp-up cadence, but it stacks on exports + email infra; the per-subscriber-schedule table is the model to copy when built.
