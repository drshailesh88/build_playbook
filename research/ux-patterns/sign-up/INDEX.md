# Sign-up (A1) — Pattern Index

## Coverage note
- **Queries run — by-app (4):** "Linear sign up page", "Vercel sign up page create account", "Notion sign up screen with social login options", "Slack create account enter email". **by-pattern (3):** "sign up form with name email password fields SaaS", "Stripe sign up split screen testimonial", "sign up error email already in use account exists". **by-flow (1):** "sign up and create an account for a SaaS workspace". All platform=web.
- **Apps swept:** Linear, Vercel, Notion, Slack, Stripe, Intercom, Loom, Height, TheyDo, Plausible, Outseta, Workable, Replicate, Spotify, Biosites, The Leap, Oyster, Attio, Grain, Dovetail, Productboard, Fibery, Equals (+ magic-link interstitials from Better Stack, Felt, Loops, Qatalog, Fey, Clay, Depop).
- **Dryness:** final two queries (SSO-related, duplicate-email) surfaced only additional app evidence for already-recorded patterns — sweep stopped per the 2-consecutive-no-new rule.
- **NOT found / excluded:** Raycast web sign-up screens did not appear in any query (gap — Raycast is iOS/desktop-app heavy on Mobbin). No CAPTCHA-challenge-failure states, no rate-limit/lockout screens at signup. iOS was not queried (web results were plentiful). Replicate's GitHub-only auth observed but not carded (single-provider dev-tool pattern, off-brief for email-primary).

## Patterns
- ★ **single-step-full-form** — one page: name + email + password, inline validation, ToS microcopy (Stripe, Intercom, Workable, Plausible, Height, TheyDo, Oyster, Biosites). RECOMMENDED default.
- **email-first-progressive-signup** — email-only first screen, verify, then collect the rest (Linear, Vercel, Slack, Dovetail, Pitch). VIABLE.
- **social-auth-stack** — "Continue with X" stack above/below email with divider (Notion, Slack, Linear, Workable, Spotify). VIABLE.
- **email-otp-code-verification** — emailed code typed into same card, resend cooldown (Notion, Dovetail, Clay). VIABLE.
- **magic-link-check-inbox-interstitial** — check-inbox screen, webmail deep links, resend + wrong-email escape (Better Stack, Felt, Loops, Qatalog, Fey, Clay, Depop, Productboard). VIABLE.
- **password-strength-feedback** — live meter/checklist + disabled submit (Loom, Stripe, TheyDo, Biosites). RECOMMENDED companion to ★.
- **split-screen-value-panel** — form beside value props/testimonial/plan summary (Stripe, Intercom, TheyDo, Outseta, Grain, Oyster, Profound, Notion). VIABLE.
- **work-email-nudge** — "Work email" label + soft personal-domain tip; Attio-style hard block documented (Slack, Notion, Attio). VIABLE (soft tier only).
- **duplicate-email-inline-error** — inline "already exists" + login link (Spotify, Biosites, The Leap, Oyster). RECOMMENDED sad path.
- **post-auth-workspace-setup** — tenant creation as separate post-auth step: name, slug, region, stepper (Linear, Slack, Dovetail, Productboard, Fibery, Equals). RECOMMENDED adjacent step.
