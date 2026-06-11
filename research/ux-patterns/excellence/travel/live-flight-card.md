# Pattern: Live flight card (one-glance segment status block)
**Surface:** travel · **Observed in:** Flighty Live Activities (refs: https://mobbin.com/flows/7e5b1c0f-fe17-4f5f-ad94-dfd1fc802091, https://mobbin.com/flows/8f54910b-ffab-4066-bafb-ea16f525f27c)

## Flow
1. Compact card: header row = airline icon + flight number (left), source brand (right).
2. Main row: origin code + time | tiny plane glyph + progress dots/bar | destination code + time. Times colored by status (see flight-status-color-language).
3. Sub-row per endpoint: terminal/gate chip + delta ("T8 · On Time", "1m early").
4. Bottom banner = the ONE thing that matters now: "Gate Departure in 1h 45m — Inbound aircraft has arrived" with gate chip "↗14"; arrived state flips to "Arrived 33m Early — Terminal 4 · Gate 42A" + baggage chip "T4C1".
5. Card background escalates with state (green-tinted on-time/early, red delayed).

## Use when
Per-segment status anywhere small: delegate-facing itinerary page, ops list rows, notification previews, live-share landing page.

## Avoid when
The record has no live feed — a static itinerary should look like a document, not imitate a live tracker.

## Sad paths observed
- Severe delay: whole card turns red, banner carries cause ("Late aircraft in air from DAC") — cause, not just effect.
- Unknown gate = "--", never blank.

## Accessibility
All state encoded in text + color; progress bar is decorative reinforcement only.

## Default verdict for our stack
RECOMMENDED (as the segment-card grammar; live data optional) — the oracle card (F4–F10) already has route/times/PNR/icon; adopting this layout gives it the at-a-glance hierarchy.
