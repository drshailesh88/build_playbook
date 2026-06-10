# Pattern: Unified "log in or sign up" single entry
**Surface:** sign-in · **Observed in:** Dovetail, Pitch (refs: [Dovetail flow](https://mobbin.com/flows/5afc337b-50b5-4c11-8152-11ed8db44014), [Pitch](https://mobbin.com/screens/2a767e90-ec8b-4745-921d-44538d0d439b))

## Flow
1. One auth entry point for both states: card titled "Log in or sign up" (Dovetail modal over the marketing page) or explainer "We'll sign you in or create an account if you don't have one yet" (Pitch).
2. User enters email (or picks a provider); the server decides — existing account → login challenge, new → signup continuation.
3. Dovetail follows with an emailed code either way; Pitch keeps an opt-out for traditionalists: "Would you rather use email and password? Continue with email and password."

## Use when
- Passwordless/OTP or social-dominant auth where login and signup genuinely share the first step.
- Killing the classic "wrong door" problem (users signing up twice / logging into nothing).

## Avoid when
- Password-primary auth: the post-email branch (password vs full signup form) is awkward and confuses password managers.
- You need different legal copy or fields at signup vs login upfront.

## Sad paths observed
- The pattern itself prevents the duplicate-account/wrong-door sad path; no failure states observed beyond standard code-entry errors.

## Accessibility
- Single entry reduces navigation decisions; explainer sentence (Pitch) sets expectations for the branch.

## Default verdict for our stack
VIABLE — elegant but mismatched with password-primary Better Auth flows today; revisit if we move to OTP/magic-link-first.
