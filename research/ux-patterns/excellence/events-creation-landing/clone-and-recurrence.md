# Pattern: Clone with explicit copy matrix + recurrence in natural language

**Surface:** events-creation-landing · **Observed in:** Luma web (https://mobbin.com/flows/589cf657-0963-4905-97b4-b715a91f27cb, https://mobbin.com/flows/6e029388-0089-4fa3-bfbf-babcfe629ded), Posh web (https://mobbin.com/flows/e0c4b2e2-d811-4457-8043-dfe07d025331), Partiful web (https://mobbin.com/screens/3fee236a-dfe6-4fa7-aee9-50e90d3017af), Kajabi web (https://mobbin.com/flows/76b2eb45-57b0-479a-b22e-88d594824c80), Amie web (https://mobbin.com/flows/97ac1996-cdb7-4a47-900e-9480776ddf39)

## Flow
1. Clone states its copy matrix UP FRONT: "Clone Event — Create a new event with the same information as this one. Everything except the guest list and event blasts will be copied over." (Luma).
2. Bulk multi-date clone: "Choose Times" modal — start date, "Repeats — Weekly", day-of-week letter pills, "Until / For — 6 weeks" segmented, a live preview of generated date chips, constraint in amber ("You can add up to 6 times at once."), and the CTA carries the live count: "Add 6 Times". Success lists every new event with links: "We've created 9 new events." (Luma).
3. Recurrence rules confirmed in NATURAL LANGUAGE with computed count before save: "Repeats every 1 month on the 28th of the month until February 4th, 2026 (2 events)"; impossible ranges error inline: "The end date must be at least one month after the start date." (Posh).
4. Two distinct recurrence models observed: clones (each occurrence = independent event/page/guest list — Luma Choose Times) vs sessions (one event, one page, "Session Start Times" list + "Add Recurring Sessions" — Luma series). The choice is structural, not cosmetic.
5. Lightweight duplicates: "Clone Event" in the page overflow menu (Partiful); duplicate as a row icon in the events table (Kajabi); right-click → Duplicate + confirmation toast (Amie).

## Use when
Organizers run repeat events (annual conferences, monthly meetups). The copy-matrix disclosure is mandatory — silent inclusion/exclusion of registrants is how trust dies.

## Avoid when
Don't model multi-day conference days as recurrence — that's the program/sessions module. Avoid clone-per-occurrence when attendees register once for a series.

## Sad paths observed
- Invalid recurrence range → inline red error (verbatim above, Posh).
- Caps stated in amber before hitting them ("up to 6 times at once").
- Date-shift integrity: cloned occurrences each get their own page — stale links to the "wrong week" can't happen.

## Accessibility
Generated date chips are text; natural-language summary doubles as the screen-reader-friendly form of the rule.

## Default verdict for our stack
RECOMMENDED (clone half) — the old app already has duplicate-event with a copy matrix in UI copy and date-shifting (carry verbatim, done-spec §6); the steal is the natural-language confirmation + live generated-dates preview. Recurrence engines are AVOID for V1 (annual conferences don't recur monthly; duplicate covers the real job).
