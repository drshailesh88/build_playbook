# Pattern: Settings modal with Account/Workspace split nav
**Surface:** org-settings · **Observed in:** Notion (refs: [modal w/ domain settings](https://mobbin.com/screens/0f69714a-080a-43ed-b1c6-7103ea8fadfe), [modal general](https://mobbin.com/screens/06c84b94-deb7-42f8-80b7-ba8b8ec1be06), [modal w/ custom domain](https://mobbin.com/screens/c14151f0-6cf8-4b17-9dae-8b488d8b1437))

## Flow
1. Settings opens as a large centered modal over the app (app remains visible behind), not a route.
2. Modal's left nav splits into **Account** (avatar + email header, My account, My settings, Notifications, Connections, Language & region) and **Workspace** (Settings/General, Teamspaces, People, Upgrade, Sites, Security, Identity & provisioning, Connections, Import).
3. Workspace › Settings pane: Name, Icon (Emoji/Icons/Custom-upload picker), Domain, Allowed email domains, Public home page (plan-gated "TEAM PLAN" tag), Export content.
4. Edits commit via explicit "Update" / "Cancel" buttons at pane bottom; success surfaces as toast ("slmobbin has been added to your workspace").
5. Upgrade nudge (storage usage meter + "Upgrade plan") embedded at nav bottom.

## Use when
- Users tweak settings mid-task and must not lose page context (doc editors).
- Settings are shallow enough to not need deep links.

## Avoid when
- Admin-heavy B2B settings (members, billing, audit) — modals can't be deep-linked/bookmarked cleanly, back button fights the overlay, and nested pickers inside a modal stack awkwardly (Notion's icon-upload popover-in-modal).

## Sad paths observed
- Explicit Cancel next to Update — dirty state is discardable.
- Plan-gated fields stay visible but tagged ("TEAM PLAN") rather than hidden — discoverability of paid features.

## Accessibility
- Modal traps focus by design; long nav inside a modal is heavy for screen readers; Update/Cancel pair gives an unambiguous commit point (vs ambient auto-save).

## Default verdict for our stack
AVOID for org settings — our admin surface (members, billing, danger zone) wants URLs and server-gated routes; keep modals for quick per-item edits only.
