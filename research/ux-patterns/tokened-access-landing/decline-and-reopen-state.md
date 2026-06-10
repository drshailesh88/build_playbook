# Pattern: Decline/cancel with confirm dialog and reversible "Not Going" state
**Surface:** tokened-access-landing · **Observed in:** Luma (refs: https://mobbin.com/flows/d947278c-7299-4f93-a40d-2d6d8b03437a), Calendly (refs: https://mobbin.com/screens/97f464b7-d06a-4df3-9cd8-0ae513e04919), Workable, Rise (refs: https://mobbin.com/flows/1773c47f-bc4d-4df8-92d4-63a138611778, https://mobbin.com/flows/7a7718c7-1bfa-4da2-b427-ef25bc1cfafb)

## Flow
1. From the confirmed state, user clicks "canceling your registration".
2. Confirm dialog: "Cancel Registration — Click the confirm button below to cancel your registration. We'll let the host know that you can't make it." Confirm / Dismiss.
3. On confirm: toast "You've canceled your registration" and the card becomes "You're Not Going — We hope to see you next time!"
4. Reversal offered immediately: "Changed your mind? You can register again."
5. Calendly variant: cancellation collects a reason and can mark "canceled and reported"; Workable/Rise show a DECLINED badge on the event entry with Maybe/Decline/Accept still switchable.

## Use when
- Every decline/cancel on a tokened link: the host is notified, the user gets a soft landing, and the decision stays reversible until a cutoff.
- Faculty decline: capture an optional reason (Calendly-style) so organizers can re-plan.

## Avoid when
- Declining has hard consequences (seat released to waitlist, paid ticket refunded) — a one-click "register again" reversal is misleading; state the consequence in the confirm dialog instead.
- Don't bury decline behind multiple confirmations to discourage it; one dialog max.

## Sad paths observed
- This IS the sad path, handled as first-class: notify host + regret copy + reversal. Calendly additionally routes abuse ("canceled and reported — Thank you! Your report helps us learn…").

## Accessibility
- Confirm dialog uses destructive-styled primary (red Confirm) — pair color with explicit text; keep Dismiss as the safe default focus.
- Toast announcements should use aria-live polite.

## Default verdict for our stack
RECOMMENDED — decline must notify the organizer, show a regret state on the same tokened URL, and stay reversible until the organizer's cutoff; optional reason field for faculty.
