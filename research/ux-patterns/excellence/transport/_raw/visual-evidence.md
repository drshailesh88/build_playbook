# TRANSPORT — Visual evidence sweep (screen-level)

- Mode: visual (screen-level layouts, on-screen microcopy, states)
- Date: 2026-06-11
- Sources (mixed, per-entry): Mobbin MCP (authenticated session — connection dropped repeatedly; 1 query completed before disconnect), Google Play store screenshot galleries via Playwright browser (public, vendor-published screenshots), official TripShot Rider App Guide PDF (already read page-by-page in the by-app sweep — cross-referenced, not duplicated).
- Purpose: close the adversarial-review (2026-06-11) finding that the transport harvest had documented behavior but zero screen-level visual evidence. This file records what screens actually LOOK like; entries only state what is visible.

---

## V1 — Booking.com (iOS): "Live flight tracking for airport pick-ups" onboarding
- Source: Mobbin MCP search_screens · mobbin_url: https://mobbin.com/screens/a14aef35-7ebb-4d4e-ae67-7c2cde3ef00b
- Visually observed: full-screen onboarding card, centered airplane glyph, H1 "Live flight tracking for airport pick-ups", body "Book an airport taxi in advance and our drivers will monitor your arrival and wait 45 minutes after you land", page dots (3rd of 3), full-width primary button "Got it", "Help Center" link top-right, × close top-left. Happy/educational state.
- Maps to: flight-eta-derived-pickup (the consumer-facing promise of the mechanic), passenger-notification-ladder (expectation-setting copy).
- Quality note: shows the VALUE FRAMING of flight-linked pickups as a one-screen promise with a concrete wait window ("45 minutes") — usable almost verbatim for attendee-facing copy.

