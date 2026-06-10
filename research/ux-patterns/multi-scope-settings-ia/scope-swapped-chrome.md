# Pattern: Scope-Swapped Chrome (different top-nav + sidebar per scope)
**Surface:** multi-scope-settings-ia · **Observed in:** Vercel, Neon (refs: [Vercel team settings](https://mobbin.com/screens/f085cf74-1b25-4b2c-9e90-05b76e437d0e), [Vercel project settings](https://mobbin.com/screens/c681207e-c335-4e34-96a2-018cfa69baff), [Vercel team general](https://mobbin.com/screens/a5af21d8-7b80-4a07-a258-5e685d6ae668), [Neon project dashboard](https://mobbin.com/screens/1662d1cc-c43f-4227-91f1-bf6652b2146e), [Neon org projects](https://mobbin.com/screens/7feb0738-4a43-4bd8-ae68-8ecfbbebf015))

## Flow
1. At team scope, the top tab bar shows team-level surfaces (Overview, Integrations, Activity, Domains, Usage, Monitoring, Storage, Settings); the settings sidebar is grouped under a "Team" label (General, Billing, Members, Access Groups...) with a second "Account" group below it.
2. Drilling into a project swaps the ENTIRE top tab bar to project-level surfaces (Project, Deployments, Analytics, Speed Insights, Logs, Storage, Settings) and the settings sidebar to project-only items (General, Domains, Git, Functions, Environment Variables, Deployment Protection...).
3. The page H1 confirms scope ("Project Settings") so the user never relies on nav position alone.
4. Neon does the same with explicit ALL-CAPS sidebar group labels: ORGANIZATION sidebar (Projects, People, Billing, Settings) at org scope vs PROJECT / BRANCH grouped sidebar inside a project, each scope carrying its own Settings item.

## Use when
- The two scopes have genuinely different capability sets (org admin vs per-event operations) — the swap makes wrong-scope edits structurally impossible.
- You already committed to full-page settings with grouped nav (DEC-038): this is the same shell instantiated once per scope.

## Avoid when
- Scopes share most of their settings — duplicated near-identical trees confuse more than they clarify.
- Users must frequently compare a parent value with a child value side by side; the full chrome swap makes cross-scope comparison a two-trip task.

## Sad paths observed
- Vercel greys out plan-gated cards inside settings ("Password Protection ... optionally available for $150/month") rather than hiding them — scope stays honest about what exists.
- None of the screens show what happens if a user deep-links to a project settings URL after losing project access (not observable on Mobbin).

## Accessibility
- Scope is signalled redundantly: tab set + sidebar group label + page H1. Screen-reader users get the H1 ("Project Settings") even if visual nav cues are missed.
- Vercel's sidebar group labels ("Team", "Account") act as list headings, giving structure to assistive nav.

## Default verdict for our stack
RECOMMENDED — matches DEC-038/043 (Org zone vs Account zone) and extends it cleanly to a third per-event scope: same settings shell, swapped chrome, H1 names the scope.
