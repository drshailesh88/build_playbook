# Pattern: Relative-to-event scheduling — "N hours before event starts" trigger form
**Surface:** automation-triggers / scheduling · **Observed in:** Cal.com; adjacent: Square, Apollo (refs: [Cal.com workflow](https://mobbin.com/screens/2b89c07b-a910-44f3-bba4-83e07dff61b7), [Square reminder toggle](https://mobbin.com/screens/1ce7c729-82db-4fdb-b4be-e25580d2c0c1), [Apollo presets](https://mobbin.com/screens/5d9581e4-6ddc-4554-8d2b-313a9987c02a))

## Flow
1. Numbered form, no canvas: "1. Trigger — When something happens": When = [Before event starts ▾]; "How long before event starts?" = [24] [hours ▾] (Cal.com).
2. "2. Action — Do this": [Send email to attendees ▾] + Sender name + Message template dropdown (Reminder) + Email subject with "Add variable ▾".
3. Scope selector: "Which event type will this apply to?" + "Apply to all, including future event types" checkbox.
4. Operational caveat surfaced inline: "When testing this workflow, be aware that Emails and SMS can only be scheduled at least 1 hour in advance."
5. Square's lighter sibling: a single review-page toggle, "If the email is not opened, resend the email 5 days after the original delivery date."

## Use when
Time-anchored event communication — pre-event reminders, post-event follow-ups, day-of instructions. The anchor ("before event starts") is domain language, not cron.

## Avoid when
The trigger is a state change (registration created, travel updated) — that's the domain-event trigger pattern, not clock-relative.

## Sad paths observed
- Cal.com names the scheduling floor (≥1 hour ahead) instead of failing silently when the window has passed.
- Scope checkbox ("including future event types") prevents the new-event-forgot-the-reminder failure.

## Accessibility
Pure form controls — selects and a number input; works without canvas interactions.

## Default verdict for our stack
RECOMMENDED — this is exactly the missing `event_reminder` dispatch shape (48h-before per data-requirements); a form like Cal.com's, anchored to event start date, fits our triggers page without inventing a canvas.
