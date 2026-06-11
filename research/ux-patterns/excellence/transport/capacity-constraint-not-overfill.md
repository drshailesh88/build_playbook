# Pattern: Capacity as an enforced constraint (never overfill; overflow goes visible)

**Surface:** transport · **Observed in:** OptimoRoute, Routific, Track-POD, Bringg, TripShot
(refs: P4, A28, A36, F4 — URLs in `_raw/`; key: https://academy.routific.com/en/articles/1317930-driver-capacity-and-delivery-loads, https://help.bringg.com/docs/assign-a-different-driver-for-orders-on-a-planned-route)

## Flow
1. Capacity is unit-agnostic: "Load is the number of units... Capacity is the maximum number of units a vehicle can carry at once" (Routific); weighted units handle mixed sizes (passenger + luggage).
2. The optimizer never overfills — "orders on a given route will be limited by the capacity set for a particular vehicle" (OptimoRoute); what doesn't fit becomes visibly unscheduled with reasons, not silently dropped.
3. Manual reassignment checks constraints at commit time: Bringg shows capacity / time-window / team / skills checks before the Assign/Merge/Create-New action completes.
4. Review surfaces show load vs capacity with overload notifications during planning (Track-POD).
5. Passenger-transport variant: capacity per route OR per ride, with "confirmed or standby reservation lists" as the overflow pressure valve (TripShot).

## Use when
Any passenger-to-vehicle move (drag, suggestion accept, bulk reassign) — the check belongs at the mutation, not just the render.

## Avoid when
Ops genuinely needs to overfill (jump seat, child on lap) — then enforcement must come with an explicit override, never a hard wall with no exit. NOTE: no vendor documents a manual hard-block-with-override; that exact interaction is a FIRST-PRINCIPLES candidate (see first-principles-candidates.md #2).

## Sad paths observed
- OptimoRoute: excluded orders are manually draggable onto routes afterwards — override exists but is a separate deliberate act.
- Routific does not document what happens to overflow in manual mode (gap noted in raw).

## Accessibility
Not observable from documentation sources. Over-capacity signaled by color alone (legacy red count) fails WCAG 1.4.1 — pair with text ("14/12 over capacity").

## Default verdict for our stack
RECOMMENDED — legacy capacity was display-only (red count, server happily overfills). Steal: server-side check at assign/move with explicit override + audit, and over-capacity text not just color.
