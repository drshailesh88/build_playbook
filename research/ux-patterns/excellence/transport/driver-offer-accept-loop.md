# Pattern: Offer → accept/decline → timeout → next-best loop, with operator alert on exhaustion

**Surface:** transport · **Observed in:** Tookan, Moovs, Limo Anywhere (Auto Farm)
(refs: F29, F31, A16, A23, F30 — URLs in `_raw/`; key: https://help.jungleworks.com/knowledge-base/auto-allocation-methods-on-tookan-dashboard/, https://www.limoanywhere.com/2026/04/28/auto-farm-by-limo-anywhere-turn-affiliate-farm-outs-into-a-scalable-workflow/)

## Flow
1. Assignment is an OFFER: the trip goes to the best candidate first; "if the timer runs out or if the agent declines the task, it goes to the second best option" (Tookan ONE BY ONE; configurable Request Time in seconds).
2. Alternative modes: SEND TO ALL (first acceptance wins), BATCH WISE (waves), ROUND ROBIN (forced, weighted by distance/load) — the mode is an explicit operator policy.
3. Search scope widens across attempts (Start Radius → Radius Increment → Maximum Radius).
4. Exhaustion is loud: "the Dashboard gets a notification and tasks shows the option to Retry Auto Assignment" — a stuck offer never sits silent; Moovs texts/emails the operator the moment a driver declines ("Your driver, [driverName], just declined the trip that you assigned to them.").
5. The same shape scales to organizations: Auto Farm offers trips to affiliate POOLS by region + vehicle type, round-robin or bidding, with a monitoring view of "what has been sent, what has been accepted, and where action may still be needed" (Limo Anywhere).
6. Driver-side: pending trips require accept/reject before entering the Upcoming queue (DriverAnywhere).

## Use when
Drivers/vendors are independent actors who can say no — typical for conference fleets built from hired vendors. The accept gate turns "I assigned it" into "they confirmed it."

## Avoid when
Drivers are staff under direct instruction — an accept loop adds latency to people who can't decline anyway; direct assignment + notification suffices.

## Sad paths observed
- Decline and timeout are the designed-for cases; the documented failure mode is pool exhaustion → operator notification + manual retry affordance.
- Un-accepted offers are detectable by status ("Offered to Driver") and recoverable (Limo Anywhere).

## Accessibility
Not observable from documentation sources.

## Default verdict for our stack
AVOID for V1 (no driver accounts exist); RECOMMENDED for the eventual driver surface — and the vendor-pool variant maps to how conference ops actually contracts vehicles.
