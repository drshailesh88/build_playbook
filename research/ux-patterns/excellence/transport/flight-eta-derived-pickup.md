# Pattern: Pickup time derived from flight ETA + standing offset (self-healing plan)

**Surface:** transport · **Observed in:** Limo Anywhere, Hoppa, Uber Reserve, Welcome Pickups
(refs: A18, P6, F12, F13, A22 — URLs in `_raw/`; key: https://kb.limoanywhere.com/docs/how-the-set-up-and-use-real-time-flight-tracking/)

## Flow
1. Flight tracking activates automatically once a routing has date, time, airport, airline, flight number (Limo Anywhere via FlightStats).
2. Pickup time becomes a DERIVED value: flight ETA + a chosen offset. Eight options on the routing: "Do not adjust based on flight arrival", "When your flight arrives", 15–120 "min after gate arrival".
3. Documented worked example: ETA 12:30 + "15 min after gate arrival" → pickup 12:50; flight slips to 12:50 → pickup auto-moves to 1:05. The offset survives the change.
4. Dispatch grid carries flight columns (scheduled, actual, terminal/gate, status); multi-flight trips expose per-flight data on hover.
5. Variants: full automatic transfer rebooking (Hoppa: "your selected transfer will automatically rebook to match your new arrival time"); flight-linked wait time replacing fixed grace timers (Uber Reserve: "Wait time is included once your flight lands"); pre-trip input validation with correction emails (Welcome Pickups).

## Use when
Airport/station arrival pickups where a live flight-status feed exists — the plan absorbs delays instead of generating re-planning work.

## Avoid when
No live flight feed is wired (our rebuild V1: travel records update via delegate/ops edits, not an airline API) — then the red-flag cascade is the correct mechanism and auto-moving times without a trusted feed would lie. Also avoid on departures (Limo Anywhere only adjusts the pickup leg).

## Sad paths observed
- Per-routing opt-out is first-class ("Do not adjust based on flight arrival") — ops can pin a time against the machine.
- Cancellation (vs delay) handling is NOT specified in the Limo Anywhere doc — the gap our red-flag system covers.
- Hoppa: if rebooking fails on cancellation → full refund (a defined terminal outcome).

## Accessibility
Not observable from documentation sources.

## Default verdict for our stack
VIABLE (V2-leaning) — requires a flight-data integration (FlightAware AeroAPI per A35). For V1 the derived-value PRINCIPLE still applies: batch window shifts when its source travel records shift, surfaced as red flags, never silent.
