# Pattern: Import-or-create dual path on first-record empty states
**Surface:** zero-data-empty-states · **Observed in:** Attio, Linear, Airtable, Apollo, Neon (refs: https://mobbin.com/screens/5696d7c4-64a0-47be-9876-3736c6058e36, https://mobbin.com/screens/44729082-a489-47f2-abf9-a1e6f73b6380, https://mobbin.com/screens/4795f734-3af1-48ce-897b-9b96a30b5fe3, https://mobbin.com/flows/24008106-068d-4871-b191-6b273c32a304, https://mobbin.com/flows/a15904ee-ae55-46a9-b1bf-cfb6a3ac6924)

## Flow
1. The first-record empty state names both fill routes in its copy: Attio Contacts — "Kick-start your new list by importing people from a *.CSV or add your first person. [+ Add Person]".
2. The migration route also lives as a persistent chrome nudge for switchers: Linear sidebar card "Import Issues — Use our Migration Assistant to copy issues from another service. Try Now →".
3. Airtable elevates import to a first-class creation mode on Home: "Quickly upload — Easily migrate your existing projects in just a few minutes" beside Start with AI / templates / scratch.
4. Apollo makes "Connect your CRM (or upload a CSV) to sync your records" a setup-checklist step.
5. Neon's Import Data flow shows the production-grade shape: step 1 compatibility check on the connection string → explicit failure state ("Cannot connect to the source database... check your connection string and try again [Contact support]") → step 2 import → "Database import in progress" status on the branch.

## Use when
- Target customers are migrating from a previous tool/spreadsheet (Event State tenants coming off the legacy single-tenant app or Excel attendee lists) — manual entry of hundreds of people is a churn cliff.
- The empty state is for bulk-shaped data (people, sessions), not singleton config.

## Avoid when
- Import infrastructure isn't actually built — advertising CSV import in zero-state copy before it works is a trap; ship create-only copy first.
- The record type is created in seconds (a single event) — import framing adds noise to a one-item decision.

## Sad paths observed
- Neon: source connection failure mid-import with a clear retry + support escalation; import leaves an "import in progress" branch the user must understand.
- Attio's CSV mention is copy-only — the visible button is only "+ Add Person"; the import path is buried in a toolbar ("Import / Export"), a discoverability mismatch between copy and CTA.

## Accessibility
- When copy mentions two routes, both need focusable controls — Attio's single-button version forces sighted scanning of the toolbar to find import.
- Neon's failure state is text + button (good); avoid toast-only import errors.

## Default verdict for our stack
RECOMMENDED — for Event State's People module (and template import), pair "Add person" with a visible CSV-import button in the same empty state; copy both routes from Attio's sentence, fix its button mismatch.
