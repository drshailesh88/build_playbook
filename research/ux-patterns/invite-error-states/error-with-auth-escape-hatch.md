# Pattern: Invite Error with Org Context and Auth Escape Hatch
**Surface:** invite-error-states · **Observed in:** Supabase (refs: [Supabase](https://mobbin.com/screens/53cc50f8-fdd3-4181-939c-d60006ab5a97))

## Flow
1. Invite page keeps its normal structure even in failure: header still reads "You have been invited to join an organization" with the org slug shown.
2. The error renders inline where the accept action would be: "There was an error requesting details for this invitation. (No authorization token was found)" — cause in parentheses.
3. Guidance line converts the error into a next step: "You will need to sign in to accept this invitation."
4. Two escape-hatch buttons inline: "Sign in" and "Create an account" — both routes preserve the pending invite.

## Use when
The invite itself may be fine but the viewer's state is wrong (no session, missing token, stale page) — recoverable-by-auth failures; any time you can keep org context visible, do, it reassures the user the invite still exists.

## Avoid when
The invite is truly dead (expired/revoked) — offering "Sign in" implies signing in will fix it; use the expired-link or not-found patterns there. Also avoid leaking raw internals: "(No authorization token was found)" is developer-grade copy below a Linear-quality bar.

## Sad paths observed
Whole screen is a sad path handled in place: error + cause + instruction + two recovery actions on one card, org context never lost.

## Accessibility
Inline error text adjacent to the actions it explains; both recovery buttons are real buttons; keep the org name in the heading hierarchy.

## Default verdict for our stack
VIABLE — the structure (org context + inline error + sign-in/create-account actions) is exactly our B7/B8 router fallback, but rewrite the cause line in human language.
