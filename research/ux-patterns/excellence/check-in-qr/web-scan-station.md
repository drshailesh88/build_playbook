# Pattern: Browser scan station — no-install check-in with a permission sad path

**Surface:** check-in-qr / scanning (web) · **Observed in:** Luma (web) (refs: https://mobbin.com/flows/677c310b-74ca-4a11-a9b6-eeb0bc90d6f4, https://mobbin.com/screens/39fd9313-2e91-4105-bd17-de49d87b1407)

## Flow
1. The web app itself is a scan station: big camera viewport, camera-flip control, event name in the header — any laptop + webcam or borrowed tablet becomes a door device with a URL.
2. Live progress strip below the viewport (see live-progress-strip card).
3. Camera-permission sad path is designed, not default-browser: "📷 **Please Enable Camera Access** — Luma needs to access your camera to scan QR codes."
4. The page advertises the upgrade path without blocking: "We also have mobile apps you can download to check in guests. [Get for iOS / Get for Android]".

## Use when
The product is web-first (EventState is) or doors are staffed by volunteers on personal/borrowed devices where "install the staff app" dies at the door.

## Avoid when
Camera-in-browser falls over on locked-down kiosk hardware or old WebViews — the manual-entry keyboard mode must exist as the same-page fallback.

## Sad paths observed
- Permission denied/never granted: instructional empty state in-page (no dead camera rectangle).

## Accessibility
The permission state must be announced; keyboard mode (typed codes) doubles as the no-camera path.

## Default verdict for our stack
RECOMMENDED — legacy is already a browser-based scanner (census @yudiel/react-qr-scanner on the qr page) ✓; the deltas are the designed permission sad path (census has none) and the live strip under the viewport.
