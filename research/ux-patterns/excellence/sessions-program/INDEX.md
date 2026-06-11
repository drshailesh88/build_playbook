# sessions-program (EXCELLENCE) — pattern index

EXCELLENCE-mode harvest 2026-06-11 for the EventState rebuild: the ceiling for
this module's three jobs-to-be-done, not fidelity to the old app. 3 parallel
agents (coordinator-scheduling / attendee-program / speaker-lifecycle), each
swept by-app / by-pattern / by-flow until dry. Raw notes with full step
sequences in `_raw/`. 56 cards; ★ = recommended default for our stack.

## Coverage

- **Queries run:** 47 total (16 coordinator, 16 attendee, 15 speaker) across
  search_flows + search_screens, web + iOS, deep mode. Per-mode query lists at
  the bottom of each `_raw/*.md`.
- **Reference apps NOT in Mobbin's corpus:** Sched, Sessionize, Whova, Notion
  Calendar (standalone), Fantastical, Google Calendar, Hopin, Reclaim,
  Airtable, Songkick. Best in-corpus stand-ins used: WWDC + Apple Store
  (conference agenda), 7shifts + Deputy (lane scheduling + publish), Clockwise
  (conflict resolution), Eventbrite + Luma (event programs), Calendly/Cal.com
  (commitment lifecycle).
- **First-principles candidates (Mobbin has no direct coverage — do not fake):**
  1. Room×time conference day grid (rooms as lanes for one day) — compose from
     `coordinator-resource-lanes` + `coordinator-drag-reschedule-feedback`.
  2. Schedule-native publish diff ("what changed since v3" at session level) —
     adapt `coordinator-publish-diff-adjacency` + `coordinator-draft-vs-published-encoding`.
  3. Multi-field "what changed" change notification (time AND room AND
     co-speaker) — compose from `speaker-change-diff-reconfirm`.
  4. Speaker/faculty portal with responsibility bundles — compose from
     `speaker-action-ownership-status` + `speaker-tristate-rsvp`.
  5. Selection-based bulk session edit (multi-select → action bar) — nothing
     observed anywhere; Booking.com is criteria-based only.
  6. Speaker double-booking conflict UX — transfer from Clockwise
     attendee-conflict + 7shifts employee-conflict.
  7. Speaker DIRECTORY page (browsable all-faculty index) — only individual
     profiles observed.
  8. Whole-agenda ICS export ("export my schedule") — only per-event choosers
     observed.
  9. CFP/talk-proposal submission (Sessionize absent).
  10. Web decline-then-changed-mind (only KakaoTalk iOS showed re-editable
      responses).
- **Excluded as off-job:** Whereby (video rooms), Deel (headcount), Discord
  stage, generic doc-version tools beyond the diff shape, fintech waitlists,
  Luma "Register to See Address" gating (belongs to events-landing surface).
- **Conflict/live-now conference evidence is TRANSFERRED** from shift/fitness/
  streaming apps — no conference app showed it natively; flagged on each card.

## Cards — coordinator builds the program

- ★ `coordinator-resource-lanes` — lanes per resource + per-lane unassigned row + hatched unavailability (7shifts, Deputy, Workable, Fresha). Raw material for the first-principles room×time grid.
- ★ `coordinator-drag-reschedule-feedback` — origin ghost, receipt toast, edge-resize (Motion, Amie, Skiff).
- ★ `coordinator-in-grid-composer` — click-slot popover / side panel, room as first-class field (Motion, Front, Skiff).
- ★ `coordinator-move-event-diff` — New vs ~~Original~~ + who is harmed, confirm-gated (Clockwise).
- ★ `coordinator-conflict-severity-split` — hard conflicts vs "inconveniences"; nothing changes until confirmed (Clockwise).
- ★ `coordinator-warning-pills-header` — ambient conflict counts next to Publish + "Fix warnings" (7shifts).
- ★ `coordinator-prepublish-triage` — categorized warning inventory w/ definitions before publish; auto-fix AVOID for V1 (7shifts).
- ★ `coordinator-quantified-publish-notify` — "Publish 11 shifts" + notify/require-confirmation/silent choice + state legend (Deputy).
- ★ `coordinator-draft-vs-published-encoding` — striped/grey unpublished chips, per-cell drift visibility (7shifts, Deputy).
- ★ `coordinator-publish-diff-adjacency` — review-changes diff + version description + restore; adapt, not adopt (ElevenLabs, Linear).
- ★ `coordinator-unscheduled-tray` — "Unscheduled {n}" parking lot at grid edge (Jobber, ClickUp).
- ★ `coordinator-scoped-clone` — copy-scope disclosure, draft landing, what-travels checkboxes (7shifts, Luma, incident.io).
- ★ `coordinator-lane-management` — drag-to-order halls with grid-consequence sentence; archive not delete (Deputy, 7shifts).
- ★ `coordinator-color-track-legend` — filter control IS the legend; never color alone (Amie, Deputy).
- ★ `coordinator-mobile-grid-adaptation` — Move/Copy verbs on touch; 1–3 day columns; next-up strip (TimeTree, Cron, Outlook).
- ★ `coordinator-preview-as-attendee` — render the real public view, device toggle, pre-publish (Eventbrite, User Interviews).
- `coordinator-multi-view-projections` — table/timeline/calendar projections of one dataset; keep two, not the engine (Notion).
- `coordinator-dirty-state-bar` — Discard/Save sticky bar; pick batched OR auto-save, never both (User Interviews, Jira).
- `coordinator-scheduling-guardrails` — max-per-day / min-notice constraints enforced at placement (User Interviews).
- `coordinator-slot-agenda-builder` — slot-by-slot on-ramp for small single-track events (Eventbrite).
- `coordinator-bulk-edit-criteria` — rule-based bulk edit; V2 shape (Booking.com).
- `coordinator-recurrence-grammar` — repeat grammar + computed "(2 events)" count; only if recurrence ships (Skiff, Cron, Posh).
- `coordinator-dependency-links` — AVOID for V1; parent/child nesting covers it (Linear).

