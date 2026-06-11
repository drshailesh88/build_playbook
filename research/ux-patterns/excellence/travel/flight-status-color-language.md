# Pattern: Flight status color language (green/red + minute deltas)
**Surface:** travel · **Observed in:** Flighty (refs: https://mobbin.com/flows/7e5b1c0f-fe17-4f5f-ad94-dfd1fc802091, https://mobbin.com/flows/8f54910b-ffab-4066-bafb-ea16f525f27c), Air NZ, American Airlines ("ON TIME" chip)

## Flow
1. Every displayed time carries a state color: green = on time / early, red = late. Neutral gray for scheduled-only (no live data yet — Qantas shows "Scheduled" chips).
2. The delta is spelled out per endpoint, not just a label: "9m early", "26m late", "1m early" under each airport's time.
3. Changed times show old struck through next to new (Flighty arrival "~~4:31~~ 1m early").
4. Status text is phase-aware: "Departs On Time" → "IN AIR / Landing in 3h 29m" → "Arrived 33m Early".

## Use when
Any list/card/detail showing departure or arrival times where live (or last-known) status exists; ops scanning many records need pre-attentive color triage.

## Avoid when
No live data source exists and times are pure plans — coloring everything green fabricates confidence; use neutral "scheduled" styling instead.

## Sad paths observed
- Unknown gate/terminal/baggage rendered as "--" placeholder (Flighty, AA, Qantas) — never hidden, never fake.
- Delay state escalates the whole card tint (Flighty red lock-screen card), not just one number.

## Accessibility
Color is always paired with text ("26m late", "On Time") — never color-only. Deltas readable by screen reader as plain words.

## Default verdict for our stack
RECOMMENDED — status badges exist in the oracle (F5); this adds the early/late delta + struck-old-time grammar when live tracking lands.
