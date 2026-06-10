# Pattern: "Switch workspace" submenu inside the account/workspace menu
**Surface:** org-switcher · **Observed in:** Linear, Fibery (refs: [Linear submenu open](https://mobbin.com/screens/e8fe60b4-6db4-4485-99b8-3395d69ea7db), [Linear menu closed](https://mobbin.com/screens/14daab5b-7872-456a-8c5a-94f3d9d03a48), [Fibery onboarding flow incl. user-menu switcher](https://mobbin.com/flows/028cdf95-4b10-4eb0-a0be-44f333ab340a))

## Flow
1. Sidebar-header button opens a command-style menu: Settings (`G then S`), Invite and manage members, Download app, **Switch workspace** (`O then W`) ▸, Log out (`⌥⇧Q`).
2. Hovering "Switch workspace" opens a nested submenu: account email as header, workspace list with checkmark on active and **numbered shortcuts (1, 2, …)** per workspace.
3. Submenu footer: "Create or join a workspace…" and "Add an account…".
4. Selection switches org instantly in-place (client-side context swap, sidebar re-renders).
5. Fibery variant: same shape from the user avatar menu — "Switch Workspace ▸" submenu + "Create Workspace" beneath.

## Use when
- Switching is a secondary action for most users (single-org majority) and you don't want a whole popover dedicated to it.
- Keyboard-first culture: chord shortcuts (`O then W`, number keys) make org-hopping free.

## Avoid when
- Multi-org is the dominant daily motion — hiding the list one level deep adds a hover/hop every switch.
- Touch devices: nested hover submenus are hostile on touch.

## Sad paths observed
- Active workspace always checkmarked so a mis-aimed click on the current org is a no-op.
- Account email shown as submenu header prevents cross-account confusion before switching.

## Accessibility
- Explicit keyboard shortcuts rendered beside every action — best-in-class discoverability (Linear). Nested submenu requires arrow-key support to be usable without a mouse.

## Default verdict for our stack
VIABLE — excellent for Linear-grade keyboard UX, but a one-level sidebar popover is simpler to build correctly with shadcn DropdownMenu; adopt the shortcut hints regardless.
