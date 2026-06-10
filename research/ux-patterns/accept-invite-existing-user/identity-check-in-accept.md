# Pattern: Identity Check Inside the Accept Step
**Surface:** accept-invite-existing-user · **Observed in:** Descript, Asana, Intercom, Plane (refs: [Descript](https://mobbin.com/screens/fc5c2dba-e81a-4f41-a8c7-17ad447a01f0), [Asana](https://mobbin.com/screens/45822a5a-03de-4294-9a4d-4030072fba41), [Intercom](https://mobbin.com/screens/1a9fb615-d0da-41ee-a701-3ba2d750f44b), [Plane](https://mobbin.com/screens/c682b873-0870-4cfc-bb28-15967889e823))

## Flow
1. The accept screen names the acting account inline: Descript dialog title "Join Alex's Drive as samlee.mobbin@gmail.com?"; Asana footer "You're joining as jdoe.mobbin+1@gmail.com"; Plane shows the session email top-right.
2. A change-identity escape hatch sits next to it: Descript "If this is not the Descript account you want to link, please logout and login with the desired email" with a Log out button beside Accept; Asana "Not the right account?" link; Intercom "Want to sign in with a different account? Sign out" top-right.
3. User either accepts as the shown identity or exits to re-authenticate; the invite link survives the round-trip.

## Use when
Always when a session exists — silent joins under the wrong account are the worst B8 failure (wrong person inside a tenant); mandatory when users commonly hold work + personal accounts.

## Avoid when
Never omit the identity display itself; the heavyweight modal version (Descript) is overkill if the email is already visible in the page chrome and matches the invited email.

## Sad paths observed
This pattern IS the sad-path handler: Descript's copy explicitly covers "invite addressed to a different account than the one signed in"; the only offered repair is logout→login, none of the observed apps re-validated and showed "this invite is for other@email" proactively.

## Accessibility
The acting email must be plain text in the dialog (not just avatar tooltip) so it is announced; Log out and Accept need distinct, descriptive labels.

## Default verdict for our stack
RECOMMENDED — "Joining as {email} · Not you?" line under the Accept button; if invited email ≠ session email, escalate to the explicit switch-account screen instead of letting Accept fail server-side.
