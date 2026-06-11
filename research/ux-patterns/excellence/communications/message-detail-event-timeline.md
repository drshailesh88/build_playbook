# Pattern: Message detail — per-send event timeline with content tabs
**Surface:** delivery-log · **Observed in:** Resend, AutoSend, folk (refs: [Resend detail](https://mobbin.com/screens/ffacb4cf-8fb9-4b00-9ea4-09c9aeb207ff), [Resend dark](https://mobbin.com/screens/5377d748-9e5c-42b0-a664-1d6eb1c2f1a7), [AutoSend event history](https://mobbin.com/screens/b2af058f-f466-4b15-a7fd-4b09dcf24951), [folk activity](https://mobbin.com/flows/087543d6-7221-46d9-94b8-3eca45fbddca))

## Flow
1. Dedicated page (or modal) per message: header rows FROM / SUBJECT / TO / copyable message ID / topic (Resend).
2. "EMAIL EVENTS" horizontal stepper: Sent → Delivered → Opened → Opened…, each step icon + timestamp; hovering a step explains it in a sentence ("Resend successfully delivered the email to the recipient's mail server") with "See details" (Resend).
3. AutoSend's modal variant GROUPS events by hop: "Received by AutoSend" (PROCESSED/QUEUED/SENT) → "Received by Google mail server" (DELIVERED + green "IN 1 SEC" latency badge) → "Received by <recipient>" (OPENED ×N) — where the message is, told as a story.
4. Body shown as it was sent, in tabs: Preview / Plain Text / HTML / Insights (Resend) — the rendered content is part of the forensic record.
5. folk shows the same as a per-recipient "Activity" feed ("LVMH opened 4 minutes ago / received 4 minutes ago") above the rendered message.

## Use when
Support escalations: "the keynote speaker says she never got the itinerary" — one screen must answer what was sent, when, what the provider did, and what it looked like.

## Avoid when
As the only log view — the table (delivery-log card) is the entry point; this is its drill-down.

## Sad paths observed
- Failure step renders in the same timeline with its reason, keeping one mental model for good and bad sends.
- Copyable provider message ID supports the provider-support escalation path (Resend).

## Accessibility
Timeline steps carry text labels + timestamps (not icon-only); tabs are standard.

## Default verdict for our stack
RECOMMENDED — our delivery_events table is this page's data already (forensic journal, forward-only CAS); rendering stored content (we persist rendered bodies) completes the "what did they actually receive" answer.
