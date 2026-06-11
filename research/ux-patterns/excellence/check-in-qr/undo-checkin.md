# Pattern: Undo check-in — reversal lives where the mistake happened

**Surface:** check-in-qr / scanning + lists · **Observed in:** Luma, Posh (refs: https://mobbin.com/flows/74bc6276-56b0-44b9-9a2b-cd8ed27f650f, https://mobbin.com/flows/4022cce6-c624-4831-9f9f-b52243749684, https://mobbin.com/screens/df1c4370-2edf-460b-b23e-8faf38531822)

## Flow
1. Immediately after a successful check-in, the primary button on the SAME sheet becomes **Undo Check In** (Luma).
2. In list views, the checked-in row keeps a reversal control: green ✗ next to the status chip (Posh); tapping reverts status to "Not Checked In" with toast "Guest updated successfully".
3. Luma web shows the checked-in row with an **Update** button — state is editable, not terminal.
4. Record keeps both timestamps (Registered / Checked In) so a reverted-and-redone check-in stays auditable.

## Use when
Always, for staff-operated check-in. Wrong-person scans, tester scans, and "scanned the speaker as a delegate" happen at every door.

## Avoid when
Self-service kiosk surfaces — exposing undo to attendees invites gaming; reversal there should be staff-only.

## Sad paths observed
- Wrong guest checked in: one-tap undo on the still-open sheet (Luma).
- Bulk mistake: Posh's per-row ✗ requires row-by-row reversal — no bulk undo observed anywhere (gap).

## Accessibility
Undo button must be reachable before toast timeout matters (button persists; the toast is informational only — never make the toast the only undo path).

## Default verdict for our stack
RECOMMENDED — NEVER ATTEMPTED in the legacy app (census has zero un-check-in capability; a wrong scan is permanent without DB surgery). Table stakes in every excellence app harvested.
