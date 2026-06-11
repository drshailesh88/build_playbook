# Transport — Excellence pattern library INDEX

**Module job:** conference ops moves attendees between hubs (airport/station ↔ hotel ↔ venue) in batches: plan from travel data, assign vehicles/passengers under capacity, dispatch drivers, run day-of boarding, react to flight changes, notify passengers/drivers, roll-up counts for planning.
**Harvested:** 2026-06-11 · for EventState rebuild (test_Gica), reusable cross-project.

## COVERAGE NOTE — read before trusting

- **Mobbin MCP was unstable this session** (OAuth session repeatedly invalidated; 1 query completed). The behavior sweep ran on **WebSearch/WebFetch over vendor documentation** (help centers, API docs, official guides); every raw entry cites a URL; behaviors are recorded as documented, never inferred.
- **Visual evidence pass (post adversarial review 2026-06-11): `_raw/visual-evidence.md`** — screen-level evidence from Mobbin MCP (Booking.com flight-pickup onboarding, Uber Eats courier-tracking card), Google Play vendor screenshots (Uber Driver offer/accept + home, Uber rider booking/safety strip), and the TripShot official PDF (reservation/boarding/notification screens). **Visually evidenced:** passenger tracking-card anatomy, driver offer/accept anatomy, flight-pickup framing, shuttle seat-capacity + threshold notifications.
- **Mobbin re-sweep (same day, after OAuth restore): `_raw/mobbin-resweep.md`** — 38 screen-cited findings across the five V1-CORE families, per-family verdicts: pickup notification **STRONG** (Grab/Uber/Bolt/Beat direct), driver run sheet **STRONG** (DoorDash Dasher deep + nav-app stop lists; single-gig-app caveat), capacity enforcement **STRONG** (10 apps incl. Grab Bus & Ferry seat meters, Kakao T three-state rows), day-of boarding **PARTIAL** (check-in interaction loop verified via Luma/Partiful ADJACENT; per-stop expected/checked-in/capacity manifest ABSENT from Mobbin), dispatcher exception queue **PARTIAL adjacent-only** (Zendesk/Navan/Fiverr/Stripe ops queues; fleet consoles confirmed absent from Mobbin). The five affected cards now carry "Visual evidence" sections with these verdicts.
- **Vendor-asset screenshot pass (same day, third pass): `_raw/visual-resweep.md`** — 13 visually-inspected SCREEN findings via curl-downloaded vendor screenshot assets + App Store `screenshotUrls` (an earlier sandbox-blocked attempt was superseded). Key adds: **Onfleet's real web ops console** — Command Center with failed/delayed alert counters + routes table (F2.1), dispatch board with unassigned queue pinned above driver lanes and per-stop completed/ETA/amber-late states (F2.2), named route containers with progress (F2.3); Onfleet SMS notification ladder verbatim + tokened tracking page (driver photo, vehicle + plate, stops-ahead, ETA) with organizer privacy knobs (F5.1–F5.2); TripShot Driver Ridership tab + shift Check-In (F1.1); DriverAnywhere Job-Details run sheet with requirements/greeting sign (F4.1); TripShot rider delay-threshold subscription + scheduled-vs-ETA True-Time (F5.3–F5.4).
- **Still NOT visually evidenced (first-principles for UX shape):** B2B web ops surface LAYOUTS — suggestion-approval, arrivals roll-up, staged re-plan, boarding operator triad screen, no-show wizard, bulk reassign, export config. Their component anatomy now has direct or adjacent screen anchors (see re-sweep), but the composed ops-console layouts remain design territory requiring explicit design DECs. **Exception:** the dispatch-grid composition itself is now screen-evidenced (Onfleet web console, third pass F2.1–F2.3 — alert counters as board header, unassigned queue above driver lanes, table+map split); the exception-queue REVIEW→RESOLVE workflow on such a board remains unevidenced.
- **Swept (3 modes, each looped until 2 consecutive dry queries):** by-app (`_raw/by-app.md`, 45 entries, 30 queries), by-pattern (`_raw/by-pattern.md`, 15 patterns, 36 queries), by-flow (`_raw/by-flow.md`, 37 flows, 48 queries). Apps covered: Onfleet (incl. full API docs), Limo Anywhere, Moovs, Routific, Circuit/Spoke, OptimoRoute, Tookan, Bringg, Track-POD, Route4Me, Motive, Flighty, FlightAware, TripShot, Via (thin — marketing only), Uber Central/Reserve, Zūm, HopSkipDrive, Welcome Pickups, Blacklane, Hoppa/SAS, Tourplan NX, Travelport GlobalWare, Booking Tool, miMeetings (events vertical), Azavista (events vertical), RideCo, Samsara, ADA-paratransit practice (DREDF).
- **Not swept / unreachable:** Onfleet+FlightAware+OptimoRoute Zendesk help centers block fetches (403 — behaviors recorded from search excerpts of the named articles, flagged inline); Via has no public help center; TripShot support portal not public (official PDF guide used); miMeetings site has SSL errors. Samsara/Motive covered only where surfaced by pattern queries, not walked app-by-app. (The original doc-based harvest had no screen-level evidence; the two visual passes above have since added it for the surfaces they name.)
- Accessibility sections in cards are mostly "not observable" — doc sources don't show focus order/ARIA. Honest gap.

