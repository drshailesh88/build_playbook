# LIVE-WEB Raw Harvest — Public credential pages & verification portals

Method: WebSearch + WebFetch + headless browser (Playwright MCP: browser_navigate / browser_snapshot / browser_run_code) over live public pages; every entry cites the live URL; observed-only.
Date: 2026-06-11
Module: CERTIFICATES (EventState) — closes Mobbin gap: no public credential-verification page existed in Mobbin corpus.

---

## Credly (credly.com)

### Entry C1 — VALID badge (live, fully rendered)
URL: https://www.credly.com/badges/48c47ac0-5268-45cf-b76c-b015f9a72fc4
Platform: Credly (Pearson). AWS Certified Solutions Architect – Professional, issued to Michael Mead.

Page anatomy top-to-bottom (observed via accessibility snapshot):
1. Header: Credly logo · global search box ("Search") · "Create Account" · "Sign In". (No issuer branding in chrome — Credly-branded surface.)
2. Issuance strip: small avatar img · "This badge was issued to **Michael Mead**" (name links to public profile `/users/<slug>`) · "Date issued: August 12, 2016" · "Expires: June 17, 2027".
3. Right of strip: blue **"Verify"** button + **"Celebrate"** button (Celebrate appears on valid badge; ABSENT on expired badge — see C2).
4. Badge hero: large badge artwork. Image alt text: "AWS Certified Solutions Architect – Professional badge image. Certification. Advanced level. Issued by Amazon Web Services Training and Certification" — the alt encodes type+level+issuer.
5. H1 badge title + "Issued by Amazon Web Services Training and Certification" (links to `/org/amazon-web-services`).
6. Badge description paragraph ("Earners of this certification have an extensive understanding…") + "Learn more" external link to aws.amazon.com.
7. "Template attributes" group: chips "Certification" (type) and "Advanced" (level).
8. "Skills" H2: ~10 linked skill chips (each → `/skills/<slug>` browse page).
9. "Earning Criteria" H2: checklist item "Successfully passed the AWS Certified Solutions Architect – Professional exam."
10. "Occupations" H2: 5 occupation cards (Solution Architects, Computer Network Architects, Data Architects, AI Engineers, Enterprise Architects) each with description + "Learn More" button (jobs upsell).
11. "Related" H1: related badge templates from the same issuer (cards linking to template pages).
12. Footer: Request Demo | About Credly | Terms | Privacy (→ pearson.com privacy notice) | Developers | Support | Cookies | Do Not Sell My Personal Information.
13. OneTrust cookie banner ("Privacy and cookies" — Cookie Settings / Reject All / Accept All).

Verify modal (clicked "Verify", observed live — animated checklist, rows resolve one-by-one from "Verifying..." to "Verified"):
- Dialog title: "Verification"
- Row 1: ✓ Verified — "Issued on" → August 12, 2016
- Row 2: ✓ Verified — "Issued by" → Amazon Web Services Training and Certification
- Row 3: ✓ Verified — "Issued using" → Credly
- Row 4: ✓ Verified — "Issued to" → Michael Mead
- Row 5: ✓ Verified — "Accepted on" → (date; acceptance is a distinct verified fact)
- Row 6 (valid badge only): ✓ Verified — "Last updated" → (date)
- Final verdict banner (alert role): **"Verified"**

Structured metadata (from document head, observed):
- og:title = "AWS Certified Solutions Architect – Professional was issued by Amazon Web Services Training and Certification to Michael Mead." (sentence-form social proof)
- og:image = images.credly.com `linkedin_thumb_image.png` variant; twitter:image = `twitter_thumb_201604_image.png`; twitter:card = summary; twitter:site = @Credly
- No JSON-LD / Open Badges assertion embedded in the HTML page itself (ld+json scripts: none found). Open Badges JSON is available via separate OB endpoints, not in the public page DOM.

