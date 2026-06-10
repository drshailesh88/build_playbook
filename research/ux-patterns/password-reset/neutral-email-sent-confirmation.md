# Pattern: Enumeration-safe "check your email" confirmation
**Surface:** password-reset · **Observed in:** Substack, Plausible Analytics (refs: [Substack](https://mobbin.com/screens/a4e25b79-caaa-4a51-aacf-d7c9fe744833), [Plausible](https://mobbin.com/screens/be63021d-6043-4ade-bac0-5368d81d0c2e))

## Flow
1. User submits the reset-request form.
2. Confirmation page renders the SAME success state whether or not the account exists.
3. Copy hedges explicitly: "**If you have an account with us**, we've sent an email to <email>..." (Substack); "We've sent an email containing password reset instructions to <email> **if it's registered in our system**" (Plausible).
4. Troubleshooting copy follows: check spam (Substack), "you might have used an email that's not registered — verify the address and try again" + contact-us link (Plausible).
5. "Try again" link returns to the request form.

## Use when
- You do not want the reset endpoint to leak which emails have accounts (account enumeration defense) — the right default for a B2B multi-tenant product.
- Signup and login are on separate, rate-limited surfaces so the hedged copy doesn't confuse legitimate users for long.

## Avoid when
- Your signup flow already publicly confirms email existence (e.g. "email already in use" on signup) — hedging here buys nothing and adds friction; most consumer apps observed (Coda, Mural, Navan) skip it.

## Sad paths observed
- Plausible folds the "didn't receive it?" sad path directly into the confirmation copy (wrong address, spam folder, contact us) instead of leaving the user stranded.

## Accessibility
- Pure static text pages — no focus traps. Substack renders it as a normal content page with the site header still present.

## Default verdict for our stack
RECOMMENDED — matches the security posture expected of a B2B SaaS (OWASP enumeration guidance) and costs one sentence of copy; pair with the same neutral response from the Better Auth endpoint.
