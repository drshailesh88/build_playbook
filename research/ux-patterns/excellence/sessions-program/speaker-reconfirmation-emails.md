# Pattern: Reconfirmation + self-service links inside lifecycle emails

**Surface:** sessions-program / speaker-lifecycle · **Observed in:** Calendly, Luma, Zoom (refs: [Calendly email editor](https://mobbin.com/screens/006469b3-a0ed-405b-bcf7-defb5fd4b40b), [Calendly workflows](https://mobbin.com/flows/b3deadf8-ee5e-4d98-9216-dff5cbb30c2d), [Luma scheduled emails](https://mobbin.com/screens/350bc45a-535a-4b72-b165-d39f7acdd270))

## Flow
1. Lifecycle email templates include a "Reconfirmation" type alongside Reminder / Thank you / Follow-up (Calendly).
2. Composer checkboxes: "Include reconfirmation button", "Include cancel and reschedule links", "Include cancellation policy" — the recipient can act from the email without logging in.
3. Luma variant: scheduled emails per audience segment ("Send to guests who are: Approved ×") with variable chips in the subject ("{Event Name} is starting {Time Until Event}") and "Send Preview".

## Use when
Long-lead commitments (conference faculty confirmed months out) — the "are you still presenting?" nudge with one-click reconfirm keeps the program honest before printing.

## Avoid when
Short-lead or high-frequency events — reconfirmation requests so close to acceptance read as distrust.

## Sad paths observed
- Reconfirmation exists precisely to surface silent dropouts before they become day-of no-shows.

## Accessibility
Action buttons in email + plain links; variable chips visually distinct from literal text in the composer.

## Microcopy worth stealing
"Include reconfirmation button" · "Include cancel and reschedule links" · "Send to guests who are: {segment}"

## Default verdict for our stack
VIABLE — composes with the existing notification-template system (faculty_reminder etc.); reconfirm button = re-use of the confirm token. Worth wiring once invite delivery itself works.
