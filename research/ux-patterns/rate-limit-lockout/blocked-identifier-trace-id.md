# Pattern: Blocked identifier with trace ID + timestamp for support
**Surface:** rate-limit-lockout · **Observed in:** Uber, Shopify, NordVPN (refs: [Uber](https://mobbin.com/screens/52bfdf6d-753f-43f5-bde1-d858179783db), [Shopify](https://mobbin.com/screens/48e31cd5-0b38-4053-91cf-55159315753a), [NordVPN](https://mobbin.com/screens/dfa9ee24-160c-445b-b605-623b2f588d2b))

## Flow
1. A hard block fires (blocked phone/email, abuse flag, expired attempt).
2. Modal/page states the block and the action: "Unable to create account — The phone number you entered is blocked. Choose another option to continue." (Uber).
3. Machine-readable diagnostics rendered in small text: "Trace ID: 37371502-7889-4fee…" + full timestamp with timezone (Uber); "Request ID: 6ca27d95…" (Shopify); "Attempt ID: b81e7d1e…" above the support email (NordVPN).
4. Support contact sits adjacent to the ID (support@nordaccount.com — NordVPN).

## Use when
- Any terminal security block where the user cannot self-serve — the ID turns "it doesn't work" tickets into one-lookup resolutions.
- B2B especially: admins screenshot errors to IT; IDs make those screenshots actionable.

## Avoid when
- Self-recoverable errors (wrong password, expired link with re-request) — IDs add noise where a retry button suffices.
- The ID would leak internals — use opaque UUIDs, never stack traces.

## Sad paths observed
- This pattern is pure sad-path infrastructure; Uber pairs it with "Choose another option" so the block is not a dead end even before contacting support.

## Accessibility
- IDs are selectable text in all observed apps (copyable); keep them text, not images, and add a copy button at our bar.

## Default verdict for our stack
RECOMMENDED — trivially cheap with request IDs from our logging layer; render on terminal auth errors (locked account, blocked tenant, repeated 429s) next to the support link.
