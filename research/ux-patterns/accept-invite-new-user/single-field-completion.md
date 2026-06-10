# Pattern: Single-Field Completion (Pre-Provisioned Account)
**Surface:** accept-invite-new-user · **Observed in:** Slack, Square, Sprout Social, Fibery (refs: [Slack](https://mobbin.com/screens/ffe87cb7-2628-4751-a368-9010a5cdead0), [Slack 2](https://mobbin.com/screens/31abbd5d-9b47-42a4-886b-b880f9a39ec9), [Square flow](https://mobbin.com/flows/f37841a1-9dcc-486e-8335-53202935e63b), [Sprout Social flow](https://mobbin.com/flows/edef6b76-47b9-45ca-a6c9-f17146453f2f), [Fibery flow](https://mobbin.com/flows/49bf3863-b754-4a82-be03-bb19182051cb))

## Flow
1. Invite link itself authenticates the email — the page states it: Slack "You're accepting an invitation sent to jdoe@…"; Sprout "Your Username is: jonsmith@…".
2. Exactly ONE input is asked: display name (Slack) or password (Square "Finish account setup by creating a password"; Sprout "Create Password"; Fibery "Set your password. You are almost there… go to the workspace").
3. Single CTA ("Continue", "Go to workspace") creates the account and joins the org in one step.
4. User lands in the workspace (Square/Sprout/Fibery flows all end inside the product).

## Use when
The invite email is trusted as proof of identity (token = verification); you want the absolute lowest-friction accept — the strongest pattern for the highest-friction flow.

## Avoid when
You cannot treat the invite link as an authentication factor (forwardable links, long expiry, compliance requirements for explicit email verification); or password policy demands confirm-password + strength UX that makes "one field" a lie.

## Sad paths observed
None visible in the captured screens; Slack keeps OAuth ("Continue With Google/Apple") as a parallel path below the single field, so a user who prefers SSO is not trapped.

## Accessibility
One labeled input + one primary button is the easiest possible keyboard path; Fibery's password screen has a single focusable field and CTA.

## Default verdict for our stack
RECOMMENDED — pair with locked-email-invite-signup: token verifies the email, user supplies name + password on one screen; this is the Linear/Vercel-grade minimal version of it.
