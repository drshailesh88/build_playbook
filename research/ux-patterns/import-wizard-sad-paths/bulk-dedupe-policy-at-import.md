# Pattern: Bulk duplicate policy chosen once at import time
**Surface:** import-wizard-sad-paths · **Observed in:** Pipedrive, Apollo, Intercom, Attio, Zoom, Clay (refs: [Pipedrive](https://mobbin.com/screens/a3854ba6-58df-4bed-bef3-571ef7c369ca), [Apollo](https://mobbin.com/screens/53746d77-d3e4-4eb3-b877-85436827ac4b), [Intercom flow](https://mobbin.com/flows/c7c65d83-e2e9-4de0-85a4-aebf6b295b79), [Attio counts](https://mobbin.com/screens/bfa3edeb-c3a1-41dc-b446-e05a577bbcae), [Zoom flow](https://mobbin.com/flows/74b34c01-38b1-42ce-a844-03d97f7c97e5), [Clay replace warning](https://mobbin.com/screens/bb336b80-4f33-464c-ad7a-679714b3c770))

## Flow
1. The final wizard step asks one question for the whole file: "What to do with duplicates if found?" (Pipedrive) with two radio cards — "Merge data" vs "Create multiple records" — each explaining its match key in plain words ("People with the same name and email are merged into one").
2. The matching rule is disclosed, not hidden: "Duplicates are checked only for people and organizations" (Pipedrive); Intercom's upload step states "If a user ID or email address in your CSV matches an existing user or lead, they will be updated with the mapped values. Otherwise, a new user or lead will be created."
3. Apollo exposes the policy as settings dropdowns at mapping time: "If contacts already exist in Apollo: Update the existing record with information from CSV" and a second-order rule "If existing contacts already have owner: Do not override ownership."
4. Before commit, the outcome is previewed as counts: "0 records will be updated / +100 records will be added to your list" (Attio's Start-your-import dialog) — the dedupe decision made visible as numbers.
5. Destructive strategies are warned inline: Clay's "Select destination: Replace current table" shows "Warning: Replacing this table will delete all existing rows"; Zoom offers "Replace with new CSV file" as a named wholesale strategy.

## Use when
- Files are large — per-row dedupe decisions don't scale past a few dozen conflicts; one policy + preview counts does.
- Match keys are reliable (our decided email+phone dedupe) so a bulk rule produces predictable results.

## Avoid when
- Merges can silently overwrite curated fields — Apollo's ownership-protection sub-rule exists because blanket "update existing" clobbers sales-team data; offer field-level protection or skip-instead-of-update.
- Match confidence is fuzzy (name-only) — bulk-merge on weak keys corrupts records; fall back to a review queue (see merge-preview card).

## Sad paths observed
- "Create multiple records" is offered as an explicit, legitimate choice (Pipedrive) — not every duplicate is an error.
- Update-vs-add counts shown pre-commit (Attio) catch wrong-policy mistakes before they happen.
- Replace-strategy warned with a row-deletion callout (Clay).

## Accessibility
- Policy options are large radio cards with full-sentence descriptions, not bare radio labels.
- Preview counts are text ("0 records will be updated"), screen-reader readable before the single Start import button.
- Warnings are inline text near the triggering control, not toast-only.

## Default verdict for our stack
RECOMMENDED — matches our decided email+phone dedupe: one policy step (update existing / skip / create anyway) + Attio-style pre-commit counts ("N new, M matched") + Apollo-style "don't overwrite fields that already have values" guard.
