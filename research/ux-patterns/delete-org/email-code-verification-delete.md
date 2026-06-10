# Pattern: Emailed verification code gate on workspace deletion
**Surface:** delete-org · **Observed in:** Linear (refs: [Linear](https://mobbin.com/screens/293a8ed9-7304-4e39-9ebf-87381247fdef))

## Flow
1. Workspace settings → General has a delete section: "If you want to permanently delete this workspace and all of its data … you can do so below" with a red "Delete this workspace" button.
2. Clicking sends a code and shows a toast: "Deletion verification code sent — An email containing a verification code was sent to jsmith…@gmail.com."
3. Modal "Verify workspace deletion request" restates scope and retention: "this operation is irreversible and will result in a complete deletion of all the data associated with the workspace. Data including but not limited to users, issues and comments will be permanently deleted."
4. Inputs: the emailed deletion code + an acknowledgement checkbox "I acknowledge I understand that all of the workspace data will be deleted and want to proceed."
5. Red full-width "Delete my workspace" executes.

## Use when
You need proof of mailbox control, not just an unlocked session — defeats both shared-laptop misuse and autopilot typing (a code can't be typed from muscle memory).

## Avoid when
Email delivery is unreliable in your user base or the action must work offline from email (locked-out mailbox = undeletable org without support); the base type-name pattern suffices for most tenants.

## Sad paths observed
The toast names the destination mailbox so a user watching the wrong inbox can self-diagnose; resend/expiry handling not captured.

## Accessibility
Code input is labeled with the destination address; acknowledgement is a separate checkbox, so the screen-reader flow reads scope → code → consent → action.

## Default verdict for our stack
VIABLE — strongest gate observed and it is Linear (our quality north star), but email-code infra is extra build; adopt later if org deletion proves abused, keep type-name + re-auth for v1.
