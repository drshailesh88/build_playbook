# Pattern: Top-bar breadcrumb scope selector (org / project)
**Surface:** org-switcher · **Observed in:** Vercel, OpenAI Platform (refs: [Vercel two-column selector](https://mobbin.com/screens/3cafbfa5-2067-41a3-b344-95727589e012), [Vercel personal vs teams](https://mobbin.com/screens/9fbccbf8-cd2e-47f6-9a82-c441ee04afad), [Vercel empty team](https://mobbin.com/screens/946ed206-4fc2-48ab-8b9c-d5cdc107dc3a), [OpenAI Platform switch flow](https://mobbin.com/flows/9c66c1d5-05e0-4726-8d9a-8681b7ac31a8))

## Flow
1. Top navigation bar shows the current scope as a breadcrumb: `▲ / <Team avatar> Team Name [plan badge] ⌄ / Project ⌄`.
2. Clicking the caret opens a popover; Vercel renders two columns — left: "Find Team…" search, Personal Account section, Teams list with checkmark, "Create Team" footer; right: "Find Project…" search, Projects of the hovered/selected team, "Create Project" footer.
3. Plan badges (Hobby / Pro Trial) rendered inline on the scope itself.
4. OpenAI Platform: single-column "ORGANIZATIONS" list with checkmark; selecting swaps dashboard content in place instantly (URL-scoped org).
5. Org and project switch in one surface — choosing a team then a project deep-navigates directly.

## Use when
- Two-level tenancy (org → project/event) where users jump across levels constantly.
- Top-bar app shells without a permanent left sidebar.

## Avoid when
- Only one scope level exists — the second column is dead weight.
- Long org names: breadcrumb real estate is tight and truncates.

## Sad paths observed
- Empty team: right column shows "No projects, yet! This team has no projects." with "Create Project" as the only action (946ed206) — empty state lives inside the switcher.
- Search inputs appear above both lists, so >5 orgs/projects stays usable.

## Accessibility
- Caret is a discrete button separate from the name link; search-first popover supports type-ahead. Checkmark indicates active scope.

## Default verdict for our stack
VIABLE — the right answer if Event State surfaces org→event in the chrome; for a sidebar-shell desktop app the sidebar popover wins, but steal the search input and empty-state-with-CTA.