## Pattern cards (20)

| Card | One-liner | Default verdict |
|---|---|---|
| `dispatch-board-unassigned-queue.md` | Unassigned queue + multi-gesture assignment (drag, menu, multi-select), savable filter tabs | **RECOMMENDED** ★ |
| `batch-as-named-container.md` | Batch = named container, late-bound driver, derived per-member state rollup | **RECOMMENDED** ★ |
| `auto-suggest-human-finalize.md` | Suggest → edit → accept; "not scheduled + reasons"; lock finished work | **RECOMMENDED** ★ |
| `staged-replan-publish-changes.md` | Draft edits + graduated blast radius + atomic "Publish Changes"; scoped re-notify | **RECOMMENDED** ★ |
| `capacity-constraint-not-overfill.md` | Capacity enforced at the mutation; overflow visible with reasons | **RECOMMENDED** ★ |
| `flight-eta-derived-pickup.md` | Pickup = flight ETA + standing offset; self-healing plan | VIABLE (V2 — needs flight feed) |
| `flight-alert-taxonomy.md` | Named alert types, severity grades, ≥N-min noise thresholds, predicted-vs-official honesty | **RECOMMENDED** ★ |
| `attention-flags-exception-queue.md` | Flag overlay on cards + counted click-to-filter queue | **RECOMMENDED** ★ |
| `passenger-notification-ladder.md` | Booked → driver assigned (name/plate/ETA) → arriving → outcome; per-trip override | **RECOMMENDED** ★ |
| `live-tracking-link-no-app.md` | Time-boxed tokened web page; V1 = static trip details, V2 = live position | VIABLE |
| `driver-run-sheet-day-of.md` | Driver manifest via tokened link/print; accept gate; ordered statuses | **RECOMMENDED** ★ |
| `day-of-boarding-checkin.md` | Expected vs checked-in vs capacity per stop; tap/QR; boarded milestones notify | **RECOMMENDED** ★ |
| `no-show-guided-protocol.md` | Grace timer → attempted contact → reason → correctable record | **RECOMMENDED** ★ |
| `arrivals-rollup-board.md` | Pax totals per time+origin, pivot by vehicle/driver, cancellation toggle | **RECOMMENDED** ★ |
| `bulk-reassign-vehicle-swap.md` | Whole-run swap with pre-commit capacity checks | **RECOMMENDED** ★ |
| `status-integrity-guardrails.md` | Too-early blocks, escalating nags, gaming-proof metrics | VIABLE (V1: date-sanity checks only) |
| `driver-offer-accept-loop.md` | Offer/timeout/decline → next-best → loud exhaustion | AVOID for V1 (no driver accounts) |
| `recurring-batch-templates.md` | Templates, copy-forward, no retro-apply | VIABLE (V1: copy-batch-to-date) |
| `coordinator-guest-visibility.md` | Coordinator books, guest rides app-less, milestones to responsible party | VIABLE |
| `manifest-export-audience-toggles.md` | One manifest, audience presets (driver/ops/hotel), cancelled toggle | **RECOMMENDED** ★ |
| `first-principles-candidates.md` | 10 undocumented surfaces — design from scratch, several are our differentiators | (not a pattern — candidate list) |

## Rules reminder
Cards are CANDIDATES with evidence. Choices are founder DECs (project-side), citing card + rejected alternatives. `.planning/ux-patterns/` in the project is T0-locked; refreshing this library is a deliberate re-run, never mid-build improvisation (DEC-032).
