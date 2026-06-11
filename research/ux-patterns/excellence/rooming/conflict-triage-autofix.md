# Pattern: Conflict detection + pre-publish triage (fixable vs unfixable, auto-fix with review)
**Surface:** rooming · **Observed in:** Clockwise, 7shifts, Fresha
(refs: https://mobbin.com/screens/671e0870-f520-4d92-bc16-8ee9b332bb3b , https://mobbin.com/screens/8796902e-18e6-4f82-98d8-2146b96be325 , https://mobbin.com/screens/e330f42b-1220-4c3d-8c87-64c6de3f001b , https://mobbin.com/screens/ac5e971e-8cfb-47ca-9b36-bb6ae392b53f ; raw: `_raw/by-pattern.md` §P17, `_raw/by-flow.md` §F19)

## Flow
1. Sentence verdict first: "I can schedule this meeting, but there is a conflict for Sam." (Clockwise).
2. Severity tiers separated: "Sam has conflicts that I can't fix:" (hard) vs "You have inconveniences:" (soft); reassurance "Nothing will change until explicitly confirmed."
3. Persistent toolbar chips next to the publish action: red "2 Conflicts", amber "2 Overtime", link "Fix warnings"; offending cells tinted at the exact location (7shifts) — two-level signposting.
4. Pre-publish triage modal with taxonomy + counts + definitions per class, then "Yes, fix them for me" → live auto-fix progress → honest partial result: "There were some warnings we couldn't fix so you may want to review your schedule before publishing."
5. Warn-but-allow for soft rules: amber inline "Alex Smith is not working between 7:00am and 7:45am" with Apply still enabled (Fresha).

## Use when
Assignments can violate rules: delegate double-roomed, assignment dates outside the person's travel dates or the block's nights, over-capacity rooms, roommate-rule violations.

## Avoid when
A rule is a hard invariant the server must reject anyway — don't downgrade data integrity to a dismissible warning.

## Sad paths observed
The pattern IS the sad path: unfixable separated from fixable; auto-fix admits partial failure and routes to review; soft violations overridable with the reason stated.

## Accessibility
Conflict chips = color + count + word; cell-level indication paired with a list view of the same conflicts.

## Default verdict for our stack
RECOMMENDED — "2 Conflicts · 1 Over capacity · Fix warnings" above the rooming list/grid, with a triage gate before "Send to hotels". Distinguish hard conflicts (same bed, overlapping nights) from inconveniences (preference miss, split stay). Old-app cascade flags are reactive; this is the proactive complement.
