# Pattern: Searchable organisations panel with full reload switch
**Surface:** org-switcher · **Observed in:** Employment Hero (refs: [switching organisations flow](https://mobbin.com/flows/f0d98767-ce65-4168-a951-716a2d4597ae))

## Flow
1. Trigger: org name at top-left of the app bar.
2. A dedicated overlay panel slides over the sidebar: title "Organisations", close ×, search input, then the org list with the active one checkmarked.
3. Selecting another org performs a **full reload** into that org's dashboard — page, plan banner ("Free – Upgrade To Standard" vs "Platinum Trial"), and module nav all change wholesale.
4. Panel pattern (vs popover) gives room for many orgs — built for accountants/admins belonging to dozens of tenants.

## Use when
- Users routinely belong to many orgs (10+) — search is mandatory, a popover list doesn't scale.
- Per-org differences are so large (plan, enabled modules, theming) that a clean reload is more honest than an in-place swap.

## Avoid when
- 1–3 orgs per user — a panel + reload is heavyweight; instant in-place swap (OpenAI Platform, Linear) feels dramatically faster and is the Linear/Vercel-bar behavior.

## Sad paths observed
- Active org checkmarked; selecting it again is a no-op.
- Post-switch dashboard re-renders with org-specific trial/plan banners — pricing state never leaks across tenants.

## Accessibility
- Search field focused affordance, explicit close button; full reload guarantees a clean focus/announcement reset (at the cost of perceived speed).

## Default verdict for our stack
AVOID as default — our members will hold few orgs; choose the sidebar popover with in-place `setActive` + router refresh. Revisit only if power-admins with many tenants emerge.
