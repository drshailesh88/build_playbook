# Pattern: Sidebar-header workspace popover
**Surface:** org-switcher · **Observed in:** Notion, Base44, Air (refs: [Notion switcher open](https://mobbin.com/screens/3934d9e2-d212-4a31-a5bd-a67f120833b9), [Notion multi-account](https://mobbin.com/screens/eb0b0242-8e97-41c0-b2b0-f7446a6f7b3c), [Notion single-org](https://mobbin.com/screens/1257521d-e4ab-4ae9-8355-fc64bfa011ce), [Base44 switch flow](https://mobbin.com/flows/48037716-dd13-4e3d-a676-5d42edc19480), [Air create-workspace flow incl. switcher](https://mobbin.com/flows/4a12588a-cbb2-461e-966f-6a0ac1dfb88e))

## Flow
1. Trigger: current org name + avatar at the very top of the left sidebar, with chevron.
2. Popover header = current-workspace card: logo, name, plan + member count ("Free Plan · 1 member", Base44 adds usage meters), and quick actions "Settings" / "Invite members".
3. Below: list of all workspaces, grouped by signed-in account email (Notion), active one marked with a checkmark; Notion also injects "Suggested · Join" rows from domain discovery.
4. Footer entries: "+ Add workspace" / "+ Create new workspace", "Join or create a workspace" (Air), "Add another account", "Log out".
5. Clicking another workspace swaps the whole app context in place; sidebar content re-renders for the new org.

## Use when
- The app is sidebar-anchored (shadcn sidebar) and the org defines everything below it — switcher belongs at the root of the hierarchy users scan first.
- You want Settings/Invite reachable in one click from anywhere.

## Avoid when
- Top-bar-only layouts (no persistent sidebar).
- The popover would need to carry both org AND project switching — it overloads (that's the Vercel two-column pattern instead).

## Sad paths observed
- Single-workspace users still see the popover with just their one workspace + create entry — no special casing needed (Notion 1257521d).
- Notion separates "Log out" per account vs "Log out all" when multiple accounts are attached.

## Accessibility
- Checkmark plus highlighted row for active org (not color-only). Trigger is a real button in the tab order. No shortcut hints shown (unlike Linear).

## Default verdict for our stack
RECOMMENDED — fits shadcn sidebar header exactly; popover lists Better Auth organizations, sets activeOrganizationId on click, footer = create/join + settings shortcuts.
