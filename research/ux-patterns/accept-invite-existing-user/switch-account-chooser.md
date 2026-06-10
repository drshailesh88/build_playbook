# Pattern: Switch-Account Chooser (Wrong Session Detected)
**Surface:** accept-invite-existing-user · **Observed in:** Better Stack (refs: [Better Stack](https://mobbin.com/screens/79ff5d94-60a3-441e-a5e4-d535330f7948))

## Flow
1. App detects the link belongs to a different user than the current session and interrupts BEFORE any action: heading "Switch accounts".
2. Plain-language diagnosis: "You clicked a magic link for a different user. What do you want to do?"
3. Two explicit, email-labeled choices stacked as buttons: "Switch account to jonsmith.mobbin@gmail.com" (primary, highlighted) and "Stay signed in as jsmith.mobbin2@gmail.com" (secondary).
4. "Back to Better Stack" escape in the corner; terms line at the bottom.

## Use when
Invite/magic link email ≠ session email and you can resolve both identities — this converts the classic dead-end ("this invite is for another email") into a one-click repair.

## Avoid when
You cannot safely end the current session programmatically (shared/kiosk machines mid-work in another tenant — warn about unsaved state); or the target email has no account yet (route to B7 signup instead of "switch").

## Sad paths observed
The screen is itself the sad path, handled as a first-class decision rather than an error; both emails are shown in full so the user can see exactly which identity does what.

## Accessibility
Both options are full buttons with the email in the label — announced completely by screen readers; no ambiguous "OK/Cancel".

## Default verdict for our stack
RECOMMENDED — implement as the dedicated mismatch state for invite links ("This invite was sent to {invited}. Switch from {current}?"); strictly better than Descript's logout-and-figure-it-out.
