# Pattern: Embedded setup checklist as dashboard hero
**Surface:** zero-data-empty-states · **Observed in:** Asana, Apollo, Copilot, Google Workspace, Causal, Langdock (refs: https://mobbin.com/screens/d891cb71-8b4b-4c9d-a701-e293398dcea8, https://mobbin.com/screens/2623e252-4ac9-429d-9482-369027fefb80, https://mobbin.com/flows/24008106-068d-4871-b191-6b273c32a304, https://mobbin.com/flows/63ada8d0-d8a0-4f25-8b72-a83f622b6c29, https://mobbin.com/flows/710c15b9-59ac-4596-998c-67b668fa106c, https://mobbin.com/screens/c69db9e3-a938-4c5f-9c86-652c6efc28a7, https://mobbin.com/flows/90a890c5-e5fd-4920-a65f-a81642cb66a0)

## Flow
1. New tenant lands on Home/dashboard; the top (or entire above-the-fold) slot is a numbered checklist card, not widgets: "Create your first project", "Connect your CRM (or upload a CSV)", "Invite teammates", "Customize home" (Asana 1-5 steps; Apollo "Next steps for you" grouped by category with per-step Start buttons; Copilot 5-step list with reward "Finish onboarding and receive a $100 credit").
2. Each step expands or deep-links into the module where the action happens (Apollo Start buttons; Causal items open video walkthrough modals; Google Workspace step cards "Step 1 of 7" with action button + "Mark as done").
3. Completed steps show checkmarks/strikethrough; progress counter updates ("1 of 3 steps completed" — Asana team page; Causal "Getting started 0/4" → "3/4").
4. Checklist is dismissible (X on Asana/Google Workspace cards) and collapses once complete; real widgets take over the slot.
5. Variant: Langdock gamifies with points per task and a leaderboard rank.

## Use when
- Tenant-wide activation has a known dependency order (workspace settings → first event → people/program → invite team).
- The dashboard would otherwise be a grid of dead widgets.
- You want one canonical "what next" answer visible on every return visit until activated.

## Avoid when
- Setup is one step — a checklist of one item looks like filler; use a single-action takeover instead.
- Steps cannot actually be tracked to completion server-side; a checklist that never checks itself erodes trust.
- The checklist would push live data below the fold for already-activated tenants — it must yield once data exists.

## Sad paths observed
- Copilot keeps trial/billing pressure stacked above the checklist ("14 days left of your trial · Select a plan") — two competing CTAs on a zero-data screen.
- Asana shows the checklist alongside already-hollow widgets (Goals: "This team hasn't created any goals yet"), so the page has 3+ simultaneous CTAs.
- Dismissal is one-way on some cards (X with no obvious way to reopen except a sidebar entry).

## Accessibility
- Steps are real text with numbered order — screen-reader friendly sequence, observed across all apps (no icon-only steps).
- Progress conveyed by both count text ("1 of 3 steps completed") and visual bar in Asana/Apollo — don't rely on the bar alone.
- Google Workspace pairs every step with an explicit action button + "Mark as done" — keyboard reachable.

## Default verdict for our stack
RECOMMENDED — Event State's new tenant has a strict dependency chain (create event → add people → build program); an embedded, server-verified checklist on the empty dashboard is the cleanest observed answer to "what replaces the widgets".
