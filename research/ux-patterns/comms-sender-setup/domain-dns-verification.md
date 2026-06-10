# Pattern: Add Domain → DNS Records Table → Verify → Per-Record Status Lifecycle
**Surface:** comms-sender-setup · **Observed in:** Resend, AutoSend, Loops, Churnkey, Customer.io, Grok (refs: [Resend not-started](https://mobbin.com/screens/ee71c976-8c06-4610-b736-afbb27829f87), [Resend pending + timeline](https://mobbin.com/screens/6f41111b-5a31-4d83-a3fa-ec3f2064a957), [AutoSend mixed pending/verified](https://mobbin.com/screens/bb3e5124-d099-46c2-881a-2e0037cef8ac), [AutoSend all verified](https://mobbin.com/screens/73dac168-688d-4801-b8cb-ac8259e20381), [AutoSend records-not-found](https://mobbin.com/screens/2c9c4317-dfc7-4957-a9ca-79169ad9bc97), [Loops records-not-found / partially-correct](https://mobbin.com/screens/9427302f-0ce1-4393-95b1-11d4b05ee676), [Loops fully verified](https://mobbin.com/screens/455556f9-d2d3-4058-8b2d-3cc2315bdd1d), [Churnkey flow](https://mobbin.com/flows/fbe03c4b-8b33-493c-9e47-82d55560a7e6), [Customer.io flow](https://mobbin.com/flows/921e1c22-3da1-45f5-b215-b2ebefdb2c6a), [Grok TXT ownership](https://mobbin.com/screens/51b04f49-d28b-49fd-b99f-5832b0cd99aa))

## Flow
1. Add domain: a single input + button ("Add Sender Domain → Begin Domain Verification", Churnkey; "Add Sending Domain", Customer.io); success toast "Sender Domain Added".
2. Domain detail page shows a header status chip (Not Started / Pending / Unverified / Verified — Resend, AutoSend) and a DNS records TABLE: Type · Name/Host · Content/Value · TTL · Priority · per-record Status chip, every value with a copy button.
3. Records are grouped by PURPOSE with plain-language captions — Loops: "MX Records — used for email delivery", "SPF & DMARC — used for email routing and error reporting", "DKIM — used for signing emails"; Resend splits "Domain Verification (DKIM)" from an "Enable Sending (SPF)" toggle section.
4. A re-check button drives the loop: "Verify DNS Records" / "CHECK VERIFICATION" / "REFRESH", paired with propagation copy ("DNS propagation can take anywhere from a few minutes to a few hours, depending on your provider").
5. States resolve per record, not just per domain — AutoSend shows VERIFIED and PENDING chips mixed in one table with banner "Domain ownership verified. Configuration pending."
6. Resend adds a domain-events TIMELINE (Domain added → DNS verified → Verifying domain, each timestamped) above the table; Customer.io's verified state collapses records into four checkmarked rows (MX ✓ SPF ✓ DKIM ✓ DMARC ✓) with "Show records" expanders.

## Use when
- Tenant-level custom sending domain setup — this exact table+chip+recheck loop is the industry-converged shape; founders' DNS admins recognize it instantly.
- Per-record states matter (SPF correct, DKIM missing) — group-level "Partially correct" (Loops) tells the user WHICH record to fix.

## Avoid when
- Verification is instant/owned by the platform (subdomain delegation) — a records table for records the user never touches is noise.
- You cannot poll DNS server-side; the pattern's promise is "click verify, we check" — without that, fall back to Mailchimp's email-code pattern (separate card).

## Sad paths observed
- Failure state: red "No DNS records found. Please add the DNS records below to verify domain ownership." (AutoSend); "Records not found" / "Partially correct" per group in red/amber (Loops).
- Retry guidance instead of dead ends: "If you have already entered your records, try checking again in a few minutes." (Loops); Grok toasts "Success — We initiated the verification process… may take up to 24 hours. Please check back later."
- Customer.io exposes the infra consequence on the same page: "Shared IP Pool - Default — emails sent from this domain will be sent over a shared IP pool" with dedicated-IP upsell — verified ≠ done.

## Accessibility
- Status chips pair COLOR with TEXT (PENDING/VERIFIED words, not dots alone) in every observed app.
- Copy buttons per cell avoid forcing manual selection of long DKIM values; record purposes are explained in adjacent text, not tooltips only.

## Default verdict for our stack
RECOMMENDED — Resend/AutoSend-style domain detail page (header chip, purpose-grouped records table, per-record chips, re-check button, propagation copy) is the default for our tenant domain-auth surface.
