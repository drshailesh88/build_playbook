# Pattern: Dedicated full-page "You have been logged out" screen
**Surface:** session-expiry · **Observed in:** Revolut, Revolut Business, Melio, Docusign (refs: [Revolut card](https://mobbin.com/screens/faab0919-54b5-4d86-8449-ba5166cbacaf), [Revolut full-page](https://mobbin.com/screens/d87be297-055c-466b-bff1-22939436b562), [Melio](https://mobbin.com/screens/13f6a790-96f6-4235-b115-fe403d7b0d53), [Docusign](https://mobbin.com/screens/a3958355-8d10-4997-b6b2-3d65181000a6))

## Flow
1. On expiry the app hard-redirects to a dedicated logged-out page (not the generic login form).
2. Headline states the event: "You have been logged out" / "Your session has expired due to inactivity" / "You've been securely logged out".
3. Body states the reason and reassurance: Revolut "We've logged you out due to inactivity. This is for your security as it will protect your account from others accessing it in case you left your computer unattended."
4. Single CTA: "Log in" / "Sign in"; Docusign embeds the email field prefilled on the same page.

## Use when
- High-security domains (finance, signing) where wiping the screen entirely on expiry is the point — nothing about the prior session remains visible.

## Avoid when
- Productivity SaaS mid-task — the hard redirect unmounts everything; without return-URL + draft restore this is the most input-destructive option observed. Also loses the user's place even when no input existed.

## Sad paths observed
- Reason + reassurance copy is standard ("for your security... in case you left your computer unattended") — the logout is framed as protection, not failure.
- Docusign reduces re-entry cost by prefilling the email on the logged-out page.

## Accessibility
- Full page with heading + single action — the simplest possible structure; headline as h1 announces state on load.

## Default verdict for our stack
AVOID (as default) — maximally destructive to context and input; acceptable only if we later add a high-security mode, and even then must carry returnTo + draft restoration.
