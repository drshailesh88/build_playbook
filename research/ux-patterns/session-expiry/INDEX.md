# INDEX — session-expiry (A7)

## Coverage
- **Queries run — by-pattern (4):** "session expired modal please log in again timeout", "you have been signed out message login screen returning user", "re-enter password unlock continue editing draft preserved after login interruption", "session timeout warning countdown stay signed in inactivity" (platform=web).
- **Queries run — by-flow (0 dedicated):** expiry rarely appears as a curated multi-step flow on Mobbin; flow-mode evidence came indirectly via logout flows (login landing pages). The 4th screen query returned only repeats (Revolut Business, Employment Hero) — sweep treated as dry.
- **Apps swept:** Quicken, Rocket Money, Revolut, Revolut Business, Square, Zoom, GitBook, Melio, Docusign, Mailchimp, Monarch, Gamma, Intercom, Threads, Figma, Canva, Microsoft Loop, Employment Hero, Kraken, Vanta.
- **NOT found / excluded — IMPORTANT GAP:** No app was observed explicitly showing a "your draft was restored" message after re-login, and redirect-and-return (returnTo) behavior is not provable from static screens. Draft/input preservation is only EVIDENCED indirectly: Employment Hero / Microsoft Loop keep the page mounted behind the re-auth modal (state survives by construction). Our never-lose-input requirement therefore exceeds what Mobbin can document — implementation must be specified from first principles (autosave/localStorage + returnTo), not pattern-copied. Zoom's timeout dialog was network/policy-related, not session expiry — excluded. None of our six priority reference apps (Linear, Vercel, Slack, Notion, Stripe, Raycast) had expiry screens captured on Mobbin.

## Patterns
- ★ `in-place-reauth-modal` — page stays mounted + blurred, re-auth in a modal, resume exactly where you were; "Not Jane?" + popup-retry sad paths (Employment Hero, Microsoft Loop). ★ recommended primary handler — the only observed pattern that preserves input by construction.
- ★ `expiry-warning-countdown-modal` — pre-expiry countdown with "Keep session" (Revolut Business). ★ recommended companion (prevention beats recovery).
- `session-expired-modal-in-place` — post-expiry notice modal with reason, then redirect to login (Quicken, Square, Rocket Money). Viable for non-edit pages.
- `full-page-session-expired` — hard redirect to a dedicated logged-out page (Revolut, Melio, Docusign). AVOID as default — most input-destructive.
- `login-page-signed-out-banner` — login form + cause banner, prefilled email, "stay signed in" remedy (Mailchimp, Monarch, Intercom, Gamma). Recommended as the redirect fallback.
- `recognized-account-quick-resume` — "Jump back in / Continue as" one-click resume (Canva, Threads). Viable later.
- `step-up-reauth-sensitive-action` — re-auth gate for sensitive actions within a valid session, dual proof methods (GitBook, Figma, Notion). Recommended alongside.
- `session-timeout-duration-setting` — user/tenant-configurable idle timeout (Kraken, Vanta). Viable later, enterprise tier.
