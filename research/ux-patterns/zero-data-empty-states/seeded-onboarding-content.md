# Pattern: Never truly empty — workspace seeded with onboarding artifacts at creation
**Surface:** zero-data-empty-states · **Observed in:** Notion, Causal, monday.com (refs: https://mobbin.com/screens/2641304f-d69f-4644-bccc-bc2577f00dc3, https://mobbin.com/screens/7fe20ac8-2dee-4468-8ac6-f73038d4e5f9, https://mobbin.com/screens/a8c412e9-2b79-42db-8795-117e568e1dd5, https://mobbin.com/flows/710c15b9-59ac-4596-998c-67b668fa106c, https://mobbin.com/screens/fc17d45d-8927-4536-a43f-17780e99d0af)

## Flow
1. The workspace is born containing real objects made of onboarding content, so the user's first sight is content, not voids: Notion creates a "Getting Started"/"Welcome to Notion" page (interactive checkboxes teaching core verbs: "Click anywhere and just start typing", "Hit / to see content types"), plus sample pages like "To Do List"/"Task List" in the sidebar.
2. The seeded artifact doubles as the tutorial — it is built FROM the product's own primitives (a Notion doc teaching docs; Causal's "Getting started (Cloned)" model teaching models alongside template models "B2B SaaS Revenue", "Profit & Loss + Cash Runway").
3. monday goes further: the onboarding wizard manufactures the first real board from the user's typed answers before they ever see the app, so the workspace opens with their own board, never a blank.
4. Seeded artifacts are ordinary objects — deletable, renameable; once deleted, the workspace behaves like any other.

## Use when
- The product's core object can carry instructional content naturally (a sample "Welcome" event whose program slots teach the program builder).
- You want first-session learning without modal tours — the tutorial is persistent, skimmable, returnable.

## Avoid when
- Seeded objects would pollute tenant-wide counts, billing metrics, search, or integrations (a seeded event leaking into a public events listing or attendee email flows would be a serious defect).
- B2B contexts where multiple members join later — member #5 sees a stale "Getting Started" doc as clutter, not help.

## Sad paths observed
- Notion workspaces accumulate seeded artifacts across surfaces (Getting Started + To Do List + Templates entry + trial banners) — the "empty" workspace is actually busy.
- No observed app auto-removes seeded content after activation; it lingers until manually deleted.

## Accessibility
- Notion's checkbox-tutorial is real interactive content — fully keyboard/screen-reader navigable because it IS the product, a structural advantage over overlay tours.
- Emoji-heavy copy (👋 🥳 👈) is read aloud literally by screen readers — observed throughout Notion's seeded pages; use sparingly.

## Default verdict for our stack
VIABLE — a single seeded sample event that teaches the event/program model is attractive for Event State, but only with hard guarantees it's excluded from counts, listings, and messaging; otherwise prefer the takeover + checklist with no seeds.
