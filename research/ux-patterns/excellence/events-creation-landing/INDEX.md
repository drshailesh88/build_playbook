# events-creation-landing — Pattern Library Index (EXCELLENCE harvest)

**Harvested:** 2026-06-11 · **Job-to-be-done:** an organizer creates an event and gets a public landing page that converts visitors.

## Coverage
- **Modes swept:** by-app (Luma · Partiful · Eventbrite, web + iOS), by-pattern (12 families), by-flow (12 tasks) — raw evidence with per-query hit/dry logs in `_raw/{by-app,by-pattern,by-flow}.md`; every entry cites a mobbin_url.
- **Apps with recorded evidence (24):** Luma, Partiful, Eventbrite, Posh, Circle, Cal.com, Calendly, Apple Invites, Discord, WhatsApp, Peerspace, Locals, Lex, Square, Kajabi, Aboard, Amie, Skiff, Vimeo, Sana AI, Product Hunt, Twitch, X, Microsoft Teams (+ analogous: Notion, Later, SavvyCal, Gamma, Linktree, GetYourGuide).
- **Excluded by scope** (harvested under `excellence/registration-public/`): the registration/RSVP form itself, checkout/payment, post-registration confirmation/QR.
- **Known gaps (no precedent found — first-principles candidates):** attendee-facing date-changed banner on the landing page · purpose-built "unlist live event" flow · big-numeral pre-registration countdown · hour-by-hour conference agenda module · event-native AI cover generation (Luma query timed out, not retried).
- **Loop-until-dry honesty:** all three sweeps were bounded by context budget rather than strict 2-consecutive-dry exhaustion; per-file coverage notes list exactly what ran and what came up thin.

## Cards (★ = harvester's recommended default for EventState — candidates, NOT decisions)

### Creation
- ★ `defaults-first-instant-create.md` — every field defaulted, the form IS the page; one keystroke from a valid event (Luma, Posh)
- ★ `draft-first-lifecycle.md` — SAVE DRAFT primary, autosave pill, TBD-date honesty, visible Draft pills (Partiful, Circle, Eventbrite, Aboard)
- ★ `checklist-builder.md` — steps sidebar + WYSIWYG page sections merchandised with conversion stats; the shape for a publicPageSettings admin (Eventbrite, Partiful)
- ★ `location-mode-switch.md` — In Person / Virtual / TBA segmented modes, address autocomplete + map, separate arrival-instructions field, hide-location (Luma, Eventbrite, Circle)
- ★ `date-time-timezone-entry.md` — compact date card, city-name timezone typeahead, multi-day range with day-captioned times, display toggles (Luma, Eventbrite, Calendly)
- ★ `cover-image-system.md` — never-blank generated default, search-first picker, constraints up front, focus-point multi-crop, good/bad teaching modal (Luma, Eventbrite, Posh, Circle)
- `live-theming-knobs.md` — VIABLE: theme×color×font×display trays over the live page; contrast guardrails mandatory; tenant-curated set for V1 (Luma, Partiful, Posh + analogous)
- `ai-assisted-create.md` — VIABLE (V2): structured Q&A generator with opt-out; field-level "Suggest Description" first (Eventbrite, Luma, Partiful)

### Publish · share · lifecycle
- ★ `publish-review-gate.md` — distinct review step with rendered preview + readiness checklist + discoverability metadata; status always a visible control (Eventbrite, Aboard, Circle, Posh)
- ★ `post-publish-share-moment.md` — success screen IS distribution: short URL + Copy + QR + channels; embed widget; funnel stats beside the link (Luma, Partiful, Eventbrite, Posh)
- ★ `true-guest-preview.md` — preview as real state-switch with private-label banner + mobile frame (Partiful, Eventbrite, X)
- ★ `visibility-layers.md` — discovery / link access / password / content-gating as independent labeled layers; hidden ≠ deleted (Posh, Partiful, Luma, Circle, Cal.com, Vimeo)
- ★ `cancel-event-protocol.md` — notify-by-default with customizable message, reason shared, tombstone page, reschedule as symmetric verb with audit trail; cancel-as-delete is the named AVOID (Luma, Cal.com, Calendly, WhatsApp, Skiff)
- ★ `clone-and-recurrence.md` — copy matrix stated up front, bulk multi-date clone with receipt, natural-language recurrence summary with computed count (Luma, Posh, Partiful)
- ★ `capacity-waitlist-settings.md` — capacity as behavior ("auto-close registration"), waitlist policy machine, inline "Not supported with X" conflict surfacing, explicit add-directly bypass (Luma, Partiful, Eventbrite)

### Public landing page
- ★ `landing-page-anatomy.md` — two-column conversion grammar, state-swapping single page, agenda/good-to-know blocks, speakers-list hero for conferences (Luma, Eventbrite, Posh, Sana AI)
- ★ `social-proof-stack.md` — going-count + avatar stack, host/org trust block, earned badges; privacy-toggled for professional contexts (Luma, Eventbrite, Posh, Partiful)
- ★ `landing-logistics-block.md` — add-to-calendar menu, map + how-to-get-there, expectation chips, time-gated join, dual-TZ (Eventbrite, Luma, Partiful, Circle)
- ★ `landing-sad-states.md` — composable states: scarcity, approval, sold-out, closed-but-alive, cancelled tombstone, ENDED-with-afterlife, date-TBD, location-withheld (Luma, Posh, Cal.com, Eventbrite, X, Discord, Partiful)

### Organizer surfaces
- `organizer-dashboard-coach.md` — VIABLE: countdown hero, planner timeline, phase meter, funnel-in-list, poster wall vs table shapes (Eventbrite, Posh, Partiful, Luma, Circle)
- ★ `manage-on-page.md` — manager banner on the public URL + edit drawer over context; consumer host-dock is the named AVOID for multi-role SaaS (Luma, Partiful)
- ★ `organizer-identity-profile.md` — org profile entity feeding the "Organized by" trust block; identity chosen at create; contact-disclosure at entry (Eventbrite, Luma, Partiful, Posh)

## Project consumption
EventState surface choices live in `test_Gica/.planning/ux-patterns/excellence/EVENTS-CREATION-LANDING.WOW-DELTA.md` (22 ranked grill items). Choices become DECs citing these cards; pathways cite DEC + card. This library is frozen between deliberate re-harvests.
