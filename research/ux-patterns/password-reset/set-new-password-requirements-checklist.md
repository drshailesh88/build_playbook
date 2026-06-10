# Pattern: Reset form with live requirements checklist / strength feedback
**Surface:** password-reset · **Observed in:** ChatGPT, OpenAI Platform, AutoSend, Wave, Pipedrive (refs: [ChatGPT](https://mobbin.com/screens/ef23e6f2-8e15-4a68-bee3-1992eac0cf4a), [OpenAI Platform](https://mobbin.com/screens/e59c4b02-e099-44e0-9e4b-72fe3abfea8f), [AutoSend](https://mobbin.com/screens/9dcacc4c-72ab-4cb5-b487-0fdd235826c7), [Wave](https://mobbin.com/screens/4d6526c3-81a6-4a01-9027-0fa86a76f73c), [Pipedrive](https://mobbin.com/screens/a26131d6-3aa6-4ea8-8618-35e8059334d0))

## Flow
1. User lands from the email link on a standalone "Reset your password" page.
2. New password + confirm/re-enter field, both with show/hide visibility toggles.
3. Requirements rendered as a live checklist that ticks as conditions are met: "Your password must contain: ✓ At least 12 characters" (OpenAI Platform); per-rule green checks for special char / uppercase / number / min length (AutoSend).
4. Strength feedback inline: "STRENGTH: STRONG" (AutoSend), "This is a very strong password!" (Wave), "Impressive" (Pipedrive).
5. Mismatch validated live: red fields + "Passwords don't match" under the confirm field (ChatGPT).
6. Submit ("Reset password" / "Confirm changes"), then success handoff (see post-reset cards).

## Use when
- Any password-setting surface — reset, signup, settings change. The checklist removes the guess-and-fail loop on policy.

## Avoid when
- Policy is a single trivial rule (min 8 chars) — a one-line hint under the field (Notion's "at least 15 letters, or at least 8 with letters and numbers" — [ref](https://mobbin.com/screens/3628ab24-47aa-4acd-87eb-7e7bda0ec245)) is lighter than a checklist box.

## Sad paths observed
- ChatGPT: mismatch error shown before submit, fields outlined red — error precedes the server round-trip.
- Simpler variants (Paramount+ [ref](https://mobbin.com/screens/f18e39e4-d4df-40fe-9620-227c84106696), Patreon [ref](https://mobbin.com/screens/81054160-3737-4367-8e56-2f8ecdd38229)) keep submit disabled until both fields validate.

## Accessibility
- Show/hide toggles on every observed implementation; checklist items change state visually — needs `aria-live` in our build since ticks alone are not announced.

## Default verdict for our stack
RECOMMENDED — pairs with Better Auth `resetPassword`; live checklist + confirm field + visibility toggle is the shadcn-friendly, Linear-bar default.
