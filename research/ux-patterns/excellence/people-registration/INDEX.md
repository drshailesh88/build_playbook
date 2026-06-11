# Pattern Library Index — people-registration (EXCELLENCE harvest)

Job-to-be-done: manage a large people/registrant database for events — table views,
search/filter, record detail with history, CSV import, dedup/merge, bulk ops, event rosters.
Harvested: 2026-06-11 · Mode: EXCELLENCE (ceiling, not oracle fidelity) · Raw notes: `_raw/`

## COVERAGE NOTE (honesty first)

**Swept:** web platform only, via Mobbin MCP. Three modes, loop-until-dry (final round
yielded only saved-views variants → declared dry):
- **by-app:** Attio, Airtable (named references) — plus incidental deep coverage of Front,
  folk, Clay, Square, HubSpot, Pipedrive, Luma, Notion, Fibery, Neon, Sprig, Apollo,
  Workable, AutoSend, Copy.ai, Wix, Klaviyo, Remote (surfaced by pattern/flow queries).
- **by-pattern:** saved views, filter builders, column menus, CSV column mapping, value
  reconciliation, duplicate merge, bulk selection, enrichment/data health, import
  history/revert, dynamic segments.
- **by-flow:** guest-list management/approval/check-in (Luma), quick-create contact
  (Front/Pipedrive/HubSpot), import data (Pipedrive).

**NOT swept (be honest when consuming):** iOS apps; Eventbrite Organizer specifically
(Luma stood in for event-roster admin); command-palette/global person search (Attio ⌘K
observed in chrome but not walked); column pinning/resizing micro-interactions;
pagination variants (infinite vs numbered); print/badge layouts; offline check-in.
**First-principles candidates (thin on Mobbin):** faculty-vs-delegate role-footprint
views (GEM-specific concept — no excellence app models "role = footprint across tables");
anonymize/GDPR flows (only GEM has it as UI); multi-event person linkage.

## Cards (17) — ⭐ = recommended default for EventState V1

| Card | One-liner | Verdict |
|---|---|---|
| ⭐ filter-builder-progressive | Quick dropdowns → chips → advanced groups; live count; filtered-empty rescue | RECOMMENDED (tiers 1–2 in V1) |
| ⭐ bulk-selection-toolbar | Count-bearing toolbar; bulk edit/tag/export; undo for soft, confirm for hard | RECOMMENDED (old app has zero) |
| ⭐ duplicates-detection-queue | Standing auto-detected dup queue w/ badge, ignore, merge-all | RECOMMENDED (findDuplicates exists, 0 callers) |
| ⭐ merge-preview-conflict-resolution | Merged-result preview, per-conflict pickers, "cannot be undone" up front | RECOMMENDED (replaces UUID paste) |
| ⭐ import-wizard-stepper | Upload→Map→Review→Preview; auto-match counts; sample data; mandatory checklist | RECOMMENDED (GEM skeleton close) |
| ⭐ import-value-reconciliation | Raw CSV values reconciled to canonical options pre-insert | RECOMMENDED (kills BUG-4r class) |
| ⭐ import-history-and-revert | Per-import counters (added/updated/merged/skipped), history, 48h bounded revert | RECOMMENDED (revert = V2) |
| ⭐ view-scoped-export | Export next to Import; current view → CSV; async + caveats; audit-logged | RECOMMENDED (NEVER-ATTEMPTED in old app) |
| ⭐ activity-timeline-field-diffs | Grouped per-save diffs, resolved actor names, import/merge provenance | RECOMMENDED (audit data already exists) |
| ⭐ record-two-pane-detail | Tabs left, attribute rail right, prev/next stepping with list context | RECOMMENDED |
| ⭐ quick-create-panel | Side-panel create, at-least-one-contact gating, create-and-add-another | RECOMMENDED |
| ⭐ guest-list-at-a-glance | Count-vs-capacity bar, status chips, inline approve/decline on roster | RECOMMENDED |
| ⭐ undo-archive-not-delete | Instant archive + undo toast; confirm only the irreversible; Archived view | RECOMMENDED |
| ⭐ empty-states-twin-cta | Zero-data vs filtered-empty vs scoped-empty, each actionable | RECOMMENDED |
| saved-views-as-objects | Named shareable views, dirty-state Save/Discard, personal vs collaborative | VIABLE (V2; hardcoded chips OK for V1) |
| column-header-menu | Per-column sort/hide/pivot menus | VIABLE (when columns grow) |
| dedicated-checkin-surface | Search-first door-staff page; honest early check-in | VIABLE here / cross-ref check-in module |
| segments-dynamic-membership | Criteria-defined cohorts w/ live count; lists vs segments split | AVOID V1 / V2 bridge to comms |
| data-health-enrichment | "N missing email" dashboard linking to rows; bulk fix | VIABLE V2 (strip 3rd-party enrichment) |
| footer-aggregations | Per-column calc slots + live counts | AVOID V1 (count already shipped) |
| custom-attributes-admin | Tenant-extensible schema w/ locked types, archive+undo | AVOID V1 (SYSTEM scope-risk) |

(21 cards total; 17 with a non-AVOID default.)

## Consumption rule
These are CANDIDATES. Project choices happen in the founder grill over
`.planning/ux-patterns/excellence/PEOPLE-REGISTRATION.WOW-DELTA.md`; each accepted item
becomes a DEC citing the card. Builders implement DECs, never this index.
