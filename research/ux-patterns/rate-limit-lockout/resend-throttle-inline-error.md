# Pattern: Inline throttle error on code/email resend
**Surface:** rate-limit-lockout · **Observed in:** Binance, PlanetScale, Amazon (refs: [Binance](https://mobbin.com/screens/649d8c32-0f98-4912-800e-90f3f962b170), [PlanetScale](https://mobbin.com/screens/244fa06c-4e83-4efc-8a77-4fa87e7cc2ef), [Amazon](https://mobbin.com/screens/a392358c-1227-4197-a16c-e4daf603e958))

## Flow
1. User hammers "Get Code"/"Resend"; the server throttles.
2. Error appears inline under the field AND as a toast: "Too many requests. Please try again later.(015002)" — red field outline, error code appended (Binance).
3. PlanetScale variant: toast only — "Email was just sent. Please check before trying again."
4. Amazon variant (pre-emptive): info note "Please wait 53 seconds before requesting another code" with the resend link muted.
5. Escape hatch stays visible: "Security verification unavailable?" link (Binance), "Need help? … try a different way" (Amazon).

## Use when
- Any send-code/send-email button as the server-side backstop — even when a client cooldown timer exists (timers can be bypassed).
- Error codes (Binance's `015002`) are worth copying for B2B: support can diagnose from a screenshot.

## Avoid when
- As the ONLY defense — reactive errors after the click are worse UX than the pre-emptive countdown (see `resend-cooldown-timer.md` in email-verification); use both.
- Vague durations ("try again later") when the server knows the window — show the actual wait.

## Sad paths observed
- This is the sad path of the sad path: Binance keeps the verification modal open and the code field usable for an already-received code — throttling the resend does not block code entry.

## Accessibility
- Inline error + toast duplication ensures discovery; inline copy needs `role="alert"`. Red-outline-only signaling (Binance) must be paired with text in our build.

## Default verdict for our stack
RECOMMENDED (as backstop) — Better Auth rate-limits these endpoints by default; surface its 429 inline with the concrete retry window and keep the support link adjacent.