## Cards — attendee consumes the program

- ★ `attendee-timezone-explicit-times` — every time carries its zone or the page declares the frame; non-negotiable given old-app scars (WWDC, Unity, Meetup, Zomato).
- ★ `attendee-time-grouped-agenda` — sticky time-group headers + "(+1 day)" cross-midnight (WWDC, Eventbrite).
- ★ `attendee-day-strip-filter-summary` — day strip + filter state always legible ("Filter (On)", "Filters · 20") (Apple, WWDC, Insight Timer, Peacock, Peloton).
- ★ `attendee-save-from-anywhere` — one-tap save on every row, everywhere the session appears (WWDC, DICE, Peloton, Bloom).
- ★ `attendee-favorites-first-home` — my-agenda first + time-aware empty copy; saved vs attended (WWDC, Bloom).
- ★ `attendee-add-to-calendar-chooser` — destination chooser w/ restatement; "Other calendar" ICS mandatory (Fresha, Open, Luma, Meetup, Eventbrite).
- ★ `attendee-session-detail-anatomy` — time/venue map/speaker chips/what-to-bring/a11y disclosure (Open, WWDC, Eventbrite, Front).
- ★ `attendee-speaker-profile-bidirectional` — "Guided by" block ↔ "More with {name}"; one-line credential (Ten Percent Happier, Open, Polywork).
- ★ `attendee-expand-in-place-rows` — public hub: search + facets + expand-in-place, "Who should attend" (Unity).
- ★ `attendee-empty-results-recovery` — empty states name the exact controls to change; chrome never disappears (Apple, ESPN, Klook, Turo).
- ★ `attendee-session-full-waitlist` — scarcity → full → waitlist → recovery actions; announced twice (Meetup, SeatGeek, Eventbrite).
- ★ `attendee-cancelled-stay-visible` — demote, never delete, from a personal schedule (Uber, GetYourGuide, Fixtured).
- ★ `attendee-soft-conflict-tag` — warn-don't-block for personal-agenda overlaps; transfer (TimeTree vs Calendly).
- ★ `attendee-live-now-indicators` — LIVE / "IN 1 HR" / "TODAY 8 PM" in one badge slot + now-line; day-of mode (Insight Timer, Peloton, Fixtured).
- `attendee-temporal-segments` — Live Now/Upcoming/Replay as top-level switch; relevant once recordings exist (ESPN, Unity, Peanut).
- `attendee-related-sessions` — related/other-occurrence rails; only with honest relatedness data (WWDC, Front, Apple).
- `attendee-remind-pill-state` — "remind me" → "you got it! ✓" in place; needs a delivery channel (Clubhouse, Peanut).
- `attendee-post-registration-card` — You're-In countdown/calendar/polite-exit chassis, shared with faculty confirm (Luma, Apple Store).

## Cards — speaker/faculty lifecycle

- ★ `speaker-tokened-invite-landing` — no-login accept/decline card swapping in place to confirmed state + undo (Luma).
- ★ `speaker-per-speaker-guest-link` — send via email OR copy link; single-use on the ACTION only (Vimeo, Calendly).
- ★ `speaker-token-sad-path-family` — distinct page per failure cause w/ recovery; Clay's dead end = anti-pattern (Supabase, Jitter, Linear, Squarespace).
- ★ `speaker-invite-lifecycle-console` — state tabs, expiry countdown column, bulk resend/revoke/extend, policy stated inline (Slack, 15Five, 1Password).
- ★ `speaker-invite-funnel-tracker` — sent/opened/accepted/declined rollup above the list (Luma).
- ★ `speaker-action-ownership-status` — "Need to sign" vs "Waiting for {name}"; spine of tracker AND portal (DocuSign, 1Password, Rise).
- ★ `speaker-decline-consequence-honesty` — consequence stated pre-commit, optional reason, annotated audit row (Navan, Calendly, Cal.com).
- ★ `speaker-change-diff-reconfirm` — Current/New diff + consequence + re-confirmation on every change; multi-field digest is first-principles (Tripadvisor, Booking.com, Airbnb).
- ★ `speaker-accept-completes-profile` — collect bio/photo at the accept moment (post-accept variant) (Substack).
- `speaker-tristate-rsvp` — keep faculty binary; steal re-editable-before-lock, pending-as-bucket, conditions gate (Partiful, Apple Invites, KakaoTalk, GroupMe).
- `speaker-reconfirmation-emails` — "are you still presenting?" nudge with one-click reconfirm (Calendly, Luma).
- `speaker-reschedule-as-request` — change as a pending consented object; speaker-initiated only (Cal.com, Airbnb).
- `speaker-attestation-confirm` — type-to-sign for formal speaker agreements; optional layer (Contra, DocuSign).
- `speaker-magic-link-interstitial` — resend/spam/wrong-email recovery kit; auth library owns the full version (Better Stack, Qatalog, Felt).
- `speaker-availability-poll` — slot voting for panel scheduling; per-person tokens, never open links (Calendly, SavvyCal, Zoom).
