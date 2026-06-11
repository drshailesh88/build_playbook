# Pattern: Metric alert rules (threshold → notify)

**Surface:** dashboard-reports / alerting · **Observed in:** Mixpanel, Sentry (refs: https://mobbin.com/screens/62532a4d-4db4-42ee-8cd7-ce52a063cb28, https://mobbin.com/screens/2c3b4aec-e35e-42a5-b7fb-4ca085697a53, https://mobbin.com/screens/aeffe233-0f96-41d3-af9b-123bed3b5182)

## Flow
1. Mixpanel "Create Custom Alert" from any chart: name, sentence-builder condition ("Alert me when [Last] [Overall conversion rate] is [Below] [45%]"), rate limit ("Send at most once every Day"), email recipients.
2. Sentry's fuller ladder: threshold types Static / Percent-change vs. same time last week / Anomaly (outside expected bounds); severity tiers Critical/Warning/Resolved each with own threshold; then actions + an owner.
3. Alerts are created FROM the chart being watched, inheriting its scope — not from a separate config area.

## Use when
Someone must react within hours, not at the next dashboard visit: failed-notification spike during a blast, registration flatline after a marketing push, no emergency kit 48h before an event.

## Avoid when
The needs-attention feed already covers it at the user's own cadence — alert fatigue is real; every alert rule must name a recipient who agreed to be woken.

## Sad paths observed
- Rate limiting is part of the creation form (Mixpanel "at most once every day") — without it a flapping metric spams.
- Sentry separates "Resolved" threshold from trigger threshold — alerts that never auto-resolve become permanent noise.

## Accessibility
Sentence-builder rows are standard selects; the resulting rule reads as an English sentence.

## Default verdict for our stack
AVOID for V1 — the cron-driven attention items (kit missing, failed sends) cover the conference cases server-side without user-configured rules; revisit when multi-tenant ops teams ask for custom thresholds.
