# Pattern: Template/content seeding at first run
**Surface:** org-onboarding · **Observed in:** Notion, monday.com (refs: [Notion template picker](https://mobbin.com/screens/d54cce88-7962-44cd-8d99-61e0199f35ed), [Notion docs preview](https://mobbin.com/screens/9f55986e-6646-4030-b9ce-da3b024813f1), [monday.com empty workspace "Add from templates"](https://mobbin.com/screens/1c670431-dda6-440b-8de3-a14d7fba1a40))

## Flow
1. After the workspace exists, an overlay/side-panel offers starter content: "Get started with Notion — Add templates to your workspace" with toggleable template chips (Wiki / Projects / Docs / Meetings), each previewing on selection.
2. CTA reflects selection count: "Continue with 4 templates".
3. Selected templates materialize as real sidebar content (teamspaces/pages), so the app never opens empty.
4. monday.com variant: the empty workspace itself carries "This workspace is empty" + "Add from templates" / "Start from scratch" — seeding offered at point of emptiness rather than as a wizard step.

## Use when
- The product's value is invisible on an empty canvas (docs, boards, events) and demo content teaches the model.

## Avoid when
- Domain data is real-world-anchored (live events, payments) — fake seed data pollutes the tenant and must be deleted later (monday demo-data banner: "Click set up now to clear the sample data").
- Templates would outnumber the user's first real action.

## Sad paths observed
- Notion allows deselecting all templates; flow still continues (empty is allowed, just not default).
- Employment Hero (adjacent observation, [flow](https://mobbin.com/flows/f0d98767-ce65-4168-a951-716a2d4597ae)) shows a persistent banner over sample data: "Finished exploring? Click set up now to clear the sample data and start adding your real data."

## Accessibility
- Chip toggles with check badges; selection state also reflected in CTA text (count), not color alone.

## Default verdict for our stack
VIABLE — a single "Create a sample event" offer on the empty dashboard (monday-style, at point of emptiness) fits better than a wizard step; must be clearly deletable.
