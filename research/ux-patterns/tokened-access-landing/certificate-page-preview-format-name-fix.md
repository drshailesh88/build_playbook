# Pattern: Certificate page — full preview, format choice, name-correction escape
**Surface:** tokened-access-landing · **Observed in:** Udemy (ref: https://mobbin.com/screens/486bca84-52f9-4f34-9692-500df457c08f), Codecademy (ref: https://mobbin.com/screens/93071642-c4dc-42ec-bd64-ff93afb7646e), Uxcel (ref: https://mobbin.com/screens/811a4fa6-865c-4a41-9385-b8995e326ba7)

## Flow
1. Certificate renders full-size in the page/modal exactly as the artifact will look (recipient name, course/event title, date, instructor signature).
2. Verification metadata on the artifact: certificate number, verification URL, reference number (Udemy); QR + credential ID (Uxcel: "ID: 0541VANBUFU"); sidebar shows "Certificate Recipient" and issuer context.
3. Download with format choice: popover "Choose the format — .jpg / .pdf" (Udemy); "Save as PDF" (Codecademy); "Download Certificate" (Uxcel).
4. Share actions sit beside download: Share, "Share on LinkedIn", "Add to Profile/LinkedIn".
5. Name-correction escape adjacent: "Update your certificate with your correct name or preferred language" (Udemy), "Edit Name" (Codecademy) — fix-then-regenerate without support.
6. Validity statement in plain text: "This certificate above verifies that Jane Doe successfully completed…" (Udemy); "Does not expire." (Uxcel).

## Use when
- Conference attendance/CME certificate via personal link: preview before download, PDF + image formats, printed verification ID so third parties can check authenticity.
- Name errors are common with bulk-imported delegates — the self-serve name fix is the highest-value element here.

## Avoid when
- If certificates are legally controlled documents where self-serve name edits are not allowed, replace "Edit Name" with "Request correction" routed to the organizer.
- Don't add LinkedIn-share for internal/private events.

## Sad paths observed
- Wrong-name-on-certificate handled as a first-class link, not a support ticket (Udemy, Codecademy).
- Verification text under the certificate explains exactly what the document asserts — pre-empts disputes.

## Accessibility
- The certificate is an image — the verifying sentence below it is the accessible text equivalent; keep it.
- Format choice popover must be keyboard-reachable; two explicit buttons beat a dropdown.

## Default verdict for our stack
RECOMMENDED — certificate download page = preview + pdf/jpg + verification ID + self-serve or request-based name correction, all reachable from the delegate's tokened link.
