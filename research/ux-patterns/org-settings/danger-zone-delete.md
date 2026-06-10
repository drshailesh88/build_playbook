# Pattern: Danger zone — workspace deletion at the bottom of General
**Surface:** org-settings · **Observed in:** Linear, Plane (refs: [Linear delete section (classic)](https://mobbin.com/screens/480db52c-fce1-409e-9477-ff51f7cb7b12), [Linear "Danger zone" (current)](https://mobbin.com/screens/60dd3590-48ba-4a6b-933a-7f8ef3ab8b6d), [Plane collapsed delete accordion](https://mobbin.com/flows/ad1e88c4-7acb-4b4d-a2ab-583cf13bcc4e))

## Flow
1. Deletion lives at the very bottom of the org General page, visually separated.
2. Consequence copy precedes the action: "If you want to permanently delete this workspace and all of its data, including but not limited to users, issues, and comments, you can do so below." (Linear classic).
3. Action styled destructive-red: "Delete this workspace" button (Linear classic); current Linear labels the section **"Danger zone"** with row copy "Delete workspace — Schedule workspace to be permanently deleted" (deletion is scheduled/grace-period, not instant).
4. Plane variant: "Delete this workspace" is a collapsed accordion row (chevron) — the destructive button isn't even rendered until expanded.

## Use when
- Every tenant General page — owners need a discoverable but friction-guarded exit.

## Avoid when
- Never omit entirely; but avoid surfacing it to non-owner roles (render only for owner/admin, server-gated).

## Sad paths observed
- Linear's "Schedule … to be permanently deleted" implies an undo window — softens the worst sad path (accidental delete).
- Data scope is enumerated in plain words before the button, not in a post-click dialog only.
- **Gap:** the type-org-name-to-confirm dialog after clicking was not captured in harvested screens; the downstream forced create-or-join state after deleting your last org also was not directly observed (see org-onboarding/join-or-create-gate as the receiving state).

## Accessibility
- Red styling is paired with explicit warning text (not color-only); Plane's accordion keeps the destructive control out of the default tab path.

## Default verdict for our stack
RECOMMENDED — danger-zone section, owner-only, scheduled deletion with grace period; pair with a name-confirmation dialog (ours to design) and route survivors to the join-or-create gate.
