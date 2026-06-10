# Pattern: Live password-strength feedback
**Surface:** sign-up · **Observed in:** Loom, Stripe, TheyDo, Biosites (refs: [Loom checklist](https://mobbin.com/screens/389204de-eb10-45c0-a7ea-a609c63f582c), [Stripe strong meter](https://mobbin.com/screens/659402fd-e641-4535-9899-8d229e8aad96), [Stripe weak error](https://mobbin.com/screens/3a9bdc9b-0784-44f1-91bc-458e92ddfb7f), [TheyDo](https://mobbin.com/screens/1805b668-16d4-4901-96a8-fe4fe8943573), [Biosites](https://mobbin.com/screens/13212991-3292-4b1a-ba25-d872c80abdb5))

## Flow
1. As the user types a password, feedback renders inline under/inside the field — no submit needed.
2. Variants observed: requirements checklist + colored bar + word label "Weak" (Loom: "a symbol, an uppercase letter, a number, 8 characters minimum"); 3-segment colored bar + "Strong" tag (Stripe); single word badge "STRONG" in-field (TheyDo); "Medium password" with info icon (Biosites).
3. Submit button stays disabled until threshold met (Loom's greyed "Continue").
4. On submit with weak password, hard inline error states the exact rule: "must be at least 10 characters" (Stripe).

## Use when
- Any password-creation field — signup, reset, change. Pairs with single-step full-form.
- You enforce server-side rules and want users to discover them before submit, not after.

## Avoid when
- Passwordless flows (no password field exists).
- Checklist-style for very simple policies (only "min 8 chars") — a one-line hint suffices; a 4-item checklist overstates the rule.

## Sad paths observed
- Stripe: post-submit weak password → red border + explicit remediation text with the numeric minimum ([ref](https://mobbin.com/screens/3a9bdc9b-0784-44f1-91bc-458e92ddfb7f)).
- Loom: disabled submit until all checklist rules pass — prevents the round-trip entirely.

## Accessibility
- Color-only meters (Stripe's bars) are insufficient alone — Loom/TheyDo pair color with text labels ("Weak"/"Strong"); checklist items are readable text.
- Show/hide password toggle present in all observed instances.

## Default verdict for our stack
RECOMMENDED — cheap client-side addition to the email+password form; mirror Better Auth's server-side minPasswordLength in the visible rule text so the two never disagree.
