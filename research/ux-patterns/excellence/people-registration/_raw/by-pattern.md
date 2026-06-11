# BY-PATTERN Raw Harvest — People/Registration Tables

Source: Mobbin MCP. Date: 2026-06-11.

---

## Pattern hunt: duplicate merge

### Front — "Merging contacts" (side-panel merge with explainer)
- Mobbin URL: https://mobbin.com/flows/6cd12873-6ff6-401c-a5d0-e312ea3be131
- Contact list (Shared contacts) → select contact → Contact Details side panel → merge entry → "Review your merge" panel:
  - Info box "How does merging work?": "Fields that can have multiple values (like handles) are all preserved. If there are conflicting values for a unique value field (like the name), you'll get to pick the one to keep. **Merging cannot be undone.**" + LEARN MORE link.
  - Amber banner "⚠ 1 conflict found for name"; conflicted field rendered as dropdown on the merged preview (pick John vs Jordan); multi-value fields (emails, phones) listed all-preserved.
  - Footer: Cancel / Merge. Result: merged contact shows both emails comma-joined in list row.
- Notable: merge preview IS the future record, not a 3-column diff table.

### folk — "Merging duplicate contacts" (dedicated Duplicates queue, auto-detection)
- Mobbin URL: https://mobbin.com/flows/b4c3bac2-0e97-461c-bd67-3a18e4fd2981
- Sidebar nav item "Duplicates" with count badge (1). Page: "We've detected 1 possible duplicate contact. You can merge them into one contact."
- Layout: two source cards side-by-side (each shows the differing fields: one has Email+Company+Phone, other has Phone only) + a third "merged result" card with per-field-value checkboxes (1 Companies ☑, 1 Emails ☑, 2 Phones ☑☑ — keep both) and star icons to mark primary value.
- Actions: "Don't merge" / "Merge" (black, primary).
- Empty state after merge: "No duplicate in your contacts now — Our algorithms are constantly running to detect duplicates in your contacts list. If found, they will appear on this page."
- Success toast bottom-right: "Jane Smith has been merged — Open profile" link.
- Also observed (folk, applicants table): top-of-table quick actions "+ Add people · Email all · Enrich all"; sidebar shows live progress "Enriching 28 contacts" with bar.

### Clay — "Merging contacts" (multi-select → Merge with keyboard shortcut)
- Mobbin URL: https://mobbin.com/flows/78502e69-41ed-4e62-86f5-66cf2f7298d2
- People list: checkbox multi-select of 2 records (two "Alex Smith" rows) → context menu: Add to Group (L), Copy email addresses, Copy phone numbers, **Merge People (M)**, Archive People (E).
- Post-merge: one record remains; right panel SOURCES section shows BOTH emails retained; timeline keeps both histories.
- Provenance details: timeline entries "Jane imported via Bulk Import", "Alex imported via Email"; an auto-created group "CSV Import - 2025-02-24" per import batch.

### Square — "Merging duplicates" (review queue + Merge All)
- Mobbin URL: https://mobbin.com/flows/f4ebc84b-57c8-4696-8741-d6205c58241b
- Customer directory header: "Group: All Customers ▾ · ① 1 Duplicate Suggestion >" inline link chip.
- "Review Duplicates" full page: duplicate sets grouped under the matched name ("Alex Smith"), each set lists candidate rows with distinguishing columns (email, phone), per-set actions Ignore / Merge, global "Merge All" primary button.
- Confirmation page "Merge Successful — 1 duplicate proposal was successfully merged" with ✓ check, merged record row + "Edit" link.

## Pattern hunt: CSV import column mapping

