# Pattern: One-tap remind pill that becomes its own confirmation

**Surface:** sessions-program / attendee-program · **Observed in:** Clubhouse, Peanut (refs: [Clubhouse remind flow](https://mobbin.com/flows/70694b16-0292-4af3-bd5c-692cefacefd7), [Peanut reminder flow](https://mobbin.com/flows/a52b7377-d8b2-4a0e-a0d0-0597c22e39d9))

## Flow
1. Future-session cards carry a "🔔 remind me" pill; tap flips it in place to green "you got it! ✓" (Clubhouse) — no toast needed, the button IS the state.
2. Peanut: outline "🔔 SET REMINDER" → filled "🔔 REMINDER SET"; label, fill, and icon all change (never color alone).
3. Calendar export is offered as the escalation AFTER the reminder ("add to cal" appears as the follow-up action).
4. Reminder is the primary CTA for future sessions; "Join" is reserved for live ones (Peanut).

## Use when
Sessions are timed and missable — the lightest commitment an attendee can make, cheaper than calendar export.

## Avoid when
You can't actually deliver the reminder (no push/email channel) — a set-reminder button that silently does nothing is worse than absence.

## Sad paths observed
- None in flow; the dependent sad path is notification permission (see add-to-calendar card for the OS-permission moment).

## Accessibility
State change = label + fill + icon together; in-place change keeps focus context.

## Microcopy worth stealing
"remind me" → "you got it! ✓" · "SET REMINDER" → "REMINDER SET"

## Default verdict for our stack
VIABLE — depends on a notification channel for attendees (push/WhatsApp/email exists in the comms module); if my-schedule ships, remind-me is its natural companion.
