# Pattern: Mobile grid adaptation — Move/Copy verbs on touch, 2–3 day columns, next-up strip

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** TimeTree, Cron (iOS), Outlook (iOS) (refs: [TimeTree Move/Copy](https://mobbin.com/screens/090f84e4-a389-4521-b18a-339c3a036610), [Cron 2-day view](https://mobbin.com/screens/3b91c850-4eff-416f-80ca-b9f0ccde05ba), [Cron status sheet](https://mobbin.com/screens/59da54a2-f73e-4ffa-9f2c-7f614d97e870), [Outlook 3-day view](https://mobbin.com/screens/7c44fcd6-a3a0-43c8-81a1-dac8619cf607))

## Flow
1. Touch reschedule = explicit verbs, not drag: long-press raises a context bubble with "Move" | "Copy" targeting the selected event to the chosen date (TimeTree) — beats drag precision on touch.
2. Phone week views show 1–3 day columns, never 7 (Cron: 2 columns; Outlook: 3 with month strip above and current-time line).
3. A bottom textual status sheet anchors orientation: "Upcoming in 1h 39mins" / "No upcoming meeting" + "+" FAB (Cron).

## Use when
The coordinator opens the schedule on a phone (on-site, day-of) — desktop grid density does not survive on mobile.

## Avoid when
Shipping the desktop grid to mobile verbatim — none of the observed calendar apps do; the adaptation IS the pattern.

## Sad paths observed
- "No upcoming meeting" calm-empty in the status sheet.

## Accessibility
Verb menu is labeled buttons (vs precision drag — itself an a11y win); current-time line supplements the textual next-up strip.

## Microcopy worth stealing
"Move" | "Copy" · "Upcoming in {time}"

## Default verdict for our stack
RECOMMENDED — the old app's grid had responsive scars (44px targets, table/card splits); the rebuild rule: admin schedule on mobile = 1-day hall-columns view + long-press Move/Copy + next-session strip, not a shrunken week grid.
