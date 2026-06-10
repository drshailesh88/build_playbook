# Pattern: Captcha interstitial on excessive requests
**Surface:** rate-limit-lockout · **Observed in:** Shopify, TIDAL, Airbnb (refs: [Shopify](https://mobbin.com/screens/48e31cd5-0b38-4053-91cf-55159315753a), [Shopify unchecked](https://mobbin.com/screens/200070c1-1338-4368-b453-2d65129ee5c2), [TIDAL](https://mobbin.com/screens/10c35910-c73c-4979-8273-b7a30521cbcf), [Airbnb](https://mobbin.com/screens/76ab57b9-7f75-4324-a4dc-905f26084721))

## Flow
1. Excessive/suspicious traffic swaps the page for a card: "Too Many Requests — We've received excessive or malicious requests from your computer or network. To continue, confirm you are not a robot." (Shopify).
2. Embedded captcha (hCaptcha — Shopify; reCAPTCHA — TIDAL; proprietary puzzle "Let's do a quick security check" modal — Airbnb).
3. Continue button disabled until the captcha passes (Shopify's unchecked vs checked states).
4. Diagnostics for support: "Request ID: 6ca27d95…" (Shopify); TIDAL explains WHY it triggered ("browsing much faster than expected of a human… a robot on the same network (IP …) as you") + "Having problems accessing the site? Contact support."
5. Pass → original request proceeds; the wall disappears.

## Use when
- Distinguishing bot floods from a stuck human — captcha lets legitimate users through instantly instead of serving them a timed ban.
- Escalation tier ABOVE per-account throttles: account lock protects credentials, captcha protects infrastructure.

## Avoid when
- First response to a couple of failed logins — captcha-on-attempt-2 is hostile; escalate only after thresholds.
- No support escape hatch — captcha-blind users (accessibility) get fully locked out without one.

## Sad paths observed
- This page IS the sad path; both Shopify and TIDAL attach correlation IDs / explanations + help links so a false positive is recoverable via support.

## Accessibility
- Airbnb's puzzle offers "Switch to audio" — the only observed non-visual alternative. Any captcha we ship must have an audio/alternative path and a support contact.

## Default verdict for our stack
VIABLE — adopt at the edge (Vercel/Cloudflare Turnstile) rather than building in-app; in-product login throttling should come first, captcha as network-level escalation only.
