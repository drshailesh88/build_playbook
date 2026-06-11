# Pattern: Registered vs Checked-In timestamps — the row tells its own story

**Surface:** check-in-qr / audit · **Observed in:** Luma, Posh (refs: https://mobbin.com/screens/df1c4370-2edf-460b-b23e-8faf38531822, https://mobbin.com/flows/777d7312-09c7-413e-8dfc-f880610ec198, https://mobbin.com/flows/4022cce6-c624-4831-9f9f-b52243749684)

## Flow
1. Post-check-in person sheet shows three facts side by side: Status: Going · **Registered:** Today at 9:41 AM · **Checked In:** Today at 9:44 AM (Luma).
2. List rows annotate check-in state relative to context: "✓ Checked In in 13 hours" (before session start — honest about early check-ins, Luma web).
3. Table view keeps state + freshness visible: status chips, "Last Updated 5:37pm ↻" (Posh).
4. Reversals don't erase history — the row returns to Not Checked In but the toast trail confirms the update.

## Use when
Staff-facing detail sheets and logs — disputes at the door resolve in seconds when the original times are on screen ("you were checked in at 9:44 by the south door").

## Avoid when
Attendee-facing surfaces don't need the audit pairing — show only what they must act on.

## Sad paths observed
- Duplicate scan dispute: the original check-in time on the duplicate feedback is what de-escalates "but I never came in" at the door.

## Accessibility
Timestamp pairs need labels read together ("Registered… Checked in…"), not as bare times.

## Default verdict for our stack
RECOMMENDED — legacy records checkInAt + checkInBy + method (census schema) but the duplicate feedback showing the ORIGINAL time was ASSUMED, not confirmed, in pathways (PATH-attendance-002 note); the rebuild should pin it as contract.
