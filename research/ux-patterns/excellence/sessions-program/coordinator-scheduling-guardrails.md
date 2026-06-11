# Pattern: Scheduling guardrail settings — constraints defined once, enforced at placement

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** User Interviews (refs: [manage availability + rules](https://mobbin.com/screens/e6e4ff11-5e88-497e-905e-ad03de19e100))

## Flow
1. A rules panel beside the availability grid: "Minimum scheduling notice [4][Hours]", "Maximum number of confirmed sessions per day [6]", "Show open time slots on my connected calendar", attendance role default.
2. The constraints are set ONCE and enforced automatically at every subsequent placement — the coordinator doesn't re-police them per booking.
3. Confirmations restate specifics: "Jon Smith has been scheduled for the session on 12/20/2023 at 08:45 AM EST" (timezone included).

## Use when
Recurring placement rules exist: max sessions per speaker per day, minimum turnaround between a speaker's sessions, hall close times.

## Avoid when
Rules vary per instance — a guardrail that's overridden every time is just friction; keep those as warnings instead.

## Sad paths observed
- None visible; the guardrail prevents the sad path (overloaded speaker, impossible turnaround) upstream.

## Accessibility
Rules are labeled numeric inputs with unit dropdowns; enforcement messages restate values as text.

## Microcopy worth stealing
"Minimum scheduling notice" · "Maximum number of confirmed sessions per day"

## Default verdict for our stack
VIABLE — per-event program settings (max sessions/speaker/day, min gap between a speaker's sessions, hall operating hours) feeding the existing conflict engine as a new warning category; natural home for the warnings→hard-block toggle (old-app NEVER-ATTEMPTED #21).
