# first-run-onboarding — Pattern Index

## Coverage note
Sweep executed 2026-06-10 via Mobbin MCP, platform `web` only (no iOS queries needed — web yield was rich).
- **Mode 1 (by-app): 6 queries** — Linear checklist, Notion getting-started, Attio setup, Airtable first base, Slack workspace, Asana/ClickUp first project. Apps captured: Google Workspace, Adaline, Outseta, Time2book, Mailchimp, Klaviyo, Notion, Attio, Airtable, Slack, Asana.
- **Mode 2 (by-pattern): 6 queries** (+2 retried after Mobbin 500 errors) — product tours, completion celebration, invited-member screens, template gallery, sample-data empty states, resume/finish-later. Apps captured: Zoho CRM, Salesforce, ClickUp, Navattic, Toggl Track, Otter.ai, Graphite, Remote, Alan, Linktree, Plane, Grain, Clay, Coda, PandaDoc, Microsoft Loop, Rive, Adobe Express, Webflow, Mixpanel, Productboard, Vercel, Render, SavvyCal, Uxcel, Fresha, Langdock, Wave.
- **Mode 3 (by-flow): 2 queries** — setup-checklist flows (Slite, Motion, folk, ClickUp 23-screen), invited-member flows (n8n, Charma, Maze). Stopped: final two probes returned only variants of already-catalogued patterns (dry per 2-consecutive rule).
- **NOT found (no silent truncation):** Linear's own onboarding checklist never surfaced despite a targeted query — Mobbin substituted lookalikes; the Linear-style claim rests on Adaline/Slite/Graphite analogues. Attio's post-wizard in-app checklist (if any) not captured — only its 5-step creation wizard. No app was observed offering a "restore checklist after dismissal" path — gap, not evidence of absence. "Apps dropped tours" is observed absence (no tours in the Notion/Attio/Airtable/Asana first-runs swept), not documented removal.

## Patterns
| Pattern | Sub-area | Verdict |
|---|---|---|
| ★ [setup-checklist-persistent-card](setup-checklist-persistent-card.md) — persistent dismissible checklist with auto-detected progress (GWS, Adaline, Outseta, Mailchimp, Klaviyo, Slite, Fresha, SavvyCal, Maze) | a | RECOMMENDED |
| ★ [deferral-and-resume](deferral-and-resume.md) — skip-for-now everywhere + saved progress + standing resume surface (Wave, Fresha, Klaviyo, Attio, Graphite, Langdock) | a | RECOMMENDED |
| ★ [guided-first-object-wizard](guided-first-object-wizard.md) — route admin straight into creating the core object, 2–4 steps, live preview (Asana, Airtable, Motion, ClickUp) | b | RECOMMENDED |
| ★ [multi-path-empty-state](multi-path-empty-state.md) — typed entry cards in every empty module: manual/import/sample (folk, Render, Vercel, Mixpanel, Productboard) | b | RECOMMENDED |
| [product-tour-tooltips](product-tour-tooltips.md) — chained anchored tooltips; legacy-CRM territory, absent from modern reference apps (Zoho, Salesforce, ClickUp, Toggl, Otter) | c | AVOID (no ★ — max one contextual tooltip per surface) |
| ★ [template-vs-blank-first-decision](template-vs-blank-first-decision.md) — template gallery with preview vs always-visible blank path (Airtable, Asana, PandaDoc, Loop, Coda, Vercel) | d | RECOMMENDED |
| [sample-data-prefill](sample-data-prefill.md) — labeled demo content in the empty tenant (Webflow, Mixpanel, folk, n8n, Maze) | d | VIABLE (needs inert-comms + one-click teardown guarantees) |
| [personalization-survey-drives-defaults](personalization-survey-drives-defaults.md) — use-case chips that seed templates/groups (Attio, ClickUp, folk, Maze) | b/d | VIABLE (fold into template step) |
| ★ [role-aware-onboarding-split](role-aware-onboarding-split.md) — invitee skips org wizard, profile-only setup, lands in populated workspace (n8n, Charma, Maze, Grain, Notion) | e | RECOMMENDED |
| [doc-as-onboarding](doc-as-onboarding.md) — pre-seeded interactive Getting Started doc (Notion only) | b/c | AVOID (medium ≠ our core object) |
| ★ [checklist-completion-retirement](checklist-completion-retirement.md) — confetti + "ready to fly" + explicit dismiss/remove (Mailchimp, Graphite, Remote, Outseta) | f | RECOMMENDED |