PII exposed to anonymous visitor: full name, link to full public badge wallet (`/users/<slug>`), issue/expiry dates. No email, no evidence files on this badge, no employer.
Sad-path affordances: none on valid page (no "report" link visible to anon).

### Entry C2 — EXPIRED badge (live, fully rendered) — GOLD
URL: https://www.credly.com/badges/862230de-19d7-4586-80d9-184a485f9aeb
AWS Certified Solutions Architect – Professional, issued to olivier brun. Found via web search — Google result title itself reads "(Expired)".

Differences vs valid badge:
- Issuance strip reads: "This badge was issued to olivier brun" · "Date issued: June 08, 2020" · **"Expired: June 08, 2023"** (expiry rendered as its own emphasized element, label switches from "Expires:" to "Expired:").
- **"Celebrate" button is gone**; "Verify" button remains.
- Everything else (badge art, description, skills, earning criteria, occupations, related) renders identically — the badge is NOT hidden, blurred, or watermarked.
- og:title = "AWS Certified Solutions Architect – Professional **(Expired)** was issued by Amazon Web Services Training and Certification to olivier brun." → the expired state leaks into social-share previews.

Verify modal on EXPIRED badge (observed live):
- Same animated checklist: Issued on ✓ / Issued by ✓ / Issued using: Credly ✓ / Issued to: olivier brun ✓ / Accepted on: June 09, 2020 ✓
- Row 6 replaced: "Expired on" → June 08, 2023, with row state **"Verification Failed"** (red X icon state in a11y tree).
- Final verdict banner (alert role): **"Expired"** — facts still verify, verdict downgraded. Pattern: per-fact verification + overall verdict are separate concepts.

### Credly revoked state
Not found live (no public revoked badge URL surfaced in searches — see Coverage notes).

---

## Accredible (credential.net)

### Entry A1 — VALID credential (live, fully rendered)
URL: https://www.credential.net/d4bd834b-0937-4b7c-993e-e923567dc053
Platform: Accredible. "Corporate Finance Fundamentals" issued by Corporate Finance Institute to Ennio Buzali, July 30, 2019. (WebFetch returns HTTP 403 — page must be read with a real browser; Angular SPA.)
Page title pattern: "Corporate Finance Fundamentals • Ennio Buzali • Corporate Finance Institute".

Page anatomy top-to-bottom:
1. Cookie notice bar ("This website uses cookies… Got it!").
2. Header: Accredible logo (links to accredible.com with utm "navbar_logo_link") · nav buttons · link to app.mycareerjourney.com.
3. LEFT: full certificate render (image of the designed certificate). The image's accessible text contains: recipient name "Ennio Buzali", credential title, **credential ID "13482330"**, and issue date "July 30, 2019" — the cert render itself carries the ID.
4. RIGHT main column:
   - Issuer chip: "Corporate Finance Institute" with **verified-issuer mark** ("verified issuer, website - opens in a new tab").
   - H1 credential title.
   - "Credential actions" toolbar (share/download icons) + link **"Sign in to access more options"** (owner-only actions like PDF download gated behind login).
   - Recipient card: initials avatar "EB" · H2 "Ennio Buzali" · "View All Credentials" → `/profile/<slug>/wallet` · recipient's **LinkedIn profile link** (linkedin.com/EnnioBuzali).
   - Long course description paragraph.
   - "Skills / Knowledge" H3: chips (Capital markets overview, Business valuation overview, Mergers & acquisitions, Debt financing, Equity financing).
   - "Issued on" H3: July 30, 2019 · "Expires on" H3: **"Does not expire"** (explicit non-expiry statement instead of blank).
   - "Credential evidence" region (empty for this credential).
