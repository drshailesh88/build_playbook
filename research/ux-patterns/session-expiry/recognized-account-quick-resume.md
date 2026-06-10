# Pattern: Recognized-account quick resume ("Jump back in" / "Continue as")
**Surface:** session-expiry · **Observed in:** Canva, Threads (refs: [Canva jump back in](https://mobbin.com/screens/bf27c36f-e040-4f22-b6f4-ba09f2b84d19), [Canva variant](https://mobbin.com/screens/a0042646-14e2-41bd-b901-7864ed1bf4ab), [Threads continue-as](https://mobbin.com/screens/5954a512-cc59-45c2-a35e-41c0953fe3b6))

## Flow
1. Returning user with a remembered identity hits the auth boundary; instead of a blank login form they see their avatar + name + email and a single "Continue" button (Canva: "Jump back in!"; Threads: "Continue as <email>").
2. One click re-establishes the session (provider-backed), no credential retyping.
3. Escape hatches: "Continue with another account" and "Do you need to remove an account?" (Canva).

## Use when
- OAuth/SSO-heavy products where the provider session outlives the app session — turns re-auth into one click, the least painful expiry recovery after silent refresh.

## Avoid when
- Shared/public computers — showing name+email+avatar at the auth wall leaks identity; the remove-account affordance is mandatory if you ship this.

## Sad paths observed
- Canva explicitly handles "wrong person" (another account) and "shared machine" (remove an account) directly on the resume card.

## Accessibility
- Single primary action with the account identity as visible text — low cognitive and motor cost; alternatives are plain links.

## Default verdict for our stack
VIABLE — attractive for our social-login users as the re-auth dialog's one-click path, but secondary to in-place re-auth; requires remembered-device identity storage we may not want at MVP.
