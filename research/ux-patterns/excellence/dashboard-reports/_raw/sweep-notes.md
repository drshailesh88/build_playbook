# dashboard-reports — EXCELLENCE sweep raw notes (2026-06-11)

Project trigger: EventState rebuild (test_Gica), module dashboard-reports.
Mode: EXCELLENCE — ceiling, not oracle fidelity. Reference apps: Stripe, Linear
(per kickoff suggestion) + best-at-job analytics apps surfaced by Mobbin
(Amplitude, Mixpanel, Mailchimp, Front, Toggl) + same-domain Eventbrite/Luma.

## Sweep matrix executed (web platform)

| # | Mode | Query | New patterns yielded |
|---|------|-------|---------------------|
| 1 | by-app | Stripe dashboard home metrics overview reports | KPI cards w/ period comparison, narrative reporting overview, freshness stamps, benchmarking percentiles, customizable overview (+Add/Edit), report-param page |
| 2 | by-app/flow | Stripe export data CSV download report columns | export dialog (timezone/date-range/columns), async email-when-ready, ready-dialog retry, status tab-cards, edit-columns popover, per-dataset Download-data sections |
| 3 | by-app | Linear insights dashboard triage inbox | actionable inbox (list+detail), notification structured filters, insights side panel on filtered list |
| 4 | by-app | Mixpanel Amplitude analytics dashboard create report add chart | dashboard composer (Add Content: existing/new/AI/text), templates gallery, board-level date control, pinned KPI slots, Subscribe button, save-chart-to-dashboard, "Computed 1 min ago · Refresh", Good Morning greeting (Mixpanel) |
| 5 | by-pattern | schedule recurring report email subscription digest | Amplitude Subscribe modal (Email/Slack, per-subscriber schedule, CSV attach), Circle weekly digest w/ section toggles, Fabric recap freq/day/time/tz, Hotjar daily/weekly summary |
| 6 | by-pattern | exports list download history processing ready async | Customer.io Exports page, Eventbrite report Exports tab, Slack Past Exports + email-when-ready + 10-day retention, Clay Expires column, Apollo progress/status table |
| 7 | by-pattern | metric alert threshold anomaly notification | Mixpanel Create Custom Alert, Sentry threshold tiers (static/percent/anomaly; critical/warning/resolved), Vapi monitor thresholds |
| 8 | by-app | Eventbrite organizer event dashboard sales summary attendee report | Reporting hub (catalog + Scheduled reports + Analytics tabs), preview-first report page (Summary/Exports, KPI strip, group-by, edit columns), organizer home countdown + phase bar + checklist, analytics explorer w/ Export Chart/Export Data |
| 9 | by-pattern | date range picker compare to previous period | Mailchimp dual dropdown (range+comparison), Mixpanel compare chip, Amplitude Last/Since/Between + offset + anomaly/forecast, Toggl comparative dual-axis, Front custom range + delta KPI cards |
| 10 | by-pattern | share dashboard public link export PDF | Mixpanel Make Board Public + Copy URL, June share-to-web, Steep chart→image Download/Copy, Maze Share/Embed/PDF tabs + "Download failed. Please try again." toast + PDF-limits warning, Apollo restricted visibility |
| 11 | by-pattern | dashboard empty state no data error loading retry | Slack in-place "Member data unavailable" (chrome stays usable), Causal first-chart empty state, Shopify actionable unable-to-access, Chronicle/Skiff/Tines reload pages |
| 12 | dryness probe | live event check-in realtime counter today attendance | Luma At-a-Glance capacity bar (1/cap 1000 + Going/Invited), live Checked-In counters — mostly check-in module territory. LOW YIELD #1 |
| 13 | dryness probe | metric KPI card click drill down detail breakdown | Zoho scorecard-KPI config (≈ already-captured chart builder), Amplitude metric def w/ natural-language trend sentence, Slite hover activity chart. LOW YIELD #2 → DRY |

## Key refs (Mobbin)

Stripe: flows 545a744c (Home/Today), 29a0bba1 (Reporting overview),
c96f68a8 (Billing overview + Benchmarking), a1994371 (Reports),
465c67dd (Downloading data), 319c3b60 (Exporting transactions),
aa9bdbef (Editing columns).
Linear: flows 2ee08fdf + 0ebbf5cb (Inbox), a21b30a0 (Issues insights),
7d012661 (Filtering notifications).
Amplitude: flow 062bd936 (Creating dashboard), faaf0db1 (Creating chart),
screens 6289030e (Subscribe modal), 61716928 (date picker), 72da281c (metric def).
Mixpanel: flows c3c50fee (Adding report; Good Morning home), 0d7ba557 (Creating
board), screens 62532a4d (Create Custom Alert), 0b923cb3 (Share board),
5a96aa64 (compare chip).
Eventbrite: flows 547761cd (Reporting hub), 9261e137 (Audit report detail),
e45fde58 (Events list), screen b98182dd (report Exports tab).
Scheduled/digest: screens 95f30b50/a3f2f1c3/bdd73254 (Circle), 3bb015cd/bd5c0c4d
(Fabric), 70a00359 (Frame.io), f9a70dd3 (Hotjar).
Export centers: screens c01b45fb + da49e12c (Customer.io), 85dd544d (Slack),
44af26eb (Clay), 01d12b3e (Apollo), d0b2a1fa/0dc7a3c3 (AWS upload status).
Date/compare: screens b3f28c30 + 031efda0 (Mailchimp), 10d96779 (Toggl),
917464ff (Front).
Share/PDF: screens 752592f1 (June), e40b8a6f (Steep), 076c828b + 6771923c (Maze),
3c63ed63 (Apollo).
Sad paths: screens 6e8301b5 (Slack analytics), 557539ea (Causal), 3286f573
(Shopify), 3bd32686 (Chronicle), f7e56d77 (Skiff), 46945d84 (Tines).
Luma: screens 369500dd (At a Glance), 51bf2700/fc3826ca (check-in counters).
Sentry: screens 2c3b4aec, aeffe233, a0a883e0 (alert rules).

## NOT swept (coverage honesty)

- iOS platform (EventState admin is web-first; mobile dashboard patterns unswept)
- Stripe Sigma / SQL-based custom report builders (beyond V1 ceiling, deliberate)
- TV/wall-mode dashboards (Geckoboard/Databox) — day-of-event ops wall could
  matter someday; flagged as first-principles candidate, no Mobbin coverage found
- Notion/Airtable database-view dashboards (covered by people/registration-tables
  module harvest instead)
- Embedded-BI products (Metabase/Looker) — not on Mobbin
