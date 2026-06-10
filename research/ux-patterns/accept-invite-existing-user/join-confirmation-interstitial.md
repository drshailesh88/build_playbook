# Pattern: Join-Confirmation Interstitial
**Surface:** accept-invite-existing-user · **Observed in:** Attio, Plane, Intercom, Clearbit (refs: [Attio](https://mobbin.com/screens/cc9ec9af-d3e9-4a89-af5e-0e7ddaf46779), [Plane](https://mobbin.com/screens/c682b873-0870-4cfc-bb28-15967889e823), [Intercom](https://mobbin.com/screens/1a9fb615-d0da-41ee-a701-3ba2d750f44b), [Clearbit](https://mobbin.com/screens/49f50727-f06f-4fee-a06a-c58c4523e0df))

## Flow
1. Signed-in user opens invite link; a minimal page/modal shows the target workspace card (Attio: org avatar + name + URL; Plane: "Join a workspace" card with role "Member"; Intercom: user-avatar → org-avatar arrow graphic).
2. Copy asks for explicit consent: Attio "Do you want to accept your invite to this workspace?"; Intercom "You're already signed into Intercom. Click below to join this JDM team."
3. Primary CTA accepts and enters: "Yes, take me there" / "Accept & Join" / "Join This Team" / "Accept".
4. Secondary path declines or defers: Attio "Not yet"; Plane "Go Home"; legal line ("By accepting this invite, you agree to…") rides under the question.
5. On accept, the app switches the user into the new org.

## Use when
User already has a session — the only decision left is membership; joining has consequences (org list changes, possible seat billing) that justify one explicit click.

## Avoid when
The user just authenticated FROM this very invite link seconds ago — a second confirm is redundant (auto-join instead); or in multi-invite situations (use a pending-invites picker).

## Sad paths observed
Plane shows the signed-in email top-right so a wrong-account user can self-diagnose before joining; Attio keeps a "Sign out" link in the footer as the escape hatch.

## Accessibility
Single question + two buttons is screen-reader friendly; make the org name part of the heading; keep Accept as default focus, Decline reachable by tab.

## Default verdict for our stack
RECOMMENDED — one explicit Accept click for signed-in users, with org card, role shown (Plane), signed-in identity visible, and a "Not now" secondary.
