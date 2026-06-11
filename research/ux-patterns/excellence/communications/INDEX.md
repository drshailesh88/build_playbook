# INDEX — communications (EXCELLENCE harvest, EventState rebuild)

Job-to-be-done framing: what does the best app in the world at "send templated, branded, multi-channel messages to event people, automate them off domain events, and prove delivery" feel like? Reference set: Loops, Customer.io, Mailchimp + everything the sweep surfaced.

## Coverage
- Queries run: 16 (5 flows-mode, 11 screens-mode), platform **web only**, 2026-06-11. Raw observations in `_raw/sweep-notes.md` (Q1–Q16, every claim ref'd to a Mobbin URL).
- Modes: by-app (Mailchimp, Customer.io, Loops), by-pattern (analytics, delivery log, automation builder, scheduling, segments, suppression, SMS compose, merge tags, confirm-send, template registry, non-opener resend), by-flow (campaign create ×3, metrics).
- Apps swept: Mailchimp, Customer.io, Loops, Klaviyo, HubSpot, AutoSend, Resend, GoDaddy, folk, Apollo, Pipedrive, Salesforce, Churnkey, Fresha, Eventbrite, Square, Wix, Shopify, Workable, Posh, Airtable, Attio, HoneyBook, Cal.com, Tines, Employment Hero, Clerk, Intercom, Outseta, Podia, OpenPhone, WhatsApp (consumer), Circle.
- Dry-stop: Q15 returned only refinements of catalogued patterns; Q16 returned nothing usable → stopped per loop-until-dry.
- NOT found / honest gaps: (1) **WhatsApp Business / WABA campaign tooling — ZERO on Mobbin** (verified again this sweep; matches `../../comms-sender-setup/INDEX.md`): template-approval states, 24h-session rules, WA broadcast composer must be designed first-principles from Meta/provider docs. (2) Campaign **calendar view** seen only as a Mailchimp tab toggle — not explored in depth. (3) **A/B test variations** (Customer.io sample-percentage slider, Klaviyo A/B tabs) observed and noted in `_raw` but NOT carded — judged out of conference-module scope; revisit if a growth use-case appears. (4) Conversion-goal step (Customer.io) observed, not carded — same reason. (5) Send-test modal and sender/domain readiness deliberately EXCLUDED — already carded in base library `comms-sender-setup/` (send-test-email-modal, sending-readiness-gates, domain-dns-verification). (6) No iOS sweep — admin tooling is web-first.

## Patterns (★ = harvester's recommended default — candidates, NOT decisions)
- ★ channel-split-ia — Campaigns vs event-triggered vs transactional named at IA level (Loops, Customer.io, HubSpot, AutoSend)
- ★ broadcast-composer-checklist — single-page sections w/ per-row completion + disabled send (Mailchimp, GoDaddy) — ★ for our compose surface
- broadcast-composer-stepper — Recipients→Goal→Content→Review wizard w/ blocking review (Customer.io, Loops, Fresha, Wix) — viable alternative; steal "Metrics as final stage" regardless
- ★ audience-picker-with-exclusions — named cohorts + do-not-send-to + per-recipient sendability + count-on-button (Mailchimp, Fresha, folk, Posh, GoDaddy)
- segment-builder-live-count-preview — condition rows + live count + matching-people table (Loops, Salesforce, Churnkey, Mailchimp) — V2-leaning; named cohorts first
- ★ pre-send-review-and-confirm — key-value review + "about to send to N" + 2-min buffer + post-send closure (AutoSend, Mailchimp, Eventbrite, GoDaddy, Shopify, Square, Wix)
- ★ schedule-send-controls — now/later, explicit timezone question, relative presets, batch delivery, finalize-recipients-at-send-time (HubSpot, Mailchimp, Klaviyo, Apollo, Loops, Square)
- ★ relative-event-time-automation — "[24] [hours] before event starts → send template to attendees" form (Cal.com) — ★ for event_reminder
- ★ template-editor-sample-data-preview — real-person sample data rail + live render + problems/links/accessibility lint (Customer.io, Apollo, AutoSend)
- ★ variable-tokens-and-fallbacks — `{` autocomplete / token chips / merge-tag menu + per-template missing-variable policy (AutoSend, Posh, Customer.io, Mailchimp, Apollo)
- ★ system-template-registry — event-keyed table w/ plain-language trigger, recipient, Default-vs-Edited badge, version history, email/WhatsApp tabs (Employment Hero, Clerk, HubSpot, Intercom)
- ★ automation-builder-test-before-activate — trigger→action stack, guard-condition rows, test-with-real-record, draft-until-published, misconfig badges (Airtable, Attio, HubSpot, Klaviyo, HoneyBook) — form-first variant ★; drag canvas AVOID for v1
- ★ delivery-log-expandable-timeline — status taxonomy incl. Suppressed, expandable plain-language timeline + bounce reason + inline resend, auto-refresh, funnel strip, CSV (Customer.io, AutoSend)
- ★ message-detail-event-timeline — per-send hop timeline + stored-content tabs + copyable provider ID (Resend, AutoSend, folk)
- ★ campaign-metrics-funnel-cards — stat cards w/ denominators, outcome tabs incl. Unopened, engagement chart, metric-honesty copy (Mailchimp, Klaviyo, HubSpot, Pipedrive, GoDaddy, folk, Loops)
- deliverability-health-monitor — health badges, benchmarks, sender score, volume breakdown (Klaviyo, HubSpot) — V2
- ★ suppression-management — reason-split tabs + consequence copy + suppressed≠failed (AutoSend, HubSpot, Podia) — scoped to broadcast-class sends
- ★ sms-compose-phone-preview — char budget + token chips + phone-frame sample-data preview (Posh) — ★ transferable shape for WhatsApp compose; WABA specifics first-principles
- send-throttles-frequency-caps — skip-recently-messaged, batch delivery, visible quotas, 2-min buffer (Klaviyo, Mailchimp, Eventbrite, GoDaddy, AutoSend) — viable; needs operational-class exemption
- resend-to-non-openers — review-page toggle + outcome-tab re-targeting + stop-if-replies (Square, Pipedrive, folk) — V2-leaning; v1 floor = Unopened outcome tab
- ★ campaign-list-inline-metrics — status badges + red failed count inline + continue-editing drafts + clone (Customer.io, Mailchimp, Loops, GoDaddy, folk)

Composition note: the ★ set composes into one coherent module — hub (channel-split-ia + campaign-list-inline-metrics + metrics cards) → compose (checklist composer + audience picker + schedule + review/confirm) → templates (registry + editor + tokens) → triggers (form builder + relative-event-time + test) → observability (delivery log + message detail + suppressions).
