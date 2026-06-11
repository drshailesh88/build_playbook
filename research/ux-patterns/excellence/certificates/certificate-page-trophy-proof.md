# Pattern: Certificate page = trophy + proof hub (one canonical URL)

**Surface:** certificates / recipient + public · **Observed in:** Udemy, Uxcel, Skillshare, Codecademy (refs: https://mobbin.com/screens/6f26edde-fdbb-4cbd-aace-e3161e09fe04, https://mobbin.com/screens/811a4fa6-865c-4a41-9385-b8995e326ba7, https://mobbin.com/screens/7d1055dd-affd-463a-b61c-f11d2f2bf1b7, https://mobbin.com/screens/93071642-c4dc-42ec-bd64-ff93afb7646e, https://mobbin.com/screens/7d5be8a2-c69a-4962-9a3d-6b33c92294ba)

## Flow
1. Full-bleed certificate render; the ARTIFACT ITSELF carries the proof trio: "Certificate no: UC-9582e423-…", "Certificate url: ude.my/UC-…", "Reference Number: 0004" (Udemy) / QR code + "ID: 854VANBUFU" + issue date (Uxcel) / tiny "CERTIFICATE ID" (Skillshare).
2. Action row under the artifact: Download (format choice ".jpg / .pdf" — Udemy), Share (popover: Facebook/Twitter/LinkedIn), "Share on LinkedIn" AND "Add to LinkedIn" as SEPARATE actions (Uxcel).
3. Right rail = trust block: "Issued to — Jane Doe — ✓ Credentials Verified", "This course certificate of completion was issued on May 7, 2024. **Does not expire.**" (Uxcel).
4. Plain-language verification footer a verifier can read: "This certificate above verifies that Jane Doe successfully completed the course … on 06/25/2023 as taught by … The certificate indicates the entire course was completed as validated by the student." (Udemy)
5. Self-serve correction link on the page: "Update your certificate with your correct name or preferred language." (Udemy)
6. Fully localized variant of the same page (Udemy Korean) — certificate language is a feature, ID/URL unchanged.

## Use when
Every issued certificate — the same URL serves recipient (download/share), employer (verify), and issuer (single source of truth).

## Avoid when
Credentials that must stay private (exam scores) — then the public URL needs an access decision first, not this open-by-default page.

## Sad paths observed
- Name-correction escape hatch directly on the page (Udemy/Codecademy) instead of a support ticket.
- Eligibility explained when no certificate exists: "No certificates for this course — Only paid, approved courses offer a certificate of completion." + "Got it" (Udemy iOS).

## Accessibility
Certificate is an image — the trust block and verification sentence must duplicate ALL artifact data as real text (they do, in every observed app).

## Default verdict for our stack
RECOMMENDED — legacy has a verify-token endpoint + delegate download page (external-links module, DEC-062) but no canonical per-certificate page unifying trophy + proof. The verification URL on the PDF should land HERE.
