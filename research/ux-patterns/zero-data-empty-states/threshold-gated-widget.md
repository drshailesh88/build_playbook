# Pattern: Threshold-gated widget ("metrics show after N records, X/N so far")
**Surface:** zero-data-empty-states · **Observed in:** Copilot (refs: https://mobbin.com/flows/63ada8d0-d8a0-4f25-8b72-a83f622b6c29 — screen "Metrics will show after you create 10 clients (2/10 created so far)")

## Flow
1. An analytics widget renders its frame with a ghosted/sample trend line behind an info bar.
2. The info bar states the exact unlock condition and live progress: "Metrics will show after you create 10 clients (2/10 created so far)" with a "Go to CRM" link to the module that feeds it.
3. As records accumulate, the counter updates; at the threshold the ghost is replaced by the real chart.

## Use when
- A widget is statistically meaningless below a floor (attendance trends with 2 registrants) and you'd rather state the rule than show a misleading 2-point chart.
- You can compute progress toward the threshold cheaply and link directly to the feeding module.

## Avoid when
- The threshold is arbitrary or invisible to the user's mental model — "why 10?" invites support tickets; only gate where small-N output is genuinely junk.
- The user has no way to reach N soon (e.g., waiting on external attendees) — a hard gate on something outside their control reads as a paywall.

## Sad paths observed
- Only one app observed (single-source pattern — treat as a candidate, not an industry norm).
- The ghost chart behind the bar can be mistaken for real data at a glance; Copilot keeps it visibly grayed.

## Accessibility
- The unlock condition is plain text in an info bar, not tooltip-only — keep it that way; progress "(2/10)" is text, not just a meter.
- Ghost chart is decorative; must be aria-hidden equivalent so the announced content is the condition sentence.

## Default verdict for our stack
VIABLE — strong fit for Event State analytics (registrations/attendance charts that are noise below ~N registrations), but single-app evidence; use sparingly and always state the exact rule with live progress.
