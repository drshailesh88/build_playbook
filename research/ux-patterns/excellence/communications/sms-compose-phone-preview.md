# Pattern: SMS/short-message compose — token chips, character budget, phone-frame live preview
**Surface:** multi-channel compose · **Observed in:** Posh (event platform); adjacent: folk (refs: [Posh composer](https://mobbin.com/screens/2bc41822-1a58-4f50-a392-6fc7b6031ae4), [Posh inserted field](https://mobbin.com/screens/7ee06c31-c10a-4888-8b53-4925d50904b9))

## Flow
1. Recipients block names the blast radius in domain language: "This SMS blast will be sent to the 3 attendees that you've selected" + avatar stack + "View & Edit Recipients".
2. Compose textarea with two chip buttons: [⊞ Insert Field] (personalization token rendered as a colored inline chip + "Inserted FIRST NAME field" toast) and [✎ Attach Event Link].
3. Character budget visible while typing: "89/140 Characters" with an ⓘ explaining the limit.
4. Right side: live PHONE-FRAME preview (iMessage mock) rendering the message WITH sample data ("Hi! Alex…") — sender name prefix shown as recipients will see it.
5. Rate-limit disclosure in the footer: SMS blasts limited within a rolling 30-day period — the quota is stated where the message is written.

## Use when
Any character-constrained channel (SMS, WhatsApp text) — the char counter and phone-frame preview prevent mid-message truncation and "looks wrong on the phone" surprises.

## Avoid when
Email composition — the phone frame misrepresents rich HTML rendering; use desktop/mobile email preview instead.

## Sad paths observed
- Over-limit risk is visible continuously (counter), not at submit.
- Variable chips make personalization visible inside a tiny textarea where raw `{{tokens}}` would eat the budget invisibly — preview shows true post-interpolation length.

## Accessibility
Chip buttons are labeled; counter is text; preview duplicates (not replaces) the textarea content.

## Default verdict for our stack
RECOMMENDED as the transferable shape for our WhatsApp channel compose — FIRST-PRINCIPLES FLAG: Mobbin has ZERO WhatsApp-Business/WABA campaign tooling (verified twice, incl. comms-sender-setup harvest); template-approval states and 24-hour-session rules must be designed from Meta/provider docs. Posh's counter + chips + phone-frame + sample-data preview is the strongest observed starting point.