### Attio — 4-step import wizard with VALUE-LEVEL reconciliation
- Screens: https://mobbin.com/screens/66a5a32c-0b06-4b83-b48b-d96cb4da4e12 , https://mobbin.com/screens/3d54a03b-1f64-4145-9207-578d9cb34e6a , https://mobbin.com/screens/de2ec449-2208-4989-9b59-2f58c1a0fc5c , https://mobbin.com/screens/6ae4cc88-67ec-4f2c-9e32-d98e5f7e0973
- Stepper across top: 1 Upload file → 2 Map columns → 3 Review values → 4 Preview import. Filename shown as page title (invitees.csv). "Start over" always available next to Continue.
- Map columns: rows = File column → "Select attribute" dropdown; mapped ones show attribute icon + name with × to unmap; ambiguous/duplicate mapping shows ⚠ (two columns mapped to same "Name" attribute both get amber warnings); right rail = live "Data preview" of the selected column's values ("This preview shows only a portion of the column values"). Option "Map unique attributes" hint at top.
- **Review values step (the differentiator):** for select/category attributes, raw CSV values are reconciled against existing options — left rail lists columns with status dots, main pane "Needs review 3": each raw value (R&D, Sales, Support) → mapped-value picker (search existing options like "Accounting", "Market Research") OR "+ Create 3 missing select options" bulk action; per-row undo/skip controls. Sorted-by-Raw-value toggle.
- Import history lives in Settings ("Import history" nav item, also surfaced as tab on object settings: General / Attributes / Permissions / Integrations / Import history).

### Clay — single-screen import (config left, live preview right)
- Screen: https://mobbin.com/screens/bb348fea-3889-455d-b06c-6de93abca2ad
- Left: file card with "Remove file", Delimiter select (Comma), ☑ "First row contains column names", mapping rows "Clay table columns ← CSV column headers" selects with red asterisks on required, per-row delete, "+ Create column" inline, Save.
- Right: full 20-row preview table rendering the mapping result live.

### AutoSend — mapped/unmapped counters + compliance gate
- Screen: https://mobbin.com/screens/ecb994a6-1de0-46a4-9a80-5774130e8065
- "Map the fields" step: summary chips "✓ 8 Mapped · ⚠ 0 Unmapped"; right-aligned "We found 5 contacts to import"; table FIELD FROM CSV / PREVIEW DATA (one sample value) / MAP TO FIELD dropdown per row, ✓ on resolved rows.
- Permission attestation checkbox before import ("I have the permission to email all contacts in this file. This list was not purchased, rented, or scraped.") + "START IMPORTING" + note "Your duplicate contacts will override".

### Workable — mandatory-fields checklist rail
- Screen: https://mobbin.com/screens/2b9586cc-f107-451b-b72c-73b7a8733a6e
- Modal wizard, left step rail (Upload CSV ✓ / Map fields / Map values / Select employees). Banner "⚡ Matched 3 fields" (auto-match count). Rows: COLUMNS (22) with sample value under each name → PROFILE FIELD select with × to clear.
- Right rail "Mapping Mandatory fields": checklist (First name ✓, Last name, Work email, Job title, Start date) ticking live as you map — import gated on completing the checklist.
- Note Workable also has step "Map values" — same value-reconciliation idea as Attio.

### Copy.ai — 3-column mapping modal
- Screen: https://mobbin.com/screens/0ff9041a-e81a-404a-b4a0-38fa42ffc2cb
- UPLOADED COLUMNS / SAMPLE DATA (two stacked examples per column) / TEMPLATE COLUMNS dropdown + trash per row; Previous/Next footer.

## Pattern hunt: bulk selection & actions

### Notion — floating selection toolbar with bulk property edit
- Mobbin URL: https://mobbin.com/flows/30b98bed-ae6c-4b9d-bf43-b03193211e1f
- Checkbox-select rows → toolbar appears above table: "2 selected | <property buttons: User characteristics, Date> | 🗑 | ⋯" — properties are directly bulk-editable from the selection bar.
- Delete → black toast bottom-center "Moved to trash — Undo".

### Fibery — Actions button with selection count
- Mobbin URL: https://mobbin.com/flows/4cb8c8fc-f057-41f5-9dc5-4c5deb7e53a9
- Select rows → header button "Actions (5 Problems)" → menu: Convert to…, Duplicate, The Big Red Button, Delete. Count always visible in the button.

