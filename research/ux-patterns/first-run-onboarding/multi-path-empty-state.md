# Pattern: Multi-path action empty state (module first-use)
**Surface:** first-run-onboarding · **Observed in:** folk, Vercel, Render, Mixpanel, Productboard, Airtable, Asana (refs: [folk "let's add your first partners"](https://mobbin.com/flows/d6cccc15-0fd8-4412-9b19-d6a00993978d), [Vercel "No projects, yet!"](https://mobbin.com/screens/e03a020c-0ddc-4d5f-9d75-6cfcd7f586a6), [Render "You haven't created any services yet"](https://mobbin.com/screens/b3ff4d88-92b3-406c-b9c1-577cabdc030f), [Mixpanel](https://mobbin.com/screens/d25e3630-abec-48eb-81ad-97c90419cc2a), [Productboard](https://mobbin.com/screens/e0bebb50-4971-4b97-b510-2b601086cd43), [Airtable home](https://mobbin.com/screens/440e61a4-7a70-4210-8f83-ac2a089a4a96), [Asana examples modal](https://mobbin.com/screens/6d39eaba-e29e-474e-b306-0c7b3235ac3f))

## Flow
1. First visit to an empty module shows not a bare "nothing here" but 2–4 typed entry cards, each a different route to the first object: folk offers "Start with 10 sample contacts / Sync your contacts, emails and calendar / Import from a file, an integration, or a CRM" plus a quiet "Or create contacts manually" below.
2. Cards differentiate by SOURCE or TYPE, not just style: Render's empty Overview offers "Deploy a Web Service / Deploy a Static Site / Create a Postgres database / Explore all service types" — the empty state teaches the module's type system.
3. Headline is stateful and friendly, naming the void: "No projects, yet!" (Vercel), "You haven't created any services yet. Deploy in just a few minutes." (Render), personalized "Welcome Sam, let's add your first partners" (folk).
4. A learning path rides alongside the action path: Mixpanel pairs "New Board / Use a Template" with "Learn Board Basics or explore Example Boards"; Asana's empty project pops an "Examples to get you started" picker (Welcome your team / Add meeting details / Add communication channels).
5. The standard create CTA remains in the chrome (toolbar "+ New"), so the empty state is additive, never the only path.

## Use when
- Each module a new admin explores after creating the event (people, program, travel, comms) — every module's first-use IS this pattern.
- Multiple legitimate entry routes exist (manual add / import CSV / sync integration); the empty state is where users decide.
- You want module education without tours: the empty state is contextual, persistent until resolved, and self-dismissing (it disappears when content exists).

## Avoid when
- Only one entry route exists — a single clear CTA beats a fake gallery of one.
- The module isn't actually empty (partial data); don't overlay entry cards on real content — Mixpanel switches to a slim warning banner instead.
- Cards would bury the most common path; folk demotes "create manually" to a text link below the cards deliberately — copy that hierarchy only if your data agrees.

## Sad paths observed
- Empty-because-broken vs empty-because-new: Mixpanel distinguishes — "We don't have any data! Don't worry—it's easy to get implemented" (warning tone, fix CTA) vs a normal "create your first board" empty state.
- Import promised, not delivered inline: folk's "Migrate from another CRM" card sets expectations ("We'll assist with importing...") before a "Start migration" commitment.
- Dead-end after dismissing suggestions: Asana's examples modal has an X; the project remains usable with standard add-task affordances — the empty state must never be the only path in.

## Accessibility
- Entry cards are links/buttons with text labels in all observed apps — keep icon+text, never icon-only.
- Empty-state headlines carry state info; ensure they're real headings for screen-reader landmarks.
- Action cards in a row need logical tab order matching visual priority.

## Default verdict for our stack
RECOMMENDED — this is the "module exploration" half of our surface: each module inside the new event ships a typed multi-path empty state (add manually / import / use template section), which makes per-module tours and tooltips unnecessary.
