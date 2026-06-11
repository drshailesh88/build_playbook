# Excellence Pattern Library — Certificates / Credentials

**Job-to-be-done:** design a certificate/credential template → issue at scale → recipient receives/downloads/shares → anyone verifies authenticity → admin manages lifecycle (revoke/reissue/expire).
**Harvested:** 2026-06-11 · Mobbin MCP, three modes (by-app / by-pattern / by-flow), each looped until dry (2 consecutive queries with nothing new). Raw observations with full step sequences in `_raw/`.

## Coverage honesty

- **Swept:** Canva, Udemy, Uxcel, Skillshare, Codecademy, Coursera, LinkedIn, Upwork×Credly, Teachable, Deel, Kajabi, Podia, Cake Equity + ~50 adjacent apps (Docusign, Attio, Klaviyo, Customer.io, AutoSend, Resend, PandaDoc, Twingate, 7shifts, Apple Wallet…). Platforms: web + iOS.
- **Absent from Mobbin (zero corpus presence):** Accredible, Sertifier, Certopus, CertifyMe, Credly (issuer side), Canvas Badges — the dedicated credential-platform admin UX has NO direct coverage; issuer-side cards are built from cited adjacents.
- **Not observed anywhere (first-principles candidates, flagged on cards):** dedicated public verification portal (enter-ID → valid/revoked verdict); revoke-with-REASON capture; what a revoked credential looks like to a verifier; credential expiry renewal journeys; certificate-as-wallet-pass end-to-end.
- **Not swept:** Android/Google Wallet; pagination page 2+ on Canva/LinkedIn queries; email-client rendering of issuance emails; print-production; blockchain credentials; issuer-permission/SSO gating.
- Minor raw-only observations not carded: Canva export panel ("Suggested" format badge, "If your download hasn't started, click here"), Canva three-tier share links ("Anyone with the link… No sign in required"), LinkedIn Skill Assessments badge catalog — see `_raw/by-app.md`, `_raw/by-pattern.md`.

## Cards (★ = recommended default for EventState)

### Template design
| Card | One-liner | Verdict |
|---|---|---|
| ★ [parametric-certificate-editor](parametric-certificate-editor.md) | Form rail + live sample-data preview (Teachable/Deel) — non-designers, zero layout defects | RECOMMENDED (default path) |
| [field-palette-merge-editor](field-palette-merge-editor.md) | Canvas + field palette + merge chips + fallbacks (Docusign/Ditto) — the pdfme class | VIABLE (advanced mode) |
| ★ [template-gallery-start](template-gallery-start.md) | Start-from-template gallery; never open a blank canvas | RECOMMENDED |
| ★ [brand-kit-propagation](brand-kit-propagation.md) | Org-level logo/colors/fonts propagate to every artifact; template locks | RECOMMENDED (org-level) |
| ★ [template-lifecycle-metadata](template-lifecycle-metadata.md) | Status/validity/issuing-authority metadata; "Issued N times"; one-active rule stated in words | RECOMMENDED |
| [template-version-history](template-version-history.md) | History + restore as the bad-edit undo | VIABLE (V2) |
| ★ [empty-state-primary-action](empty-state-primary-action.md) | Zero-state teaches the object + one CTA | RECOMMENDED |

### Issuance
| Card | One-liner | Verdict |
|---|---|---|
| [bulk-merge-generate](bulk-merge-generate.md) | Canva bulk create: visible element↔field binding, count-in-CTA | VIABLE (steal interactions) |
| ★ [csv-import-remediation](csv-import-remediation.md) | Import wizard: auto-map counts, row-level fixes, dedupe policy, pre-flight tiles | RECOMMENDED (custom lists) |
| ★ [deliberate-issue-preview](deliberate-issue-preview.md) | Generated preview + review checkpoint + notify-toggle before commit | RECOMMENDED |
| ★ [test-send-sample-data](test-send-sample-data.md) | "Send test certificate to myself" with real merge data before the batch | RECOMMENDED |
| ★ [bulk-job-progress](bulk-job-progress.md) | Aggregate % + per-item status + failure isolation + stated navigation contract | RECOMMENDED |
| ★ [delivery-log-resend](delivery-log-resend.md) | Per-recipient Sent/Delivered/Opened/Bounced + event timeline + row resend | RECOMMENDED |

### Recipient experience
| Card | One-liner | Verdict |
|---|---|---|
| ★ [claim-ceremony-name-confirm](claim-ceremony-name-confirm.md) | Confirm name BEFORE generation; claim deadline; identity-bound claim | RECOMMENDED |
| ★ [certificate-page-trophy-proof](certificate-page-trophy-proof.md) | One canonical URL = artifact + actions + trust block + verification sentence | RECOMMENDED |
| ★ [self-serve-name-fix](self-serve-name-fix.md) | "Update your certificate" on the artifact, regeneration as supersession | RECOMMENDED |
| ★ [add-to-linkedin-schema](add-to-linkedin-schema.md) | Add-to-profile (credential ID+URL prefill) distinct from share-post | RECOMMENDED |
| [share-card-prefilled](share-card-prefilled.md) | Designed share image + factual prefilled copy + privacy toggle | VIABLE (polish) |
| [celebration-chain](celebration-chain.md) | Congrats moment → share → ONE next action | VIABLE |
| [evidence-backed-certificate](evidence-backed-certificate.md) | Pair artifact with recorded proof (sessions/credit hours) | VIABLE |
| [wallet-pass-credential](wallet-pass-credential.md) | Email+Download+Wallet trio (⚠️ extrapolated from tickets) | AVOID V1 / VIABLE V2 |

### Verification & lifecycle
| Card | One-liner | Verdict |
|---|---|---|
| ★ [public-verification-portal](public-verification-portal.md) | ⚠️ FIRST-PRINCIPLES: verdict-first page (valid/revoked/superseded/expired) over legacy verify-token | RECOMMENDED |
| ★ [qr-with-manual-fallback](qr-with-manual-fallback.md) | QR on artifact always paired with typable ID + short URL | RECOMMENDED |
| [verified-by-issuer-chip](verified-by-issuer-chip.md) | Open-credential metadata so third parties render "verified" | VIABLE (V2 ecosystem) |
| ★ [revoke-reversible-segregated](revoke-reversible-segregated.md) | Impact-sentence confirm, dependency guard, segregated revoked filter (legacy reason-capture KEPT — exceeds corpus) | RECOMMENDED |
| [expiry-reminders-routing](expiry-reminders-routing.md) | Expiry + multi-party reminders + "Does not expire." explicitness | VIABLE (data V1, machinery V2) |
| ★ [post-send-correction](post-send-correction.md) | Guided "fix recipient" = revoke+reissue+resend in one flow, with history | RECOMMENDED |
| ★ [bulk-zip-async-export](bulk-zip-async-export.md) | Two-stage toasts, export history rows, email handoff threshold | RECOMMENDED |
| ★ [audit-log](audit-log.md) | Per-certificate history strip (actor+verb+object, diffs, export) | RECOMMENDED (scoped) |
| [issuer-analytics](issuer-analytics.md) | "Issued N times" / verification counts inline before any dashboard | VIABLE |
