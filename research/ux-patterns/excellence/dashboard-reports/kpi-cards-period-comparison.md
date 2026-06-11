# Pattern: KPI cards with period comparison + sparkline

**Surface:** dashboard-reports / overview · **Observed in:** Stripe, Mailchimp, Front, Amplitude (refs: https://mobbin.com/flows/545a744c-9b68-4b16-b3ce-25344345c93d, https://mobbin.com/flows/29a0bba1-f256-494d-9756-77cb7bb2ef4f, https://mobbin.com/screens/b3f28c30-f957-44b0-904b-4e629ce606b1, https://mobbin.com/screens/917464ff-021c-430e-a254-60a2b9beb06b)

## Flow
1. Each metric card shows: label, current value, previous-period value or delta (Stripe: "MYR 2.00 / MYR 0.00 previous period"; Front: "22m ↗ +22m" with arrow + color), and a small trend chart in the card itself.
2. The comparison period is driven by one global control ("Last 7 days compared to Previous period, Daily" — Stripe), not per-card settings.
3. Every card carries a freshness stamp ("Updated 06:23", "Updated yesterday") and a "View more" link that deep-links to the owning detail page.
4. Zero values render as real charts with flat lines — not blank cards (Stripe test-mode screens show MYR 0.00 with full axes).

## Use when
The dashboard's job is "is my event healthy right now and is it trending the right way" — a bare count (old GEM dashboard) answers the first question only; the delta + sparkline answers the second at zero interaction cost.

## Avoid when
A metric has no meaningful time dimension (e.g. "halls configured") — a delta on a static config count is noise. Also avoid deltas during the first period of data (nothing to compare against — show "—" or "first week", never a fake 0%).

## Sad paths observed
- No prior-period data → Stripe shows "0 previous period" rather than hiding the comparison (weak; prefer explicit "no prior data").
- Metric fetch failure → Slack renders in-place "data unavailable, try again later" per panel while the rest of the dashboard stays alive (https://mobbin.com/screens/6e8301b5-63ad-48a2-b71a-59e28b060c0e).

## Accessibility
Delta direction must not be color-only — pair arrow glyph + signed number (Front does both). Sparklines are decorative; the value+delta must be readable as text.

## Default verdict for our stack
RECOMMENDED — direct upgrade of the old app's 5 static metric cards (done-spec §3.25); registrations/today badge already exists, the delta+sparkline is the missing half.
