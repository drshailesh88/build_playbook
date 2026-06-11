# Pattern: Recurring schedule templates — stamp out repeating runs, edits never retro-apply

**Surface:** transport · **Observed in:** Route4Me, Routific, Tookan, OptimoRoute
(refs: P13, F25, F26 — URLs in `_raw/`; key: https://help.routific.com/en/articles/9-what-are-route-templates, https://help.jungleworks.com/knowledge-base/recurring-tasks/)

## Flow
1. A template stores the stable parts: shift times, start/end locations, vehicle capacity, route count (Routific).
2. Instantiation is either manual ("+ → Add route from template → quantity → Add routes" — Routific) or scheduled (Route4Me Master Route + recurring schedule auto-generates and even auto-dispatches; Tookan REPEAT with daily/weekly/monthly rules and explicit END conditions — count or date).
3. Generation can run one day prior to keep boards uncluttered (Tookan "Create Recurring Tasks One Day Prior").
4. Template edits deliberately do NOT retro-apply: "Editing templates will not adjust any current scheduled routes. It will, however, affect any new routes to be scheduled" (Routific).
5. Multi-day planning variant: plan up to 5 weeks with per-order Allowed Days / Blackout Date constraints (OptimoRoute).

## Use when
Conference hotel-loop shuttles repeating each event day — define the loop once, stamp per-day batches, adjust each day's instance independently.

## Avoid when
Every run differs (arrival pickups keyed to flights) — templates fit the fixed-loop subset of transport only. Avoid unbounded recurrence: Tookan ships a help article for runaway recurrences; end conditions are mandatory.

## Sad paths observed
- Runaway recurrence is a real documented failure mode ("Recurring tasks cannot be controlled?" — Tookan).
- No-retro-apply is the safety rule that makes templates trustworthy.

## Accessibility
Not observable from documentation sources.

## Default verdict for our stack
VIABLE (V2-leaning) — multi-day medical conferences repeat hotel↔venue loops daily, but V1 can copy-a-batch-to-another-date and get 80% of the value with 20% of the machinery.
