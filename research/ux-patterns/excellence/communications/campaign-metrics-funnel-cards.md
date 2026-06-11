# Pattern: Campaign metrics — funnel stat cards with denominators and recipient-outcome tabs
**Surface:** analytics · **Observed in:** Mailchimp, Klaviyo, HubSpot, Pipedrive, GoDaddy, folk, Loops (refs: [Mailchimp report](https://mobbin.com/screens/b8f8f7c3-482f-41be-9b55-ba97b983285f), [Klaviyo detail](https://mobbin.com/screens/513c7564-8fc8-41f9-a20f-142db466036c), [HubSpot performance](https://mobbin.com/screens/683e0e96-590f-443a-b5c5-3f0be8b54b5f), [Pipedrive recipients](https://mobbin.com/flows/ffff2c8d-5da8-402a-906a-f05b96fb3e09), [GoDaddy summary](https://mobbin.com/flows/c40e72cd-b6b0-4492-a917-737219725395), [folk stats](https://mobbin.com/flows/087543d6-7221-46d9-94b8-3eca45fbddca), [Loops metrics](https://mobbin.com/flows/7fa5c7ff-bfab-48aa-9167-c6f0daf64424))

## Flow
1. Stat-card strip per campaign: Opened / Clicked / Bounced / Unsubscribed (Mailchimp boxes), always with the DENOMINATOR visible — "50.00% — 1 / 2 recipients" (GoDaddy), "Open rate 33.3% — 1 recipient" (Klaviyo).
2. Recipient-outcome TABS with counts turn rates into people lists: Delivered (3) / Opened (1) / Clicked (0) / Unsubscribed (1) / Bounced (2) / **Unopened (2)** (Pipedrive); folk adds negations (Not sent 1 / Not opened 8 / Not clicked 10).
3. Engagement-over-time chart with removable metric chips (Delivered× Opened× Clicked×) and hourly/daily granularity (Klaviyo, Pipedrive).
4. Honesty affordances: folk's tooltip — "Open rates can be unreliable due to image blocking and automatic opens… rely on the 'Replied' metric"; HubSpot's "Bot filtering is currently ON" + "Calculate adjusted open rate" + device split.
5. Account-level rollup: date-range + compared-to-previous-period strips (HubSpot Analyze); composable dashboard cards with funnel summary (Klaviyo "Add card"); export — Download/Print/Share (Mailchimp), Download Campaign Metrics (GoDaddy), Export charts (HubSpot).
6. Pre-send placeholder: "Metrics will appear here after a campaign has been sent" (Loops) — metrics is a permanent tab of the campaign object, never a separate report to find.

## Use when
Any send list or campaign detail; counts with denominators are what organizers actually report to committees.

## Avoid when
Open-rate-centric dashboards for WhatsApp-heavy channels — read receipts and email opens aren't comparable; lead with delivered/failed there.

## Sad paths observed
- Failed/bounced get their own card AND their own people tab — failure is always one click from the number.
- Zero-state metrics render as 0% cards, not hidden sections (HubSpot trial states).

## Accessibility
Cards pair % with absolute counts in text; chart data is also available as the recipients-by-outcome tables.

## Default verdict for our stack
RECOMMENDED — M13 hub cards (sent per channel / delivered rate / failed count) + per-campaign outcome tabs; our webhook status data already supports delivered/read; treat folk-style metric honesty as copy guidance.
