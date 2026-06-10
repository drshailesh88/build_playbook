# Pattern: Email binding + wrong-account escape hatch on accept
**Surface:** invite-email · **Observed in:** Linear, Sketch, Todoist, Glide (refs: [Linear](https://mobbin.com/screens/f2c717d4-6bb3-44c2-9605-9e32e813f18c), [Sketch](https://mobbin.com/screens/63ebd23e-0196-400c-8bf7-0b9ee5338476), [Todoist flow](https://mobbin.com/flows/43a1c29d-3cde-4e1f-8dbe-26d4699febf8), [Glide flow](https://mobbin.com/flows/caa3904b-2521-44a1-b8dc-716cfe54023a))

## Flow
1. The accept page states which email the invite is bound to: Linear — "To accept the invitation please login as alexsmith.mobbin@gmail.com"; Sketch — "Accept this invitation using jonsmith.mobbin@gmail.com to get access…".
2. Auth is pre-framed to the join action: Todoist's invite link lands on a combined sign-up/sign-in page headed with the org name ("SLMobbin — Sign up or log in to join this team"), email pre-filled.
3. Wrong-account path is explicit: Sketch offers "Request access with a different email" as a secondary button instead of a dead end.
4. Glide accepts via passwordless: invite link → Google or magic-link sign-in → "Check your email" interstitial → lands in workspace.
5. Post-join confirmation in-app: Todoist toast "You joined the SLMobbin workspace".

## Use when
- Invites are issued to specific addresses (our case with Better Auth) — the accept flow must reconcile invite email vs session account, not silently attach the invite to whoever is logged in.

## Avoid when
- Open invite links (B5 shareable link) — there is no bound address, so frame the org instead and skip the binding copy.

## Sad paths observed
- Logged-in-as-someone-else is the core sad path: Linear instructs the exact login needed; Sketch offers re-request with another email.
- Glide handles no-account-yet by folding signup into the accept flow rather than bouncing to a generic register page.

## Accessibility
- Bound email rendered in bold body text, announced naturally; secondary path is a real button, not a footnote link.

## Default verdict for our stack
RECOMMENDED — Better Auth invitation accept route must check session email vs invite email, show "logged in as X, this invite is for Y" with switch-account, and inline signup for new users.
