# Pattern: Guided "resolve issues" remediation loop during mapping
**Surface:** import-wizard-sad-paths · **Observed in:** Attio, HubSpot (refs: [Attio review values](https://mobbin.com/screens/28882ce0-aacf-49ec-8156-b60abca11f4d), [Attio resolve issues](https://mobbin.com/screens/cb89c27e-16a7-49a1-9731-1f652e3c0ed8), [Attio create options confirm](https://mobbin.com/screens/683a5479-19e0-4881-84cd-312a1f9d187a), [Attio flow](https://mobbin.com/flows/535a7828-5915-47a2-b782-c6bfd708adc0), [HubSpot fix panel](https://mobbin.com/screens/11317643-e311-4f65-921f-e09456043d45), [HubSpot status filter](https://mobbin.com/screens/0d38bdc3-8b30-40f8-90a9-630fb0404efd))

## Flow
1. After auto-mapping, a "Review values" summary lists each column with a status icon: green check (clean) or amber warning (needs review) — Attio.
2. Footer offers two exits: "Continue without resolving" vs "Resolve issues" — sad path is skippable, never forced.
3. "Resolve Issues" drill-in shows one column at a time: "22 invalid out of 100 values" with an "Only show invalid values" toggle on by default; each bad value gets a per-row "Fix invalid value" affordance.
4. Column-level escape hatches: "Do not import column" or "Confirm column" (Attio); HubSpot equivalent: "Don't import data in unmapped column" checkbox.
5. Unknown enum values get bulk repair: "Create 3 missing select options" — with a confirm dialog warning the schema change "cannot be un-done" (Attio).
6. HubSpot renders the same idea as a side panel: error name ("Could not find owner"), count ("4 import errors"), "View values with errors," then a "Ways to fix this error" list — update file and re-import, add the missing user, choose a different property, or "Ignore and fix later."
7. HubSpot's mapped-status filter (Unmapped / Mapped, not validated / Mapped with errors / Mapped with edits) lets users triage a wide file by error state.

## Use when
- Errors come from vocabulary mismatch (select options, owners, domains) that the app itself can repair — creating the missing option beats round-tripping the file.
- You want the cheapest path from "error detected" to "error gone" without leaving the wizard.

## Avoid when
- Fixes mutate workspace schema (new select options, new users): without the explicit "cannot be un-done" confirmation Attio shows, a careless import pollutes the schema for every tenant member.
- Single-admin small files — the full drill-in machinery is heavier than a simple error list.

## Sad paths observed
- "Ignore and fix later" (HubSpot) is offered as a legitimate first-class fix strategy — the import proceeds and drops unmatched values ("Values that don't match an existing user won't be imported").
- Attio marks an invalid domain inline with a red "Invalid domain" chip while typing the replacement.
- Schema mutation guarded by a confirm dialog naming the irreversible consequence.

## Accessibility
- Column status communicated by icon + grouped headings ("Needs review 3", "Automatically mapped 3"), not color only.
- One-column-at-a-time drill-in keeps focus scoped; prev/next pagination is explicit buttons.
- Toggle "Only show invalid values" is a labeled switch.

## Default verdict for our stack
VIABLE — strongest version of pre-import remediation, but it overlaps our decided manual-override mapping step; adopt selectively (per-column needs-review counts and a "don't import this column" escape) rather than rebuilding the wizard around it.
