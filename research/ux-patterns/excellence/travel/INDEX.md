# Pattern Index — Travel / Itinerary Management (EXCELLENCE harvest)

**Harvested:** 2026-06-11 · **Mode:** EXCELLENCE (ceiling, not fidelity) · **Source:** Mobbin MCP (flows + screens, iOS + web)
**Job-to-be-done:** enter/track people's travel itineraries → keep them current as reality changes → notify traveler + downstream ops on change → give ops a who-lands-when picture at scale.

## Coverage
- **Apps swept (by-app):** Flighty (deep), Navan, TravelPerk, KAYAK / KAYAK for Business, Wanderlog, Tripsy, Qantas, American Airlines, Singapore Airlines, Air NZ, Expedia, Kiwi.com, Booking.com, Trip.com, GetYourGuide, The Weather Channel, Turo (adjacent), Pangea/Vrbo/Viator/Airbnb (skimmed, low yield).
- **Modes:** by-app, by-pattern, by-flow — all three run; stopped when the manifest query came back fully dry and later rounds yielded only peripheral additions.
- **NOT swept / dry (honesty):**
  - **TripIt, App in the Air not indexed on Mobbin** — their DNA harvested via Wanderlog/Tripsy/KAYAK Trips (noted per card).
  - **Day-of arrivals/departures ops manifest: DRY on Mobbin** → first-principles sketch in `traveler-manifest-report.md`.
  - **WhatsApp itinerary delivery UX: not harvestable** → first-principles (EventState origin-doc binds the channel).
  - **CSV import wizard: deliberately excluded** — EventState binds the import-wizard contract (PATH-onboarding-import-007/008); travel rides it (PATH-travel-008).
  - Accommodation/hotel booking UX excluded (separate module).
- Raw citations: `_raw/sweep-notes.md`.

## Cards (recommended default marked ★)

| Card | One-liner | Verdict |
|---|---|---|
| ★ `countdown-first-flight-list.md` | Sort by time-until-departure; big countdown left rail that compresses (days→hours→minutes) | RECOMMENDED |
| ★ `flight-status-color-language.md` | Green/red times + explicit "26m late" deltas; struck-through old times; "--" for unknowns | RECOMMENDED |
| ★ `live-flight-card.md` | One-glance segment card: codes/times/progress + "the one thing that matters now" banner | RECOMMENDED (grammar; live data optional) |
| ★ `flight-updates-audit-feed.md` | "25 updates for this flight" — timestamped per-record change history on the detail page | RECOMMENDED |
| ★ `plain-language-change-notification.md` | "Your flight now leaves 10 minutes later at 11:20 AM" — consequence-first copy + per-type action | RECOMMENDED |
| ★ `add-flight-by-number-or-route.md` | Flight-number/route+date lookup auto-fills the record; manual stays as fallback | RECOMMENDED |
| ★ `trip-timeline-day-grouped.md` | Day-grouped chronological journey per person; gaps become suggestions | RECOMMENDED |
| ★ `booking-detail-page.md` | Record home: ref header + segment timeline + actions rail (resend email, PDF, calendar) | RECOMMENDED |
| ★ `cancel-with-rules-disclosure.md` | Consequences + live deadline disclosed before the destructive verb; reason captured | RECOMMENDED |
| ★ `share-live-itinerary-link.md` | Tokened live link, no login; consent disclosure (what is/isn't shared); revocable | RECOMMENDED |
| ★ `document-wallet-attachments.md` | Real uploads with inline preview + copyable confirmation #; wallet-grade pass | RECOMMENDED (upgrade from single URL) |
| ★ `group-event-travel-hub.md` | Event roster coverage: "0/2 booked" progress, est-vs-actual cost, setup checklist | RECOMMENDED (as header strip) |
| ★ `traveler-manifest-report.md` | Who-lands-when report grouped by date/airport — **first-principles candidate (Mobbin dry)** | RECOMMENDED (build) |
| `trips-status-tabs.md` | Lifecycle tabs with counts (Now/Upcoming/Drafts/Past/Canceled) + "Only my" filter | VIABLE |
| `alert-tier-preferences.md` | Alert tiers with scope text; sample push before permission ask | VIABLE |
| `on-behalf-booking-mode.md` | Persistent "acting on behalf of X" banner + Exit mode | VIABLE (RECOMMENDED if delegate self-view ships) |
| `proactive-context-microcopy.md` | "+1 day", timezone translation, codeshare "operated as", check-in window countdowns | VIABLE |
| `forward-email-import.md` | Forward confirmation email to per-account address; parse, don't transcribe | VIABLE (V2-shaped infra) |
| `travel-policy-inline-guardrails.md` | Inline policy panel + "In policy" badges + approval queue | AVOID V1 / VIABLE V2 |

## Library rule reminders
Cards are CANDIDATES. Project choices are DECs made by the founder; pathways cite DEC + card. This index never makes the choice.