5. RIGHT sidebar ("Credential widgets"):
   - "Share Credential" H2 — "Show this credential on your social network": LinkedIn, Facebook, X, WhatsApp icons + "See all sharing options" + big button **"Add to My LinkedIn Profile"**. Share URLs point at issuer-white-label domain `credentials.corporatefinanceinstitute.com/<uuid>?utm_source=…` (same credential served on issuer subdomain).
   - "Your Next Steps — Personalized for your goals" career-journey upsell card ("A step-by-step career path tailored to your credential, skills, and goals." + "View Your Journey").
   - **"Credential Verification"** H2 region: shield icon + "This credential is from a **verified issuer**" + button **"Verify Credential"**.
   - "More about the Issuer" H2: verified-issuer card, "Visit Issuer Website", "Visit Course Page", "More credentials from the Issuer" → "View All Credentials" (`/issuer/1298/groups`).
6. Footer: "Issue Credentials" (About Accredible, Request a Demo) · "Credential Recipients" (**"Retrieve a Credential"** → v2.accounts.accredible.com/retrieve-credentials, Help, Coursefinder) · language combobox · Terms of Service, Privacy Policy, Accessibility, Site Map.

Verification dialog (clicked "Verify Credential"; URL gains fragment `#acc.KkG4gyJq`):
- Dialog title: "Credential Verification"
- Verdict block (green check): "This **Corporate Finance Fundamentals** Credential is VERIFIED"
  - Sub-line: **"This digital credential was securely issued via Accredible and its information is valid."**
- Issuer block: "**This issuer is verified by Accredible**" + issuer logo card + "Issuer's Website" link.
- Owner block: "**The owner of this credential has been verified**" + recipient card + "View All Credentials".
- Dates: "Issued on July 30, 2019" / "Expires on — Does not expire".
- **"Full credential history"** H3: audit-trail list — "2019-07-30 • Credential Issued".
- "Close dialog" button.

PII exposed to anonymous visitor: full name, initials avatar, full credential wallet link, recipient's LinkedIn URL, credential ID, issue date. No email.
Metadata: SPA; meta extraction returned no JSON-LD in initial DOM pass (page is client-rendered; og tags are injected server-side for crawlers — not captured in this session).

### Accredible expired/revoked state
Not observed live (no public expired/revoked credential.net URL surfaced). Vendor help article exists: help.accredible.com "Why has my credential been revoked?" (recipient-facing explanation; public-view rendering of a revoked credential not directly observed). See Coverage notes.

---
## Sertifier (verified.sertifier.com)

### Entry S1 — "Verified" search portal (verify-by-ID surface, live)
URL: https://verified.sertifier.com/en/search/
Anatomy: header (Verified-by-Sertifier logo · About Us · Learn · Verify) → H1 **"Search for a credential"** → single search box ("Search") → footer (Company/Learn/Resources links + "Want to send certificates or badges?" issuer upsell "GET STARTED FOR FREE").
Behavior observed: submitting a query navigates to `/en/profile/<query>` — the search treats input as a recipient/username lookup (API call to api.verified.sertifier.com returns 404 for unknown values).

### Entry S2 — NOT-FOUND sad path (live, deliberately triggered)
URL after searching bogus ID "ABC123XYZ000": https://verified.sertifier.com/en/profile/ABC123XYZ000
Rendered state: "Not Found" illustration · H1 **"Oops!"** · body **"Sorry, there is no user matching with the given username."** · link **"Report an issue"**.
(API 404 is swallowed into a friendly page; no raw error shown.)

### Sertifier credential page
A live per-credential page (verified.sertifier.com/en/onboarding-credential/22852900695451/ surfaced in search results) was identified but not fully documented this session — see Coverage notes.

---

## Certifier (credsverse.com)

### Entry CF1 — VALID credential (live, fully rendered)
URL: https://credsverse.com/credentials/60cd0068-2853-4ac1-ae01-36421c4d6f7f
"JORS Outstanding Reviewer Certificate" issued by The OR Society to Roland Braune.
Page title pattern (SEO/social): "Check out Roland Braune's JORS Outstanding Reviewer Certificate credential issued by The OR Society".

