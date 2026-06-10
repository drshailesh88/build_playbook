# INDEX — multi-scope-settings-ia

## Coverage note
Sweep: 5 search_screens queries (2 by-app, 3 by-pattern) + 1 search_flows query, platform web only; 1 query dropped mid-call by the MCP transport and was retried with a rephrase. Stopped when the final query returned only navigation-switcher variants of already-captured patterns (Neon/Unity/Fibery/Dovetail). Apps swept: Vercel, Neon, OpenAI Platform, Linear, Amplitude, Retool, PlanetScale, Notion, GitHub, Cursor, Churnkey, GitLab, Clerk, WorkOS, Unity, Fibery, Dovetail, Toggl Track, Qatalog, Cycle, Maze.
NOT found / not observable: (1) URL structure for scope signaling — Mobbin screenshots crop the address bar, so the /[org]/[project]/settings convention is inferred from breadcrumbs only, not observed; (2) Slack and Stripe multi-scope settings did not surface in any query despite being named reference apps; (3) an explicit "you are editing TEAM settings, not project settings" interstitial/warning was not observed anywhere — apps rely on chrome, breadcrumbs, and H1s, never on confirmation dialogs; (4) inheritance display for rich/structured values (branding-like JSON, templates) was only observed as Churnkey's text-key table — no app showed template-level inherit/override UI.
Round-1 shells (full-page settings, grouped nav, Org vs Account zones) were deliberately NOT re-harvested.

## Patterns
- ★ scope-swapped-chrome.md — entire top-nav + sidebar swap per scope, H1 names the scope (Vercel, Neon). ★ default for sub-area (a) scope signaling.
- ★ breadcrumb-scope-switchers.md — header chain of switchable org›project tokens (Vercel, Neon, PlanetScale, GitHub, Unity). ★ default for sub-area (b) scope switching, app-wide.
- unified-settings-tree-scope-sections.md — one settings tree with labelled scope sections (OpenAI, Amplitude, Linear, Retool, Notion). Viable for Org+Account zones; does not scale to many events.
- ★ parent-allows-child-override.md — org-side "allow override" toggle + child-side "Default (controlled at the team level)" select (Vercel, Cursor, GitLab). ★ default for sub-area (c) inheritance display, enumerable settings.
- override-table-reset-to-default.md — key/value override table with per-row Reset to Default and overrides-only filter (Churnkey, single-app evidence). Companion for sub-area (c) on template/copy overrides.
- ★ resource-settings-entry-from-workspace.md — event settings as a tab inside the event workspace + org-settings roster table for admin actions (Vercel, Linear, Neon, Notion). ★ default for sub-area (d) entry point.
