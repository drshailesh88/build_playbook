# Pattern Library — check-in-qr (EXCELLENCE harvest)

**Harvested:** 2026-06-11 · Mobbin MCP (search_flows + search_screens), iOS + web, loop-until-dry (2 consecutive near-empty rounds).

## Coverage note (honesty)
- **Swept:** by-app (Eventbrite, Luma, Partiful, Posh, Live Nation, StubHub, Nike Run Club, Shangri-La, Tonal, WWDC, Open), by-pattern (scanner overlays, scan errors, offline banners, live counts, capacity, badges), by-flow (door scanning, manual/list check-in, walk-in, credential presentation, self check-in, web check-in).
- **Luma is the depth source** — the only modern event platform with full organizer check-in flows on Mobbin (iOS + web).
- **NOT on Mobbin / not found:** Eventbrite **Organizer** staff app (the brief's suggested reference — only Eventbrite's attendee side exists there), Cvent OnArrival, Whova/Bizzabo onsite, self-serve **kiosk** check-in, **badge printing** on scan, **scan-out / re-entry / occupancy**, multi-device scanner coordination. → first-principles candidates, flagged in the WOW-DELTA.
- Scanner-recovery and offline evidence drawn cross-domain (Walmart, Lyft, Grab, Lime, ZARA, Qantas, Waymo, WeTransfer, Expedia) where event apps were silent.

## Cards (16)
| Card | One-liner | Default verdict |
|---|---|---|
| scan-identity-confirm-sheet | Scan raises an identity sheet; human confirms; undo on the same sheet | **RECOMMENDED** |
| undo-checkin | Reversal lives where the mistake happened (sheet button, row ✗) | **RECOMMENDED** |
| scanner-utility-dock | Torch + manual entry + mode tabs + history docked on the scanner | **RECOMMENDED** |
| scan-fail-nonblocking-recovery | Failure card over a live camera; next action always named | **RECOMMENDED** |
| one-tap-list-checkin | Search-first list mode: status tabs w/ counts, per-row Check in, bulk actions | **RECOMMENDED** |
| walkin-guest-creation | + Create Guest at the door (no ticket/account), +1s, description-as-reason | VIABLE (founder picks variant) |
| live-progress-strip | Checked-in vs expected as a progress bar ON the scan surface | **RECOMMENDED** |
| session-scoped-checkin | Session selector scopes every scan; early check-in labeled, not blocked | **RECOMMENDED** |
| fullscreen-qr-wallet-pass | Full-screen high-contrast QR + Add to Wallet + ticket recovery | **RECOMMENDED** |
| offline-credential-fallback-code | "Available offline" + human-readable code + gate routing on the ticket | **RECOMMENDED** |
| rotating-anti-screenshot-code | SafeTix-style living barcode; visible TTL | AVOID (V1) — printed-email persona |
| persistent-member-pass | One durable identity QR across an org's events | VIABLE (V2 architecture choice) |
| checkin-first-class-action | Check In promoted on event page / live-event card; ≤2 taps to door mode | **RECOMMENDED** |
| web-scan-station | Browser camera scan station + designed permission sad path | **RECOMMENDED** |
| offline-queue-vs-block | Anti-pattern card: block-and-retry vs the legacy queue-first mechanic | **RECOMMENDED** (keep legacy queue) |
| checkin-timestamps-audit | Registered vs Checked-In side by side; freshness indicators | **RECOMMENDED** |

Raw sweep logs: `_raw/by-app.md`, `_raw/by-pattern.md`, `_raw/by-flow.md`.
Project consumption: `test_Gica/.planning/ux-patterns/excellence/CHECK-IN-QR.WOW-DELTA.md` (choices become DECs there — this library never decides).
