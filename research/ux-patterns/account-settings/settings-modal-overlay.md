# Pattern: Settings as modal overlay with internal sidebar
**Surface:** account-settings · **Observed in:** Notion, Figma (refs: [Notion my account](https://mobbin.com/screens/6e762c68-0171-4bc4-9a2b-614e3c2a54b1), [Notion profile](https://mobbin.com/screens/aa59f603-76b1-49d1-82e7-9932068618fe), [Figma sessions tab in account modal](https://mobbin.com/screens/7a492b27-a3ca-47a7-932e-46a76e00ad69))

## Flow
1. User clicks Settings; a large centered modal opens over the workspace (work context stays visible, dimmed, behind).
2. Modal has its own left sidebar (Notion: Account section on top, Workspace section below) or top tabs (Figma: Account / Notifications / Sessions).
3. User edits in place; sub-actions (change email, change password) open stacked secondary modals on top.
4. Close (X / Esc) returns to the exact working position — no navigation occurred.

## Use when
- Users tweak settings mid-work and must not lose their place; settings tree is moderate; app is a single dense workspace (doc/canvas tools).

## Avoid when
- Sections need deep links/shareable URLs (modals make routing awkward); settings panels contain large tables (sessions, audit logs) that fight the modal viewport; stacked modal-on-modal chains get deep (Notion already stacks 2 levels).

## Sad paths observed
- Notion stacks a password-confirmation modal on top of the settings modal and shows inline "Incorrect password." under the field ([ref](https://mobbin.com/screens/27c11172-8341-4fd1-8060-a568593c659f)) — error stays local, modal does not close.

## Accessibility
- Two-level modal stacking demands careful focus-trap management; Esc behavior must close only the topmost layer. Not directly observable in stills.

## Default verdict for our stack
VIABLE — beautiful for workspace tools, but routing-hostile and heavier to build right (focus traps, stacked dialogs) than full-page settings; choose only if mid-work settings access is a core need.
