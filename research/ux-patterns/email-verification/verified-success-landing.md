# Pattern: Verified-success landing ("you can close this page" / toast confirmation)
**Surface:** email-verification · **Observed in:** Vercel, Bumble, Zillow, Epidemic Sound, Brilliant (refs: [Vercel](https://mobbin.com/screens/a841f8e4-3ca6-4201-83b5-8d718e58595e), [Vercel #2](https://mobbin.com/screens/445bc941-42ef-4e86-8488-189d5da649e6), [Bumble](https://mobbin.com/flows/6734e6b0-6486-4377-9e25-cb13a75dacca), [Zillow flow](https://mobbin.com/flows/f8614871-952a-45bd-ae30-5f0506a99f88), [Epidemic Sound flow](https://mobbin.com/flows/39d03687-ce7d-4880-8df6-b3178d590d66))

## Flow
Variant A — close-this-tab page (link opened in a fresh tab while the original tab waits):
1. Minimal page: "Sign Up Successful — <email> was confirmed. You may close this window." (Vercel); "Email Verification — Your email address was successfully authenticated. You can now close this page." (Vercel).
2. Original tab auto-advances into the product (paired with Vercel's keep-this-window-open mechanic).
3. Bumble: standalone "Thank you! We've successfully confirmed your email address. Welcome to Bumble!" page.

Variant B — in-app toast/banner (verification completed in the same session):
1. Toast "Your email is now verified." (Zillow), "Email address confirmed" (Epidemic Sound), banner "Thanks for confirming <email> as yours" (Brilliant); persistent banner/nag disappears simultaneously.

## Use when
- Variant A: link opens out-of-context (new tab, different time) — tell the user explicitly the job is done and which tab to return to.
- Variant B: the user is already in the app — confirm without yanking them to a new page.

## Avoid when
- Variant A as a dead end WITHOUT a "continue to app" path when the original tab is gone — Vercel can rely on the waiting tab; if we can't guarantee one, the landing must include a "Go to dashboard" CTA.

## Sad paths observed
- Vercel keeps a "(undo)" / change-email path on the waiting side, and the landing names the confirmed address — catches wrong-account confirmation.

## Accessibility
- Static text landings are trivially accessible; toasts must be `aria-live` and paired with persistent state change (the banner disappearing is the durable signal).

## Default verdict for our stack
RECOMMENDED (Variant B primary) — with OTP-first verification we confirm in-session via toast + state flip; ship Variant A page with a "Continue to dashboard" button for link-based flows (invites).
