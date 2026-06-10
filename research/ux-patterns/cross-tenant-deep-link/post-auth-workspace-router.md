# Pattern: Post-Auth Workspace Router
**Surface:** cross-tenant-deep-link · **Observed in:** Slack, Hex, Linear, Current, Plain, Steep, Runway (refs: [Slack welcome-back](https://mobbin.com/screens/464e7e5b-0702-4b26-8028-784ec3235c40), [Slack welcome-back v2](https://mobbin.com/screens/2eaef962-a178-4ff2-bda2-80c8c83545d1), [Hex choose-workspace with roles](https://mobbin.com/screens/3ba1c251-53e1-4628-9ddd-985a3e379024), [Linear "You have access to these workspaces"](https://mobbin.com/screens/68b1b551-7599-4286-8647-f9e4e1f72a91), [Current choose-workspace](https://mobbin.com/screens/cc50f62c-513d-4a69-bcf2-206973cc4542), [Plain choose-workspace](https://mobbin.com/screens/86cf33f8-139b-487c-8bf4-cb0951ee00ff), [Steep workspaces](https://mobbin.com/screens/a3098517-393e-4403-b1cd-22f3e88043b6), [Runway select-workspace](https://mobbin.com/screens/228d6f10-a4f2-45e9-82c8-a46cf52f1bde))

## Flow
1. User authenticates (or arrives already authenticated without a resolvable destination).
2. Full-page interstitial lists every workspace the signed-in identity can access — "Workspaces for jsmith.mobbin@gmail.com" (Slack), with member counts (Slack, Hex, Plain) and the user's role per workspace (Hex: "You are an Admin / You are an Editor").
3. Each row has an explicit Open / Launch / Join action.
4. Escape hatches below the list: "Create another workspace", "Not seeing your workspace? Try a different email" (Slack, Hex), "Log out" (Linear, Steep), "Check invitations" (Current).
5. User picks a workspace → lands inside it as the active tenant.

## Use when
- The deep link's target org is ambiguous, or the user hit a tenant-less entry point (root URL, expired context) while belonging to multiple orgs.
- As the recovery destination when a cross-tenant link can't be resolved — better than a dead 403.
- Showing the user's role per org (Hex) when role determines what the link will do.

## Avoid when
- The link fully identifies one org the user belongs to — forcing a chooser on every deep link adds a click that Slack/Notion avoid. Route directly and confirm instead.
- The user belongs to exactly one org — auto-route, don't show a one-item list (Plain shows a one-item list; it reads as friction).

## Sad paths observed
- Workspace was deleted while away: Current shows the chooser with a toast "Your workspace has been deleted" — user is re-routed instead of stranded ([ref](https://mobbin.com/screens/cc50f62c-513d-4a69-bcf2-206973cc4542)).
- No workspace matches the email: Slack/Hex offer "try a different email" inline rather than dead-ending.
- Plain states "You are a member of 1 workspace... you might need someone to invite you" — sets expectations when the list looks wrong.

## Accessibility
- Full-page, single-purpose layout; workspace rows are large click targets with text labels (not icon-only).
- Slack pairs each row with an explicit labeled button ("Launch Slack", "Open") rather than relying on row-click alone.
- Role text on rows (Hex) communicates state without color alone.

## Default verdict for our stack
RECOMMENDED — as the fallback/landing chassis (Better Auth session without activeOrganizationId, or unresolvable link); composes with DEC-057's fail-closed gate as the place the gate sends multi-org users.
