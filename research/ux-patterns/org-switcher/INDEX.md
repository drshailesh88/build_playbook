# org-switcher — pattern index

## Coverage
- **Queries run:** by-app: "Linear workspace switcher dropdown sidebar menu", "Vercel team switcher scope selector top navigation bar dropdown", "Notion workspace switcher popover multiple workspaces accounts"; by-flow: "switch between workspaces or organizations". Platform: web only. Incidental switcher evidence also harvested from B1 flows (Air, Fibery, Base44).
- **Apps swept:** Linear, Vercel, Notion, Fibery, Air, Base44, OpenAI Platform, Employment Hero.
- **NOT found / excluded:** Slack's web workspace switcher (desktop-app left rail not represented in web results), Raycast (no web presence on Mobbin for this surface), Stripe's account picker (not surfaced in queries run). Switch *behavior* evidence: instant in-place swap observed in OpenAI Platform/Linear/Notion; full reload observed in Employment Hero — no app observed showing a loading interstitial between orgs.

## Patterns
- ★ `sidebar-header-popover` — org card + workspace list + create/join footer at the top of the sidebar (Notion, Base44, Air). **Recommended default** — matches our shadcn sidebar shell and Better Auth `setActive` in-place switch.
- `account-menu-submenu` — "Switch workspace ▸" nested in the workspace/account menu with keyboard chords and numbered shortcuts (Linear, Fibery). VIABLE; steal the shortcut hints.
- `topbar-scope-selector` — breadcrumb org/project two-column popover with search and plan badges (Vercel, OpenAI Platform). VIABLE if org→event lives in the chrome.
- `searchable-org-panel-reload` — dedicated searchable panel, full reload on switch (Employment Hero). AVOID for our org-count profile.
