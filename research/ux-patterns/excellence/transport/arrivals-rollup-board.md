# Pattern: Arrivals/departures roll-up — pax totals per time + origin, regroupable, cancellation-honest

**Surface:** transport · **Observed in:** Tourplan NX, Travelport GlobalWare, Limo Anywhere
(refs: P15, A22, F34 — URLs in `_raw/`; key: https://usermanuals.tourplan.com/v2/Content/NX%20Reports/B-Operations%20Reports/F-Arrivel%20Depature.htm, https://support.travelport.com/webhelp/GlobalWare/Content/14-Groups/Arrival_Departure_Manifest.htm)

## Flow
1. The board lists all arrivals/departures with service date, flight info, arrival time, passenger names — and TOTALS: "the total number of passengers arriving or departing at a particular time" (GlobalWare). This is literally "10 arriving 10:00 from BOM".
2. Regroupable on demand: "Order By" pivots the same data by Pickup, Dropoff, Agent, Supplier, Driver, Vehicle, or Guide (Tourplan); with resource assignment on, driver/vehicle show inline per group.
3. Consolidation merges multiple bookings into one line (Tourplan "Consolidate Bookings").
4. Cancellation honesty is a TOGGLE: include/exclude canceled passengers (GlobalWare) — counts never silently inflate.
5. Filterable by date range, connections ("Same Day Only"), status, location; the live-grid variant filters by airport to "group nearby pickups and drop-offs for easier routing" (Limo Anywhere JFK example).

## Use when
Planning batches from arrival data (PATH-transport-003): filter by date/time/city/terminal, read the count, spawn a batch covering the group.

## Avoid when
Counts would be stored rather than derived — every source derives live from records (matches data-req §11). Avoid burying it as an export-only report if ops plans from it daily — but note the LIVE auto-refreshing wallboard variant is undocumented anywhere (FIRST-PRINCIPLES candidate #1).

## Sad paths observed
- Canceled-passenger include/exclude is explicit (GlobalWare) — maps to our ASSUMED sad branch "cancelled travel never inflates ops counts" (PATH-transport-003).
- Empty filter results need an explicit "no arrivals match" state (our pathway requirement; no vendor documents it — report tools just print empty).

## Accessibility
Not observable from documentation sources. Roll-up rows are tabular data — proper table semantics make this screen-reader-friendly for free.

## Default verdict for our stack
RECOMMENDED — PATH-transport-003 is a MUST-NOT-LOSE rebuild requirement with no legacy implementation; Tourplan/GlobalWare prove the shape: time+origin grouping with live-derived totals, pivot-by-vehicle/driver, cancellation toggle.
