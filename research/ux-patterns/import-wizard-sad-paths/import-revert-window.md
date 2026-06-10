# Pattern: Time-boxed import revert from import history
**Surface:** import-wizard-sad-paths · **Observed in:** Pipedrive, ClickUp (refs: [Pipedrive history](https://mobbin.com/screens/3d5ac1a9-1479-4a9e-ba8c-cadaf314c5be), [Pipedrive import detail](https://mobbin.com/screens/32e3fd61-09fa-4d60-9319-e97b2c1b5e89), [ClickUp](https://mobbin.com/screens/e9e161e4-635b-45b5-8288-70218c04a5b0))

## Flow
1. Undo lives in Import history, not on the success page alone. Pipedrive's "Import data > Import history" tab pins a "Summary of your last import" card with a Revert button.
2. The summary quantifies exactly what revert would touch: "+52 items added / 0 items updated / 0 items merged / 0 rows skipped."
3. The time window is stated in plain text next to the list: "Imports can be reverted within 48 hours after their upload" (Pipedrive), with a Learn more link.
4. Each history row carries its own Revert button plus a "Details" drill-in.
5. The detail page lists every record the import created, tabbed by object type (Deals 12 / People 12 / Organizations 12 / Activities 12 / Notes 4), with a red Revert button in the header — users can inspect the blast radius before pulling the trigger.
6. ClickUp's minimal variant: each history row has a "Delete imported tasks" action with an info tooltip — delete-what-this-created without a stated window.

## Use when
- Imports create records in bulk and "wrong file / wrong mapping" is discovered after commit — the #1 import regret.
- Multi-object imports (our attendees + their event links) where users can't realistically hand-delete.

## Avoid when
- Imported records start mutating immediately (check-ins, messages sent) — a blanket revert would destroy post-import work; Pipedrive's added/updated/merged split exists precisely because reverting "updated" rows is not the same as deleting "added" rows.
- You cannot keep the import-batch linkage (which records came from which import) — revert without that mapping is unimplementable.

## Sad paths observed
- Window expiry: Pipedrive's 48-hour limit is disclosed up front rather than discovered at click time.
- Side-effect ambiguity is mitigated by splitting counts into added vs updated vs merged vs skipped — only "added" is cleanly deletable.
- ClickUp pairs the destructive action with an explanation tooltip rather than burying it in a menu.

## Accessibility
- Revert is a labeled text button, repeated at list-row and detail level.
- Blast-radius counts are plain text/tabs, inspectable before confirming.
- Destructive detail-page Revert is visually distinct (red) and separated from Close.

## Default verdict for our stack
RECOMMENDED — Pipedrive's shape is the target: per-import revert in history, 48h-style stated window, added/updated split, and a drill-in listing created records; requires us to persist an import_batch_id on every created row.
