# INDEX — email-verification (A4 + C4)

## Coverage note
- **by-app queries (2):** "Slack email verification enter code after signup" (TIMED OUT — Slack never surfaced in any later result either; gap), "Vercel check your email confirmation" (rich: security-phrase + success landings).
- **by-pattern queries (3):** "verify your email address after signup confirmation code", "verify email banner unverified account warning resend verification", "dashboard top banner please confirm your email address to unlock features".
- **by-flow queries (1):** "verify email address after creating account" → Epidemic Sound, Bumble, Brilliant, Zillow full flows.
- **Apps swept:** Vercel, ClickUp, Clay, Contra, Cycle, Krea AI, PlanetScale, Cloudflare, Discord, Wise, Coinbase, Revolut Business, Squarespace, Podia, PayPal, Airbnb, Dialpad, Epidemic Sound, Bumble, Brilliant, Zillow, Databricks, Canva, Frame.io, Amazon, Linear.
- **Not found / excluded:** Slack and Notion verification screens (never surfaced); Raycast and Stripe absent from all result sets; no example observed of a hard gate that expires into account deletion ("verify within X days"); Dialpad's 71-hour identity-verification deadline banner noted but is identity (KYC), not email, verification — excluded. Stop condition: final pattern/banner queries returned only already-seen apps.

## Patterns
- ★ `blocking-code-entry-gate.md` — full-screen OTP entry post-signup with resend cooldown + edit email (ClickUp, Cycle, Contra, Databricks, Canva, Frame.io, Krea). Recommended default.
- `blocking-link-sent-gate.md` — "we sent a link" wall with resend/update-email/sign-out trio (PlanetScale, Discord, Clay, Coinbase, Wise, Revolut).
- `hybrid-link-or-code.md` — link OR manual code on one screen; kills the wrong-browser dead end (Clay, Linear).
- `anti-phishing-security-phrase.md` — matching phrase in tab and email, "keep this window open" (Vercel).
- `resend-cooldown-timer.md` — countdown-disabled resend button, 15–60s windows (Wise, Revolut, Databricks, Canva, Frame.io, Amazon, Plane).
- `soft-gate-dismissible-banner.md` — persistent banner with send/resend/change actions over a working app (Squarespace, Podia, Epidemic Sound, Airbnb).
- `soft-gate-modal-verify-later.md` — interrupting modal with "Verify later" (Cloudflare).
- `capability-gate-unverified.md` — explore freely, named sensitive actions blocked until verified (PayPal, Brilliant).
- `verified-success-landing.md` — "you may close this page" landing vs in-app toast + state flip (Vercel, Bumble, Zillow, Epidemic Sound).
- `settings-verification-status.md` — settings row with unverified/verified label + verify/resend (Zillow, Brilliant, PayPal).
