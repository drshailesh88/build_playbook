# Pattern: Living credential — rotating/auto-refreshing code that defeats screenshots

**Surface:** check-in-qr / anti-fraud · **Observed in:** Live Nation (SafeTix), Shangri-La Circle (refs: https://mobbin.com/flows/131e83a0-2f9c-42ee-a5d3-b5896eb5e0be, https://mobbin.com/flows/ec56ffda-1174-4b44-849d-7ec42ac5afc6)

## Flow
1. The barcode ANIMATES (moving scan bars) and rotates its payload; caption says why in attendee language: "**Screenshots won't get you in.**" + manual refresh ↻ (Live Nation).
2. Shangri-La variant: visible freshness countdown "Auto refresh every 60s(59s)" + Refresh button — the token's TTL is part of the UI.
3. The rotating credential still offers Add to Apple Wallet (wallet passes support rotating NFC/QR payloads).

## Use when
Resale/sharing fraud has real cost: paid tickets scalped, capacity-restricted credentials shared, one badge admitting many people via WhatsApp'd screenshots.

## Avoid when
Free/community events or credential-checked-against-face contexts — rotation adds connectivity dependence on the ATTENDEE side (a static signed QR works from a printout; a rotating one needs a live app), which is the wrong trade for a medical conference where delegates may present printed emails.

## Sad paths observed
- Attendee offline with a rotating code: not addressed in harvest — the known cost of this pattern (Ticketmaster's real-world pain). The static-but-verified alternative (duplicate detection at the door + face check) covers most of the risk for non-scalped events.

## Accessibility
Animation must not be the only validity indicator; refresh control needs a label; countdown should not announce every second.

## Default verdict for our stack
AVOID for V1 — legacy duplicate-scan detection (census 23505 backstop + duplicate feedback) already catches shared codes at the door, and printed-email delegates are a core persona; revisit only if paid-ticket scalping becomes real.
