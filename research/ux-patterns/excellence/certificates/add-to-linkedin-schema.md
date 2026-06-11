# Pattern: "Add to LinkedIn" (profile credential) as distinct from "Share on LinkedIn" (post)

**Surface:** certificates / recipient-share · **Observed in:** LinkedIn, Uxcel, Udemy, Codecademy, Upwork (refs: https://mobbin.com/flows/d97a84bf-7296-41d6-847b-34a7b5c016b2, https://mobbin.com/screens/ff867250-9ec4-4458-9aac-e5414a18abe2, https://mobbin.com/flows/f54be105-7a32-47b5-bd9f-a8aebba7bb43, https://mobbin.com/screens/811a4fa6-865c-4a41-9385-b8995e326ba7, https://mobbin.com/flows/fa7ca86e-d394-4fab-b81f-4f0f4cd72ce6)

## Flow
1. LinkedIn's "Add license or certification" modal is the target schema any issuer must fill: Name*, Issuing organization* (typeahead with org logos), checkbox "**This credential does not expire**" (gates the expiry dropdowns), Issue date (Month/Year), Expiration date, **Credential ID**, **Credential URL**.
2. Profile renders: issuer logo + "Certified Associate in Project Management (CAPM) · Project Management Institute · Issued Jan 2021 · Expires Jan 2026".
3. Recipient-side visibility: per-section "Certifications — Show" toggle on public profile + embeddable "Public Profile badge" (LinkedIn settings).
4. Issuer apps surface BOTH actions separately: "Add to LinkedIn" (profile entry) and "Share on LinkedIn" (celebration post) — Uxcel's certificate page has both buttons side by side.

## Use when
Every professional credential — for medical/academic delegates the profile entry is the durable value; the post is the viral moment. Offer both.

## Avoid when
Don't collapse the two into one "Share" button — they serve different jobs and the profile deep-link needs the credential fields, not an image.

## Sad paths observed
- Expiry renders publicly ("Expires Jan 2026") — issuing with a wrong expiry is visible forever; get the does-not-expire decision right per certificate type.

## Accessibility
Standard form modal; issuer typeahead requires the org to EXIST as a LinkedIn organization — register the tenant's org page or the logo/typeahead match fails.

## Default verdict for our stack
RECOMMENDED — never attempted in legacy. Mint per-certificate Credential ID (exists: certificate number, census #12) + Credential URL (exists: verify token URL) and prefill LinkedIn's add-to-profile deep link; zero new backend, pure distribution win.
