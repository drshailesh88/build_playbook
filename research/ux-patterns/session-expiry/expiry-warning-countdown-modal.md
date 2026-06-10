# Pattern: Pre-expiry warning modal with countdown and "Keep session"
**Surface:** session-expiry · **Observed in:** Revolut Business (refs: [countdown modal](https://mobbin.com/screens/1cdd71c1-8987-414d-82f6-edfc4ec9f77e))

## Flow
1. Shortly before idle timeout, a modal appears over the app: circular countdown timer (mm:ss), title "Your session will expire soon", body "Keep the session active or log out to terminate it now".
2. Primary action "Keep session" extends the session in place — user never loses the page or its state.
3. Secondary "Logout" terminates immediately; X closes (treated as keep, by implication).
4. If the countdown reaches zero, the expired state takes over (see full-page/in-place expired cards).

## Use when
- Sessions are short for security but users do long-running work — the warning converts "surprise logout with lost input" into a one-click save. The strongest preventive companion to draft preservation.

## Avoid when
- Sessions are long (days) and idle expiry is rare — an interrupting modal would fire mostly on abandoned tabs; also avoid countdowns that can't actually extend the session (false promise).

## Sad paths observed
- The pattern IS the sad-path mitigation: it fires before expiry so in-progress work (a bills table was visible behind) is never torn down without warning.

## Accessibility
- Time-limited dialogs are a WCAG 2.2.1 (Timing Adjustable) concern: the "Keep session" control satisfies the extend requirement; countdown must be announced (aria-live) — not verifiable from stills.

## Default verdict for our stack
RECOMMENDED — fire a keep-alive warning ~2 min before idle expiry; it is the cheapest way to honor our "never lose user input" rule before recovery patterns are even needed.
