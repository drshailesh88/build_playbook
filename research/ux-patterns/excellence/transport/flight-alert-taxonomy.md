# Pattern: Graded flight-alert taxonomy with thresholds, reasons, and predicted-vs-official honesty

**Surface:** transport · **Observed in:** Flighty, FlightAware, Moovs, Azavista
(refs: A32, A33, A34, A35, A13, F11, F14 — URLs in `_raw/`; key: https://flighty.com/help/flighty-notifications, https://flighty.com/help/delay-predictions)

## Flow
1. Alerts are a NAMED taxonomy, not one generic "flight changed": Delay Prediction, Cancellation or Diversion ("the moment your flight is cancelled"), Gate Changes, Connection Assistant, Airport Delay Alert, Inbound Plane Alert (Flighty) — each independently toggleable.
2. Severity is graded: inbound-aircraft lateness and airport-wide delays are LEADING indicators that fire before the passenger's flight officially slips.
3. Noise thresholds gate action: Moovs texts the driver only when arrival time moves "by 15 minutes or more" AND pickup is an airport.
4. Derived data never overwrites source data: "Flighty shows both: our predicted times alongside the official ones, so you always see the full picture."
5. When a delay REASON is determinable (weather, ground stop, ATC staffing) it rides inside the notification; unknowable causes (maintenance, crew) are an explicit "we don't know" category.
6. Third-party watching is a product concept ("Friends' Flights") — exactly the ops-team-watches-attendee-flights relationship; machine side is webhooks (FlightAware AeroAPI: impending departure/arrival, cancels, diverted, holding pattern).

## Use when
Designing the transport red-flag vocabulary: flag TYPES (time-change vs cancellation vs no-data) with different severities and different default actions, not one undifferentiated flag.

## Avoid when
Only one upstream change type exists — taxonomy without variety is dead weight. Also avoid sub-threshold alerting: a 5-minute slip on a 3-hour window batch must not page anyone.

## Sad paths observed
- Cancellation/diversion are DEDICATED alert types, never folded into generic updates — matches our `travel_cancelled` flag type being distinguishable on the card (PATH-transport-004 step 3).
- Flighty is explicit about prediction coverage limits per region — honesty about data quality is part of the UX.

## Accessibility
Not observable from documentation sources.

## Default verdict for our stack
RECOMMENDED — the legacy cascade already writes typed flags (`travel_changed`/`travel_cancelled`); steal the graded severity, the ≥N-minutes noise threshold, and showing old AND new values side-by-side in the flag detail.
