# Pattern: Batch as a named container with late-bound driver and per-member state rollup

**Surface:** transport · **Observed in:** Onfleet (Route Plans, Linked Tasks)
(refs: A4, A5 — URLs in `_raw/by-app.md`; key: https://docs.onfleet.com/reference/routeplan.md, https://docs.onfleet.com/reference/dependencies.md)

## Flow
1. A Route Plan is "a container used to track a driver's work throughout a shift, day, or planned segment" — named, colored, created from a "+" → Create Route modal.
2. Driver/vehicle binding is late-bound: "A driver can be assigned to a Route or changed at any time before the Route is started."
3. "Even after a Route has started, tasks can be added or removed" — membership stays editable during execution.
4. The container exposes a computed per-member state array (`taskStates`) — the batch knows how many members are unassigned/assigned/active/completed without storing counts.
5. Linked Tasks: a dropoff can declare a dependency on its pickup — "the Pickup has to complete prior to starting the Dropoff."

## Use when
Modeling transport batches: the batch is the planning unit, vehicles/drivers are swappable resources, and roll-up counts are derived from member states (matches data-req §11 "derived, never stored").

## Avoid when
A trip is genuinely atomic (one VIP, one car) — container overhead obscures rather than organizes.

## Sad paths observed
- Driver swap is allowed right up to execution start, then the binding freezes elsewhere in the industry (Routific: "Driver information cannot be edited once their routes begin") — the lock point is start-of-execution, not assignment.

## Accessibility
Not observable from documentation sources.

## Default verdict for our stack
RECOMMENDED — validates the existing batch→vehicle→passenger schema; steal the late-bound driver swap and the derived per-member state rollup as a visible batch header ("12 passengers / 2 vehicles / 3 boarded").
