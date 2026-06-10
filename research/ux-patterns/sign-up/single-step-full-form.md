# Pattern: Single-step full-form sign-up
**Surface:** sign-up · **Observed in:** Stripe, Intercom, Workable, Plausible, Height, TheyDo, Oyster, Biosites (refs: [Stripe](https://mobbin.com/screens/c360e87e-9ced-4410-a594-38da5638c8fd), [Intercom](https://mobbin.com/screens/9361bd82-0473-4976-9e38-7aadb32fa72b), [Workable](https://mobbin.com/screens/d9f5a690-d4fe-48c8-b7fb-7e9ef42660d8), [Plausible](https://mobbin.com/screens/b44d2a44-95f7-42b1-8b75-4beded2b736b), [Height](https://mobbin.com/screens/20970a9f-d4e3-4037-ad97-5435b629a20b), [TheyDo](https://mobbin.com/screens/1805b668-16d4-4901-96a8-fe4fe8943573), [Oyster](https://mobbin.com/screens/3b614711-2da4-444e-a92b-e76b552d9e48), [Biosites](https://mobbin.com/screens/13212991-3292-4b1a-ba25-d872c80abdb5))

## Flow
1. User lands on one card/page with all account fields visible: email (often labeled "Work email"), password, full name (Stripe also adds country; Intercom adds company name/size; TheyDo strips to just email + password).
2. Labels above inputs; submit is a single full-width primary button ("Create account" / "Start a free trial" / "Register").
3. Submit stays disabled (Stripe) or validates inline on blur/submit.
4. ToS/privacy consent is implicit microcopy under the button ("By signing up you agree to…"); marketing consent is a separate optional checkbox (Workable, Stripe).
5. "Already have an account? Sign in" link below the card.

## Use when
- Email+password is the primary credential and you want account creation in one round-trip.
- B2B tools where users expect a deliberate, form-like enrollment (Stripe-grade trust).
- You need extra fields (name) at creation time anyway for tenant records.

## Avoid when
- You want social/SSO to be the dominant path — a full form competes with it visually.
- Mobile-first conversion funnels where every visible field measurably drops completion.
- You plan to verify email before letting users in anyway — then email-first staging wastes the form.

## Sad paths observed
- Stripe: weak password → red field + inline "Your password is not strong enough. Your password must be at least 10 characters." ([ref](https://mobbin.com/screens/3a9bdc9b-0784-44f1-91bc-458e92ddfb7f)).
- Plausible: password-confirmation mismatch → inline "does not match confirmation" + hCaptcha "I am human" gate ([ref](https://mobbin.com/screens/b44d2a44-95f7-42b1-8b75-4beded2b736b)).
- Oyster/Biosites: duplicate email → inline red text under field (see duplicate-email-inline-error card).

## Accessibility
- Persistent labels above every field (no placeholder-only labels) in Stripe, Intercom, Workable — screen-reader and autofill friendly.
- Single-column layout, logical tab order; password show/hide toggles (Stripe, TheyDo, Loom).

## Default verdict for our stack
RECOMMENDED — maps 1:1 to Better Auth `signUpEmail` (name/email/password) with zero extra verification infrastructure; matches the email+password-primary decision.
