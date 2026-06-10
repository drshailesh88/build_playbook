# INDEX — rate-limit-lockout (C6)

## Coverage note
- **by-app queries (1):** "Linear Stripe sign in trouble logging in error message" — returned Linear passwordless screens only (no rate-limit states); Stripe absent.
- **by-pattern queries (3):** "too many failed login attempts account temporarily locked try again later", "login error rate limit exceeded please wait before trying again captcha challenge", "account locked for security reasons unlock via email wait 30 minutes".
- **by-flow queries (0 dedicated):** flow-mode queries for lockout were not run separately because the second and third screen queries already returned majority-duplicate results (Surfshark, Uber, Shopify repeated) — dry condition hit; lockout flows are single-screen states, poorly represented as multi-step flows on Mobbin.
- **Apps swept:** Surfshark, Uber, Shopify, TIDAL, Airbnb, Binance, Zillow, Contra, Amazon, PlanetScale, NordVPN, Discord.
- **Not found:** an explicit timed lockout with visible countdown ("account locked, try again in 30:00") — no app in Mobbin's web index surfaced one; the closest are resend cooldown timers (seconds-scale) and Surfshark's untimed "too many attempts". Also not found: captcha escalating specifically on the Nth failed login (observed captchas are network-level); reference apps Linear/Notion/Slack/Stripe/Raycast showed NO lockout screens at all. These are gaps, not omissions.

## Patterns
- ★ `too-many-attempts-alternate-path.md` — "too many attempts" + offer another way in (code login / other provider) (Surfshark, Uber). Recommended default.
- `captcha-interstitial-too-many-requests.md` — full-page "Too Many Requests" + hCaptcha/reCAPTCHA + request ID + support (Shopify, TIDAL, Airbnb).
- `resend-throttle-inline-error.md` — server-side throttle surfaced inline with error code + escape link (Binance, PlanetScale, Amazon).
- `blocked-identifier-trace-id.md` — terminal block + Trace/Request/Attempt ID + timestamp beside support contact (Uber, Shopify, NordVPN).
- `account-disabled-support-escape.md` — administrative disable wall: what happened + contact support + recovery deadline (Zillow, Contra, Discord).
