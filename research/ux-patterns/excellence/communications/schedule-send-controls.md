# Pattern: Schedule controls — now/later cards, timezone choice, relative presets, batching
**Surface:** scheduling · **Observed in:** HubSpot, Mailchimp, Klaviyo, Apollo, Loops, Square, Workable, Shopify (refs: [HubSpot schedule tab](https://mobbin.com/screens/c49845b0-1e9e-4d80-8f83-14f085c35668), [Mailchimp send time](https://mobbin.com/screens/554f232d-8ca4-4844-b76f-d03618bc2cc5), [Klaviyo modal](https://mobbin.com/screens/3589d585-df8e-4115-8408-5686e2d79434), [Apollo presets](https://mobbin.com/screens/5d9581e4-6ddc-4554-8d2b-313a9987c02a), [Loops schedule](https://mobbin.com/screens/190a9d6e-16ea-4d17-9e9c-3f57d896dd92), [Square schedule](https://mobbin.com/screens/92b02ecd-b0c1-407c-8c2e-cd17522bcb8e), [Shopify send modal](https://mobbin.com/screens/a8bcea24-b445-4a74-84ad-3679df971102))

## Flow
1. Binary entry: "Send now" vs "Schedule for later" as radios (HubSpot) or cards (Mailchimp, Klaviyo); Loops expands "Later" inline into a calendar + 15-minute slot list.
2. Timezone is an explicit, answerable question: HubSpot radios — Account default (with "3:37 PM in your current time zone" equivalence shown) / My time zone / Recipient's time zone (varied); Klaviyo offers "Recipient's Local Timezone" as a dropdown value; Workable shows a plain (GMT+08:00) select.
3. Relative presets beat calendars for ops work: Immediately / In 1 hour / In 24 hours / Next business day morning / Custom (Apollo); Shopify suggests "Tomorrow at 9:00 pm EST ✨Suggested".
4. Large-audience controls: Mailchimp "Batch delivery — send in [2] batches of subscribers [5 minutes] apart, to prevent website-crushing click floods" + "Finalize your recipients at send time" checkbox; Square adds a "Repeat this campaign" toggle.
5. Optimization tier: Mailchimp "Send Time Optimization — best send time when scheduling at least 48 hours in advance".

## Use when
Any broadcast or reminder; the timezone question is unskippable for events whose attendees and organizers live in different zones.

## Avoid when
Transactional/cascade sends — they fire on the domain event, never on a clock the user picks.

## Sad paths observed
- Mailchimp's "finalize recipients at send time" resolves the segment at fire time, so late registrations are included — the alternative silently snapshots a stale list.
- Scheduled state is explicit afterward: "This campaign is scheduled to be sent at 4:45 pm GMT+7 on Nov 06, 2024" status row (Loops); scheduled confirm restates date/time (Eventbrite).

## Accessibility
Time pickers are dropdowns with discrete options (15-min increments), not free text; timezone consequence is spelled out in words.

## Default verdict for our stack
RECOMMENDED — now/later + explicit event-timezone display + Apollo-style relative presets; batch delivery maps directly onto our existing Inngest batch/sleep machinery.
