# Pattern: Pre-composed share card + prefilled brag copy (+ privacy toggle)

**Surface:** certificates / recipient-share · **Observed in:** Duolingo, Replit, Reddit, Marriott Bonvoy, Any Distance, Fiverr Learn, Superhuman, Handshake (refs: https://mobbin.com/flows/3f0795fd-8c9a-4887-acbb-cdd1ffa81b3d, https://mobbin.com/flows/bbe22c41-e24b-43b3-a146-4de331ec14a1, https://mobbin.com/screens/6b775721-e6cc-47e5-9bab-1b29894d94a4, https://mobbin.com/screens/2d444eb2-7070-48a9-a55c-80fbc43b1bd8, https://mobbin.com/flows/b07960b3-0375-49df-97aa-a5f6a85e6051, https://mobbin.com/screens/eeb9e354-0908-449c-a054-24cf2b04ed58, https://mobbin.com/flows/0eb021f2-221c-4f1a-9c2f-393583991aae)

## Flow
1. Achievement moment auto-generates a DESIGNED share image (square card with date/score/logo — Duolingo; story-format variant — Any Distance) distinct from the certificate PDF itself.
2. Share text is prewritten with hashtags + link: "Hello to the world of coding… Day 1 of #Replit100DaysOfCode #100DaysOfCode. Join me on @Replit <link>" (Replit) — recipient does zero composition.
3. Preview of the generated card BEFORE posting + privacy toggle "**Include username and avatar**" (Reddit).
4. Targets: native share sheet (Save Image, Messages, Instagram) on mobile; icon row (LinkedIn/X/Facebook) on web.
5. Evidence of why it matters: the certificate image IS the feed creative in real posts (Handshake student post) — design for thumbnail legibility.

## Use when
You want recipients to market the conference — every shared certificate is issuer advertising; make the share zero-effort and beautiful.

## Avoid when
Conservative professional contexts where gamified brag copy reads as spam — for medical CME keep the prefilled text factual ("I earned 12 CME credits at GEM 2026") and skip incentivized-share mechanics (Duolingo "+20 GEMS" would be off-voice).

## Sad paths observed
- None in-flow; the implicit failure is an illegible certificate thumbnail in feeds — the share card (big name, big event logo) fixes what the A4 PDF render can't.

## Accessibility
Share card needs alt text with the full claim; privacy toggle labeled in text.

## Default verdict for our stack
VIABLE (polish) — never attempted in legacy. Generate a social card (1200×630 + square) per certificate alongside the PDF; prefill factual copy + event hashtag.
