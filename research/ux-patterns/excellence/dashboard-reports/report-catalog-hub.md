# Pattern: Report catalog hub (grouped named reports + tabs)

**Surface:** dashboard-reports / reports landing · **Observed in:** Eventbrite, Stripe (refs: https://mobbin.com/flows/547761cd-3c73-424c-b57a-aac81ec386a1, https://mobbin.com/flows/a1994371-58c7-4c02-95ec-5c7af5520a46)

## Flow
1. Eventbrite's "Reporting" page is tabbed: **Organization Reports** (the catalog) · **Scheduled reports** · **Analytics** (ad-hoc explorer).
2. The catalog groups report cards by domain (Sales: Orders, Sales, Sales Summary, Audit · Attendees: Attendees, Add-ons, Custom Questions Responses), each card = name + one-line description + icon; "New" badges mark recent additions.
3. Clicking a card opens a report PAGE (see preview-first-report-page), not a download.
4. Domain caveats live at the group level ("Reports may not reconcile … if they include amounts not collected by Eventbrite") — honesty copy at the catalog, not buried in a tooltip.

## Use when
There are ≥5 distinct report types — a grouped catalog with descriptions is how users discover reports they didn't know existed. The old app's 6-export-card grid is already a proto-catalog; grouping + descriptions + a scheduled tab is the mature form.

## Avoid when
≤3 reports — a tabbed hub around three cards is ceremony; inline them on the dashboard instead.

## Sad paths observed
- Eventbrite scheduled-reports tab empty state: "You can schedule up to 10 custom reports for your organization's active events" + "Create a report" — the empty state states the capability AND the limit.

## Accessibility
Cards are links with descriptive names — far better than icon-only download buttons.

## Default verdict for our stack
RECOMMENDED — the rebuild already has a per-event reports page and a global hub; adopting catalog grouping (Attendance / People / Logistics / Communications) plus per-card descriptions is nearly free and fixes discoverability of the 8-type registry (done-spec flags Agenda + Delivery-Log as missing from the catalog).
