# zero-data-empty-states — Pattern Index

## Coverage note
Sweep executed 2026-06-10 via Mobbin MCP, platform web only (web coverage was rich; no iOS queries needed).
- **by-app screen queries (5):** Notion new workspace / Linear empty project / Attio empty CRM / Airtable empty base / Asana new account / Monday+ClickUp onboarding (ClickUp returned no results — only monday.com screens surfaced; ClickUp is a coverage gap).
- **by-pattern screen queries (6):** analytics dashboard no-data + demo, explore-with-sample-data toggle, no-results-clear-filters, create-first-project CTA, connect-integration-to-unlock, empty events list, setup-checklist-progress, remove-demo-data.
- **by-flow queries (2):** new-workspace onboarding → empty dashboard w/ checklist (Apollo, Copilot, Causal, Google Workspace, Todoist); sample-data/demo flows (7shifts toggle, Mixpanel sample dataset + demo project, Amplitude demo, Neon import).
- **Dry-stop:** final two queries ("setup checklist progress dismiss", "remove demo data banner") returned only repeats/irrelevant screens — sweep terminated per 2-consecutive-dry rule.
- **NOT found / gaps:** ClickUp screens (zero hits); an explicit in-product "delete sample data" affordance (no app surfaced one — demo removal is always container-switch or manual delete); viewer/no-permission variants of empty states; auto-expiring seeded content; per-widget empty states on a true BI grid (Looker/Metabase-class apps did not surface). Two queries timed out once and were retried successfully in fast mode.
- One timed-out query ("feature locked until setup complete") was re-run in narrowed form; nothing was silently dropped.

## Patterns

### a) Empty dashboard/home for a new workspace
- ★ **embedded-setup-checklist-dashboard** — numbered, server-verified checklist replaces the widget grid until activation (Asana, Apollo, Copilot, Google Workspace, Causal, Langdock). RECOMMENDED.
- **hollow-widgets-per-widget-cta** — dashboard keeps its real frame; each widget shows its own zero state + the one CTA that feeds it (Amplitude, Neon, Asana, Attio, Notion, Linktree). RECOMMENDED.
- **threshold-gated-widget** — "Metrics will show after you create 10 clients (2/10 so far)" with progress + link (Copilot, single-app). VIABLE.
- **persistent-setup-progress-pill** — "2/6 first steps" pill in chrome, survives navigation (Attio, Chatbase, Deputy, Apollo, Assembly). VIABLE.

### b) Seeded next-action / sequenced module emptiness
- ★ **single-action-takeover-home** — nav stays, content collapses to one CTA: "Welcome to Posh! Create your first event" (Posh, Spline, Copy.ai, Adobe, Contra). RECOMMENDED — Posh is same-domain proof for Event State.
- **source-vs-derived-emptiness** — educational empty + create CTA where data is born; calm zen state where data flows in; dependency pointer upstream (Linear, Attio). RECOMMENDED.
- **import-or-create-dual-path** — first-record empty offers CSV/migration beside manual add; Neon shows the failure-handling shape (Attio, Linear, Airtable, Apollo, Neon). RECOMMENDED.
- **populated-preview-empty-state** — show a rendered, sample-populated mock of the module instead of a blank (Apollo, monday, Airtable, Ditto). VIABLE.

### c) Demo/sample data offers and their removal
- ★ **isolated-demo-sandbox-exit-banner** — demo lives in a separate container with a persistent "you are in demo / start with real data" banner; removal = abandon/delete container (Mixpanel, Amplitude, Plain, Causal, Databricks). RECOMMENDED.
- **segmented-starter-template-picker** — 4-7 use-case templates seed real editable structure, blank always offered (Airtable, monday, Mixpanel, Notion). RECOMMENDED (as event-type templates).
- **connect-or-demo-dual-cta** — primary "connect/create real" + secondary "try demo" + tertiary help/invite (Steep, Mixpanel, Amplitude). VIABLE.
- **demo-data-toggle** — inline switch repaints the real dashboard with fake data, instantly reversible (7shifts, single-app). VIABLE with watermark caveat.
- **seeded-onboarding-content** — workspace born containing tutorial artifacts built from product primitives (Notion, Causal, monday). VIABLE with count/listing-exclusion caveat.

### d) Empty search/filter vs true-empty
- ★ **filtered-empty-vs-true-empty** — cause-naming copy + Clear/Reset filters with chips preserved vs create-CTA; three-way split for analytics (query/range/not-instrumented); Todoist documented as the conflation anti-pattern (Midday, OpenSea, Going, Codecademy, Fey, Slite, Amplitude, June, Linktree). RECOMMENDED.
