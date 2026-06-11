# Pattern: Add flight by number or route+date (lookup, don't type the itinerary)
**Surface:** travel · **Observed in:** Flighty (ref: https://mobbin.com/flows/e5a241ca-9ae9-4bee-baa4-bf56b4759fef), The Weather Channel (ref: https://mobbin.com/flows/2ebd073f-9620-4242-9f2f-7f0a06e06f74)

## Flow
1. Single search entry point: type a flight number (AA171) OR pick origin + destination airports + date.
2. Route+date path returns EVERY flight operating that day on the route: airline logo, flight number, dep/arr times, duration — user picks one row.
3. "SHOW CODESHARES — 22 RESULTS" toggle and "Filter by Airline" keep the list honest but scannable.
4. Selection auto-fills the entire record: times, terminals, aircraft, carrier — no manual datetime entry.
5. Variant (Weather Channel): structured Outbound/Return cards with "Add a layover" / "Add a return flight" affordances.

## Use when
Flight (and rail where data exists) itinerary entry — anywhere a human currently re-types facts an API already knows. The mode=flight branch of a travel form.

## Avoid when
Modes with no lookup source (self-arranged car, bus) — keep manual fields as the fallback path, same form; never force lookup-only.

## Sad paths observed
- Unknown/charter flight number → manual entry remains available (search-first, not search-only).
- Recent searches surfaced to shortcut repeat entry (Flighty "Recent" row).

## Accessibility
Results are a list of buttons with full text (airline + number + times); keyboard date entry alongside pickers.

## Default verdict for our stack
RECOMMENDED — the oracle form (G1–G24) is 100% manual typing incl. two datetime-locals; flight-number lookup is the largest data-entry time saver and accuracy gain available to an ops team entering dozens of itineraries.
