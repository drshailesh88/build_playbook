# Transport — Excellence pattern library INDEX

**Module job:** conference ops moves attendees between hubs (airport/station ↔ hotel ↔ venue) in batches: plan from travel data, assign vehicles/passengers under capacity, dispatch drivers, run day-of boarding, react to flight changes, notify passengers/drivers, roll-up counts for planning.
**Harvested:** 2026-06-11 · for EventState rebuild (test_Gica), reusable cross-project.

## COVERAGE NOTE — read before trusting

- **Mobbin MCP was UNAVAILABLE this session** (server configured globally but failed to connect; no tools loaded). Per the harvest brief, transport is thin on Mobbin anyway; the sweep ran on **WebSearch/WebFetch over vendor documentation** (help centers, API docs, official guides). Every raw entry cites a URL; behaviors are recorded as documented, never inferred. **A deliberate Mobbin re-sweep can be layered on later** — it would add visual/screen-level evidence (layouts, exact screens) that doc-based harvesting cannot.
- **Swept (3 modes, each looped until 2 consecutive dry queries):** by-app (`_raw/by-app.md`, 45 entries, 30 queries), by-pattern (`_raw/by-pattern.md`, 15 patterns, 36 queries), by-flow (`_raw/by-flow.md`, 37 flows, 48 queries). Apps covered: Onfleet (incl. full API docs), Limo Anywhere, Moovs, Routific, Circuit/Spoke, OptimoRoute, Tookan, Bringg, Track-POD, Route4Me, Motive, Flighty, FlightAware, TripShot, Via (thin — marketing only), Uber Central/Reserve, Zūm, HopSkipDrive, Welcome Pickups, Blacklane, Hoppa/SAS, Tourplan NX, Travelport GlobalWare, Booking Tool, miMeetings (events vertical), Azavista (events vertical), RideCo, Samsara, ADA-paratransit practice (DREDF).
- **Not swept / unreachable:** Onfleet+FlightAware+OptimoRoute Zendesk help centers block fetches (403 — behaviors recorded from search excerpts of the named articles, flagged inline); Via has no public help center; TripShot support portal not public (official PDF guide used); miMeetings site has SSL errors. Samsara/Motive covered only where surfaced by pattern queries, not walked app-by-app. No screen-level visual evidence anywhere (doc-based harvest).
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
