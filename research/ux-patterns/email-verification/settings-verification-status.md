# Pattern: Settings row shows verification status with verify/resend action
**Surface:** email-verification · **Observed in:** Zillow, Brilliant, PayPal (refs: [Zillow flow](https://mobbin.com/flows/f8614871-952a-45bd-ae30-5f0506a99f88), [Brilliant settings](https://mobbin.com/screens/daa85c0d-656c-405f-8bc8-4077afddd745), [PayPal email settings](https://mobbin.com/screens/61cc199f-ed5f-4f7d-8921-592debc6aaa8))

## Flow
1. Account/security settings list the email with an explicit status label: "unverified" + **Verify** + Edit actions (Zillow); "send verification | ★ primary | remove" per address (Brilliant); "Primary, Unconfirmed" (PayPal).
2. Clicking Verify opens a "Check your email" modal with the sent-to address, Resend link, and Cancel (Zillow).
3. On confirmation, status flips to "✓ verified" (Brilliant) and a toast fires ("Your email is now verified." — Zillow).

## Use when
- Always — settings is the durable home for verification state and the recovery point after a dismissed banner or expired email; also the surface for multi-email accounts (Brilliant).

## Avoid when
- Never omit; only avoid making settings the SOLE prompt for verification (discovery is too low — pair with a gate or banner).

## Sad paths observed
- Zillow's modal includes "Didn't receive an email? Resend" inline; Brilliant explains the policy ("some features require email verification...") right in settings, covering the "why is this nagging me" confusion.

## Accessibility
- Status is conveyed by text labels ("unverified"/"verified"), not color alone, in all three apps.

## Default verdict for our stack
RECOMMENDED — cheap, expected, and the necessary backstop for every other pattern in this surface; one row in the account settings page with status badge + verify action.
