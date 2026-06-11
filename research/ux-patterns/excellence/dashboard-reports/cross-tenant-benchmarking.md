# Pattern: Peer benchmarking with percentile badges

**Surface:** dashboard-reports / benchmarking · **Observed in:** Stripe (refs: https://mobbin.com/flows/c96f68a8-c962-45d1-9ce3-64b81dcacca6 — Billing overview → Benchmarking tab, marked "Preview")

## Flow
1. Stripe Billing's Benchmarking tab compares the account's metrics against similar companies: peer-group selectors (ARR bracket, ARPU bracket, business model B2C/B2B), then each KPI card gets a percentile badge ("MRR growth rate — 48th percentile", "Subscriber churn — 99th percentile" in green) and "You: X / median: Y" with both lines on the chart.
2. Badges are color-coded by favorability (high churn percentile = good when inverted — Stripe computes favorability, not raw rank).
3. Feature ships labeled "Preview" — benchmarking is explicitly an evolving, opt-in surface.

## Use when
The platform hosts many comparable tenants and the metric is comparable across them — a multi-tenant conference SaaS could eventually tell an organizer "your faculty-confirmation rate is 82nd percentile among medical conferences your size."

## Avoid when
Tenant count is small (percentiles over 4 tenants are gossip, and potentially identifying), metrics aren't normalized (a 200-person workshop vs 5,000-person congress), or tenants haven't consented to aggregate use of their data — privacy/contractual question BEFORE a UX question.

## Sad paths observed
- Insufficient peer data → the tab must say so rather than compute fake percentiles (not observable on Mobbin; verify-in-code at implementation).

## Accessibility
Percentile as text in the badge; favorability via label ("better than median"), not color alone.

## Default verdict for our stack
AVOID for V1, file as the multi-tenant moat candidate — uniquely enabled by the SaaS pivot (single-tenant GEM could never), but it needs tenant volume, metric normalization, and a data-use policy first.
