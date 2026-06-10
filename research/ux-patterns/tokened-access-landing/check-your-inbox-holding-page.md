# Pattern: "Check your inbox" holding page with resend + wrong-email escape
**Surface:** tokened-access-landing · **Observed in:** Better Stack (ref: https://mobbin.com/screens/891e5c6b-aa8b-4582-abfb-674346e36f5e), Felt (ref: https://mobbin.com/screens/67db25a6-d5a2-4382-9cf0-321ab7f32d48), Loops (ref: https://mobbin.com/screens/74845a20-3a31-4cab-b895-bb647f771421), Jitter (ref: https://mobbin.com/screens/5b922398-f3b6-4299-b7d7-47c502dab770), Qatalog (ref: https://mobbin.com/screens/79f9ac38-e747-4780-833a-fa82045ad6a2), Fey (ref: https://mobbin.com/screens/64f59b98-4444-43e1-a468-b0e30b419f8f)

## Flow
1. After requesting a link (or a fresh link after expiry), a dedicated holding page: "Check your inbox / Check your email".
2. The destination address is echoed in bold: "We've sent a magic link to jsmith@gmail.com."
3. No-login framing: "Please click the link to confirm your address" / "temporary login link" — sets expectation that no password exists.
4. Helpers: "Open Gmail / Open Outlook / Open Superhuman" deep links (Better Stack, Felt, Loops).
5. Recovery row: "Can't see the email? Check the spam folder." + "Send it again" (Felt, Qatalog) + identity escape "Wrong email? Please re-enter your address." (Better Stack) / "Signing up as X (logout)" (Qatalog).

## Use when
- Our "request a fresh link" recovery flow (expired token, lost email): after the external person enters their email/reg#, land here.
- Echoing the address in bold is the identity confirmation — they instantly notice a typo.

## Avoid when
- Account-enumeration risk: if the input is free-form email, copy must stay neutral ("If that address is registered, we've sent a link") — none of the observed examples handle this; they all confirm the address verbatim because the address was just typed by the user.
- Skip email-client deep links on WhatsApp-first audiences; offer "resend via WhatsApp" instead.

## Sad paths observed
- Spam-folder nudge and resend are standard; Better Stack's "Wrong email? re-enter your address" is the only typo escape observed.

## Accessibility
- Address echo in bold inside a sentence reads naturally; keep resend as a button, not a timed auto-refresh.
- Avoid low-contrast small links for "Send it again" — it is the most needed action on this page.

## Default verdict for our stack
RECOMMENDED — required companion page for token recovery; bold address echo + spam nudge + resend + wrong-address escape, with WhatsApp resend added for our channels.
