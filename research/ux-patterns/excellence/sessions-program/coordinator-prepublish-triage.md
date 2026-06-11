# Pattern: Pre-publish warning triage — categorized counts, inline definitions, opt-in auto-fix

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** 7shifts (refs: [fixing-errors flow](https://mobbin.com/flows/389ba0ce-9288-4d83-bfbb-c7a8eb426111))

## Flow
1. Clicking Publish with outstanding warnings interrupts with a triage modal: "We found some warnings. Let us fix them! — There are a few warnings to look at before publishing."
2. Warnings are CATEGORIZED with counts AND plain-language definitions inline: "0 Exceptions", "0 Conflicts (Conflicts include shifts that already exist, or fall on a day when the employee has an approved time off or is unavailable.)", "1 Overtime warnings", "0 Unassigned Shifts".
3. Choice: "Yes, fix them for me" (primary) / "No thanks" + "Do not show me this again".
4. Auto-fix shows a live progress checklist ("Analyzing and fixing shifts with exceptions… / removing duplicate shifts…"), each item ticking green.
5. Result lands SAFE: "Schedule(s) has been copied and set to draft mode (not live)."

## Use when
Publish is the consequential act (notifications fan out) — the warning inventory makes "publish anyway" an informed decision and teaches the conflict taxonomy.

## Avoid when
Auto-fix moves aren't reversible/explainable — never auto-mutate a program where each session placement was a human decision; offer triage WITHOUT the auto-fixer.

## Sad paths observed
This card IS the sad path: categorized inventory, opt-out memory, and the "(not live)" reassurance.

## Accessibility
Definitions as text under each category; progress checklist gives perceivable feedback during the long-running fix.

## Microcopy worth stealing
"We found some warnings. Let us fix them!" · "Yes, fix them for me" · "…set to draft mode (not live)."

## Default verdict for our stack
RECOMMENDED (triage half) — the publish action should present the conflict inventory (hall overlaps / double-bookings / unassigned-role sessions, with counts + definitions) before snapshotting a version. AVOID the auto-fixer for V1 (program placement is judgment, not optimization).
