# Pattern: Email OTP code verification at sign-up
**Surface:** sign-up · **Observed in:** Notion, Dovetail, Clay (refs: [Notion temporary login code](https://mobbin.com/screens/2f8a40a2-20ff-467f-a818-77cb90bedbcc), [Notion resend timer](https://mobbin.com/screens/b8c55702-23b9-4c60-b8d4-5212cb000bbe), [Dovetail "We emailed you a code"](https://mobbin.com/flows/5afc337b-50b5-4c11-8152-11ed8db44014), [Clay "Enter code manually"](https://mobbin.com/screens/424a3b7e-a12b-4ca8-b919-54c3d0b7bbc1))

## Flow
1. User submits email; the same card morphs to show a "Login code" / "Code" input directly beneath the (locked) email field — no page navigation (Notion, Dovetail).
2. Helper copy confirms dispatch: "We just sent you a temporary login code. Please check your inbox."
3. User pastes code → "Continue with login code" completes signup; account is created already-verified.
4. Resend affordance with cooldown: Notion shows "Resend in 28s" countdown; Dovetail a plain "Resend code" link.

## Use when
- You want passwordless-grade verification without magic-link tab-switching pain (code can be typed on the same device/screen).
- Email-first signups where the verified email IS the credential.
- As the manual fallback alongside a magic link (Clay offers both).

## Avoid when
- Email delivery latency is unsolved — users abandon while polling their inbox.
- High-security contexts needing phishing-resistant factors (codes are phishable).
- Password-primary flows where this adds a second, redundant gate at signup.

## Sad paths observed
- Notion: resend disabled behind a visible countdown timer ("Resend in 28s") to prevent hammering ([ref](https://mobbin.com/screens/b8c55702-23b9-4c60-b8d4-5212cb000bbe)).
- Notion keeps "You can also continue with SAML SSO" escape under the code field ([ref](https://mobbin.com/screens/2f8a40a2-20ff-467f-a818-77cb90bedbcc)).

## Accessibility
- Same-card morph keeps context; focus should move to the code input on state change (observable layout implies this).
- Plain single text input (Notion/Dovetail) is easier than segmented 6-box inputs for paste and screen readers.

## Default verdict for our stack
VIABLE — Better Auth's emailOTP plugin covers it; strong candidate for the email-verification step if we later move email-first, redundant while password-primary single-step is in force.
