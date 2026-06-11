# Pattern: Offline at the door — queue-first beats block-and-retry (anti-pattern card)

**Surface:** check-in-qr / offline · **Observed in (the anti-pattern):** Qantas, Waymo, WeTransfer, Expedia (refs: https://mobbin.com/screens/18f77caf-19d5-4199-98b4-a36f34096d23, https://mobbin.com/screens/66ee96c8-a0e3-401b-a8d2-d7c80dbdaae7, https://mobbin.com/screens/21faac5b-faae-43de-a608-4631ee720deb, https://mobbin.com/screens/668fab58-397b-4204-9c4e-7061fcba85aa)

## Flow (the anti-pattern, as observed)
1. Connectivity drops → full-page takeover: "You're offline. Check your connection." + [Try again / Retry].
2. The task is BLOCKED until the network returns; nothing is captured meanwhile.
3. Best-in-class copy at least names the state honestly and gives an error code ("[IN01]" — Qantas) and a settings shortcut (GoPay).

## Use when (the block pattern)
Tasks that are meaningless offline (booking, payment, upload) — blocking is honest there.

## Avoid when
DOOR CHECK-IN. A queue of humans cannot wait for venue WiFi. The correct shape — confirmed by the legacy G_I_C_A census, NOT found anywhere on Mobbin — is: scan offline → queue locally (IndexedDB) → visible queued-count badge → auto-sync on reconnect with original scan timestamps preserved → per-record duplicate resolution on sync.

## Sad paths observed
- The block pattern IS the sad path at a door: zero capture, zero feedback beyond retry.

## Accessibility
Offline/online state changes need aria-live announcement (the legacy connectivity pill already does this — census).

## Default verdict for our stack
RECOMMENDED to keep the legacy queue-first mechanic (census: offline-queue.ts, batch-sync.ts, banners, pending badge, auto-sync with 1s debounce) — it EXCEEDS the observable Mobbin ceiling. This card exists as evidence that no harvested app shows a better offline door story; do not regress to block-and-retry.
