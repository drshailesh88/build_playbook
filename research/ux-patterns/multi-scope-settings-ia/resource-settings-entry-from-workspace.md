# Pattern: Per-Resource Settings Entered from Inside the Resource Workspace
**Surface:** multi-scope-settings-ia · **Observed in:** Vercel, Linear, Neon, Notion (refs: [Vercel project Settings tab](https://mobbin.com/screens/c681207e-c335-4e34-96a2-018cfa69baff), [Linear team context menu](https://mobbin.com/flows/1e4490a5-133c-4c8a-9942-e5a9271c909b), [Linear team settings hub](https://mobbin.com/screens/4eb70285-08a0-4648-94fe-7cc07f602a7f), [Neon project sidebar](https://mobbin.com/screens/1662d1cc-c43f-4227-91f1-bf6652b2146e), [Notion teamspace list](https://mobbin.com/screens/733d7981-311a-487d-a0b3-fc30511763ae), [Notion teamspace row menu](https://mobbin.com/screens/18b129a4-7773-4197-9405-70e8b32415d3))

## Flow
1. Vercel: a project's settings live as the LAST tab of the project workspace's own tab bar ("Project · Deployments · … · Settings") — you configure the thing where you use the thing; the global settings tree never lists projects.
2. Linear: right-click/⋯ on a team in the app sidebar → "Team settings" jumps into the settings area, landing on a per-team hub page of grouped cards (General, Access and permissions, Members, Issue labels, Workflow…), with the team also listed under "Your teams" in the settings sidebar.
3. Neon: each project's left sidebar carries its own Settings item under the PROJECT group; org settings are a different sidebar at org scope.
4. Notion (counter-variant): teamspaces are administered as ROWS in a workspace-settings table (per-row Access dropdown, ⋯ menu with Join/View members/Duplicate) — light per-resource config stays inside the parent's settings instead of getting its own tree.

## Use when
- Per-event settings (module toggles, branding, sender display name) belong to event operators working inside that event — entry from the event workspace matches their mental model and our reference apps.
- Org admins still need a roster view: pair it with a Notion-style events table in org settings for cross-event administration (rename/archive/transfer), without duplicating the full per-event settings tree there.

## Avoid when
- A resource's settings are 1–2 fields — a whole settings tab invites scope creep; use an inline row editor (Notion variant).
- Resources are administered exclusively by central admins who never enter the workspace; then per-resource entry hides settings where admins won't look.

## Sad paths observed
- Vercel keeps destructive actions (Delete Project, Transfer) at the bottom of per-resource General settings with red-bordered cards and explicit irreversibility copy — danger zone stays inside the resource's own settings.
- Linear's settings hub shows per-card state summaries ("Slack notifications: Off", "1 member") so a misconfigured team is visible before clicking in.

## Accessibility
- Entry points are persistent tabs/sidebar items, not hover-revealed icons (Linear's context menu is a secondary shortcut, not the only path).
- Linear's hub cards carry descriptive subtext per destination — useful for screen-reader scanning of a settings catalog.

## Default verdict for our stack
RECOMMENDED — per-event settings enter from inside the event workspace (Vercel mechanic), with an org-settings events roster for admin bulk actions (Notion mechanic); do not graft events onto the org settings tree.
