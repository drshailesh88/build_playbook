# Pattern: Issuer console — the credential-platform admin patterns (Mobbin-absent industry)

**Surface:** certificates / issuer-admin · **Observed in (LIVE WEB, help-docs + product pages — evidence class per item):** Sertifier, Certifier, Accredible, Certopus, CertifyMe, Virtualbadge, Hyperstack (refs: full per-platform notes with URLs and evidence-class tags in `_raw/live-web-issuer-side.md`)

EVIDENCE CLASS: help-doc/screenshot level (capability + labeled-UI evidence), NOT click-through interaction evidence — no interactive demos exist for any of these platforms. Stronger than vendor marketing, weaker than Mobbin flows. Items below recur across 2+ platforms unless noted.

## The recurring issuer-console anatomy (7 platforms)
1. **Spreadsheet-first import:** downloadable pre-built CSV template + column→attribute mapping + skip-column affordance (7/7 platforms). Accredible is the standout: 100k rows, 5 queued uploads, errors-block/warnings-flow-through with "Exclude records with warnings" opt-out, grouped error messages with totals, and an error-only CSV export that preserves column order with a message column appended.
2. **Two-stage issuance:** create/draft → review → publish. Accredible "Create, but don't publish" + "View Unpublished Credentials"; Certifier Draft status; Hyperstack Generate → "Under Review" → publish; Certopus publish toggle.
3. **Issue-time options:** send immediately / "Schedule for Later" / send-email-or-silent / "Send a Test Credential" (Sertifier).
4. **Three-layer per-recipient status ladder:** credential status × email delivery × engagement, tracked separately — Certifier's full 15-state taxonomy including the precise distinction "Email is not provided" vs "Email is not sent", filter operators incl. "is empty", bulk Export/Delete/Resend, a "Recipient View" button (see-as-recipient), and recipient-initiated "Change Request"s landing in the console.
5. **"Added to LinkedIn" tracked as a first-class engagement outcome** (Certifier, Sertifier).
6. **Re-upload conflict strategy dialog:** Sertifier's 6-option update-strategy chooser on re-import (e.g. "Update this campaign + set defaults for future").
7. **GDPR consent at import:** "Confirm that you have permission to use the personal data" checkbox (Certifier) — directly relevant to medical-conference data handling.
8. **Expiry machinery:** expired page stays reachable with a persistent banner + automated reminder emails (Sertifier: up to 3; Certifier: 2-weeks-before + post-expiry, plus recipient-side "Contact Issuer" one-click renewal request).
9. **Revoke ≠ delete doctrine:** Hyperstack ships reversible Suspend/Unsuspend (no reason field); Credly guidance: revoking "leaves a record", tell the earner why; Sertifier/Certifier hard-delete kills links (the anti-pattern). **No platform shows a structured revocation reason to verifiers — confirmed industry white-space; EventState's reason-capture (census #20) remains ahead of the field.**
10. **White-label is THE premium lever:** custom credential domain via CNAME, custom SMTP sender, attribution removal (Sertifier Pro+, Certifier $99/mo domain add-on + $19/mo "Verified Issuer", Hyperstack premium) — what this industry charges for is exactly what EventState's tenant brand kit gives every org.
11. **Issuer profile as SEO-public showcase:** Sertifier issuer page with Credentials/Collections/Recipient directories and per-item visibility toggles.

## Use when
Designing any certificates admin surface — this is what the dedicated industry converged on; deviations should be deliberate.

## Avoid when
Don't copy the hard-delete (link-killing) behavior; don't gate core trust features (verification, issuer-verified chip) behind paid tiers for tenants — that's the industry's monetization shape, not a UX virtue.

## Sad paths observed (help-doc level)
- Import: error/warning triage with downloadable error-only file (Accredible).
- "only newly added recipients will receive the email" on re-send after list edit (Virtualbadge) — re-send scoping stated explicitly.

## Accessibility
Unknown at this evidence class — interaction-level details unverified.

## Default verdict for our stack
RECOMMENDED as the corroborating evidence layer for cards already in this library (csv-import-remediation, deliberate-issue-preview, delivery-log-resend, test-send-sample-data, expiry-reminders-routing, revoke-reversible-segregated, brand-kit-propagation) — each now has industry-native confirmation, cited here once.
