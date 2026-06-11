# Pattern: Deliverability health — per-metric health badges, benchmarks, sender score
**Surface:** analytics / ops · **Observed in:** Klaviyo, HubSpot (refs: [Klaviyo deliverability tab](https://mobbin.com/screens/b4bb4bc4-8025-4a87-80e1-c355203cacd9), [Klaviyo dashboard](https://mobbin.com/screens/a5f58169-772f-4f14-bcf6-42ad6c5a90f0), [HubSpot health](https://mobbin.com/screens/18e8f55e-5d29-4613-aed6-1801156ef212))

## Flow
1. "Key deliverability metrics health": five cards — Open / Click / Bounce / Unsubscribe / Spam-complaint rate — each carrying a **Healthy / Needs attention** badge judged against thresholds, not raw numbers (Klaviyo).
2. A plain-language guidance line under the cards ("Based on your click rate performance, focus sending to your most engaged subscribers") with helpful?-thumbs feedback.
3. Send-volume breakdown chart (Delivered vs Bounced stacked) segmented by Inbox provider / Email domain / Country tabs — localizes WHERE deliverability is failing.
4. HubSpot's sender-score variant: gauge score over time, per-metric cards with industry benchmark values printed ("Hard bounces — Benchmark: 0.35%"), compare-with radio (platform benchmark vs industry), "Not enough data" empty states.
5. Trend strips on the dashboard: bounce/spam/unsubscribe rates with deltas and sparklines, "Last updated 2 minutes ago" (Klaviyo).

## Use when
The tenant sends at volume from their own domain and reputation damage is a real business risk (multi-event organizations, recurring conferences).

## Avoid when
Low-volume transactional sending through a shared, well-managed provider domain — the monitor would mostly display "not enough data".

## Sad paths observed
- "Needs attention" badge + targeted advice replaces silent metric decay.
- Benchmarks contextualize numbers a non-expert can't judge alone (is 0.5% bounce bad?).

## Accessibility
Badges are text labels; charts have tabular alternatives via the breakdown tabs.

## Default verdict for our stack
VIABLE (V2) — high value once tenants send from custom domains at scale; v1 floor is the failed-count card + circuit-breaker status we already track, surfaced in the hub.
