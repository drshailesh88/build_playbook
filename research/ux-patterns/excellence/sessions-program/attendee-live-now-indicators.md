# Pattern: Happening-now indicators — one badge slot, three temporal states + now-line

**Surface:** sessions-program / attendee-program · **Observed in:** Insight Timer, Peanut, Peloton, Fixtured, Open (refs: [Insight Timer hub](https://mobbin.com/screens/db3e14f8-31d0-4a36-9387-0fc218f20aac), [badges](https://mobbin.com/screens/587ee5e6-a0de-472a-9a7b-68992bbf0894), [Peloton LIVE rows](https://mobbin.com/screens/dea205e1-85f7-4a27-89bf-b0ea6af81816), [Fixtured now-line](https://mobbin.com/screens/77c4d66a-e281-4a89-aba0-c117599f7768), [Open countdown](https://mobbin.com/flows/586efb2c-a941-4d2f-9b22-03c2d1185ecb))

## Flow
1. One badge slot per session card carries three temporal states: red-dot "LIVE" when live · "IN 1 HR 9 MIN" countdown when imminent · "TODAY - 8:00 PM" when later (Insight Timer). Text carries the state, never color alone.
2. Page-level rollup pill: "● 1 LIVE NOW"; per-card social proof "61 attending".
3. In a scrolling timeline, a horizontal now-line (blue line + dot) sits between past (muted cards, "Final") and upcoming (vivid cards) — the auto-scroll anchor for "where are we now" (Fixtured).
4. Live cards swap the CTA: "Join"/"Preview" replaces "Set reminder" (Peanut); countdown timers on imminent cards (Open "06:12:05").

## Use when
Conference day-of mode — the program's job changes from planning to orientation; "what's on right now, where" becomes the primary query.

## Avoid when
Pre-event browsing weeks out — live chrome is dead weight; switch it on by date proximity.

## Sad paths observed
- Past items demoted but visible ("Final", muted) — orientation needs the past as context.

## Accessibility
All states are words + glyphs; the now-line supplements (not replaces) per-card state text.

## Microcopy worth stealing
"IN 1 HR 9 MIN" · "1 LIVE NOW" · "61 attending"

## Default verdict for our stack
RECOMMENDED (day-of mode) — no app showed this inside a conference agenda specifically (transfer, flagged in coverage); "Happening now" grouping + now-line in the attendee program during event dates is a high-wow, low-effort differentiator.
