# Pattern: Scale toolbar — search, role/status filters, CSV export, pagination
**Surface:** members-list · **Observed in:** Miro, Google Workspace, Coda, Linear, Mural, Navan, Vercel (refs: [Miro](https://mobbin.com/screens/faace447-f5cd-4c6e-96db-c1f5a953e179), [Google Workspace](https://mobbin.com/screens/81dd320c-cfac-4303-baf8-2db1ac4c6c05), [Coda flow](https://mobbin.com/flows/7e68441c-3c40-4431-b4be-5b67cecabc3e), [Linear export](https://mobbin.com/screens/00824d88-3866-4c22-9b9a-192223c98ad9), [Mural](https://mobbin.com/screens/8838fac5-7c90-4088-a1f9-7c3f8ea920e7), [Navan](https://mobbin.com/screens/23ac1585-3cc4-4d20-83ef-1a30e453c6f1), [Vercel](https://mobbin.com/screens/a10e73e0-e3cd-4d17-a267-1d84051af6a8))

## Flow
1. Toolbar above table: free-text search ("Search by name, email, or domain" — Miro) + scoped dropdown filters (Vercel "All Team Roles" + Date sort; Coda "Current" + "All members"; Navan "Enabled" status + "Roles" + permissions).
2. Applied filters render as removable chips (Miro: `Member ×` `Inactive last 30 days ×`) with a Filters panel for role checkboxes, license, teams, activity radio, and "Hide invited users".
3. Export: "Download CSV" (Miro, Mural), "Export CSV" (Linear), "Download users" (Google Workspace) sits in the toolbar.
4. Pagination at the foot: "Rows per page: 20" (Google Workspace), "Items per page: 50, 1–2 of 2" (Mural).
5. Google Workspace reveals row actions (Reset password / Rename / More) on hover, keeping the resting table dense.

## Use when
- 100+ members: search must be server-side, filters composable, and the result count visible.
- Ops/compliance needs an export (event staffing lists, audits).

## Avoid when
- <20 members — a chip-filter panel is overhead; Linear's single search + one "All" dropdown suffices.

## Sad paths observed
- Navan flags "2 unregistered" users with a "Send registration emails" callout — stalled members are actionable from the toolbar, not buried.
- Miro "Hide invited users" checkbox acknowledges pending rows pollute large lists.

## Accessibility
- Filter chips with explicit × targets; dropdown filters are native selects/menus. Hover-only row actions (Google Workspace) are a keyboard risk — pair with a persistent overflow menu.

## Default verdict for our stack
RECOMMENDED — at our 100+ requirement, search + role filter + pagination is the floor; chips and CSV export are cheap with TanStack Table and match the Linear/Vercel bar.