## V2 — Uber Eats (iOS): courier-tracking card during delivery
- Source: Mobbin MCP search_screens · mobbin_url: https://mobbin.com/screens/c5cc302e-4469-4801-ae13-675188610d74
- Visually observed: map on top; bottom sheet: title "Picking up your order…", subtitle "Now arriving 2:55 - 3:00 PM" with ⓘ, progress segments under the title, line "Latest arrival by 3:25 PM"; full-width blue band "Share delivery PIN **5 8 0 9**"; identity row: courier photo with "94% 👍" badge — vehicle photo — "Toyota Prius" + plate chip + "Top-rated courier" badge; action row: phone icon, "Send a message" field, "+ Tip"; collapsible "Delivery details — Meet at my door at 1226 University Dr". Happy in-progress state.
- Maps to: passenger-notification-ladder / live-tracking-link-no-app (the tracking-page anatomy: ETA range + latest-by bound + identity row + contact actions), coordinator-guest-visibility (PIN = mutual-verification visual analog of HopSkipDrive's code word).
- Quality note: the layout answer for our trip-details page — ETA as a RANGE plus a worst-case bound, identity as photo+vehicle+plate in one scannable row, verification PIN as the most prominent element.

## V3 — Uber Driver (Android, Google Play gallery): "Go online" home state
- Source: vendor-published screenshot, Google Play listing https://play.google.com/store/apps/details?id=com.ubercab.driver (screenshot 1, opened full-size in viewer)
- Visually observed: map fills screen, large circular "GO" primary button bottom-center, status bar sheet "You're offline" with list icon, "Inbox — Complete personal safety education" row beneath. Caption: "Go online".
- Maps to: driver-run-sheet-day-of (driver home = single dominant state-change action over a map).
- Quality note: driver UIs put ONE huge state action on screen; everything else is secondary.

## V4 — Uber Driver (Android, Google Play gallery): incoming trip offer card
- Source: vendor-published screenshot, same listing (screenshot 2 full-size; caption "Accept trip and delivery requests")
- Visually observed: map with route polyline and pickup pin; "× Decline" pill top-right ON the map; star chip "4.98" (rider rating) on route; bottom offer card: "UberX" badge, fare "$16.05" extra-large, "★ 4.25", two stacked rows — "4 min (1.1 mi) away — San Marino St & Irolo St, LA" and "20 min (7.3 mi) trip — 5 Central Ave & 56th St, LA" — full-width "Accept" button. Time-pressured decision state.
- Maps to: driver-offer-accept-loop (offer anatomy: compensation + pickup cost + job size + 2 actions), driver-run-sheet-day-of.
- Quality note: the offer card hierarchy is documented visually: money first, distance-to-pickup second, trip size third; Accept is the entire bottom edge, Decline is deliberately small and off-card.
- Also visible in gallery strip (thumbnails, captions readable): "Turn-by-turn directions", "Track earnings with every trip", "Rating system".

## V5 — Uber rider (Android, Google Play gallery strip): booking + safety screens
- Source: vendor-published screenshots, Google Play listing https://play.google.com/store/apps/details?id=com.ubercab (gallery strip captured; thumbnails readable at structure level)
- Visually observed: "Enter your destination" (search-first sheet over map with recent places list); "See prices upfront" (ride-class list, each row = class icon + name + price + ETA, one selected); "Confirm your pickup spot" (draggable pin on map + bottom confirm button); "Safety is a priority" (share-trip-status screen: contact avatar row with blue selection circles + "Save" button). Fine microcopy beyond captions: unclear from screenshot (thumbnail scale).
- Maps to: coordinator-guest-visibility (share-trip-status with chosen contacts is the consumer shape of milestone visibility), arrivals/booking entry patterns.
- Quality note: structural evidence only at this scale — flagged as such.

## V6 — TripShot (iOS): reservation, boarding, and notification screens (cross-reference)
- Source: official TripShot Rider App Guide PDF (Nevada State University deployment), read page-by-page WITH screenshots in the by-app sweep — see `_raw/by-app.md` A37/A38 for the full transcription
- Visually observed (per that read): trip options listing "25 reservable seats available." inline per departure with "RESERVE" action; per-stop "Scheduled Departure: 3:00 PM / ETA: 3:00 PM" pairs; "Set Notification" screen with checkboxes "Notify me when vehicle is delayed — by 5 minutes ▾" / "When vehicle is approaching — and is 5 minutes ▾ away", day-of-week chips, "Only on date", "Use mobile push notifications", "SAVE"; Wallet/Boarding tiles on home.
- Maps to: day-of-boarding-checkin, capacity-constraint-not-overfill (rider-visible seat counts), flight-alert-taxonomy (user-set thresholds), passenger-notification-ladder.
- Quality note: this was ALREADY screen-level evidence sitting in the by-app sweep — the only entry there sourced from actual screenshots; promoted to visual status here.

---

## Coverage log (honesty)

Attempts and outcomes this visual sweep:
1. Mobbin MCP (3 OAuth rounds): tools connected once, 1 query returned V1/V2, then the server session was repeatedly invalidated by Claude re-logins; subagent delegation failed 3× on harness login state. PARTIAL Mobbin coverage only.
2. Playwright browser → mobbin.com direct: blocked by Mobbin web login (fresh browser profile, no session). Dead end.
3. Playwright browser → apps.apple.com: HTTP 429 rate-limit on media. Dead end.
4. Playwright browser → play.google.com: WORKED — Uber Driver (V3, V4 full-size; strip captions), Uber rider (V5 strip). Stopped after 2 apps by deliberate token-budget decision, not exhaustion.
5. Playwright browser → onfleet.com/last-mile-delivery: page loaded; product-image element screenshot timed out (lazy-loaded carousel). Dropped per stop-grinding decision.

**Visually evidenced after this sweep:** driver offer/accept anatomy (V4), driver home state (V3), passenger tracking-card anatomy with identity + ETA-range + PIN (V2), flight-pickup promise framing (V1), shuttle seat-capacity + threshold-notification screens (V6), share-trip-with-contact structure (V5).

**Still NOT visually evidenced (remains doc-based + first-principles per the WOW-DELTA gate):** web dispatch boards/grids; suggestion-approval UI; arrivals roll-up board; staged-replan/publish-changes UI; exception/attention queues; boarding check-in operator screen; no-show wizard screens; bulk-reassign UI; manifest/export config screens. These are B2B ops surfaces — thin on Mobbin by its consumer-app nature and not published as screenshots by B2B vendors; their UX shape stays first-principles design territory (consistent with `first-principles-candidates.md`).
