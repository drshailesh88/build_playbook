# Pattern: Passwordless OTP Accept
**Surface:** accept-invite-new-user · **Observed in:** Notion (refs: [Notion](https://mobbin.com/screens/b287f274-3f13-4c94-af6b-f4d7790adc26))

## Flow
1. Invite landing asks the user to verify the invited email rather than set a password: "Verify your email to accept samlee's invite — Please check alexsmith@… for your temporary login code."
2. User enters the emailed verification code; "Resend in 15s" countdown handles lost codes.
3. "or continue with" Google / Apple / Microsoft / Passkey / SSO buttons offer alternate auth; "Existing user? Log in" link routes B8 cases.
4. Continue creates the session and proceeds to profile setup, then auto-joins the team.

## Use when
You run passwordless/magic-code auth anyway; you want explicit email verification even though the invite token implied it (defense against forwarded invite links).

## Avoid when
Your auth is password-based — adding an OTP hop on top of signup doubles the friction of the highest-friction flow; also weak for users whose mail client is on another device (desktop event-ops staff on shared machines).

## Sad paths observed
Resend with cooldown timer is built in; invalid-code inline errors observed in adjacent apps ([Perplexity](https://mobbin.com/screens/7e797431-f734-4537-9953-19b6f7b7a771), [sweetgreen](https://mobbin.com/screens/d94cc630-510f-4e22-89d8-740f849826a9) show "Invalid code, please try again" under the field).

## Accessibility
Single code input with visible label and live resend countdown; ensure the countdown updates politely (aria-live=polite) and error text is tied to the input.

## Default verdict for our stack
VIABLE — only if we adopt Better Auth email-OTP as a first-class method; otherwise it duplicates verification the invite token already provides.
