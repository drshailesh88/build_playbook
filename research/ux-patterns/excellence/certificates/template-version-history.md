# Pattern: Version history with restore (template safety net)

**Surface:** certificates / template-management · **Observed in:** Notion, Confluence, Fibery, HubSpot, Jasper, Slite (refs: https://mobbin.com/screens/68e72133-daba-44cd-a4e7-2d102b73aae8, https://mobbin.com/screens/b405410d-7a2d-4bd6-b44d-4efa934e0dec, https://mobbin.com/screens/eb05e8be-4a16-47f0-94fe-08ad3da74171, https://mobbin.com/screens/4699bcdc-f0a2-4cba-8c4a-4705d96870ac)

## Flow
1. Right-rail timestamp list grouped by day, author under each entry; selecting an entry renders that snapshot (Notion).
2. "Show changes" diff toggle with strikethrough rendering (Fibery).
3. Restore is confirmed with consequence stated: "Your current version will revert to version Jan 8, 2026 1:13 pm." (Fibery); Confluence revert dialog carries an editable comment ("Reverted from v. 2").
4. Confluence full table variant: Version / Date / Changed By / Comment + "Compare selected versions".

## Use when
A bad template edit can silently corrupt the next bulk batch — history + restore is the undo for that class of incident.

## Avoid when
V1 with single-admin tenants and version_no already bumping — a "last edited by/at" line may be enough until multi-admin editing lands.

## Sad paths observed
- Slite plan-gates older versions ("Access all versions of this doc, upgrade…") — gating the safety net is the anti-pattern to avoid.

## Accessibility
Snapshot list is plain text/links; diff view must not rely on color alone (Fibery uses strikethrough, good).

## Default verdict for our stack
VIABLE (V2) — legacy bumps version_no on active-template edits (census #10) but has no history UI or restore; record versions now, ship the UI when multi-admin editing is real.
