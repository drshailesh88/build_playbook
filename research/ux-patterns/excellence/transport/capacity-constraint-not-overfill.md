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

## Visual evidence (Mobbin re-sweep 2026-06-11) — STRONG
Capacity-limit UI is screen-verified across 10 apps (full detail in `_raw/mobbin-resweep.md` §5):
- Remaining count inside the control: eBay stepper captioned "5 available" (https://mobbin.com/screens/4d496fe4-1184-44a9-bf00-91ed0cce301d); Airbnb "Add a guest (9 left)" with commit disabled until valid — quiet enforcement, no error states (https://mobbin.com/screens/3c73932b-6170-4842-b034-68ec58896059).
- Ceiling stated up front: Viator "This activity allows a maximum of 9 travelers." as the sheet's first line (https://mobbin.com/screens/4cf12848-6540-4d13-8701-49f3839a2f8a).
- Three-state row treatment on schedule lists: Kakao T open / "매진임박" almost-sold-out (tappable) / "매진" sold-out greyed (https://mobbin.com/screens/8e3073a6-312c-4c38-9eec-aa061d6b28c0); Grab Bus & Ferry "159 of 159 seats left" X-of-Y meter on the trip card (https://mobbin.com/screens/6fc5ce3e-0ea9-493c-8410-482fc59fb16a).
- Per-vehicle-section allocation: Shopee train "EKO-1 — 31 Seat(s) Available" per carriage + time-boxed hold countdown (https://mobbin.com/screens/0549d09a-3473-42dd-b414-02fdbdb7b423).
- Blocked-at-limit recovery copy: Ticketmaster "Please Adjust Your Search — …due to the ticket quantity or filter you applied. Please try adjusting…" names both causes and both fixes (https://mobbin.com/screens/5bb4eaea-2cef-44f4-8135-3372e9d19508).

## Default verdict for our stack
RECOMMENDED — legacy capacity was display-only (red count, server happily overfills). Steal: server-side check at assign/move with explicit override + audit, X-of-Y text not just color, remaining-count-inside-the-control, and three-state capacity display. The override-with-audit CONFIRM dialog itself remains the named first-principles gap (no vendor doc and no Mobbin screen shows a manual hard-block-with-override).
