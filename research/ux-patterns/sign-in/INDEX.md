# Sign-in (A2) — Pattern Index

## Coverage note
- **Queries run — by-app (2):** "Stripe Raycast login sign in page", plus sign-in screens harvested from by-app sign-up queries (Linear, Notion, Slack returned login screens too). **by-pattern (3):** "login error message invalid credentials wrong password", "enterprise single sign-on SSO login enter work email", "passwordless magic link check your email to sign in". **by-flow (1):** "log in to account with email and password". All platform=web.
- **Apps swept:** Stripe, Notion, Loom, Intercom, Workable, TheyDo, Better Stack, WorkOS, Clearbit, Uxcel, Readymag, Profound, Duolingo, OpenAI Platform, Expedia, Behance/Adobe, Pitch, Current, Grain, Dovetail (+ Linear-labeled login screen).
- **Dryness:** the SSO and flow queries returned only new app evidence for already-recorded patterns — sweep stopped per the 2-consecutive-no-new rule.
- **NOT found / excluded:** No Raycast web login screens surfaced (gap). No account-lockout / too-many-attempts screens observed. Forgot-password/reset flow screens excluded as out of A2 scope (only the entry links recorded). Caveat: one screen Mobbin labels "Linear" ([ref](https://mobbin.com/screens/f4dfb7b1-9538-4ede-bbf2-5b8dbadfba77)) visually resembles a Figma login — treated as supporting, never sole, evidence. iOS not queried (web plentiful).

## Patterns
- ★ **social-plus-password-single-screen** — provider stack + or-divider + email/password, forgot-password adjacent, signup footer link (Notion, Loom, Intercom, Workable, Duolingo, Uxcel). RECOMMENDED default.
- **identifier-first-two-step-login** — email screen → password screen with editable identity + per-account methods (OpenAI, Expedia, Behance). VIABLE.
- **magic-link-primary-password-fallback** — "Send me a magic link" primary, password demoted (Better Stack). AVOID for us.
- **otp-code-escape-from-password** — "email me a code/link" secondary action on the password form (WorkOS, OpenAI, Expedia, Workable). VIABLE.
- **sso-escape-hatch** — demoted "Use single sign-on instead" link/button on the login card (Stripe, TheyDo, Better Stack, Intercom, Workable, Notion, Current). VIABLE.
- **remember-me-control** — "Stay signed in" checkbox with time-scope or device warning (Stripe, Expedia, Intercom, Behance). VIABLE.
- **credential-error-field-inline** — red fields + "Invalid email or password" under the input, values preserved (Uxcel, OpenAI, Profound, Duolingo). RECOMMENDED sad path.
- **credential-error-form-banner** — top-of-card alert with forward routing for non-field failures (Clearbit, WorkOS, Intercom, Workable, Readymag). VIABLE companion.
- **unified-login-signup-entry** — one "log in or sign up" door, server branches (Dovetail, Pitch). VIABLE.
- **step-up-2fa-challenge** — post-password code challenge, masked destination, resend countdown, alternate factor (Stripe). VIABLE, post-launch.
