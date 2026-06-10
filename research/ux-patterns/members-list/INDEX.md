# INDEX — members-list (B4)

## Coverage
- Queries run — by-app: "Linear workspace members settings page table with roles", "Vercel team members settings page role column", "Notion workspace settings members list role dropdown"; by-pattern: "organization members directory filter by role status deactivate suspended bulk actions"; by-flow: "change a member's role or remove member from team settings" (member-table screens surfaced inside flows). Platform: web only.
- Apps swept: Linear, Vercel, Notion, Sana AI, Fibery, Exa, Coda, Miro, Google Workspace, Mural, Navan, Clay, Visitors, 1Password.
- NOT found / excluded: Raycast team-members screens did not surface on web; Stripe members *table* not captured (only its invite modal — see B5); Slack's member management lives in a separate admin site and surfaced under invitations (B9), not as a members table. No virtualized/infinite-scroll list observed — every large-list app used pagination.
- Saturation: final directory-scale query returned only refinements (filter chips, hover actions) of patterns already catalogued.

## Patterns
- ★ settings-embedded-members-table — full-page settings table: name+email, role column, search above, invite top-right, overflow row actions (Linear, Vercel, Sana AI, Fibery, Exa, Coda)
- ★ scale-toolbar-search-filter-export — search + role/status filter chips + CSV export + pagination for 100+ members (Miro, Google Workspace, Coda, Linear, Mural, Navan)
- unified-table-with-status-badges — pending invitees as badged rows in the same table (Linear, Vercel, Exa, Fibery)
- summary-stat-header — role/seat stat cards above the table (Coda, Miro, Notion, 1Password)
- people-management-modal — members managed in a settings overlay (Notion, Clay, Visitors) — AVOID for our stack

★ = recommended default: a settings-route table with the scale toolbar; the two starred cards compose into one surface.
