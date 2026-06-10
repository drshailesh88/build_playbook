# Pattern: Pre-seeded document as the onboarding (teach-by-doing)
**Surface:** first-run-onboarding · **Observed in:** Notion (refs: [team "Getting Started" page](https://mobbin.com/screens/2641304f-d69f-4644-bccc-bc2577f00dc3), ["Welcome to Notion" workspace variant](https://mobbin.com/screens/2d5a61ef-ab49-49e3-8299-7f683c03fa17), [basics variant](https://mobbin.com/screens/7fe20ac8-2dee-4468-8ac6-f73038d4e5f9), [minimal personal variant](https://mobbin.com/screens/95cfbdc4-10fb-4f5d-bc9e-84c627e3ef35))

## Flow
1. The new workspace ships with a real page in the sidebar ("Getting Started" / "Welcome to Notion") — the onboarding IS an instance of the core object.
2. The page opens on first land and contains live interactive checkboxes ("Invite your teammates to come work with you", "Click anywhere and just start typing", "Hit / to see all content types") — checking them exercises the actual editor.
3. Content teaches by manipulation: a toggle block labeled "This is a toggle block. Click the little triangle to see more useful tips!" — the lesson is the feature.
4. Variants are role/context-tuned: team workspaces get teamspace/invite-focused content; personal workspaces get a 4-line minimal version; first item arrives pre-checked ("Create an account with Notion ✓") for instant momentum.
5. The page is ordinary content — renameable, deletable, ignorable; retirement is just deleting a page. No code-level onboarding state.

## Use when
- The core object is itself an editable document/canvas, so reading the tutorial trains the exact gestures of real work.
- You want near-zero onboarding infrastructure (no checklist engine, no tour framework — it's seeded content).

## Avoid when
- The core object is structured/relational (an Event with program, attendees, travel) — a static page describing it doesn't exercise it; interacting with a doc teaches doc-editing, not event-building.
- You need completion telemetry — checkbox state in a user-editable doc is unreliable signal and the page can be deleted day one.
- Steps must drive users to OTHER surfaces; deep-link lists in a doc are a worse checklist (no progress, no persistence pill).

## Sad paths observed
- Deleted by accident: the page behaves like any content — Notion shows the standard "Moved to Trash — Restore" toast on deletion ([ref](https://mobbin.com/screens/56f376d3-6a51-429c-a008-a37f968b4679)), so it's recoverable but not protected.
- Ignored entirely: it sits in the sidebar indefinitely as stale clutter; nothing nudges back to it.
- No progress visibility: unchecked boxes in a buried page give the team zero sense of setup state.

## Accessibility
- Inherits the editor's accessibility wholesale — checkboxes and toggles are real editor blocks, keyboard-operable to the same degree as normal content.
- Emoji-heavy copy (👋, 👈) should not carry sole meaning; Notion pairs each with text.

## Default verdict for our stack
AVOID — Event State's core object is a structured event, not a freeform doc; teach-by-doing only transfers when the tutorial medium equals the work medium. Steal the spirit (the conference template's pre-filled content can carry inline guidance) but not the mechanism.
