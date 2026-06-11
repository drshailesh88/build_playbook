# Pattern: Day-of boarding — expected vs checked-in vs capacity, per stop, with milestone notifications

**Surface:** transport · **Observed in:** Moovs Shuttle, TripShot, Booking Tool, Zūm, ETA Transit
(refs: P11, F18, F19, F20, A36, A37, A41 — URLs in `_raw/`; key: https://www.moovsapp.com/shuttle-app, https://www.ridezum.com/faqs/zum-app/)

## Flow
1. The boarding screen is a triad per stop/vehicle: EXPECTED passengers vs CHECK-IN status vs CAPACITY (Moovs Shuttle: drivers "view expected passengers, check-in status, and capacity tracking for each stop").
2. Check-in is QR scan OR manual tap — the manual fallback is documented, not an afterthought (Moovs, Booking Tool: "just scan, check, and go!").
3. Boarding is a verified physical event that feeds reporting: "Confirm when riders have physically boarded vehicles and can be counted" (TripShot); counts roll up "by route, shift, and more".
4. Boarding can be GATED on entitlement: drivers "determine if a rider has a reservation and whether or not they should be allowed to board" (TripShot).
5. The boarded event immediately notifies the responsible party: "student picked up" / "student dropped off" with scheduled-vs-actual times (Zūm) — the coordinator analog for conference VIPs.
6. Capacity is visible to riders too: "how many of the seats on board a vehicle are filled" (TripShot rider app); confirmed/standby lists absorb overflow.

## Use when
Event-day execution: marking passengers boarded/no-show at the hub, live headcount per vehicle, and the ops-room roll-up ("Van 2: 9/12 boarded"). This must work on a phone at a curb.

## Avoid when
QR-first design where attendees lack printed/displayable codes — manual tap-the-name must be the primary gesture for conference ops, QR an accelerator. Avoid hard boarding gates for walk-up reassignments (ops moves people between vans at the curb; see capacity card for the override stance).

## Sad paths observed
- Boarding denial on no-reservation is explicit (TripShot).
- No vendor documents the reconcile-then-depart decision ("2 missing — hold or go?") — FIRST-PRINCIPLES candidate (see first-principles-candidates.md #4).
- Offline at the curb: Onfleet's 2-minute grace + dispatcher-visible offline state (cross-ref driver-run-sheet card).

## Accessibility
Manual check-in fallback doubles as the accessible path. Tap targets at curb-side = large-touch design; not further observable from docs.

## Visual evidence (Mobbin re-sweep 2026-06-11) — PARTIAL
The staff-side per-stop manifest (expected vs checked-in vs capacity, bus context) was NOT found on Mobbin — school-bus apps (Zūm, HopSkipDrive) and intercity agent tools (FlixBus et al.) are not catalogued. That triad layout remains vendor-doc-described (Moovs/TripShot) + FIRST-PRINCIPLES composition. What IS screen-verified (full detail in `_raw/mobbin-resweep.md` §2):
- The tap-to-board interaction loop: Luma's scan → identity-confirm card ("Jason Smith · Status: Going · Ticket: Standard") → "Check In" → toast → "Undo Check In", with Going/Checked In tabs as manifest segmentation (ADJACENT events, https://mobbin.com/screens/a779f7d7-ecb5-4080-8bcd-b05cc92b30d4, https://mobbin.com/screens/41bed30f-78ed-4b43-a5db-ac2dd783c584).
- Manual check-in list with destructive-undo confirm ("Uncheck them?" / "Nevermind") and aggregate count chips ("Going 1 · Maybe 1 · Can't Go 0") as a lightweight manifest header (Partiful, ADJACENT, https://mobbin.com/screens/ea985466-4b63-4131-a55d-7f43a9985882).
- Rider-side boarding artifact: Transit's live-clock anti-screenshot ticket (https://mobbin.com/screens/c4e98f62-bb31-4627-826a-9f7e15de6d72); "BOARDS [time]" distinct from departure on airline wallet passes (ADJACENT, https://mobbin.com/screens/7d0d0780-7c35-4620-ab73-1ec50487b450).

## Default verdict for our stack
RECOMMENDED, re-tiered per adversarial review: the CAPABILITY (boarding statuses per stop, capacity tracking) is vendor-doc-proven; the check-in INTERACTION (scan/tap → confirm identity → commit → undo) is screen-verified via adjacent event check-in; the per-stop triad SCREEN LAYOUT is a first-principles design task anchored on those two. Legacy had statuses server-side with ZERO UI (done-spec #18) and no mobile assignment gesture (#17).
