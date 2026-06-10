# Pattern: Social/SSO button stack above email
**Surface:** sign-up · **Observed in:** Notion, Slack, Linear, Workable, Spotify (refs: [Notion stack-on-top](https://mobbin.com/screens/51a639f2-0755-4217-9314-b0ccf8d58f12), [Notion email-first variant](https://mobbin.com/screens/76afe9db-3899-4fb6-80e2-f06b007d37b6), [Slack](https://mobbin.com/screens/9f3aeef3-b001-4fc5-94f3-d2c6887911c9), [Linear](https://mobbin.com/screens/8bfaedcd-fd70-4a11-9254-5dec9d9069ac), [Workable](https://mobbin.com/screens/d9f5a690-d4fe-48c8-b7fb-7e9ef42660d8), [Spotify](https://mobbin.com/screens/16082076-0599-4645-9ec8-0a94e3d96f9a))

## Flow
1. A vertical stack of equal-width "Continue with X" buttons (Notion: Google, Apple, Microsoft, passkey, SSO — 5 deep) sits above an "or" divider.
2. Below the divider: email field (+ password if single-step) and a primary continue button.
3. Ordering signals priority: Notion/Slack put providers first; Notion's newer variant flips it — work email on top, providers demoted to small icon tiles below ("or continue with" grid).
4. One provider can be visually promoted by color (Linear's solid-purple Google vs white email button; Spotify's brand-blue Facebook).

## Use when
- OAuth providers are actually configured and you have evidence users prefer them.
- B2B: Google Workspace dominance makes "Continue with Google" a genuine fast path.
- You want one screen serving both social-preferring and email-preferring users.

## Avoid when
- No OAuth providers are wired yet — an empty or single-item stack looks unfinished; ship email-only first.
- More than ~3 providers without grouping: Notion's 5-button wall pushes the email field below the fold on small viewports.
- The form already has many fields; stack + form together overload the card.

## Sad paths observed
- Readymag (sign-in side) shows provider-outage copy: "Facebook login is temporarily unavailable… go through Forgot password" ([ref](https://mobbin.com/screens/503db49d-0a35-4c95-b3e3-3c3e3eefacfe)) — provider buttons need a degraded state.

## Accessibility
- Buttons carry full visible text ("Continue with Google"), not icon-only — good for screen readers; Notion's icon-tile variant loses this.
- Divider "or" is decorative; ensure it is not announced as content.

## Default verdict for our stack
VIABLE — adopt only when/if a Google OAuth provider is configured in Better Auth; until then ship the email form alone rather than a one-button stack.
