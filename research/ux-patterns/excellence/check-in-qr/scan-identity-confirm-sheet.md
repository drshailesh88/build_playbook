# Pattern: Scan → identity sheet → explicit confirm (face check before commit)

**Surface:** check-in-qr / scanning · **Observed in:** Luma (refs: https://mobbin.com/flows/74bc6276-56b0-44b9-9a2b-cd8ed27f650f, https://mobbin.com/screens/41bed30f-78ed-4b43-a5db-ac2dd783c584)

## Flow
1. QR decodes → bottom sheet rises OVER the live camera (camera never closes).
2. Sheet shows the person: avatar, name, email, Status ("Going" in green), Registration Time, Ticket type.
3. Staff taps the big **Check In** button to commit — the scan itself reads, the human admits.
4. Green toast "✓ Check In Successful"; button flips to **Undo Check In**.
5. Post-commit sheet shows Status · Registered timestamp · Checked In timestamp side by side.
6. A "Not Going" or "Pending Approval" guest still renders the sheet with their status visible and the Check In button available — status informs, the staffer decides.

## Use when
Identity matters at the door (paid tickets, credentialed/medical events, badge handout at scan time) — the sheet is the moment staff matches face to record.

## Avoid when
Pure-throughput doors (festival GA, hundreds/hour, one wristband per QR) — the confirm tap halves throughput; auto-commit with a loud success state wins there. Make the mode a per-event/per-station choice, not a global.

## Sad paths observed
- Ineligible-status guest (Not Going / Pending Approval): status surfaces in the sheet; admission stays a human call rather than a hard block.
- Mis-scan of the wrong person: Undo is on the same sheet — recovery costs one tap.

## Accessibility
Sheet content (name, status) must be announced on appearance; the success toast needs aria-live; Check In button needs a state change beyond color (label flips to Undo Check In).

## Default verdict for our stack
RECOMMENDED — the legacy app auto-commits on scan (census processQrScan inserts immediately); a confirm-mode sheet adds the face-check the medical-conference job actually needs, with auto-commit kept as a per-station toggle.
