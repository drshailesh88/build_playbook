# Transport — FIRST-PRINCIPLES candidates (no documented source found; do NOT attribute to any app)

Consolidated from all three sweep modes (`_raw/by-app.md` FP1–FP5, `_raw/by-pattern.md` §FP 1–5, `_raw/by-flow.md` §FP 1–7), deduplicated. Each appears industry-plausible but **no vendor documentation was found this harvest** — these are design-from-scratch surfaces, which also makes several of them differentiators.

1. **Live roll-up arrivals wallboard.** Tourplan/GlobalWare prove time+origin pax totals as generated REPORTS; a live, auto-refreshing arrivals board with count tiles per time window is undocumented. (Feeds PATH-transport-003 — the report shape is sourced, the live screen is ours to design.)
2. **Manual over-capacity hard block with explicit override.** Optimizers refuse to overfill and review screens warn, but no doc shows a manual drag-assign hard-blocked with an "override anyway" confirmation. (Feeds capacity-constraint card; aligns with humans-finalize doctrine — block + deliberate override + audit.)
3. **Attendee-travel-record clustering into suggested batches with an explicit approve step.** Route optimizers prove review-then-accept for stops; miMeetings asserts (marketing-grade) manifest→validate→group for events; the suggestion-card approval UI over passenger clusters is undocumented. This is EventState's core differentiator (PATH-transport-007) — including stale-proposal detection, which nobody documents at all.
4. **Headcount reconcile-then-depart decision.** Expected vs checked-in vs capacity per stop is documented (Moovs Shuttle); the "2 missing — hold or depart?" decision flow with a who's-missing list is not.
5. **Dispatcher-side no-show countdown + structured attempted-contact log.** Grace policies and driver wait timers are documented; the ops-facing countdown with a logged contact-attempt checklist is not.
6. **Flight-CANCELLATION (vs delay) re-planning flow.** Delay/ETA flows are richly documented; passenger-removed-from-batch + flagged-for-replan on cancellation is not. (Our travel-cascade red flags already define the data; the UI is first-principles.)
7. **Per-passenger "resend pickup details" action.** Notification setup/cadence is documented; a one-passenger resend button is not. (Done-spec #33 requires resendable pickup notifications.)
8. **Per-passenger tap-to-board manifest.** Trip-level "Passenger on Board" and count-based boarding are documented; tapping individual names on a manifest to mark boarded is not explicitly.
9. **Batch-level readiness state machine.** Per-trip/per-route states are universal; a named batch gate (ready = vehicles assigned AND passengers assigned AND notified) is undocumented — compose from Route-Plan containers + publish gates.
10. **Per-batch WhatsApp group-pickup templates.** WhatsApp as a channel is documented only as a single mention (SAS, 1h before pickup); batch/group WhatsApp workflows in a dispatch product are not.

**Convention note:** per the harvest convention these are flagged candidates, not patterns — any of them entering scope is a founder DEC with first-principles design, not a "steal".
