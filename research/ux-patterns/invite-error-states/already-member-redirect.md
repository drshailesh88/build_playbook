# Pattern: Already-a-Member / Already-Accepted Notice
**Surface:** invite-error-states · **Observed in:** Linear, Squarespace, Frame.io (refs: [Linear](https://mobbin.com/screens/7a0995a4-f085-45cd-b657-d88269272e9e), [Squarespace](https://mobbin.com/screens/c7957528-2575-4d14-8183-4aa52a5a6c8d), [Frame.io](https://mobbin.com/screens/04cb2804-b240-4a19-b934-73f5617d08f1))

## Flow
1. User re-clicks an invite they already consumed (or holds membership already); app shows a calm notice, not an error tone: Linear card "Invitation already accepted"; Squarespace "Unable to Accept Invitation — You already have permissions on this site."
2. Context chrome keeps the user oriented: Linear shows "Logged in as alexsmith…" top-right and a "‹ Back to Linear" link.
3. Escalation copy covers the confused case: Linear "If you think this is a mistake or if you have trouble logging into the workspace, please contact the workspace admins or Linear support."
4. Single CTA exits: Linear "Go back"; Squarespace "OKAY"; Frame.io's softer variant skips the error entirely — "You've already been invited! Jump right into Frame.io" with a Join/enter button.

## Use when
Idempotent re-clicks of consumed invites — common from email re-opens; membership already exists via another path (domain join, second invite).

## Avoid when
You can simply open the workspace instead — Frame.io shows the superior resolution: if the user is a member and the session is right, redirect into the org (optionally with a toast) rather than stopping them at a notice; reserve the notice for ambiguous-identity cases.

## Sad paths observed
Linear names BOTH escalation targets (workspace admins and vendor support) and shows the acting account so wrong-account confusion is self-diagnosable; Squarespace's bare "OKAY" gives no route into the site it says you can access — weaker.

## Accessibility
Notice as a focused dialog/card with h1; "Go back" must have a defined target; show the signed-in email as text.

## Default verdict for our stack
RECOMMENDED — Frame.io behavior as default (already a member → open the org with a toast "You're already a member of {org}"); Linear-style notice with logged-in-as + admin/support escalation only when the session email differs from the invited email.
