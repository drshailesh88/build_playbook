# Pattern: Quantified publish with explicit notify choice

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** Deputy (refs: [publish flow](https://mobbin.com/flows/a426e08b-cd76-4cd5-a684-0830b4744e1d))

## Flow
1. The publish button counts the pending work: "Publish 11 shifts" — never a bare "Publish".
2. Publishing opens a "Notify staff" modal with three radio choices: "Notify (email, app)" / "Require confirmation (email and app)" / "No notifications (mark as published)".
3. After publish: affected chips turn green, the button becomes the success state "All shifts published".
4. A persistent bottom legend doubles as color key with live counts: "0 empty · 11 unpublished · 1 published · 0 require confirmation · 1 open shifts · 0 warnings…".

## Use when
Publish triggers notification fan-out — the coordinator must control WHETHER and HOW HARD recipients are pinged (notify vs require-confirmation vs silent).

## Avoid when
Attendees/faculty rely on always being notified — the silent option then needs guard copy ("faculty will NOT be told about these changes").

## Sad paths observed
- Warning-triangle red chip publishes only past the triage; "1 warnings" stays counted in the legend.

## Accessibility
Legend pairs every color with label + count — the grid is readable without color perception.

## Microcopy worth stealing
"Publish 11 shifts" · "All shifts published" · "Require confirmation (email and app)" · "No notifications (mark as published)"

## Default verdict for our stack
RECOMMENDED — maps exactly onto the existing publish flow: "Publish version 4 — 12 sessions changed" with the notify choice (notify affected faculty / require re-confirmation / silent snapshot). "Require confirmation" composes with the reconfirmation-emails card.
