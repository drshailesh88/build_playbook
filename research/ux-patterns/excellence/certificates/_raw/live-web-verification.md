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
