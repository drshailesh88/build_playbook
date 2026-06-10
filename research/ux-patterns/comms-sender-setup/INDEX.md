# INDEX — comms-sender-setup

## Coverage note
Sweep: 6 search_screens queries (1 by-app-leaning, 4 by-pattern, 1 WhatsApp retry) + 1 search_flows query, platform web only. Stopped after two consecutive WhatsApp/SMS queries produced nothing usable (one empty result, one consumer-WhatsApp-Channels-only result) and the flows query returned only apps already captured. Apps swept: Resend, Loops, AutoSend, Customer.io, Mailchimp, Churnkey, folk, Intercom, GoDaddy, HubSpot, Pipedrive, Wix, beehiiv, Eventbrite, Front, Maze, Grok, Langdock, WhatsApp (consumer).
NOT found (honest gaps): (1) WhatsApp Business / Meta template approval states (pending/approved/rejected) — Mobbin web has NO Twilio, Interakt, WATI, or Meta Business Suite coverage; the only WhatsApp results are consumer Channels creation. This sub-area (e) must be designed from vendor docs/screenshots outside Mobbin. (2) SMS sender-ID registration UIs — none surfaced. (3) Postmark specifically — named in the brief but absent from results; Resend/AutoSend/Customer.io cover the identical pattern. (4) Test-send RESULT feedback (delivery confirmation after clicking Send Test) — modals were captured, post-send feedback was not. (5) Per-event sender display-name override UI — no app showed event/campaign-scoped sender overrides distinct from campaign-time sender pickers.

## Patterns
- ★ sender-identity-form.md — tenant senders roster (name/from/reply-to) + modal create + campaign-time picker (AutoSend, Pipedrive, HubSpot, Wix, GoDaddy, folk). ★ default for sub-area (a).
- ★ domain-dns-verification.md — add domain → purpose-grouped DNS records table → per-record status chips → re-check button → pending/verified/failed states (Resend, AutoSend, Loops, Churnkey, Customer.io, Grok). ★ default for sub-area (b).
- ★ dns-delegation-helpers.md — provider detection, auto-configure, prewritten "email your IT team" handoff (Resend, folk, Langdock, Loops). ★ companion default for sub-area (b) given non-technical event teams.
- email-code-domain-verification.md — Mailchimp's emailed-code domain verification staged before DNS authentication; viable fallback only.
- ★ send-test-email-modal.md — editor-header "Send test" → prefilled modal, [TEST] subject, simulated subscriber (Eventbrite, Mailchimp, beehiiv, Customer.io, Front, Churnkey, HubSpot). ★ default for sub-area (c).
- ★ sending-readiness-gates.md — review-hold banners, shared-vs-custom-domain choice cards, from-address rewrite disclosure, plan gates (Customer.io, Intercom, GoDaddy, HubSpot, Maze, Loops). ★ default for sub-area (d).
- Sub-area (e) WhatsApp/SMS: NO PATTERN CARD — nothing observed on Mobbin; see coverage note.
