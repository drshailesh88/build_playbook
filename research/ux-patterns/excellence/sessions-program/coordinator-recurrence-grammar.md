# Pattern: Recurrence editor grammar + natural-language summary with computed count

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** Skiff, Cron, Posh (refs: [Skiff recurrence](https://mobbin.com/screens/57b4fabe-1140-4dca-bdd3-eac72c999761), [Cron repeat modal](https://mobbin.com/screens/ebea84b5-e1ee-49a8-8322-11c6e38d5dd9), [Posh recurring series](https://mobbin.com/screens/1f1ae6d5-c6a6-4df1-88b1-dfecb66fcfb6))

## Flow
1. The canonical grammar: "Repeat every [N] [day/week/month]" / "Repeats on" S-M-T-W-T-F-S day pills / "Ends": never · on [date] · after [N] times.
2. Posh adds the two safety layers: inline validation ("The end date must be at least one month after the start date.") and a live plain-English summary WITH computed count: "Repeats every 1 month on the 28th of the month until February 4th, 2026 **(2 events)**".
3. Timezone visible at the point of edit (Cron "GMT-4 New York").

## Use when
Repeating sessions (daily morning briefings, recurring workshops) — the computed count is what catches rule mistakes before they create 52 sessions.

## Avoid when
A conference program with no true recurrence — Luma-style multi-date clone (pick explicit dates) is simpler than a rule for 2-3 occurrences.

## Sad paths observed
- Inline rule-violation error (verbatim above) — recurrence rules can be self-contradictory and must validate.

## Accessibility
Day pills are toggle buttons with letters + state; the sentence summary is the screen-reader-friendly restatement of the rule.

## Microcopy worth stealing
"Repeats every 1 month on the 28th… until {date} (2 events)" — always show the computed count.

## Default verdict for our stack
VIABLE — low priority for conference programs (explicit dates beat rules at this scale); if recurrence ships, this grammar + computed-count summary is the only acceptable shape.
