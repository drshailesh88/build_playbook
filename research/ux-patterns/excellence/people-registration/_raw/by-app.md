# BY-APP Raw Harvest — People/Registration Tables (admin people database)

Job-to-be-done: manage a large people/registrant database — table views, search/filter/saved
views, record detail with history, CSV import, dedup/merge, bulk ops.
Source: Mobbin MCP (search_flows + search_screens). Every entry cites a mobbin_url. Only observed patterns recorded.
Date: 2026-06-11

---

## Attio (web)

### A1. Flow: "Switching view" + "Sorting companies" (saved views as first-class objects)
- Mobbin URLs: https://mobbin.com/flows/eb12a5f8-d2c3-4b72-bd44-5187b76aa36a , https://mobbin.com/flows/ba9faa69-a275-4e70-ab76-c4ae1b1f946c
- Steps observed:
  1. Table header: colored view chip ("All Companies", green dot) → dropdown: search box ("Search views..."), list of saved views with type icons, "+ Create new view" footer action.
  2. Toolbar row beneath: "Sort" chip + "Filter" chip; an applied state reads "Sorted by Last interaction" + "Advanced filter 3" (count badge).
  3. Changing sort/filter on a saved view makes the view DIRTY: top-right shows "Discard changes" + "Save ▾" until resolved — edits to a shared view are explicit, never silently persisted.
  4. Sort popover: field row + direction select (Descending) + "× remove" + "+ Add sort" (multi-key sorting) + "Learn about sorting" link.
  5. Bottom row: record count ("13 count") and per-column "+ Add calculation" (aggregations along the table footer).
- Problem solved: views are shareable, named query objects; ad-hoc exploration never corrupts a teammate's saved view.
- Sad path: none visible beyond dirty-state guard.

### A2. Column header menus (per-column manipulation in place)
- Same flows as A1 (screens 6–8 of ba9faa69).
- Observed menu items: Sort ascending / Sort descending / Move left / Move right / Formatting ▸ / Edit column label / Hide from view.
- Problem solved: column-level control without a settings page; "Hide from view" is per-view, not destructive.

### A3. Flow: "Company detail" (two-pane record page with activity timeline)
- Mobbin URL: https://mobbin.com/flows/723a0c99-c91a-486b-816b-9ebe1f2bd387
- Steps observed:
  1. Record page header: avatar + name + favorite star; quick actions "Add to List", "Run workflow", "Compose Email"; breadcrumb back to Companies; prev/next record arrows ("1 of 1 in Stage → Meeting") for stepping through the parent list without going back.
  2. Left pane tabs: Activity / Emails (count badge 73) / Team / Notes / Tasks / Files.
  3. Activity tab = timeline grouped by week: "Alex Smith changed Stage and 7 other attributes" expands to field-level diffs (Stage → Meeting, Priority → Medium, Owner → Alex Smith, Estimated contract value → $50,000.00 …) with a "Hide all changes" collapse; system events ("sweetgreen was created", "sweetgreen.com was added to Domains", "Alex Smith first contacted sweetgreen") interleaved.
  4. Right pane: "Details" tab — Record Details card with inline-editable attributes (Domains, Name, Description, Team, Categories) + "Show all values"; "Lists" card showing memberships of this record in lists with per-list attributes (Stage, Owner) editable in place.
  5. Team tab: related people with "+ Add Person", email + "No Job title" placeholder chips.
  6. Files tab empty state: illustration + "No files found — Drag and drop a file here to upload or browse to choose a file." + "Upload file" button.
- Problem solved: one page answers "who is this, what happened, what's connected" — history is field-level and human-readable, not a raw audit dump.

