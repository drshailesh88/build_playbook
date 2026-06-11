# Pattern: Magic-link "check your inbox" interstitial with full recovery kit

**Surface:** sessions-program / speaker-lifecycle · **Observed in:** Better Stack, Qatalog, Felt, Current (refs: [Better Stack](https://mobbin.com/screens/891e5c6b-aa8b-4582-abfb-674346e36f5e), [Qatalog](https://mobbin.com/screens/d080a041-67f7-42df-88a8-b4b9c9fdae32), [Felt](https://mobbin.com/screens/67db25a6-d5a2-4382-9cf0-321ab7f32d48), [Current](https://mobbin.com/screens/e818eb8c-3fed-42ea-aa8d-29200b9e3e61))

## Flow
1. After sending the link, echo the EXACT address: "We've sent you a magic link to {email}. Please click the link to confirm your address."
2. Provider deep-link buttons: "Open Gmail / Open Outlook" (Better Stack adds Superhuman).
3. Recovery on the same screen: "Can't see the email? Please check the spam folder. Wrong email? Please re-enter your address." + "Send again" / "Resend email".
4. Identity footer: "Signing up as {email} (logout)" (Qatalog).

## Use when
Any flow where the next step lives in the recipient's inbox — e.g. coordinator resends a faculty invite and wants to tell the speaker what to expect, or a speaker requests a fresh confirm link from an expired-token page.

## Avoid when
Audience is on locked-down corporate/hospital email — provider deep-link buttons mislead (webmail not Gmail/Outlook); keep the spam-folder line + resend, drop the buttons.

## Sad paths observed
- Wrong-email and spam-folder handled inline, not via support.

## Accessibility
Address echoed as text; buttons are real links.

## Microcopy worth stealing
"We've sent a magic link to {email}." · "Can't see the email? Please check the spam folder. Wrong email? Please re-enter your address."

## Default verdict for our stack
VIABLE — the relevant slice for this module is the resend/request-new-link loop on the confirm page's expired state; full interstitial belongs to the auth surface library (see round-1 email-verification cards).