Page anatomy top-to-bottom:
1. Minimal nav: Certifier logo only.
2. LEFT: certificate render with recipient name + "Distributed by: [Certifier logo]".
3. RIGHT panel:
   - "Issued to" H4 → H2 "Roland Braune".
   - Action row: **"Share Your Award"** · **"Add to LinkedIn Profile"** · **"Download"** (+ dropdown) · copy-link icon button. All actions PUBLIC — no login gate (contrast Accredible's "Sign in to access more options").
   - **"Want to report a typo or a mistake?" + "Contact Issuer" button** — public error-reporting affordance directly on the credential.
   - **"Credential Verification" card**: shield icon · "Issue date: December 17, 2024" · button "Verify Credential" · **"ID: 60cd0068-2853-4ac1-ae01-36421c4d6f7f"** (full UUID printed on page).
   - "Issued by" H4 → H2 "The OR Society".
   - "Description" H3 → empty-state copy: **"No information provided for this award."**
4. Footer: Certifier branding "Create and send digital credentials to everyone." · "Powered by Certifier" · socials · language switcher.

Verify modal (clicked "Verify Credential", observed live) — dialog "Credential Verification", 4 sequential checks, each with green check + sentence result:
- "Verifying the recipient" → **"The owner of this credential is Roland Braune."**
- "Verifying the issuer" → **"The issuer of this credential is The OR Society."**
- "Verifying the issuer's status" → **"The OR Society organization has not been verified by Certifier."** (info icon — PARTIAL-TRUST state: credential valid, issuer unverified — surfaced honestly, does not fail the verdict)
- "Verifying the credential's ID" → **"The ID of this credential is unique and valid."**
- Final verdict alert (green check-circle): **"This is the valid credential"** + **"This credential was securely issued via Certifier. All the displayed information is valid."**

PII exposed: recipient full name, certificate render. No email, no profile/wallet link (no cross-credential identity on Certifier — unlike Credly/Accredible).

### Entry CF2 — Issuer "verify by ID" portals (found, did not render)
URLs: https://credsverse.com/issuers/01g53snfgmk7qyd7fkg81x4wpk/credential-verification (Recalc Academy) and …/01hqvp7t4pz38ww9kak9476mvz/… (Reconnective Academy). Search snippets confirm an issuer-scoped portal: "Provide the credential ID to verify its validity". In headless browser the page rendered only an empty alert node (likely bot detection); not documented further. Confirms the per-issuer "enter ID → verdict" portal pattern exists on Certifier.

---

## Badgr / Canvas Credentials (badgr.com → badges.parchment.com)

### Entry B1 — VALID Open Badges assertion (live, fully rendered)
URL: https://api.badgr.io/public/assertions/EVRYzlD2RO26uyAKFxkOGQ → 301 → https://badgr.com/public/assertions/EVRYzlD2RO26uyAKFxkOGQ → SPA redirects to https://badges.parchment.com/public/assertions/EVRYzlD2RO26uyAKFxkOGQ
"Client Thrive: Engagement Badge", issuer Safe Harbor Behavioral Care, awarded to Donna Doyle, LGPC.
Note: api.badgr.io endpoint content-negotiates — returns Open Badges JSON-LD to JSON clients, HTML shell + redirect to UI for browsers (WebFetch saw the empty Angular shell; vendor docs confirm OB 2.0 JSON at the same URL).

Page anatomy top-to-bottom:
1. Header: logo · "Sign In" · "Create Account".
2. Badge image · H1 badge title · long Description with "[View more]" expander.
3. **Verification strip (always-on, above the fold)**: green check · "Verified" · **"Last verified by Parchment Digital Badges on Jun 11, 2026"** (the date is TODAY — page re-verifies continuously, proof-of-freshness pattern) · button **"Re-verify Badge"**.
4. "Awarded to **Donna Doyle, LGPC**" · "Issued on: Jun 27, 2022 at 12:00 PM" (includes time of day).
5. "Offered by:" issuer logo + link → public issuer page `/public/issuers/<id>`.
6. "Earning Criteria" H2 — subtitle "Recipients must complete the earning criteria to earn this badge" — criteria paragraph + "View External Criteria (opens in new window)".
7. **"Narrative" H2 — subtitle "What the recipient did to earn this Badge"** — per-recipient narrative paragraph.
8. **"Evidence" H2 — subtitle "Proof that the recipient met the earning criteria"** — evidence statement + "View Evidence" external link.
9. Standards footer: "We Issue **Open Badges**" (link to openbadges.org) + button **"View JSON"** (raw OB assertion for machine verification).
10. Footer: "Provided by Instructure" · ToS · Privacy · Support · Sitemap.

"Re-verify Badge" modal (observed live) — dialog "Verify Badge":
- Headline under badge name: **"This badge has been verified by Parchment Digital Badges and its information is valid."**
- "Issued By" → Safe Harbor Behavioral Care + **"The Issuer has been verified"**
- "Awarded To" → **"You need this Recipient's permission to verify their identity"** (privacy-preserving: recipient identity is hashed in OB assertion; anonymous viewers cannot confirm identity binding)
- "Expires On" → "Does not expire"
- "Issued On" → Jun 27, 2022
- "Done" button.

PII exposed: recipient name + professional suffix (page-level), per-recipient narrative and evidence text. Verification modal deliberately does NOT verify recipient identity without permission.

---
## Sertifier — live credential page (addendum)

### Entry S3 — VALID credential page (live, fully rendered)
URL: https://verified.sertifier.com/en/onboarding-credential/22852900695451/
"Asset management and control" — issuer "MBL IT Department Asset Control Division", recipient VARKEY THOMAS, issued 2024-Nov-21. (NOTE: this is an issuer's onboarding/demo credential left public — page even shows the issuer-facing banner "🎉 Congrats! You've successfuly issued your first credential. Now, let's go back and complete your onboarding." [sic: "successfuly"]. Treat layout as representative; banner is onboarding-only.)

Page anatomy top-to-bottom:
1. Header: Verified-by-Sertifier logo · About Us · Learn · "Verify" (→ /en/search/) · account icon.
2. Identity strip: issuer chip (logo + org name) · recipient chip (photo + "VARKEY THOMAS" + label **"Credential Owner"**).
3. Certificate render (full designed certificate) + credential title.
4. Action row: **"Add to [LinkedIn]"** · share buttons twitter/facebook/**Xing** + copy-link · **"Verify Credential"** · **"Download Credential"** (public download, no login).
5. Metadata cards: "Issue Date 2024-Nov-21" · "Credential Type: Achievement".
6. "Credential Description" paragraph · "Skills" chips ("Sertifier 101", "Credential Management") · "Earning Criteria" ("Successfully maintained accurate asset records and conducted periodic audits.").

Verify modal (clicked "Verify Credential", observed live) — dialog "Credential Verification", 4 sequential checks with progress microcopy "Verifying the Owner…", "Checking Credential Status…":
- "**CREDENTIAL NAME is verified.** This credential was issued via MBL IT Department Asset Control Division and all information is valid."
- "**ORGANIZATION NAME is verified.**" + issuer logo + org name.
- "**OWNER NAME is verified.** VARKEY THOMAS" + link **"See Other Credentials"** (→ /en/profile/<slug>).
- "**Credential Status:** Issued at: 2024-Nov-21 · **Expires on: No expiry date**".
(Labels render literally as "CREDENTIAL NAME / ORGANIZATION NAME / OWNER NAME" — appears to be a template-label quirk on this page.)

PII exposed: recipient name + photo, issuer org, profile link. Public PDF download.

---

## Microsoft Learn — credential share / verification surface

### Entry M1 — VALID certification share page (live, fully rendered)
Share URL: https://learn.microsoft.com/api/credentials/share/en-us/DieterRauscher/9CAD3CFEBE5DB4A7?sharingId=3C39B423744ABF3C
→ resolves to canonical https://learn.microsoft.com/en-us/users/dieterrauscher/credentials/9cad3cfebe5db4a7
"Microsoft Certified: Azure Solutions Architect Expert" — Dieter Rauscher. (WebFetch got only the title; full page needs JS.)

Page anatomy top-to-bottom:
1. Standard Learn chrome (nav, search, Sign in) + promo banner.
2. H1 certification title · "**Issued by Microsoft on September 28, 2020 to:**" · H3 recipient name (links to public Learn profile `/users/DieterRauscher/`).
3. Certificate render: "Dieter Rauscher **has successfully passed all requirements for** Microsoft Certified: Azure Solutions Architect Expert" + on-certificate metadata: "Credential ID: 9CAD3CFEBE5DB4A7" · "Certification number: 707C55-OD738D" · "Earned on: September 28, 2020" · "Expires on: September 28, 2026" · badge **"Online Verifiable"**.
4. Status list (the page IS the verification — no verify button):
   - "Status **Active**" + "Online Verifiable" chip
   - "Credential ID: 9CAD3CFEBE5DB4A7"
   - "Certification number: 707C55-OD738D" (two distinct identifiers!)
   - "Earned on" / "Expires on"
   - "View certification page" → cert template page.
5. "Skills measured:" list (4 exam domains).
6. Standard Learn footer.

Pattern: no verify ceremony — trust comes from the page living on learn.microsoft.com + "Status: Active" + "Online Verifiable". Two IDs (credential ID + certification number) support offline cross-checking.
PII: name + public Learn profile link. Nothing else.

---

## Verify-by-ID portals (type a code → verdict)

1. **Sertifier "Verified" search** — https://verified.sertifier.com/en/search/ — LIVE, tested. H1 "Search for a credential", single box; query routes to /en/profile/<query>; unknown value → "Oops! | Sorry, there is no user matching with the given username. | Report an issue" (see S2).
2. **Certifier issuer portals** — https://credsverse.com/issuers/<id>/credential-verification — exist per search snippets ("Provide the credential ID to verify its validity") but page did not render in headless browser (blank alert node; suspected bot-gate). Not observed.
3. **Accredible** — https://www.accredible.com/verification 301-redirects to help.accredible.com/how-to-verify-a-credential (help article, itself 403 to WebFetch). No standalone public type-a-code portal observed; Accredible's model is per-credential URL + in-page Verify.
4. **PMI certification registry** — https://www.pmi.org/certifications/certification-resources/registry returned a 403/error page in headless browser ("Something unexpected happened…" + Customer Care contacts). Not observed. (Registry is name-based lookup per PMI docs.)
5. **Coursera** — pattern confirmed from Coursera support/blog: `coursera.org/verify/<code>` (printed in the lower-right corner of every certificate PDF) and `coursera.org/account/accomplishments/verify/<code>`; "the page will confirm the authenticity of your Certificate and share more about the course's syllabus and workload." No live code found in indexed web (codes only exist on issued PDFs); NOT observed live.
6. **Microsoft Learn** — share-URL surface only (M1); validation = viewing the page; Learn profile must be public for credentials to be verifiable (per MS docs learn.microsoft.com/en-us/credentials/certifications/cred-share-validate).

---

## Verdict-state matrix (observed unless marked otherwise)

| State | Credly (observed) | Accredible (observed/vendor-doc) | Certifier (observed) | Badgr/Parchment (observed) | Sertifier (observed) |
|---|---|---|---|---|---|
| Valid | Page renders fully; Verify modal: 6 rows each "Verified" (Issued on/by/using/to, Accepted on, Last updated); final banner "Verified"; valid-only "Celebrate" button | In-page region "This credential is from a verified issuer"; modal: "…Credential is VERIFIED" + "securely issued via Accredible and its information is valid" + issuer-verified + owner-verified + "Full credential history" audit list | Modal: 4 checks; final "This is the valid credential" + "…securely issued via Certifier. All the displayed information is valid." Note partial-trust row possible: "<Org> organization has not been verified by Certifier." | Always-on strip "Verified — Last verified by Parchment Digital Badges on <today>" + Re-verify modal "…verified … and its information is valid"; recipient row withheld: "You need this Recipient's permission to verify their identity" | Modal: "CREDENTIAL NAME is verified…", org verified, owner verified, "Credential Status: Issued at… / Expires on: No expiry date" |
| Expired | OBSERVED: page label flips to "Expired: <date>" (red), Celebrate removed, og:title gains "(Expired)", modal row "Expired on <date>" = "Verification Failed", final banner "Expired" | Not observed live | Not observed live | Not observed live (modal has "Expires On: Does not expire" slot) | Not observed live ("Expires on: No expiry date" slot exists) |
| Revoked | NOT observed live. Vendor evidence (credly.com/docs/issued_badges via search snippet): revoked badge's Open Badge hosted assertion returns **HTTP 410 Gone**; issuer help (credlyissuer.zendesk.com, 403 to fetch): revoking "leaves a record of the badge"; earner notified by email. Thought Industries doc: revoked badges disappear from earner badge lists. | Vendor help article exists ("Why has my credential been revoked?", help.accredible.com — Salesforce app, JS errors blocked extraction). Public rendering not observed. | Not observed | Not observed (OB 2.0 spec: assertion gets `"revoked": true` + revocationReason; not verified live) | Not observed |
| Not found / bad ID | Not tested (badge URLs are UUIDs; no portal) | Not tested | Portal exists but did not render headless | Not tested | OBSERVED: "Oops! Sorry, there is no user matching with the given username." + "Report an issue" |
| Non-expiring | "Expires:" line simply absent (other badges) | EXPLICIT: "Expires on — Does not expire" | n/a (no expiry shown on entry CF1) | EXPLICIT: "Expires On: Does not expire" | EXPLICIT: "Expires on: No expiry date" |

---

## Coverage notes (what could NOT be found live, and dead searches)

- **Revoked credential, public view — NOT FOUND on any platform.** Searches tried: `"this badge has been revoked" credly/accredible/badgr`, `"credly.com/badges/" "(Revoked)"`, vendor docs. Best evidence is indirect: Credly developer docs (410 Gone on OB assertion of revoked badge) and Credly issuer help ("revoking leaves a record"). Whether Credly's public HTML page for a revoked badge 404s, 410s, or shows a revoked banner remains UNVERIFIED. Accredible/Badgr public revoked rendering unverified.
- **Expired state found ONLY on Credly** (entry C2 — gold). No live expired example found for Accredible, Certifier, Badgr, Sertifier.
- **Coursera verify**: URL pattern documented, but no live verification code indexed anywhere reachable (codes live on issued PDFs); could not observe the verdict page.
- **PMI registry**: hard 403 to headless browser — error page captured instead.
- **Certifier issuer verify-by-ID portal**: exists (2 URLs found) but renders blank in headless Chromium — likely bot detection.
- **Accredible standalone verification portal**: accredible.com/verification is just a redirect to a help article; no public type-a-code portal exists — verification is per-credential-URL only.
- **credential.net via WebFetch**: 403 (bot-blocked); browser required. Credly: SSR meta tags but SPA body; WebFetch sees only nav/footer shell. Badgr: pure SPA shell to WebFetch; api.badgr.io content-negotiates JSON-LD (per vendor docs) — JSON response not directly captured this session.
- Browser-session note: the shared MCP browser was intermittently navigated by another process (help.accredible.com tabs) mid-harvest; all captures above were re-verified on the correct URL in atomic navigate+extract calls.

