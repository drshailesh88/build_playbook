# Pattern: Eviction to sign-in with persistent reason banner
**Surface:** revoked-mid-session · **Observed in:** Charma (refs: [Charma](https://mobbin.com/screens/3f5f224f-1205-4a05-be22-fca54e9b6db3))

## Flow
1. The user's account/access is revoked (here: deleted); their session is terminated.
2. They land on the standard Sign In page, with a dismissible full-width banner at the top: "Your Account has been deleted."
3. The login form is fully functional beneath — a user with another account can proceed immediately.

## Use when
Revocation invalidates the entire session (account deleted, all-org ban) and sign-in is genuinely the only next step; the banner prevents the "why was I logged out?" mystery.

## Avoid when
The user still has valid access to OTHER orgs — bouncing them to login destroys a working session and is hostile in a multi-tenant product; also banners that outlive a page refresh were not observed (reason may be lost on reload).

## Sad paths observed
The reason for forced logout is carried onto the destination page rather than silently dropped — the single most common failure of session eviction (generic login page, no explanation) is avoided.

## Accessibility
Banner is a top-of-page colored strip with dismiss button; reads first in document order before the form.

## Default verdict for our stack
VIABLE — correct only for whole-account termination; for org-scoped revocation keep the session and use the neutral takeover/org picker instead. Keep the carry-the-reason mechanic regardless.
