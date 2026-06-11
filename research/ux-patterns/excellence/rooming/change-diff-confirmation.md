# Pattern: Change-diff confirmation (old vs new review gate with describe-then-publish)
**Surface:** rooming · **Observed in:** Marriott Bonvoy, ElevenLabs, GitBook, PlanetScale, Neon, Airbnb, Clockwise
(refs: https://mobbin.com/flows/4d947b98-71d1-4030-97e6-dd5daf6d0d3e , https://mobbin.com/screens/ff16450b-9de9-4c60-8738-770be8df0a5c , https://mobbin.com/screens/d8307789-31af-4bdd-b7cf-dab69a87dd95 , https://mobbin.com/screens/45aae177-3a79-4e42-94fa-ac5ab6ec6456 ; raw: `_raw/by-app.md` §A11/A13, `_raw/by-flow.md` §F7, `_raw/by-pattern.md` §P19/P32)

## Flow
1. Confirm screen renders the delta, not just the new state: "DATES Jul 16–17, 1 Night" + flagged "⚠ DATE CHANGE — Jul 18–19, 1 Night"; policy and price re-stated at the NEW terms before commit (Marriott).
2. Money delta as a triplet: "Original reservation $50.74 / New reservation $101.47 / Total to pay $50.73 … in 5–7 days" (Airbnb).
3. Bulk variant: side-by-side "Published version" vs "Current changes", unchanged bulk collapsed ("Expand 77 lines…"), required "Describe what changed in this version" → Publish (ElevenLabs); rendered-document diff with strikethrough/green inline (GitBook).
4. Approve as an explicit choice distinct from comment: "Leave a comment — You are not approving…" vs "Approve changes" (PlanetScale); "This deploy request has not been approved yet" banner.
5. Proposed-change dialog shows new vs struck original ("Tomorrow, 1pm–2pm · New / ~~9am–10am~~ · Original") (Clockwise).

## Use when
Any edit to a confirmed assignment, any re-import of the delegate list, any block re-negotiation — anything where downstream parties were already told the old values.

## Avoid when
The record is still draft and nobody has been notified — diff ceremony on unpublished data is friction.

## Sad paths observed
- Unapproved state labeled loudly; request-changes/comment-without-approval are first-class outcomes; rollback framed as a previewable diff, not a blind restore (Neon "Proceed to restore").

## Accessibility
Diffs pair color with +/− glyphs, counts, and strikethrough — never color alone.

## Default verdict for our stack
RECOMMENDED — the single most stealable element of the sweep for change-handling: every confirmed-record edit renders "field: old → new" before save, and the ElevenLabs "describe what changed" note becomes the notification text sent to hotel + delegate. Old app auto-flips status (confirmed→changed) with no review gate.
