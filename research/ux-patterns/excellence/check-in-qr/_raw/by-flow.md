# BY-FLOW Raw Harvest — Check-in / QR

Task searches: "scan QR ticket to check in guest at door", "add boarding pass to wallet and show at entry", "self check-in kiosk / gym class", "organizer add walk-in guest at door", "check in guests on web".

Date: 2026-06-11

---

## Flow: staff scans a guest at the door
- Luma ios "Checking in a guest" (https://mobbin.com/flows/74bc6276-56b0-44b9-9a2b-cd8ed27f650f): event page Check In chip → scanner → identity sheet (avatar/name/email/status/reg-time/ticket) → Check In → "✓ Check In Successful" toast → Undo Check In. Post-state shows Registered AND Checked In timestamps side by side.
- Luma web "Scanning a ticket" (https://mobbin.com/flows/677c310b-74ca-4a11-a9b6-eeb0bc90d6f4): browser camera scan station with live progress strip under the viewport; camera-permission sad path.

## Flow: staff checks in WITHOUT a QR (manual / search / list)
- Luma ios guest-list sheet from scanner (https://mobbin.com/flows/26b0f3ea-2156-43d2-b580-f4774fbb7fc7): search + status tabs + per-guest sheet → Check In.
- Partiful "Checking in a guest" (https://mobbin.com/flows/615d6618-b41d-4b54-a012-d518ef0ad559): Manage Guests → Bulk actions [Download CSV / Check in guests] → per-row "Check in" → ✓.
- Luma web session check-in (https://mobbin.com/flows/777d7312-09c7-413e-8dfc-f880610ec198): session dropdown → search → Check In → "✓ Checked In in 13 hours" + Update; Approved/Checked In footer counters.
- Posh "Marked as checked in" (https://mobbin.com/flows/4022cce6-c624-4831-9f9f-b52243749684): guestlist table row ✓/✗/🗑, +1 column, status chips, "Guest updated successfully".

## Flow: walk-in admission at the door
- Posh Private Guestlist "+ Create Guest" (same flow as above): name + additional guests + description; no ticket, no account. ONLY walk-in pattern observed in the harvest.

## Flow: attendee presents a credential
- Luma "View ticket" (https://mobbin.com/flows/c186b93d-4002-48cc-a0d8-f0359f8e58ec): My Ticket chip → full-screen QR + Add to Apple Wallet.
- Live Nation "View ticket" (https://mobbin.com/flows/131e83a0-2f9c-42ee-a5d3-b5896eb5e0be): rotating barcode, "Screenshots won't get you in.", wallet.
- StubHub "Ticket detail" (https://mobbin.com/flows/bd8bafeb-7a6d-4d9d-9ea3-7033b781f5fe): "Available offline", readable code under QR, gate instruction, wallet.
- Eventbrite "Tickets"/"Ticket details" (https://mobbin.com/flows/65b9eca1-dd2c-4ded-a473-ff594b5955c1 , https://mobbin.com/flows/6e056259-aa3f-4d73-9c75-fab0cf3707bf): QR-count badge on ticket rows, Download ticket, Find-your-tickets recovery.
- Shangri-La wallet card (https://mobbin.com/flows/ec56ffda-1174-4b44-849d-7ec42ac5afc6): auto-refresh 60s QR.
- Nike Run Club "Pass" (https://mobbin.com/flows/4f299f86-1d73-42ba-9e06-cced3b97aaa5): persistent member QR.

## Flow: self check-in (kiosk / class)
- Open "Booking an in-person class" (https://mobbin.com/flows/a0068a12-a9c3-4206-9f05-cec72c5a101b): phone number REQUIRED to check in to class ("To check in to class, we require your phone number."), waiver checkbox, Confirmed (1) state, Manage/Add to cal.
- Tonal "QR Code scanner" (https://mobbin.com/flows/943aafd2-ee41-4442-a208-aa605dad7341): purpose-naming scanner microcopy.
- NO true kiosk surface found (coverage gap → first principles).

## Dry-check log (loop-until-dry)
1. "conference badge attendee QR lanyard multi day" → repeats (Luma) + 1 new (WWDC badge pickup).
2. "venue capacity occupancy counter scan out re-entry" → repeats (Luma) + 1 adjacent (Max Capacity popover); no door-side novelty.
→ Declared dry after 2 consecutive near-empty rounds.
