# Pattern: Cancel with consequences disclosed (rules + live deadline before the button)
**Surface:** travel · **Observed in:** American Airlines (ref: https://mobbin.com/flows/339b5c1d-1fdf-446d-903a-2d62adffe299), Singapore Airlines (ref: https://mobbin.com/flows/1f645645-2708-487f-9288-094ad3b133f3)

## Flow
1. Cancel entry point is labeled with its consequence: "Cancel trip — Review before you cancel."
2. Disclosure screen BEFORE any destructive action: live, specific entitlement — "You can cancel for all passengers within **48 hours 9 minutes** for a refund." (deadline computed, ticking).
3. Rules in plain language bullets (full refund window, change-fee conditions, partial-passenger exception → "please call Reservations").
4. Two honest buttons: "Cancel for a Refund" / "Go back" — the destructive verb names what you get, the safe path is one tap.

## Use when
Any cancellation with downstream consequences — for EventState: cancelling a travel record that will red-flag accommodation/transport and notify the delegate. The disclosure should enumerate exactly what will fire.

## Avoid when
Trivially reversible deletes (a draft never sent) — full ceremony for a no-consequence action trains users to skim.

## Sad paths observed
- Already-cancelled → no cancel affordance at all (terminal state hides the verb).
- Edge cases route to humans explicitly ("If you don't want to cancel for all passengers, please call Reservations") rather than failing silently.

## Accessibility
Disclosure is plain text (not a tooltip); both buttons full-size, destructive one visually distinct.

## Default verdict for our stack
RECOMMENDED — oracle uses `window.confirm()` (F12, census flags it); replace with a consequence dialog: reason field (H4 already binds it) + "This will flag 1 accommodation, 1 transport assignment, and notify Dr. Rao by email + WhatsApp" — the cascade is knowable before commit.
