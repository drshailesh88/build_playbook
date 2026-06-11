# Pattern: Brand kit — store logo/colors/fonts once, propagate to every artifact

**Surface:** certificates / template-design · **Observed in:** Canva, HubSpot, Square, GoDaddy, VEED, Adobe Express (refs: https://mobbin.com/flows/9c4c0ca9-dba1-4f3f-b9cf-580409dbfd10, https://mobbin.com/screens/82e4f1bb-6b61-4ce6-a7a8-d7e5084bd524, https://mobbin.com/screens/9685742d-e93c-4296-a33c-e11265f13002, https://mobbin.com/screens/f5fc9dd5-718e-42b4-83f2-af176b2ad73a, https://mobbin.com/flows/42362400-db42-425b-931b-c227d79d965d)

## Flow
1. One brand area: Logos (full + small variants with stated purposes — Square), Colors (named palettes; uploading a logo AUTO-EXTRACTS a palette — Canva "Colors from 1.png"), Fonts as ROLE-BASED slots (Title, Subtitle, Heading, Body, Caption — Canva), not raw font lists.
2. Editors expose the kit as a left-rail tab that restyles the canvas in one click (GoDaddy).
3. Templates can carry **Locks & Restrictions** — "Control the use of color, fonts, layers, and content while using this template." (Adobe Express "Make a template").
4. Propagation promise stated plainly: "Your logo and color will be reflected across Square, including on your receipts, Invoices… and anywhere else your customers interact with Square."
5. Compliance nudge on the admin side: "Some designs aren't using a Brand Kit… make sure everything's on brand." + "View designs" (Canva Reports).

## Use when
Multi-tenant: every org needs its certificates, emails, and public pages on ITS brand without re-uploading assets per template.

## Avoid when
Single-brand product with one template — a kit is indirection with no payoff.

## Sad paths observed
- VEED gates the entire feature behind upgrade ("Upgrade to Build Your Brand Kit") — plan-gating a brand kit punishes exactly the orgs that need on-brand output.

## Accessibility
Role-based font slots map 1:1 to a heading hierarchy — enforces consistent reading order on generated PDFs.

## Default verdict for our stack
RECOMMENDED at ORG level — directly answers the census stale-mechanics flag (GEM-hardcoded number prefix/branding): tenant brand kit feeds certificate templates, issuance emails, and the public verify page.