### Neon — destructive bulk delete with explicit confirm modal
- Mobbin URL: https://mobbin.com/flows/09eadbd7-fd3a-4694-a70b-f3cc3ca1d888
- Select rows → red "Delete 1 record" button in toolbar → modal "Confirm deletion of selected records — You are about to **permanently** delete the selected records from the dataset" Cancel / Delete records (red).

### Sprig — bottom floating selection pill
- Mobbin URL: https://mobbin.com/flows/c75267ec-4dec-4717-b8b6-3ebb2034f866
- Users table: select N rows → floating bottom pill "5 users · Add to Manual Group · ×". Primary list-level action "Upload CSV" (yellow) top-right; "Filter Users ▾" left.

## Pattern hunt: filter builder

### Notion — chips for simple, nested groups for advanced
- Mobbin URLs: https://mobbin.com/flows/3250dd04-9241-4db0-843a-51e4a8a5bf34 , https://mobbin.com/flows/f69ff737-7883-4c07-85d1-ede0488fd093
- Filter icon → property picker ("Filter by…" search, property list, "+ Add advanced filter" escape hatch).
- Simple mode: each filter is a CHIP under the toolbar ("User characteristics: Not … ▾" + "+ Add filter"); chips editable in place.
- Advanced mode: "N rules ▾" chip → popover with Where/And rows (field / operator like "Contains", "Is not empty" / value), "+ Add filter rule", "Add filter group — A group to nest more filters" (nesting), Delete filter.
- Filtered-empty state: table shows "Edit filters" + "New page" inline actions instead of dead end.

### Clay — Where/And rows with filter groups + live row count
- Mobbin URL: https://mobbin.com/flows/a91dfb3c-c3d9-4a31-bca7-261f27332669
- "Filter" toolbar item → popover rows: Where/And | field select | operator (equal to) | value input | ⋯; footer "+ Add Filter" and "+ Add Filter Group". Applied state chip "1 Filter". Status bar live-updates "5 Rows, 0 Selected".

### Attio — advanced filter (flow ref, consistent with A1)
- Mobbin URL: https://mobbin.com/flows/b70ccea5-109c-4b46-b964-9510aa9e0a91
- Filter chip → conditions; applied state renders "Advanced filter N" chip; dirty saved view triggers Save/Discard (see by-app A1).
- Attio workflow-builder filter block also observed (Condition: "Record > Country is not <Select country>" with searchable value picker) — same condition grammar reused across product.

## Pattern hunt: enrichment / data health

### Apollo — data health center dashboard
- Mobbin URL: https://mobbin.com/flows/7ec939cf-1a63-451d-8c3f-9c2f80b970f3
- "Data enrichment" page, "Data health center" tab: donut cards (Job changes: 74% up-to-date / 9% need enrichment / 17% unknown; Missing emails; Credit usage), each card has "View contacts" + "Schedule" actions; "Enrichment job activity" log; "Automate Enrichment ▾" CTA; scheduled-jobs counter.
- Pattern: the database advertises its own completeness ("N records missing email") and links straight to the affected rows.

### Clay — per-column enrichment panel ("Add data")
- Mobbin URL: https://mobbin.com/flows/5c821a07-3a83-489a-a180-d748eaca1300
- "Add data" → panel: categories left (Company Data, People Data, Emails, Phone Numbers, AI & GPT, Scraping…), providers, "Waterfall" tab (recommended provider sequence per data point: Employee Count, Revenue, Description…), "Recipes" tab of composed enrichments. "Enrich Data" button top-right of table.

### HubSpot — bulk enrich from selection + coverage preview
- Mobbin URL: https://mobbin.com/flows/0f99578e-b531-401b-86cd-8b50ccbeb5f2
- Contacts table: selection toolbar "2 contacts selected — Enrich records · Assign · Edit · Delete · Create tasks · Enroll in sequence · More ·  ×".
- "Data enrichment coverage" slide-over before running: match rate %, counters (selected / eligible / matched), "Coverage by Contact property" list, ☑ "Overwrite all values when enriching", credit-limit error state ("Credit limit reached… Buy Credits"), disabled "Enrich records" until eligible.
- HubSpot contacts chrome also observed: saved views as TABS across the top (All contacts / Newsletter subscribers / Unsubscribed / All customers / USA customers, "+ Add view (5/5)" with cap, "All Views"), quick-filter dropdown row (Contact owner / Create date / Last activity date / Lead status / More / Advanced filters), Data Quality button, Import + Create contact split, "25 per page ▾".

