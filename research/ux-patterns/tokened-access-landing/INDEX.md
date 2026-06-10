# tokened-access-landing — Pattern Index

## Coverage note
Sweep ran 2026-06-10 via Mobbin MCP until dry (final two queries returned nothing new).
- **by-app queries (7):** Luma guest RSVP confirmation · Calendly confirmation/cancel/reschedule · Partiful RSVP accept-decline · Eventbrite order/ticket download · Doodle poll respond (returned Calendly/Partiful/Teams/Skype instead) · Tito attendee details (ABSENT — name-matched only TikTok) · Hopin/Splash/RingCentral (ABSENT).
- **by-pattern queries (10):** magic link expired/invalid · check-your-email magic link sent · registration form dietary/attendee questions · retrieve booking ref+last name (web) · find my tickets/resend by email · personalized invite "not you" · declined RSVP change response · registration closed/sold-out/waitlist · certificate of attendance download · airline check-in retrieve booking (iOS; first attempt timed out, retried successfully).
- **by-flow queries (4):** RSVP to event invitation · view/download ticket QR from email link · complete attendee/passenger details · cancel registration/decline invitation.
- **Apps harvested:** Luma, Calendly, Partiful, Eventbrite, Posh, Tripadvisor, Kiwi.com, Trip.com, American Airlines, Scoot, Better Stack, Felt, Loops, Jitter, Qatalog, Fey, Grok, NordVPN, Podia, folk, Fresha, Asana, Google Classroom, Frame.io, Cake Equity, Udemy, Codecademy, Uxcel, Sana AI, Workable, Rise.
- **NOT found (no silent truncation):** Tito, Doodle, Hopin/Splash are not on Mobbin. No example of a reg#/phone identity-confirmation gate BEFORE a download (airline "find my booking" lookup form not captured even on iOS — only post-lookup passenger forms). No WhatsApp-delivered-link conventions. No verbatim "re-confirm after responsibilities changed" (closest analog: Calendly reschedule with struck-through former time). No expired-EVENT page beyond Posh "ticket sales are closed". No captured validation-error states on guest registration forms.

## Patterns (★ = recommended default for its sub-area)

### a) RSVP / confirm-participation landing
- ★ [named-invite-accept-decline-panel](named-invite-accept-decline-panel.md) — invite card names the recipient, Accept/Decline inline in event context (Luma)
- [youre-in-confirmation-state](youre-in-confirmation-state.md) — idempotent confirmed state: email echo, calendar add, self-serve cancel link (Luma, Calendly)
- [decline-and-reopen-state](decline-and-reopen-state.md) — confirm dialog → "You're Not Going" → "register again" reversal, host notified (Luma, Calendly, Workable, Rise)
- [tri-state-rsvp-inline-identity](tri-state-rsvp-inline-identity.md) — Going/Maybe/Can't-Go + name/phone capture for non-personal links (Partiful)
- ★ [reconfirm-change-via-same-link](reconfirm-change-via-same-link.md) — re-confirm variant: former commitment struck-through, "Update" verb, reason field (Calendly, Partiful)

### b) Magic-link / tokened landing conventions
- ★ [link-addressed-to-named-recipient](link-addressed-to-named-recipient.md) — "this link is for X" + adjacent not-you escape (Fresha, Asana, Jitter, Google Classroom, Frame.io, Cake Equity)
- [wrong-user-link-interstitial](wrong-user-link-interstitial.md) — session/token identity mismatch fork (Better Stack)
- [check-your-inbox-holding-page](check-your-inbox-holding-page.md) — bold address echo, resend, wrong-email escape (Better Stack, Felt, Loops, Jitter, Qatalog, Fey)

### c) Expired / reused / invalid token states
- ★ [expired-invalid-token-recovery-page](expired-invalid-token-recovery-page.md) — plain headline, "used already" wording, one-click re-request, support attempt-ID (Jitter, Grok, NordVPN, Podia, folk)

### d) Link-based form completion without account
- ★ [prefilled-identity-questions-only-form](prefilled-identity-questions-only-form.md) — token asserts identity, form asks only the unknowns (Luma, Partiful, Sana AI)
- [task-card-detail-completion-async-result](task-card-detail-completion-async-result.md) — per-section task cards, read-back confirm, "we have everything we need" + notify deadline (Kiwi.com, Trip.com, American Airlines, Scoot)
- [availability-poll-response-via-link](availability-poll-response-via-link.md) — vote on slots via shared link, counts visible, auto-update disclosure (Calendly, Partiful)

### e) Self-serve document / ticket / certificate download
- ★ [inline-ticket-qr-with-holder-identity](inline-ticket-qr-with-holder-identity.md) — in-page QR + holder name + manual-lookup number; page persists after sales close (Luma, Posh)
- [order-page-resend-and-redirect](order-page-resend-and-redirect.md) — sent-to echo, resend with scope warning, send-to-another-address, printed reference numbers (Eventbrite, Tripadvisor)
- ★ [certificate-page-preview-format-name-fix](certificate-page-preview-format-name-fix.md) — full preview, pdf/jpg choice, verification ID, self-serve name correction (Udemy, Codecademy, Uxcel)
