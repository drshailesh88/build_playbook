# Pattern: Channel/type-split IA — one-off vs automated vs transactional
**Surface:** communications IA · **Observed in:** Loops, Customer.io, HubSpot, AutoSend (refs: [Loops home](https://mobbin.com/flows/cd9dd7a6-facb-420e-a06e-c9c2a0c11a17), [Customer.io create-broadcast](https://mobbin.com/flows/effe83a3-f78b-4724-95c9-5a3a4944def3), [HubSpot templates](https://mobbin.com/screens/0e0c23a9-330a-46fa-a7ac-0711788b7b1b), [AutoSend nav](https://mobbin.com/screens/203c7575-11eb-45d1-bf20-ae879d22dee5))

## Flow
1. Loops home splits sending into three first-class objects, each with a one-line job: Campaigns ("Send an email to a segment of contacts once"), Loops ("Trigger an email with an event"), Transactional ("Send an email to a single contact") — each with create-first row + starter templates.
2. Customer.io's create screen forces the same split as type cards: Newsletter (one-off) vs "Messages triggered via API" (alerts, event reminders).
3. AutoSend's sidebar groups nav under TRANSACTIONAL EMAILS / MARKETING EMAILS / OTHER (suppressions, webhooks).
4. HubSpot's template hub splits by channel: Email / WhatsApp tabs in one screen.
5. Loops groups campaign/automation lists by lifecycle stage (Acquisition / Onboarding / Retention…) with per-group add.

## Use when
The module serves three genuinely different jobs (one-off broadcast, event-triggered automation, single transactional send) — naming them at the IA level stops users hunting for "where do I send X".

## Avoid when
Only automated sends exist (no broadcast feature) — a type split with one populated type reads as broken.

## Sad paths observed
- Loops: every type has its own empty state with starter templates, so a fresh workspace never shows a bare table.
- Customer.io: type chosen at create time is binding — the wizard differs per type, preventing half-configured hybrids.

## Accessibility
Type cards are large click targets with text labels; lifecycle group headers are plain headings.

## Default verdict for our stack
RECOMMENDED — maps 1:1 to our M13 (one-off/broadcast), M53 (triggers), and cascade/transactional sends; the hub should name the three jobs instead of burying triggers under a Templates page.
