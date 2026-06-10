# Pattern: Social-on-top + email/password single-screen login
**Surface:** sign-in · **Observed in:** Notion, Loom, Intercom, Workable, Duolingo, Uxcel, Linear (per Mobbin labeling) (refs: [Notion](https://mobbin.com/screens/3292e441-897d-4188-b606-653c4904a861), [Notion variant](https://mobbin.com/screens/89e66825-41b5-4e8e-9fef-fbc0ceff5e51), [Loom flow](https://mobbin.com/flows/01b23f38-dc54-4e01-8670-0b350cdead5f), [Intercom](https://mobbin.com/screens/6fb3111f-f41c-4605-b3b1-0bef600393ea), [Workable](https://mobbin.com/screens/df32220a-c1ed-4500-b92b-88a19ff32eff), [Duolingo](https://mobbin.com/screens/31f748e0-4481-483a-abd5-023426d8bedc), [Uxcel](https://mobbin.com/screens/59de65a0-d847-4724-b0d5-c03324fd9260), [Linear-labeled](https://mobbin.com/screens/f4dfb7b1-9538-4ede-bbf2-5b8dbadfba77))

## Flow
1. Single centered card: provider buttons stacked on top (1–5 of them), "or" divider, then email + password fields and a primary "Log in / Sign in / Continue with password" button.
2. "Forgot password?" link adjacent to the password field (label-row right slot in WorkOS/TheyDo, below button in Notion).
3. Footer links: "No account? Create one" / "Don't have an account? Start for free".
4. Auxiliary methods demoted to text links below: "Use single sign-on", SAML SSO, one-time code.

## Use when
- Default sign-in shape for SaaS — every reference app converges here; users pattern-match it instantly.
- Email+password is primary and social is optional accelerant.

## Avoid when
- Enterprise SSO must be domain-enforced before password entry — identifier-first routing handles that better.
- No social providers configured: drop the stack and divider entirely rather than showing one lonely button over a form.

## Sad paths observed
- Bad credentials render without losing the form: banner (Intercom, Workable) or field-level (Uxcel — both fields red-bordered, "Invalid email or password", login button disabled until edit).
- Workable pairs the error with an alternate channel: "Email me a link to sign in instantly" button below the password form ([ref](https://mobbin.com/screens/df32220a-c1ed-4500-b92b-88a19ff32eff)).

## Accessibility
- Text-labeled provider buttons; visible labels on fields (Notion, Workable); password show/hide toggle (Notion, Loom).
- Forgot-password link must remain reachable in tab order before the submit button (observed positioning in WorkOS/TheyDo does this).

## Default verdict for our stack
RECOMMENDED — the converged SaaS default; implement with email+password as the visual primary and reserve the top slot for Google if/when the provider is enabled.
