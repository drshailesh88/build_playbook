# Pattern: Identifier-first two-step login
**Surface:** sign-in · **Observed in:** OpenAI Platform, Expedia, Behance/Adobe (refs: [OpenAI flow](https://mobbin.com/flows/f71e1240-7085-49ec-8c3c-3181381039a3), [Expedia flow](https://mobbin.com/flows/61cba8c4-db06-4483-8df8-597a22ad3d0c), [Behance flow](https://mobbin.com/flows/26ff166f-2f45-4423-87ab-f08798c9ea6c))

## Flow
1. Step 1 asks only for email ("Welcome back") with social options below the divider.
2. Step 2 is a dedicated "Enter your password" screen: the submitted email is shown read-only with an "Edit" link (OpenAI) or avatar + account-type confirmation (Behance "Personal Account") — identity confirmation before secret entry.
3. Step 2 carries the method alternatives scoped to that account: "Log in with a one-time code" (OpenAI), "Send a secure code via email" (Expedia), "Sign in to a different account" (Behance).
4. Remember-me control lives on step 2 (Expedia checkbox, Behance toggle).

## Use when
- The server must route by identifier before choosing a method: SSO-enforced domains, passkey lookup, or accounts with different auth methods.
- You want to show per-account states (avatar, account type) before password entry.

## Avoid when
- All users authenticate the same way — the extra screen is pure added latency vs the single-screen form.
- Password managers matter to your users: split screens historically confuse autofill pairing (email and password never co-rendered).

## Sad paths observed
- OpenAI: wrong password → field-level red border + "Incorrect email address or password" inline, email still editable via "Edit" ([ref](https://mobbin.com/flows/f71e1240-7085-49ec-8c3c-3181381039a3)).
- Expedia: "Keep me signed in" carries explicit shared-device warning copy: "This is for personal devices only. Don't check this on shared devices."

## Accessibility
- One input per screen simplifies focus; read-only email with Edit affordance avoids retyping.
- Disabled submit until password entered (Expedia) — must remain focusable/announced.

## Default verdict for our stack
VIABLE — not needed at launch (uniform email+password), but it is the natural shape to migrate to when enterprise SSO domain-routing lands; don't paint ourselves out of it.
