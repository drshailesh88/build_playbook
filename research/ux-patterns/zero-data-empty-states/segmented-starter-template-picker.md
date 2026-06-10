# Pattern: Segmented starter-content picker (templates by use-case at first run)
**Surface:** zero-data-empty-states · **Observed in:** Airtable, monday.com, Mixpanel, Notion (refs: https://mobbin.com/screens/f7fa9038-2128-44f8-8e16-4ac6ff6ac4f8, https://mobbin.com/screens/e96502bb-e8f8-4769-a565-a383d1ca1927, https://mobbin.com/screens/e2e40952-d31e-4c90-a62d-5c4280c0d7f1, https://mobbin.com/flows/09c8b5b5-9900-4d70-859d-65bd93975bd2, https://mobbin.com/screens/9f55986e-6646-4030-b9ce-da3b024813f1)

## Flow
1. At first run (or persistently on Home), creation is offered as a small set of named segments instead of a blank canvas: Airtable "Choose a department — Marketing & Creative / Product Development / Project Management / IT & Support / UX Research... Or, start from scratch: Blank table"; monday "Select what you'd like to manage first — Design & Creative / HR & Recruiting / Sales & CRM / Software development. You can always add more in the future"; Mixpanel "Select Sample Dataset" by industry; Notion "Get started with Notion — add templates: Wiki / Projects / Docs / Meetings [Continue with 4 templates]".
2. Selection seeds real, editable structures (tables/boards/teamspaces) — monday shows "Creating your template boards" install progress; Airtable previews the resulting app live.
3. Escape hatch to blank is always present ("Or, start from scratch"; Airtable Home keeps "Start with AI / Start with templates / Quickly upload / Start from scratch" as permanent cards even after bases exist).
4. Seeded structures are ordinary objects afterward — renameable, deletable; nothing marks them as template-born.

## Use when
- The blank-canvas problem is real: users don't know what good structure looks like (event types: conference vs workshop vs webinar map perfectly to this).
- Segments are few (4-7 observed) and named in the customer's vocabulary, with reassurance copy ("You can always add more in the future").

## Avoid when
- Templates seed data the tenant must then delete (template boards arriving with placeholder rows become cleanup chores — monday's "project #1 / project #2" rows are exactly this).
- Your domain has one dominant shape — a picker of near-identical options is fake choice.

## Sad paths observed
- Template-seeded placeholder content lingers and pollutes search/counts until manually deleted; no observed app offered "remove template content" affordance after install.
- Notion's 4-template default biases toward accepting everything ("Continue with 4 templates" as the single primary button).

## Accessibility
- Segment cards are icon + text label in all observed apps (never icon-only); selection state shown by border + checkmark (Airtable) — keep a non-color indicator.
- monday's install progress screen is animation-heavy with a progress bar; ensure status text accompanies it.

## Default verdict for our stack
RECOMMENDED — event-type templates (conference / workshop / webinar / blank) at first event creation is the highest-leverage version of this for Event State; seed structure (program slots, ticket types), not fake people.
