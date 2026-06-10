# Pattern: Anti-phishing security phrase match
**Surface:** email-verification · **Observed in:** Vercel (refs: [Vercel signup](https://mobbin.com/screens/2aba6d2b-a966-4062-b553-5edd8365ab72), [Vercel login](https://mobbin.com/screens/7fa4f3db-1b0f-4fa9-b53e-7e5cb59436ea))

## Flow
1. After requesting email verification/login, the waiting page displays a human-readable security phrase: "Keep this window open and in a new tab open the link we just sent to <email> (undo) with security code: **Wicked Asian Elephant**".
2. The verification email contains the same phrase; the user confirms they match before clicking.
3. "(undo)" link beside the email address lets the user back out and correct a wrong address without restarting.
4. Original tab auto-advances once the link is opened.

## Use when
- Link-based verification where phishing-resistance and trust signaling matter — the phrase proves the email corresponds to THIS browser session.
- Magic-link login (Vercel uses the identical mechanic for both signup and login).

## Avoid when
- Code-entry verification (the typed code already binds session to email — a phrase adds nothing).
- Users predominantly open email on another device; the "keep this window open" instruction becomes confusing.

## Sad paths observed
- Wrong-email recovery via the inline "(undo)" affordance — correction without flow restart.

## Accessibility
- Phrase is plain text (three dictionary words) — easy to compare and to read aloud; far better than hash fragments.

## Default verdict for our stack
VIABLE — distinctive Vercel-grade polish if we ship magic-link login later; skip for v1 OTP-based verification where it's redundant.
