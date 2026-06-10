# Pattern: General tab — org identity form (logo, name, explicit save)
**Surface:** org-settings · **Observed in:** Linear, Plane, June, Notion (refs: [Linear general](https://mobbin.com/screens/480db52c-fce1-409e-9477-ff51f7cb7b12), [Plane edit flow w/ success toast](https://mobbin.com/flows/ad1e88c4-7acb-4b4d-a2ab-583cf13bcc4e), [June inline save flow](https://mobbin.com/flows/e45bcb13-2125-469a-8c0a-caa8ce1af0ab), [Notion icon picker](https://mobbin.com/screens/a8cacf52-34d8-49a1-9312-12da01f0a888))

## Flow
1. "General" is the first/default item in org settings; page header restates scope ("Workspace — Manage your workspace settings. Your workspace is in the United States region").
2. Logo block first: current logo preview, click to upload, guidance text ("Pick a logo for your workspace. Recommended size is 256×256px"); Plane labels it "Upload logo"/"Edit logo" beside the org's URL; Notion offers Emoji / Icons / Custom-upload tabs with live preview and "Remove".
3. Name input with org-appropriate helper ("You can use your organization or company name. Keep it simple." — Notion).
4. Explicit commit: "Update" / "Update workspace" button below the fields (Linear, Plane, Notion). June variant: a "Save" button materializes next to the field only once it's dirty.
5. On save: success toast ("Success! Workspace updated successfully" — Plane; "Team identifier updated" — Linear) and the sidebar/topbar org name updates everywhere.

## Use when
- Always — this is the table-stakes general tab for any tenant.

## Avoid when
- N/A for the surface; only avoid *ambient auto-save without any indicator* — every observed app used an explicit Update/Save or dirty-state Save.

## Sad paths observed
- Adaline ships logo as read-only with an honest note: "It is not possible to change your logo at this time" — constraint stated, not hidden.
- Linear confirms even small saves with a toast, since the change is visible app-wide.

## Accessibility
- Labeled inputs with helper text under each; image upload includes size guidance; dirty-state Save (June) risks being missed by screen readers vs always-present Update button.

## Default verdict for our stack
RECOMMENDED — logo + name + explicit Update + success toast, with upload constraints stated inline; exactly the shadcn form card we should ship first.
