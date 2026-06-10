# Pattern: Single-action takeover home ("Create your first event" replaces the dashboard)
**Surface:** zero-data-empty-states · **Observed in:** Posh, Spline, Copy.ai, Adobe, Contra (refs: https://mobbin.com/screens/1f1f0299-c695-4c76-9425-da73375502e9, https://mobbin.com/screens/6d89dc07-72a7-450f-a462-3c5f93c9ee75, https://mobbin.com/screens/c6eb9104-a68a-4938-a309-dfe77fe9aef2, https://mobbin.com/screens/30461b60-7b03-48ec-b364-3593ad6d8f3c, https://mobbin.com/screens/a32ef095-5fc7-47f0-aa2c-698914a37163)

## Flow
1. The full navigation stays visible (Posh keeps Overview / Marketing / Team / Finance / Profile / Settings tabs), but the content area is replaced by one centered block: hero visual + welcome line + the single root action — "Welcome to Posh! Create your first event to get started! [+ Create Event]".
2. No widgets, no checklist, no secondary CTAs in the content area (Spline: "This team has no projects yet — Organize your team files by creating your first project [+ New Project]"; Copy.ai: "You haven't started a project! [New Project]").
3. After the root entity exists, the takeover is replaced by the normal dashboard; dependent modules begin to make sense.
4. Posh is notable because it's an events product: the entire tenant home collapses to the event-creation action — Marketing/Team/Finance tabs exist but the product doesn't pretend they're useful yet.

## Use when
- One root entity unlocks everything else (an Event before people/program/registrations) — the dependency chain has a single first link.
- You want zero decision load: founder-grade clarity that there is exactly one next action.

## Avoid when
- Setup genuinely requires several parallel actions (branding, domain, billing) — a takeover hides them; use the checklist instead.
- Returning users with permissions but no create rights would hit a CTA they can't use (no observed app handled viewer-role takeover copy).

## Sad paths observed
- Contra layers an upsell strip ("Supercharge your workflow... PRO") under the first-project CTA — monetization leaks into the zero state.
- Adobe/Copy.ai keep global search and template sidebars active, which can route users away before the first create completes.

## Accessibility
- Single heading + single button is the most screen-reader-legible zero state observed anywhere in this sweep.
- Posh's hero is a high-motion-feel blurred image with white text — contrast is fine but verify if reproduced; keep the CTA as a real button, not a styled div on imagery.

## Default verdict for our stack
RECOMMENDED — for Event State, the dashboard before the first event should collapse to exactly this (Posh is a same-domain proof); graduate to checklist + hollow widgets after event #1 exists.
