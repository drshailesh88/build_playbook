# Pattern: Field-level inline credential error (non-enumerating)
**Surface:** sign-in · **Observed in:** Uxcel, OpenAI Platform, Profound, Duolingo (refs: [Uxcel](https://mobbin.com/screens/59de65a0-d847-4724-b0d5-c03324fd9260), [OpenAI flow](https://mobbin.com/flows/f71e1240-7085-49ec-8c3c-3181381039a3), [Profound](https://mobbin.com/screens/ec586558-5d1e-4686-9eee-0b41779069cb), [Duolingo](https://mobbin.com/screens/31f748e0-4481-483a-abd5-023426d8bedc))

## Flow
1. On failed login, the credential fields get red borders and a short message renders directly under the offending input.
2. Non-enumerating copy keeps email/password ambiguity: "Invalid email or password" (Uxcel — both fields outlined), "Incorrect email address or password" (OpenAI).
3. Identifier-known contexts name the field: "Password is incorrect. Try again, or use another method." (Profound), "Wrong password. Please try again." (Duolingo) — acceptable on step-2 screens where the account is already confirmed.
4. Entered email is preserved; password may clear; submit disabled until edit (Uxcel) or stays active (OpenAI).
5. Message pairs with next actions: forgot-password link and/or alternate method remain adjacent (Profound "use another method", WorkOS-style code escape).

## Use when
- Single-screen email+password forms — keeps the error attached to what must change.
- You want non-enumerating "email or password" copy (security default).

## Avoid when
- Errors unrelated to a specific field (rate limit, suspended account, server down) — those need a form-level banner instead.
- Naming the wrong field on a combined form ("wrong password") leaks account existence — only do that post-identifier-confirmation.

## Sad paths observed
- This card IS the sad path. Notable: Uxcel disables the submit button while invalid; Profound's message embeds the recovery route in the sentence.

## Accessibility
- Message adjacent to input (aria-describedby pairing); red border always paired with text; should be announced via live region on render (structure observed supports it).

## Default verdict for our stack
RECOMMENDED — "Invalid email or password" under the password field, email preserved, forgot-password link adjacent; matches shadcn form-error anatomy exactly.
