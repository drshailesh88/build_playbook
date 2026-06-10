# Pattern: Shareable invite link alongside email invites
**Surface:** invite-member · **Observed in:** Linear, Notion, Slack, Vercel, Fibery, Current (refs: [Linear](https://mobbin.com/screens/00824d88-3866-4c22-9b9a-192223c98ad9), [Notion](https://mobbin.com/screens/3a09a6c6-0ce8-483c-96be-73eee6df207e), [Slack modal footer](https://mobbin.com/screens/25019c93-8f16-4c0c-a8c5-b7343f8ebf25), [Vercel link modal](https://mobbin.com/screens/d08df551-20b7-402c-aa3f-e96c23d5a728), [Fibery flow](https://mobbin.com/flows/8fafe082-2716-4c06-a7e1-937aba52bb4d), [Current flow](https://mobbin.com/flows/a081cb1c-ffb7-436e-b1b1-387a829e9f74))

## Flow
1. An "Invite link" block with an on/off toggle sits above or inside the invite surface (Linear/Notion: top of Members settings; Fibery/Current: inside the invite form; Slack: "Copy invite link" link in the modal footer).
2. Enabled state reveals the URL read-only + "Copy" button.
3. Regenerate affordance invalidates the old link: Linear refresh icon, Notion "generate a new link"/"reset the link", Vercel "Reset Invite Link", Current refresh icon.
4. Joining via link lands on a sign-up/sign-in page pre-framed with the org name ([Todoist flow](https://mobbin.com/flows/43a1c29d-3cde-4e1f-8dbe-26d4699febf8)).

## Use when
- Inviter doesn't have everyone's email (contractors, on-site event staff) or wants to drop one link in an existing channel.
- Default role for link-joiners is the lowest-privilege role.

## Avoid when
- Role must be assigned per person at invite time — links grant a single implicit role.
- Compliance-sensitive tenants: anyone holding the link can join until rotated; if offered, the toggle must default off.

## Sad paths observed
- Every implementation pairs the link with reset/rotate — leak recovery is built in, never an afterthought.
- Notion scopes visibility: "Only people with permission to invite members can see this link."

## Accessibility
- Read-only input + explicit Copy button (not click-to-copy on the text) is the accessible shape all apps use; toggle has a visible label.

## Default verdict for our stack
VIABLE — strong v1.5 addition for event-staff onboarding, but ship email invites first; if built, default off, lowest role, with rotate + per-tenant disable.
