# Pattern: Work-email nudge / personal-email gate
**Surface:** sign-up · **Observed in:** Slack, Notion, Attio (refs: [Slack tip banner](https://mobbin.com/screens/c6f0ebdc-f3a3-4aa5-b07f-a4e6c07442e8), [Notion field hint](https://mobbin.com/screens/51a639f2-0755-4217-9314-b0ccf8d58f12), [Notion tip box](https://mobbin.com/screens/76afe9db-3899-4fb6-80e2-f06b007d37b6), [Attio hard block](https://mobbin.com/screens/8065014b-478d-4d7b-b838-b101e2b7273f))

## Flow
1. Email field is labeled "Work email" with helper copy explaining why: "Use an organization email to easily collaborate with teammates" (Notion).
2. Soft nudge tier: detection of a personal domain (gmail.com) triggers an inline tip, not a block — Slack's yellow banner "Using your work email (if you have one) will make it easier for teammates to join you" with a "Change" link; signup still proceeds.
3. Hard gate tier: Attio rejects public domains outright — red inline "Please retry with a company email" plus a side panel explaining the policy and a "Talk to sales" escape for those who can't comply.

## Use when
- Multi-tenant B2B where domain-based teammate discovery/auto-join is a growth loop (Slack's "let anyone with @domain join" depends on it).
- Soft tier: almost always safe for B2B.

## Avoid when
- Hard gate when meaningful customer segments legitimately use personal email (freelancers, small event agencies) — Attio's block requires a sales escape hatch you must staff.
- Consumer or mixed-audience products.

## Sad paths observed
- Attio: public-domain email → blocked with explanation panel + "Unable to use your company email? Talk to sales" ([ref](https://mobbin.com/screens/8065014b-478d-4d7b-b838-b101e2b7273f)).
- Slack: nudge is dismissable/ignorable; "Change" swaps the address without losing state.

## Accessibility
- Nudge banners are adjacent text blocks tied to the field, not toasts — persist until resolved and are read in document order.

## Default verdict for our stack
VIABLE — soft-nudge tier ("Work email" label + helper text) fits our B2B tenancy model; AVOID the Attio hard block since event organizers often run on personal/agency Gmail.
