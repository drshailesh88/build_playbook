# Pattern: Account disabled/deactivated wall with support escape hatch
**Surface:** rate-limit-lockout · **Observed in:** Zillow, Contra, Discord (refs: [Zillow](https://mobbin.com/screens/46aebfeb-14b2-4564-9843-27891594b72a), [Contra](https://mobbin.com/screens/44764601-7fa2-4c19-8c9b-6d7b8b222a76), [Discord](https://mobbin.com/screens/750cce9a-817a-473b-aab0-cb71c9e093b9))

## Flow
1. Login succeeds but the account is administratively disabled; a modal/wall replaces the product.
2. States what happened + the single path out: "Your account is currently disabled. We are unable to access your properties at this time. Please **contact** our team to resolve the issue." + "Return to Zillow" (Zillow).
3. Contra variant (self-deactivation): "Your account has been deactivated and will be permanently deleted within 30 days. If you log into your account within the next 30 days, you will have the option to cancel your request." + "Go To Log In" — states the deadline and the self-recovery path.
4. Discord's gate footer shows the mistaken-identity escape: "Think you're seeing this by mistake? Support | Log Out".

## Use when
- Admin-initiated or compliance locks where no self-serve recovery exists — the only honest UX is what + why + who to contact.
- Tenant-level suspension in multi-tenant SaaS (billing lapse, abuse) — same skeleton, plus which workspace is affected.

## Avoid when
- Temporary rate-limit lockouts — labeling a 15-minute throttle "account disabled" causes panic and tickets; reserve this for true administrative states.
- Without a recovery deadline/expectation when one exists (Contra's 30-day window is the model).

## Sad paths observed
- This is a terminal sad path; Contra's cancel-within-30-days is the only self-recovery observed. None of the observed walls state the REASON for the disable — a gap to improve on (our copy should name the category: billing, abuse report, admin action).

## Accessibility
- Modal with one primary action each; "contact" is an inline text link (Zillow) — should be a visible button at our bar.

## Default verdict for our stack
VIABLE — needed inventory for tenant suspension and admin-locked users, but build it as a distinct state from rate-limiting; never reuse this wall for throttles.
