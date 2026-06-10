# Pattern: Form-level error banner on login failure
**Surface:** sign-in · **Observed in:** Clearbit, WorkOS, Intercom, Workable, Readymag (refs: [Clearbit](https://mobbin.com/screens/1000c245-c148-41a0-8678-8bcc43c30737), [WorkOS](https://mobbin.com/screens/812592ce-380a-4998-a10e-55ac97d12858), [Intercom](https://mobbin.com/screens/6fb3111f-f41c-4605-b3b1-0bef600393ea), [Workable](https://mobbin.com/screens/df32220a-c1ed-4500-b92b-88a19ff32eff), [Readymag](https://mobbin.com/screens/503db49d-0a35-4c95-b3e3-3c3e3eefacfe))

## Flow
1. On failure, a red/pink alert strip renders at the top of the card (WorkOS, Intercom, Workable) or above the whole card (Clearbit); Readymag uses a dismissible toast pinned top.
2. Copy is non-enumerating and often routes forward: Clearbit "Sorry, your login failed. Your username or password was incorrect. If you don't have an account, you can create one here." (with live link); Workable "…Try again or select a different sign in option below."
3. Form values persist beneath; banner survives until next submit (toasts auto-dismiss — weaker).

## Use when
- Whole-form failures not attributable to one field: invalid credential pair on multi-method screens, rate limiting, suspended account, provider outage.
- The fix is a different method/route — banner copy can point at options below it.

## Avoid when
- A single field is clearly at fault — inline field error localizes better.
- As an auto-dismissing toast (Readymag): error vanishes before slower users read it.

## Sad paths observed
- This card IS the sad path. Clearbit cross-links signup from the failure (typo'd-email-at-signup case); Workable redirects attention to its SSO/social alternatives; Readymag also shows provider-outage copy ("Facebook login is temporarily unavailable…") in the same slot.

## Accessibility
- Banner at top of form is encountered first on re-read; needs role=alert for announcement. Dismiss button (Readymag toast) must be keyboard reachable.

## Default verdict for our stack
VIABLE — keep as the slot for non-field failures (rate limit, locked account, OAuth errors); pair with field-inline errors rather than replacing them.
