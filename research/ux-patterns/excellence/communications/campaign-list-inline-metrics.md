# Pattern: Campaign list — status badges, inline outcome metrics, continue-editing drafts
**Surface:** campaign-list · **Observed in:** Customer.io, Mailchimp, Loops, GoDaddy, folk, Pipedrive (refs: [Customer.io list](https://mobbin.com/screens/b83be075-2f4b-47cd-b46e-2e6ab2e1b44e), [Mailchimp list](https://mobbin.com/flows/448ac1a5-ea17-4abd-a942-5fcb7ab325c1), [Loops groups](https://mobbin.com/flows/dcd595e1-6207-4f0f-b015-47d7048d00bc), [GoDaddy list](https://mobbin.com/flows/c40e72cd-b6b0-4492-a917-737219725395), [folk list](https://mobbin.com/flows/0f633d24-030d-4ae3-823f-a1e734b6245c))

## Flow
1. Each row: name + type icon, status badge (Draft / Scheduled / Sent / Active / Ongoing), audience, last-edited — and INLINE METRICS COLUMNS: Failed (red count) / Delivered / Opened % / Clicked % / Converted % (Customer.io); Sends/Opens/Clicks (Loops); Recipients/Sent/Opened/Replied/Bounced (folk).
2. Drafts substitute metrics with a state line + primary action: "Newsletter not sent." + **Continue editing →** (Customer.io); "Finish setup" (Mailchimp).
3. Filters: type/status/folder/date/tags + search + sort by last edited; status tab-chips All / Drafts / Scheduled / Sent (HubSpot, GoDaddy).
4. Views: List | Calendar toggle (Mailchimp); named lifecycle groups with per-group add (Loops: Newsletters/Updates/Surveys/Promotions).
5. Row utilities: Clone (GoDaddy), Export CSV of the list (Customer.io).

## Use when
More than a handful of sends per event — the list is the de-facto dashboard; failed counts surfaced here are the operator's first alarm.

## Avoid when
Pure transactional logs (single sends) — that's the delivery-log table, keyed by recipient not by campaign.

## Sad paths observed
- Failed count is a red number IN the row — failures surface without opening reports (Customer.io).
- Draft rows can't be mistaken for sent ones: badge + missing metrics + different CTA.

## Accessibility
Real table columns with headers; badges text-labeled; row actions are buttons not hover-only (Customer.io keeps a visible ⋯).

## Default verdict for our stack
RECOMMENDED — applies to both our broadcasts list and the triggers list (per-trigger fired/failed counts); red failed-count inline is the cheapest path from list to incident.
