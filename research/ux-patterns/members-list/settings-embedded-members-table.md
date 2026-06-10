# Pattern: Settings-embedded members table
**Surface:** members-list · **Observed in:** Linear, Vercel, Sana AI, Fibery, Exa, Coda (refs: [Linear](https://mobbin.com/screens/dbf2fc9a-64ad-482a-9a01-49c81bacdee4), [Vercel](https://mobbin.com/screens/a10e73e0-e3cd-4d17-a267-1d84051af6a8), [Sana AI flow](https://mobbin.com/flows/25e08ff3-d61d-44d9-ada3-d2d2e21ee493), [Fibery flow](https://mobbin.com/flows/8fafe082-2716-4c06-a7e1-937aba52bb4d), [Exa flow](https://mobbin.com/flows/2fb3b980-3b0a-43de-975c-d1a63454eff7), [Coda flow](https://mobbin.com/flows/7e68441c-3c40-4431-b4be-5b67cecabc3e))

## Flow
1. User opens Settings → Members (sidebar nav item inside settings shell).
2. Full-width table renders: avatar + name + email in first column; Role; metadata columns (Joined / Last seen in Linear; Account created / Last active in Sana; Invitation Status in Exa).
3. Search input ("Search by name or email" / "Filter...") sits directly above the table; primary "Invite" button top-right of the same header row.
4. Per-row actions live in a trailing overflow ("...") menu or inline role dropdown; row hover reveals them.
5. Sorting via column headers (Linear sorts Name; Coda sorts Workspace role).

## Use when
- Desktop-web B2B admin area with 4+ columns of member metadata (role, status, activity).
- Members management is an admin task, not a daily surface — settings placement matches user expectation in every reference app observed.

## Avoid when
- Member count is tiny and fixed (e.g., per-project collaborators) — a simple list card (Visitors-style) is lighter.
- You need members visible inside a working context (chat sidebars etc.), not a settings context.

## Sad paths observed
- Linear shows "Pending" / "(Invited)" inline on rows so half-onboarded states are never hidden ([ref](https://mobbin.com/screens/ae99a607-158a-4642-a69f-00c024381bd0)).
- Fibery row overflow exposes Deactivate / Change Email / Delete — destructive ops kept one level deep, never as bare row buttons.

## Accessibility
- Column-header sorting and a single search input are keyboard-reachable in all observed apps; overflow menus are standard menu-button affordances. No explicit announce behavior observable from static screens.

## Default verdict for our stack
RECOMMENDED — shadcn `<Table>` + TanStack in a settings route matches Linear/Vercel exactly and carries role, status, and row actions without invention.
