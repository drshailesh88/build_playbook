# Pattern: SSO escape hatch on the login card
**Surface:** sign-in · **Observed in:** Stripe, TheyDo, Better Stack, Intercom, Workable, Notion, Current, Linear (per Mobbin labeling) (refs: [Stripe](https://mobbin.com/screens/93761d71-0981-4db7-97ae-159bbe8327bc), [TheyDo](https://mobbin.com/screens/669cd52f-a221-48db-8e1c-ca19d18cf024), [Better Stack](https://mobbin.com/screens/6e4462ee-35ac-4263-8fd9-7ca9b00b6e00), [Intercom](https://mobbin.com/screens/6fb3111f-f41c-4605-b3b1-0bef600393ea), [Workable](https://mobbin.com/screens/df32220a-c1ed-4500-b92b-88a19ff32eff), [Notion](https://mobbin.com/screens/2f8a40a2-20ff-467f-a818-77cb90bedbcc), [Current](https://mobbin.com/screens/ff309fd9-9887-4790-b376-00f30dec7daa), [Linear-labeled](https://mobbin.com/screens/f4dfb7b1-9538-4ede-bbf2-5b8dbadfba77))

## Flow
1. The standard email/password card carries a demoted enterprise entry: text link "Use single sign-on (SSO) instead" below the submit button (Stripe), "Sign in with SAML SSO" footer link (Intercom), secondary outline button "Login with SSO" under an Or divider (TheyDo, Better Stack), plain sentence "You can also continue with SAML SSO" (Current, Notion).
2. Clicking routes to an SSO-specific screen (work email/org slug → IdP redirect).
3. Hierarchy is deliberate: SSO never competes visually with the primary method — it's a link or ghost button.

## Use when
- Any B2B product that will ever sell to orgs with IdPs — reserving the slot early avoids a layout reshuffle later.
- SSO users are a minority of logins; majority path stays uncluttered.

## Avoid when
- SSO-dominant enterprise products — there, identifier-first routing or SSO-primary ordering serves better than a buried link.
- Products that will genuinely never offer SSO (dead link space).

## Sad paths observed
- None observed directly; Workable's banner suggests "select a different sign in option below" on credential failure, positioning SSO as an error-recovery alternative.

## Accessibility
- Text links with explicit method names ("single sign-on (SSO)") — no jargon-free user is forced through it.

## Default verdict for our stack
VIABLE — add the demoted link slot when enterprise SSO ships via Better Auth's SSO plugin; until then omit rather than stub a dead link.
