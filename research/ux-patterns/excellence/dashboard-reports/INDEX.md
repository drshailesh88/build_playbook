# dashboard-reports — EXCELLENCE pattern index

**Coverage:** Swept 2026-06-11 via Mobbin MCP, web platform. By-app: Stripe
(home/overview/reporting/exports/columns/benchmarking), Linear (inbox, insights,
notification filters), Amplitude (dashboards, charts, subscribe, date picker),
Mixpanel (home, boards, alerts, share), Eventbrite (reporting hub, report
detail, organizer home, analytics explorer), Luma (at-a-glance, check-in), plus
pattern-mode hits from Mailchimp, Front, Toggl, Customer.io, Slack, Clay,
Apollo, Circle, Fabric, Frame.io, Hotjar, Sentry, Maze, June, Steep, Shopify,
Causal, Zoho. Loop ended after 2 consecutive low-yield probes (#12 live-ops,
#13 KPI drill-down). NOT swept: iOS, SQL report builders (Sigma), TV/wall-mode
dashboards (no Mobbin coverage — first-principles candidate for day-of-event
ops), embedded BI. Raw log: `_raw/sweep-notes.md`.

| Card | One-liner | Default verdict |
|---|---|---|
| kpi-cards-period-comparison | Metric + delta vs previous period + sparkline + View-more deep link | **RECOMMENDED** |
| global-date-range-comparison | One board-level range control, named presets, optional compare-to chip | VIABLE (domain-tune presets) |
| narrative-reporting-overview | Plain-language findings above each chart (Stripe Reporting) | VIABLE |
| report-catalog-hub | Grouped named-report cards + Scheduled/Analytics tabs (Eventbrite) | **RECOMMENDED** |
| preview-first-report-page | Report = page with Summary tab (table, KPI strip, group-by) + Exports tab | **RECOMMENDED** |
| export-dialog-scope-controls | Timezone/date-range/column-set dialog, email-when-ready, retry-on-ready | VIABLE (subset for V1) |
| export-center-async-history | Past-exports table: who/when/status/download/expiry; doubles as PII audit | **RECOMMENDED** |
| scheduled-report-subscriptions | Recurring email/Slack report with per-subscriber schedule + CSV attach | VIABLE (V2-leaning) |
| actionable-notification-inbox | Linear-style list+detail inbox with structured filters | VIABLE (keep drawer V1, adopt its discipline) |
| needs-attention-deep-links | Counts + specimen rows + exact-filter deep links + proud all-clear | **RECOMMENDED** |
| insights-panel-on-filtered-list | Measure/Slice/Segment panel live-bound to a filtered table | VIABLE (V2) |
| customizable-dashboard-widgets | +Add/Edit widgets, pinned KPI slots, templates | AVOID V1 / VIABLE V2 |
| metric-alert-rules | Sentence-builder threshold alerts with rate limiting | AVOID V1 |
| dashboard-share-snapshot-pdf | Chart→PNG snapshot, PDF tab with downgrade warning, scoped links | VIABLE (PII-gated) |
| dashboard-freshness-stamps | "Updated X ago" + manual refresh on every aggregate | **RECOMMENDED** |
| event-countdown-ops-home | "Happening in ~1 month" + phase bar + capacity at-a-glance | **RECOMMENDED** |
| chart-empty-error-states | Four-state contract per panel: loading/zero/filtered-empty/failed | **RECOMMENDED** |
| cross-tenant-benchmarking | Percentile badges vs peer tenants (Stripe Benchmarking) | AVOID V1 — multi-tenant moat candidate |

Cards record observations; choices are DECs made by the founder (DEC-032 harvest model).
