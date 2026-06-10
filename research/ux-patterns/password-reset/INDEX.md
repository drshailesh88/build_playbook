# INDEX — password-reset (A3)

## Coverage note
- **by-app queries (3):** "Notion forgot password reset", "Vercel check your email confirmation", "Linear Stripe sign in trouble logging in error message". Notion + Linear surfaced (both passwordless-leaning); Vercel surfaced for verification, not reset; **Stripe and Raycast never appeared in any result set** — not in Mobbin's web index for these queries, excluded.
- **by-pattern queries (3):** "forgot password request form...", "reset password link expired error page", "password reset email sent check your inbox confirmation", "set new password form choose a new password confirm".
- **by-flow queries (1):** "reset a forgotten password via email link" → Ghost, Patreon, Dialpad, Rocket Money full flows.
- **Apps swept:** Notion, Linear, Vercel, Mixpanel, Strut, Patreon, TheyDo, Cal.com, Campsite, n8n, Plane, Coda, Mural, Substack, Plausible, Navan, Fibery, Uxcel, Wave, ChatGPT, Paramount+, OpenAI Platform, Pipedrive, AutoSend, NordVPN, Jitter, Sentry, folk, Podia, Height, Ghost, Dialpad, Rocket Money.
- **Not found:** Slack forgot-password (query timed out; generic re-queries never surfaced Slack web screens). No example of a reset form that also forces sign-out-all-sessions UI. Stop condition: final two queries returned only already-seen screens.

## Patterns
- `dedicated-request-form.md` — standalone email-entry page with back-to-login; table stakes spine of the flow.
- ★ `neutral-email-sent-confirmation.md` — enumeration-safe "if you have an account" confirmation (Substack, Plausible). Recommended default for our B2B posture.
- `explicit-email-sent-confirmation.md` — names the address, resend + spam hint (Coda, Mural, Navan, Fibery, Uxcel).
- `set-new-password-requirements-checklist.md` — live policy checklist + confirm + visibility toggle (ChatGPT, OpenAI, AutoSend).
- `expired-link-dedicated-error.md` — dead-end error page with re-request CTA + support ID (NordVPN, Sentry, Jitter).
- `expired-link-inline-rerequest.md` — bounce to prefilled request form with inline error (Podia).
- `post-reset-success-handoff.md` — auto-login (Ghost) vs confirm-then-login (Patreon).
- `passwordless-recovery.md` — magic link/login code replaces reset entirely (Linear, Notion).
