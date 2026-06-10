# Pattern: Hybrid gate — emailed link OR manually entered code
**Surface:** email-verification · **Observed in:** Clay, Linear (refs: [Clay](https://mobbin.com/screens/485165f6-9f54-4b79-a352-944f1c66bb40), [Linear](https://mobbin.com/screens/cb4db689-0099-47d5-9d98-682e7b3f3f34))

## Flow
1. Gate screen: "Check your email — We sent an email to <email>. It has a link that will sign you up." (Clay).
2. Divider: "OR — Enter verification code instead" with a code field and its own submit ("Sign up with code") on the same screen.
3. Linear's variant: link-first screen with collapsed "Enter code manually" that expands to a code field + "Continue with login code".
4. Either path completes verification identically.
5. Spam hint ("Can't find our email? Check your spam folder!" — Clay) + back to signup.

## Use when
- Users read email on a different device/browser than the one running your app — the code path eliminates the cross-device dead end (folk's same-browser failure).
- You want link convenience for the majority without stranding the minority.

## Avoid when
- Supporting two verification token types (link token + short code) is operationally too much for v1 — pick one and ship.

## Sad paths observed
- This pattern exists to absorb the wrong-browser/wrong-device sad path; Clay also covers spam-folder and back-out paths on the same card.

## Accessibility
- Code field is a plain text input in both apps (paste-friendly); Clay's single-screen both-options layout avoids hidden disclosure for screen readers vs Linear's collapsed toggle.

## Default verdict for our stack
RECOMMENDED — if any link-based verification ships, the manual-code fallback is the difference between Linear-grade and support tickets; Better Auth can issue both from one verification record.
