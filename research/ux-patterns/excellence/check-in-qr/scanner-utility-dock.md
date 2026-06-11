# Pattern: Scanner utility dock — torch, manual entry, mode switch, history

**Surface:** check-in-qr / scanning · **Observed in:** Lime, Lyft, ZARA, Grab, Luma (refs: https://mobbin.com/screens/3836a17e-0491-4b66-89ce-fa6172c3ea99, https://mobbin.com/screens/3ce9f604-607c-4a09-9201-da5982e2c7a2, https://mobbin.com/screens/67443377-41ac-456f-8c76-ad75fa660649, https://mobbin.com/screens/b4ba2d47-f27e-4f83-ad67-119461d5d989, https://mobbin.com/flows/74bc6276-56b0-44b9-9a2b-cd8ed27f650f)

## Flow
1. Full-screen camera, corner-bracket or rounded-square viewfinder, minimal chrome.
2. Persistent dock of utilities at the bottom: **flashlight/torch** (Lime, Lyft, Grab) and **keyboard / manual code entry** (Lime, Lyft) — both one tap away at all times, not hidden behind failure.
3. ZARA generalizes to mode tabs: **CAMERA / NFC / KEYBOARD**, plus a **SCAN HISTORY** row beneath.
4. Luma docks context shortcuts instead: guest-list (bottom-left) + camera-flip (bottom-right).
5. Viewfinder can ghost the expected code shape + purpose microcopy ("Scan '⊞' on your Tonal's Sign In screen…" — Tonal https://mobbin.com/flows/943aafd2-ee41-4442-a208-aa605dad7341).

## Use when
Any production scanner. Dark venue hall → torch; crumpled badge print or cracked phone screen → typed code; camera-blocked browser → keyboard mode.

## Avoid when
Nothing — the dock is cheap. Only trim NFC/history modes when the hardware or audit story doesn't exist yet.

## Sad paths observed
- Unreadable code → "Couldn't read barcode — Try manually entering…" (Lyft) with Manual entry as the primary action.
- Wrong-target scanning prevented by ghosted code shape + naming the exact code to scan (Lime, Tonal).

## Accessibility
Torch and manual-entry buttons need labels (icon-only fails screen readers); manual entry is itself the accessibility path for users who can't aim a camera.

## Default verdict for our stack
RECOMMENDED — legacy scanner (census QrScanner.tsx) has cooldown + online/offline modes but NO torch, NO typed-code fallback; both are absent from the census entirely.
