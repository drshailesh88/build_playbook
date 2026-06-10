# Pattern: Template vs blank as the first creation decision
**Surface:** first-run-onboarding · **Observed in:** Airtable, Asana, PandaDoc, Microsoft Loop, Coda, Rive, Vercel, Adobe Express (refs: [Airtable "Choose a department"](https://mobbin.com/screens/f7fa9038-2128-44f8-8e16-4ac6ff6ac4f8), [Airtable home entry cards](https://mobbin.com/screens/440e61a4-7a70-4210-8f83-ac2a089a4a96), [Asana create options](https://mobbin.com/screens/612e58d3-be7d-498d-a3e3-489d8eebd5ec), [Asana workflow gallery](https://mobbin.com/screens/188ad1c0-a889-4fbd-b5a9-dd7186247280), [PandaDoc](https://mobbin.com/screens/2de411fa-b1ca-4fd2-9dc7-34c50a97c15a), [Loop](https://mobbin.com/screens/71f3fa14-3a77-4f2e-9d43-30bf01b2c0a2), [Coda](https://mobbin.com/screens/eede8ffc-8610-481a-a7db-c12c70eb4614), [Rive](https://mobbin.com/screens/50ad95ee-bd3d-4f4e-a724-67ee12c65088), [Vercel](https://mobbin.com/screens/e03a020c-0ddc-4d5f-9d75-6cfcd7f586a6), [Adobe Express](https://mobbin.com/screens/7cadfcc1-96fd-45e1-ac75-064c267181d3))

## Flow
1. At the point of creating the first object, the app offers 2–4 typed starting paths on equal footing: "Blank project / Use a template / Import spreadsheet" (Asana), "Start from scratch / Quickly upload / Start with templates / Start with AI" (Airtable home).
2. Template path opens a curated gallery — categorized (Airtable departments, PandaDoc sidebar categories, Asana "For you / My organization / Marketing..."), each entry with a visual preview card.
3. Selecting a template shows a LIVE PREVIEW of the resulting workspace before committing (Airtable's right-pane app preview "You'll be able to make changes later", Asana's view preview).
4. Blank is always visibly present, usually first or last: PandaDoc's "+ Blank document" tile, Loop's "Blank page — start from scratch" leading the strip, Airtable "Or, start from scratch: Blank table".
5. Two placement variants: blocking modal at create-time (PandaDoc, Asana, Rive) vs non-blocking suggestion strip inside an already-open blank object (Coda's footer bar "Choose a starting template", Loop's bottom strip) — the latter lets users just start typing.

## Use when
- The core object has recognizable shapes (conference, summit, workshop) where a template demonstrates the product's depth faster than an empty shell.
- Templates create REAL editable structure, and you preview it before commit (Airtable's preview note "You'll be able to make changes later" defuses commitment anxiety).
- First-run specifically: a "conference starter" template doubles as product education.

## Avoid when
- You have fewer than ~3 genuinely distinct templates — a gallery of 2 looks thin; bake the one good template into the wizard instead.
- The choice would front-load taxonomy the user doesn't understand yet (Airtable's "Choose a department" assumes org-chart thinking on first contact).
- Template output is throwaway demo content rather than a usable starting point (that's sample-data-prefill, a different contract).

## Sad paths observed
- Decision paralysis on first contact: Adobe Express counters with a "For you" default tab; Asana with "Asana recommended" pre-checked views.
- Wrong-template remorse: mitigations observed are preview-before-commit (Airtable) and explicit reversibility copy ("make changes later").
- Blank-path users hit an empty object with no help: Coda/Loop's non-blocking strip stays available at the bottom after the blank choice — recoverable; modal-based galleries are gone once dismissed.

## Accessibility
- Template cards are large image targets — each needs a text name (all observed have labels) and gallery grids need arrow-key navigation.
- Preview panes should be supplementary, not the only description of what a template contains.
- "Recommended" badges must not be color-only.

## Default verdict for our stack
RECOMMENDED — fold into the first-event wizard as step 2: "Start from a conference template / Start blank", with template preview; it is the cheapest way to show what a fully-wired event (program, people, travel, comms) looks like before the admin has built anything.
