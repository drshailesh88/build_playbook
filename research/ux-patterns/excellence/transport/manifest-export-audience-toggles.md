# Pattern: One manifest, many audiences — include/exclude toggles per consumer

**Surface:** transport · **Observed in:** Limo Anywhere, Booking Tool, Tourplan, Routific
(refs: F34, F35, P3 — URLs in `_raw/`; key: https://kb.limoanywhere.com/docs/how-to-generate-a-reservation-manifest/)

## Flow
1. One report definition serves every audience via toggles: Detailed vs Summary view; with/without payment data; exclude cancelled / late-cancel entries; include "Airport Pick-up Instructions", "Routing Notes", linked trips (Limo Anywhere Reservation Manifest).
2. Filters before generation: date range, driver, vehicle, group name, service type — the "Group Name" filter is the per-conference slice.
3. Output formats: web page, email, Excel (two layouts), PDF via print — same definition, channel of choice.
4. Live variant: the digital manifest updates in real time as check-ins/cancellations/flight delays land, and exports as PDF emailed to multiple stakeholder roles (Booking Tool).
5. Driver workload summary CSV as the paper fallback of dispatch (Routific "Download Summary").

## Use when
Producing the day's transport plan for different consumers: driver trip sheets (no payment/PII beyond need), hotel desk lists, ops master plan, vendor summaries.

## Avoid when
The toggle matrix explodes — presets ("Driver sheet", "Ops master") beat raw checkbox walls once 3+ audiences are stable.

## Sad paths observed
- Cancelled-entry exclusion is an explicit toggle — exports stay honest the same way roll-up boards do (cross-ref arrivals-rollup-board card).

## Accessibility
Print/PDF outputs are the lowest-tech fallback — drivers without smartphones are a real population.

## Default verdict for our stack
RECOMMENDED — legacy export was a single fixed Excel of batches+vehicles+names. Steal: audience presets (driver sheet without payment/admin fields, with pickup instructions), cancelled-exclusion toggle, group filter.
