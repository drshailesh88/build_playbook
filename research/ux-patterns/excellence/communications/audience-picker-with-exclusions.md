# Pattern: Audience picker — named cohorts, exclusion list, per-recipient sendability
**Surface:** audience-selection · **Observed in:** Mailchimp, Fresha, folk, Posh, GoDaddy (refs: [Mailchimp To-section](https://mobbin.com/flows/23d57674-555e-4c47-9981-b50bca0dc76c), [Fresha cohorts](https://mobbin.com/screens/e6b3ee02-cbee-45f9-9904-ab6aa9d5c107), [folk recipient rail](https://mobbin.com/flows/0f633d24-030d-4ae3-823f-a1e734b6245c), [Posh recipients](https://mobbin.com/screens/2bc41822-1a58-4f50-a392-6fc7b6031ae4))

## Flow
1. "Send to" select with grouped options: All subscribers / specific tags / pre-built segments / pasted emails (Mailchimp).
2. Separate "Do not send to (optional)" exclusion select — a segment or tag subtracted from the audience (Mailchimp).
3. Fresha variant for non-marketers: a radio list of NAMED COHORTS with plain-language descriptions ("New clients — added in the last 30 days", "Lapsed clients", "Clients by appointment date"), each editable in a small modal (time window, sub-filters, "Include clients with upcoming appointments" checkbox).
4. Per-recipient sendability is visible before send: folk's recipient rail greys rows with "No email address available" and the Send button count excludes them ("Review (12)" → "Send (10)"); Posh states "This SMS blast will be sent to the 3 attendees that you've selected" with avatar stack + "View & Edit Recipients".
5. Recipient-count reassurance near the CTA: "You will be sending to (1) unique contacts" (GoDaddy).

## Use when
Senders think in roles/cohorts, not query filters — conference ops ("all confirmed delegates", "faculty with sessions on day 2") matches Fresha's named-cohort shape exactly.

## Avoid when
Audience is always one person (transactional resend) — a picker implies choice that doesn't exist.

## Sad paths observed
- Missing contact info handled at selection time, not send time: greyed rows + reduced send count (folk) — failures are prevented, not logged.
- Exclusion list prevents the "everyone except speakers" workaround of exporting/re-importing lists (Mailchimp).

## Accessibility
Cohort radios carry full-text descriptions; greyed unsendable rows keep visible text explaining why.

## Default verdict for our stack
RECOMMENDED — named cohorts from people-module roles (delegates/faculty/ops) + exclusion select + folk-style sendability preview; the count-on-the-button is the cheapest trust win in the module.
