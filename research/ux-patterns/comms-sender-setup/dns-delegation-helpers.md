# Pattern: DNS Delegation Helpers (auto-configure + "email your IT team")
**Surface:** comms-sender-setup · **Observed in:** Resend, folk, Langdock, Loops (refs: [Resend auto-configure + provider detection](https://mobbin.com/screens/ee71c976-8c06-4610-b736-afbb27829f87), [folk Entri auto-configure](https://mobbin.com/screens/73ef8018-47b2-42c8-a6e6-4fd1dfd7eeed), [Langdock infra-team email](https://mobbin.com/screens/7f2c86d9-1575-49ca-9059-19b7278b0bcc), [Loops how-to-add-records](https://mobbin.com/screens/9427302f-0ce1-4393-95b1-11d4b05ee676))

## Flow
1. Detect the DNS provider and say so: Resend's domain page shows "Provider: Cloudflare" and links "Access the DNS settings page of Cloudflare" directly in the instruction banner.
2. Offer one-click setup where possible: "Auto configure" button (Resend), "Auto configure your domain with Entri" bar above the records table (folk) — manual table remains as fallback.
3. Offer delegation for users without DNS access: Langdock's Add-domain modal includes "Don't have access to DNS settings? Send this email to your infrastructure team" with a pre-written, copy-buttoned Subject and Body containing the exact TXT record and the expiry date of the token.
4. Keep a docs escape hatch next to the table: "How to add records" (Loops), "read documentation" (AutoSend).

## Use when
- Our buyers are event teams, not IT — the person in the app frequently does NOT control DNS; the prewritten-email handoff (Langdock) directly removes the biggest drop-off in domain setup.
- Provider detection is feasible (NS lookup) — naming "Cloudflare/GoDaddy" turns generic instructions into a guided step.

## Avoid when
- Embedding a third-party connect flow (Entri) you can't support — a broken auto-configure is worse than a clean manual table.
- The delegation email would contain secrets beyond DNS values; only record values and deadlines were observed in the template.

## Sad paths observed
- Langdock's TXT value carries an expiry ("expires on 29. Apr") surfaced in both the modal and the generated email — stale-token failure is pre-empted in copy.
- folk keeps Close vs "Verify domain" as separate actions, allowing exit-without-verifying with state preserved.

## Accessibility
- Every copyable artifact (record values, email subject, email body) has an explicit Copy button.
- Helper paths are visible inline options, not buried in support docs.

## Default verdict for our stack
RECOMMENDED — ship the manual table first, add the Langdock-style "email your IT team" generator early (cheap, high-impact for B2B events orgs); treat Entri-style auto-configure as a later enhancement.