## Pattern hunt: import history / revert (sad paths)

### Pipedrive — import history with 48h revert + per-import breakdown
- Mobbin URLs: https://mobbin.com/flows/7338268f-021e-412f-a4c2-fae6e36bf06a , https://mobbin.com/flows/041cbcfd-0a61-451e-995a-8c5d09713f26
- "Import data" page tabs: New import / Import history. New import: "Import from spreadsheet" + drag-drop + "Download a sample file (.XLSX, .CSV)"; "Import from other software" partner path.
- Import history: "SUMMARY OF YOUR LAST IMPORT" card — filename, importer avatar + name, timestamp, counters "+52 Items added [View] · 0 Items updated · 0 Items merged · 0 Rows skipped", **Revert** button.
- "Past imports (last 30 days)" table: file, date, user, type icons, status, Details, per-row Revert. Copy: "Imports can be reverted within 48 hours after their upload."
- Import detail: tabbed created-records breakdown (Deals 12 / People 12 / Organizations 12 / Activities 12 / Notes 4) with red Revert + Close.
- Sidebar "Tools": Import data / Export data / **Merge duplicates** / **Restore data** as permanent first-class tools.

### Remote — upload history with error badges
- Mobbin URL: https://mobbin.com/flows/26fb94ff-71e9-44ea-a21d-6aa6cd5fdb94
- "Bulk upload" split-button → "View upload history". History table: upload date, counts (uploaded / successful / incomplete), red "CONTAINS ERRORS" badge on bad batches, initiated-by avatar.

## Pattern hunt: dynamic segments (dry-check round — variants of saved-views family)

### AutoSend — Lists vs Segments as first-class types
- Mobbin URL: https://mobbin.com/flows/bd72f575-7436-4a2c-8fff-4f46b2e7da06
- Contacts page tabs "Lists & Segments" / "Custom Fields"; table rows typed GLOBAL LIST / SEGMENT / LIST with per-row contact counts. "Create ▾" → New List / New Segment.
- "Create Segment" modal: name, source list select, criteria rows (Field / Condition / Value) + "+ ADD FILTER", live "0 matching contacts" count while building. Toast "Segment created successfully!".

### Wix — segment templates + behavioral filter library
- Mobbin URL: https://mobbin.com/flows/fc7d53d5-c91e-45f3-b833-f139799d85a6
- Contacts: "Create New ▾ → Contact / Segment ('A dynamic list of contacts that auto-updates')". Segments tab: template cards ("New contacts who recently subscribed…", "Potential customers who haven't…") with "Set Up Segment" buttons; note "Segments are updated automatically once a day".
- Filter picker is a searchable library grouped by domain (Member status, Email subscriber status, Birthday, Booking activities: "Didn't book session", Email marketing activities: "Opened email campaign") + "Can't find the filter you want? Request a Filter".

### Klaviyo — segment builder with live count + lifecycle tabs
- Mobbin URL: https://mobbin.com/flows/45c97c57-1f68-4615-abe8-23a3752d7da7
- Lists & segments index: search + type filter, starred favorites, prebuilt segments (Churn Risks, Win-Back Opportunities, Engaged (30/60/90 Days)).
- "Create segment": Name + Tags, condition rows ("Properties about someone" → $consent contains …), "+ Add condition", live profile count, "Preview details" before create.
- Segment detail tabs: Members (N) / Edit definition / Segment growth / Engagement / Settings.

DRY ASSESSMENT: this round produced only variants of the saved-views/filter family already harvested (Attio views, folk groups, HubSpot view tabs, Notion/Clay filters). Sweep declared dry for the module's core surfaces.