### A4. Flows: "Editing an attribute" / "Archiving an attribute" (schema editing with undo)
- Mobbin URLs: https://mobbin.com/flows/32f2c759-9915-4320-8cb7-48984d406fcb , https://mobbin.com/flows/f636d144-d5a9-4868-9d4c-71bdb39672d0 , https://mobbin.com/flows/68010b7b-10dc-46bf-a183-5f3f419d9075
- Steps observed:
  1. Settings → Objects/Lists → Contacts → Attributes tab: table of attributes (Name/Type/Attribute properties/Constraints), System badges on built-ins, Unique/Required constraint chips, search + Filter + "Create attribute" button.
  2. Attribute modal: Type (locked after creation, greyed), Name, Description, options list with drag-reorder; per-status submenu (Confetti toggle, "Time in status" days target, Copy status ID, Delete status).
  3. Per-attribute ⋮ menu: Edit / Duplicate / Copy ID / Copy slug / Archive attribute (red).
  4. Archive → toast bottom-right "Status (2) attribute archived — Undo"; archived attributes collapse into an "Archived" expandable section, restorable.
- Problem solved: admins extend the schema without a developer; archive-not-delete + undo makes schema edits reversible.
- Sad path: destructive schema action is soft (archive + undo toast), never hard delete.

### A5. View settings panel (kanban variant) — attribute visibility per view
- Observed in Sales list (Pipeline view): "View settings" → Grouped by Stage, Visible columns 8, "Show attribute labels" toggle, Visible attributes checklist (Close confidence, Estimated contract value, Projected close date, Owner, Company > L… > When), "+ Add card row".
- Problem solved: same record set, per-view presentation config; board cards are configurable mini-tables.

## Airtable (web)

### B1. View toolbar + view sidebar (the canonical table-view chrome)
- Mobbin URLs: https://mobbin.com/flows/3c8b481b-50b3-461f-8f1b-097c30766101 (download CSV), https://mobbin.com/flows/ed0e54dc-e653-4ca0-992b-a6b9e86be4b0 (adding a field)
- Steps observed:
  1. Toolbar: Views toggle | view name | Hide fields | Filter | Group | Sort ("Sorted by 1 field" applied-state chip, amber) | Color | row-height | Share and sync. Applied controls show count in the chip.
  2. Views sidebar: "Find a view" search, view list with checkmark on active, "Create..." section listing view types (Grid/Calendar/Gallery/Kanban/Timeline/List/Gantt/Form, some plan-gated with "Team" badges).
  3. View context menu: "Collaborative view — Editors and up can edit the view configuration" vs "Assign as personal view" (Team badge), Rename view, Edit view description, Duplicate view, Copy another view's configuration, **Download CSV**, Print view, Delete view (red).
  4. Footer: per-column aggregation cells (Sum $37,064.10, Avg $1,764.96) + record count ("21 records").
  5. Global "All changes saved" indicator in the top bar; destructive ops produce an undo snackbar ("Base moved to trash — UNDO").
- Problem solved: per-view export (Download CSV exports what the view shows — filters applied), personal vs shared views split the Attio dirty-state problem differently.

### B2. Field creation & field menus
- Mobbin URL: https://mobbin.com/flows/ed0e54dc-e653-4ca0-992b-a6b9e86be4b0
- Steps observed:
  1. "+" at end of header row → popover: name input, searchable field-type list (URL/Number/Currency/Percent/Duration/Rating/Formula/Rollup/Count/Lookup/Created time/AI), inline help tooltip with example per type, type-specific config (Precision: Days), "+ Add description", Create field.
  2. Field header ▾ menu: Edit field, Duplicate field (modal with "Duplicate cells" toggle), Insert left/right, Configure date dependencies, Copy field URL, Edit field description, Edit field permissions, Sort A→Z shortcuts, **Filter by this field**, **Group by this field**, Hide field, Delete field (red).
- Problem solved: "filter by this field" / "group by this field" from the column header collapses the distance between seeing a column and pivoting on it.

### B3. CSV ingress/egress details
- "Download CSV" lives in the view menu (B1) — export is view-scoped.
- CSV with attachment columns → warning dialog "Attachment links expiring — This CSV contains attachment columns with links that expire after a few hours" + don't-show-again checkbox. Honest egress caveats.
- Import side panel ("Import your work"): Google Sheets / Paste data / Excel / CSV / Other as equal first-class sources; "Quickly upload" is one of four entry cards on Home ("Easily migrate your existing projects in just a few minutes").
- Toast "Preparing CSV for download..." for async export.

(Column-mapping step of Airtable CSV import not found in flow search round 1 — retry in by-pattern/by-flow sweep before declaring gap.)
