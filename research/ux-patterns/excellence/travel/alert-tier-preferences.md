# Pattern: Tiered alert preferences (criticality groups, not one master toggle)
**Surface:** travel · **Observed in:** Flighty (ref: https://mobbin.com/flows/a7b48e7b-6c6f-49d0-a6c6-05013d0c6a54), Tripsy (ref: https://mobbin.com/screens/58e54c48-d256-4a79-aa74-5510cabf7cd5)

## Flow
1. Alerts grouped by tier with a one-line scope under each toggle:
   - Flighty: "Basics — The most critical alerts like gate changes, delays, & cancellations" / "Above & Beyond — inbound aircraft status, connection assistance, aircraft changes" / "Flight Plans" / "Arrival Information — landing, gate arrival, baggage claim".
   - Tripsy: General Trip Alerts ("1 month before start", "7 days before start", "Your trip starts today") / Flight Alerts (Basic, Departure & Arrival) / Collaboration ("New Activities Added").
2. Audience scoping is separate from type: "My Flights" vs "Friends' Flights" alert sets (Flighty).
3. Contextual opt-in at the moment of relevance: flight detail shows "Worried about delays? Be first to know what's happening." with a SAMPLE push notification rendered ("⚠ Delayed 2h 30m — Now departing Gate 32A at 8:30pm") + ACTIVATE ALERTS (ref: https://mobbin.com/screens/0b1b9d14-b576-44ea-b93b-c40ba046fbfd).

## Use when
The system can emit more than ~3 notification kinds to more than one audience (ops staff vs delegate); pre-trip reminder cadence (T-7d, day-of) is wanted.

## Avoid when
Only one critical notification type exists — a tier UI over one toggle is ceremony. Never make safety-critical changes (cancellation) opt-out silently.

## Sad paths observed
- Showing the sample push BEFORE asking permission (Flighty) — user knows exactly what they're enabling.

## Accessibility
Standard toggle groups with descriptive labels; scope text is part of the label.

## Default verdict for our stack
VIABLE — V1 oracle sends email+WA unconditionally (D3/D4); tiers become relevant when delegate-facing alerts and ops alerts diverge. Steal the grouped-with-scope-text presentation when prefs arrive.
