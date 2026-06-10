# Pattern: Accept/decline pair with consequence disclosure
**Surface:** invite-email · **Observed in:** GitHub, Pinterest, Attio, Plane, Loops, Otter.ai (refs: [GitHub](https://mobbin.com/screens/d9f1f83e-95dd-4f1d-9230-1b057f2162ea), [Pinterest](https://mobbin.com/screens/7abdc468-bc34-4fb4-ac8f-4246833e0063), [Attio](https://mobbin.com/screens/cc9ec9af-d3e9-4a89-af5e-0e7ddaf46779), [Plane](https://mobbin.com/screens/5baffb0d-0a98-4011-97e5-577a0e11afb9), [Loops flow](https://mobbin.com/flows/395dc637-04e7-44c6-9973-40b4fa9303ef), [Otter](https://mobbin.com/screens/c6a2effd-d510-40e9-8472-8b17689a245b))

## Flow
1. Accept is primary, decline is present but subordinate: GitHub "Join Mobmobdesign" + "Decline"; Pinterest "Accept invite" + "Decline invite"; Attio "Yes, take me there" + "Not yet"; Plane "Accept & Join" + "Go Home".
2. What-you're-agreeing-to is disclosed before accept: GitHub lists what org owners can see about you (2FA status, activity, access level, IP); Attio notes "By accepting this invite, you agree to Attio's Acceptable Use Terms"; Pinterest describes the access being granted.
3. Role visibility pre-accept: Plane shows the role on the invite card ("SG Mobbin — Member") before the user joins.
4. Variant: Loops delivers the invite as an in-app Accept/Reject toast when the invitee is already a user; Otter suggests joining a workspace matched on email domain with Join/Skip.

## Use when
- B2B invites that move a user into a tenant where admins gain visibility over them — disclose it, and always offer a decline that ends the flow politely.

## Avoid when
- Decline should not require an account or sign-in; GitHub/Pinterest keep it one anonymous click.

## Sad paths observed
- GitHub's "Opt out of future invitations from this organization" handles invite spam/harassment.
- Plane disables "Accept & Join" until the invitation checkbox/selection is made — no accidental joins.

## Accessibility
- Two clearly-labelled buttons with distinct text (never icon-only); disclosure is body text above the fold.

## Default verdict for our stack
RECOMMENDED — accept page shows org, inviter, assigned role, and a decline action; add a short "org admins can see your name and activity" line to fit our multi-tenant trust posture.
