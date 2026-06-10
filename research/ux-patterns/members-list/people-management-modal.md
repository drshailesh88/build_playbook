# Pattern: People management inside a settings modal/overlay
**Surface:** members-list · **Observed in:** Notion, Clay, Visitors (refs: [Notion](https://mobbin.com/screens/3a09a6c6-0ce8-483c-96be-73eee6df207e), [Notion role column](https://mobbin.com/screens/e78d4c10-2356-4a90-9021-f3179d6435d2), [Clay flow](https://mobbin.com/flows/de055025-303e-4336-8ce3-5a7c174d9f2b), [Visitors flow](https://mobbin.com/flows/384e0f66-ca2f-4149-bae9-a4ae5b3d8468))

## Flow
1. Settings opens as a centered overlay on top of the working canvas (Notion's settings dialog; Clay's Workspace Settings modal).
2. People/Members is a nav item inside the overlay; list renders in the modal body with tabs (Notion: Members / Guests / Groups / Contacts), search, and an "Add members" split button.
3. Roles are inline dropdowns per row; invite link section sits at the top of the same panel.
4. Visitors reduces this to a single card: email input + Invite button, Owner section, Invited section with per-row dropdown → Remove.

## Use when
- The app is canvas/document-centric and settings must not navigate away from work-in-progress.
- Member ops are shallow (view, role flip, remove) and fit a constrained viewport.

## Avoid when
- Members table needs many columns, bulk actions, pagination, or CSV export — modal width/height caps the surface (Notion's own table is visibly cramped at 4 columns).
- Deep-linking to a member or filtered view matters (modals make URLs awkward).

## Sad paths observed
- None beyond standard remove confirmations; Clay's overflow exposes Remove directly with no observed confirm — a footgun we should not copy.

## Accessibility
- Large overlay dialogs require focus traps and Escape handling; Notion's is effectively a full app surface inside a dialog — heavy to make accessible correctly.

## Default verdict for our stack
AVOID — Event State is a settings-page app (Next.js App Router routes), not a canvas app; full-page settings routes are simpler, deep-linkable, and match Linear/Vercel.
