# Pattern: Per-recipient delivery log — status taxonomy + event timeline + row-level resend

**Surface:** certificates / issuance-tracking · **Observed in:** Customer.io, Klaviyo, AutoSend, Resend, Luma, Docusign, Navan, Circle, ElevenLabs (refs: https://mobbin.com/screens/dc4b82d5-e361-499f-8bde-c52fd44308b2, https://mobbin.com/screens/9d192110-19db-4ba9-81df-dadbbca83cb1, https://mobbin.com/flows/9d10f1ae-8ab3-425b-993c-2d810a904be1, https://mobbin.com/flows/df02112c-50f5-4c3f-b149-71cf8724098b, https://mobbin.com/screens/50740c5b-cfba-47d6-8f87-3114eecced4d, https://mobbin.com/screens/95095b2b-c994-4362-8ba1-0decd846c413, https://mobbin.com/flows/47feff98-b19e-4e8f-a135-008d1959603e)

## Flow
1. KPI strip: REQUESTS / SUPPRESSED / SENT / DELIVERED 100% / BOUNCED 0% / SPAM REPORTS (AutoSend); status facets with counts (Klaviyo: Sent 3 / Opened 1 / Bounced 0 / Skipped 1).
2. Per-recipient rows with status chips — shared vocabulary: Sent / Delivered / Opened / Clicked / Bounced / Suppressed / Skipped.
3. Row expands to an event timeline with human-readable failure reasons: "Created → Sent 2 minutes later → Bounced 2 minutes later — Reason: No MX for topmailers.net" + **Resend** button (Customer.io); Resend's horizontal Sent → Delivered → Opened timeline with per-hop detail ("The recipient's mail server accepted the email…").
4. Bulk remediation: select rows → "Send a reminder" / "Revoke invites" bar (Navan); single-click resend from roster row (ElevenLabs, Docusign).
5. Resend confirmation coaches the next failure: "An invitation has been resent to Abigail. If they still don't see it, please ask them to check the spam folder." (Circle)

## Use when
Always after a bulk send — "did every delegate get their certificate?" must be answerable per person, with the fix one click away.

## Avoid when
Don't surface open/click tracking to RECIPIENTS or on the public page — it's an admin forensics tool; also skip engagement metrics where the channel can't report them (WhatsApp delivery ≠ email opens).

## Sad paths observed
- Bounce with stated reason; Suppressed/Skipped as first-class states (not lumped into "failed").
- Deliverability coaching: "Don't use 'no-reply'" insight (Resend).

## Accessibility
Status chips are text labels with counts; expandable rows need disclosure semantics.

## Default verdict for our stack
RECOMMENDED — legacy has resend-notification (census #24) but NO delivery-status surface at all; this is the single biggest admin-trust gap. Issued-certificates list gains a Delivery column + expandable event log + resend.

## Live-web corroboration (2026-06-11, issuer-side harvest — help-doc evidence)
The dedicated credential industry confirms AND extends: per-recipient status is a THREE-LAYER ladder (credential status × email delivery × engagement) — Certifier ships a 15-state taxonomy with the distinction "Email is not provided" vs "Email is not sent", filter operators incl. "is empty", bulk Export/Delete/Resend, and a "Recipient View" see-as-recipient button; "Added to LinkedIn profile" is tracked as a first-class engagement outcome (Certifier, Sertifier). Refs: `_raw/live-web-issuer-side.md`, summarized in `issuer-console-patterns` card.
