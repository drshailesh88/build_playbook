# Pattern: Email-first progressive sign-up
**Surface:** sign-up · **Observed in:** Linear, Vercel, Slack, Dovetail, Pitch (refs: [Linear](https://mobbin.com/screens/8bfaedcd-fd70-4a11-9254-5dec9d9069ac), [Linear email step](https://mobbin.com/screens/27d5ce11-de67-49c0-a92c-49ea46d00b09), [Vercel](https://mobbin.com/screens/164a4561-0813-4f14-8a70-5bb76d9bd6ba), [Slack](https://mobbin.com/screens/c6f0ebdc-f3a3-4aa5-b07f-a4e6c07442e8), [Dovetail flow](https://mobbin.com/flows/5afc337b-50b5-4c11-8152-11ed8db44014), [Pitch](https://mobbin.com/screens/2a767e90-ec8b-4745-921d-44538d0d439b))

## Flow
1. Landing screen asks for exactly one thing: email address ("Continue with Email"), with 0–1 social buttons alongside (Linear: one Google button above the field; Vercel: email only + "Other Sign Up options" link).
2. Submit triggers verification (emailed code or link) before any password/profile is requested.
3. Name, password (if any), workspace details are collected on subsequent screens, post-verification.
4. ToS microcopy under the controls; "Already have an account? Login" link.

## Use when
- You verify email anyway — collecting only email first means no dead accounts with unverified emails.
- You want the Linear/Vercel minimal aesthetic: one input, one button.
- Social and email need equal billing without a long form.

## Avoid when
- You cannot send transactional email reliably yet (the whole pattern depends on it).
- Users sign up mid-purchase or under time pressure — the inbox round-trip adds friction.
- Email+password in a single screen is the committed primary (duplicates verification effort).

## Sad paths observed
- Slack shows a yellow tip banner if a personal email is entered: "Using your work email will make it easier for teammates to join you" with a "Change" affordance ([ref](https://mobbin.com/screens/c6f0ebdc-f3a3-4aa5-b07f-a4e6c07442e8)).
- Vercel inserts a phone-OTP verification step mid-signup as an anti-abuse gate ([ref](https://mobbin.com/screens/682f64ee-bbb8-48ab-8317-95aecce815d8)).
- Slack submit button shows an in-button loading spinner during the async check (same ref).

## Accessibility
- One field per screen keeps focus management trivial; Linear auto-centers the single input.
- Loading state communicated inside the button (Slack) rather than a page overlay.

## Default verdict for our stack
VIABLE — the Linear-grade look we aspire to, but it requires verified-email infrastructure (OTP or magic link) before any account exists; adopt once transactional email is wired.
