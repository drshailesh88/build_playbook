# Pattern: Checklist composer — single page, per-section completion, send disabled until ready
**Surface:** broadcast-compose · **Observed in:** Mailchimp, GoDaddy (refs: [Mailchimp creating-an-email flow](https://mobbin.com/flows/23d57674-555e-4c47-9981-b50bca0dc76c), [Mailchimp confirm](https://mobbin.com/screens/719b47ce-4325-4a12-b475-8d5fecc86fee), [GoDaddy composer](https://mobbin.com/flows/12958bcb-5169-4a19-927d-e30b7eb57fd4))

## Flow
1. One page of stacked sections — To / From / Subject / Send time / Content — each row gets a green checkmark when complete and an "Edit recipients/from/subject/send time/design" button.
2. Page header narrates progress: "Keep it up!" → "You're almost finished!" → "Your email is ready to send!" + Draft badge.
3. Send/Schedule button stays disabled until every section is checked; "Finish later" saves the draft and exits.
4. Right column holds a live preview (skeleton placeholder until content is designed).
5. GoDaddy variant: same idea as a right-rail accordion of sections, each flagged red (⚠) until valid, with an inline error ("Please add at least one email address") and a disabled "Send now".

## Use when
Sections are independent and order-free; users hop around and resume drafts — the checklist tells them exactly what is missing at all times.

## Avoid when
Later choices depend on earlier ones (audience determines available variables, channel determines editor) — a stepper sequences dependencies better.

## Sad paths observed
- Incomplete section = greyed Send + per-section red flags; the page itself is the error summary (Mailchimp, GoDaddy).
- Draft state is explicit (Draft badge + "Finish later"), so abandonment is safe by default.

## Accessibility
Per-section buttons are real buttons with visible labels; completion is shown by icon + text state, not color alone (Mailchimp pairs checkmark with section summary text).

## Default verdict for our stack
RECOMMENDED for the broadcast/manual-compose surface — pairs naturally with our template+audience model and gives a free "what's missing" UX for the send gate.
