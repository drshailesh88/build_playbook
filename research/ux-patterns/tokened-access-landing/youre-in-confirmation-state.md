# Pattern: "You're In" confirmed state with self-serve cancel link
**Surface:** tokened-access-landing · **Observed in:** Luma (refs: https://mobbin.com/screens/243fda9c-56e1-4ce4-bb3a-aedc92ddb7ef, https://mobbin.com/screens/1bd28b3e-549a-4cf6-8e5f-d1fa22e5137a, https://mobbin.com/screens/96dccfb9-151d-41a8-9f8a-72ff8b5b6e7d), Calendly (refs: https://mobbin.com/screens/7a7b6432-5b8e-4323-93bb-116bbb539b87, https://mobbin.com/screens/a4372e19-a051-4e2a-a7f6-84dbd09f96b8)

## Flow
1. After accepting, the registration card becomes "You're In" with an emoji/checkmark.
2. Subline confirms the channel: "A confirmation email has been sent to jsmith@…".
3. Utility row: countdown to event ("Event starting in 17d 21h"), Add to Calendar (Google/Apple/ICS), invite-a-friend (sometimes).
4. Escape hatch in small text: "No longer able to attend? Notify the host by canceling your registration."
5. Optional "Get Ready for the Event" expandable: profile completeness + email/SMS reminder toggles.
6. Calendly variant: standalone "Confirmed / You are scheduled" card with event summary and "A confirmation has been sent to your email address."

## Use when
- Any tokened accept needs a durable, revisitable state: re-opening the same link should show the current status, not the original question.
- You want self-serve withdrawal without support tickets — the cancel link is part of the confirmation.

## Avoid when
- Confirmation has downstream obligations (assigned responsibilities) that the person must still review — don't present a closed "done" state; surface the obligations list on the same page.
- The event time is far out and reminders are handled centrally — skip the reminder toggles rather than showing dead controls.

## Sad paths observed
- "No longer able to attend" path leads to an explicit cancel confirmation (see decline-and-reopen card); the page never dead-ends.
- Luma shows the join button only near start time ("The join button will be shown when the event is about to start") — managing premature-access expectations.

## Accessibility
- Countdown is text, not a live timer — fine for screen readers.
- Toggle switches (Email/SMS reminders) need labels tied to the switch, not just adjacent text.

## Default verdict for our stack
RECOMMENDED — idempotent landing state for our tokened pages: same URL always renders current status, confirmation channel echo, calendar add, and a self-serve change path.
