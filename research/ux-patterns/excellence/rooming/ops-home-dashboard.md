# Pattern: Ops home — setup checklist + day-scoped arrivals/exceptions dashboard
**Surface:** rooming · **Observed in:** Booking.com extranet, Deputy, Airbnb Insights, Cal.com, Oyster, Vanta, Mailchimp, Luma
(refs: https://mobbin.com/screens/516f9969-3ce9-4286-b46e-5ceded4b9f1a , https://mobbin.com/screens/a94b862d-1c9d-4cdf-b7a5-299fa1144bdd , https://mobbin.com/screens/50fd50d0-ccb6-45f0-9779-6c5b8dcb1fe1 , https://mobbin.com/screens/d6c8a960-3253-4ca4-b4aa-06e902fa0e4e ; raw: `_raw/by-pattern.md` §P13/P14/P37)

## Flow
1. Hotel-ops vocabulary verbatim: tabs "Arrivals 0 | Departures 0 | Stay-overs 0 | Guest requests 0" scoped "Today ▾" (Booking.com extranet).
2. Exception KPIs with share-of-total: "No shows 15 / 60.0% of all shifts" (Deputy) — failures as first-class metrics.
3. Zero states in words, never blank charts: "No arrivals for selected date", "Your average occupancy rate will show here within 48 hours of your first booking."
4. Benchmark under own number: "Cancellation rate 0% / Area avg. 29.41%"; freshness stamps ("Last data update: … UTC").
5. Setup checklist drives cold start: steps with "N of M complete", per-row status pills, blocked-on-third-party stated as a sentence ("Your employer will share the contract with you to sign." — Oyster), dismissible when outgrown (Mailchimp).
6. Event capacity at a glance: "0 guests — cap 1,000" bar + status legend (Luma).

## Use when
The module landing page: today's arrivals/departures per hotel, unassigned count, pending confirmations, flags — plus first-run setup (Add hotels → Load blocks → Import delegates → Assign → Send).

## Avoid when
Stats without drill-ins — every number needs a View path to the filtered list, or the dashboard is decoration.

## Sad paths observed
Blocked-on-hotel steps labeled like Oyster's pending contract; empty/zero states everywhere with words; "Nice, no policy offenders in this timeframe!" (Navan §A9) celebrates the empty exception list.

## Accessibility
Count + bar/ring always; tab badges textual.

## Default verdict for our stack
RECOMMENDED — during the event week the rooming home IS arrivals/departures/stay-overs for the selected date + exception KPIs (Unassigned, Pending, Cancellations, Flags) Deputy-style; before the event it's the Vanta-style setup checklist with blocked-on-hotel steps explicit.
