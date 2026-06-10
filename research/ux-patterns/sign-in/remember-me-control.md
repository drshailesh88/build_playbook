# Pattern: Remember-me control with scoped promise
**Surface:** sign-in · **Observed in:** Stripe, Expedia, Intercom, Behance/Adobe (refs: [Stripe](https://mobbin.com/screens/93761d71-0981-4db7-97ae-159bbe8327bc), [Expedia flow](https://mobbin.com/flows/61cba8c4-db06-4483-8df8-597a22ad3d0c), [Intercom](https://mobbin.com/screens/6fb3111f-f41c-4605-b3b1-0bef600393ea), [Behance flow](https://mobbin.com/flows/26ff166f-2f45-4423-87ab-f08798c9ea6c))

## Flow
1. Checkbox/toggle between the password field and submit button.
2. Copy variants observed: time-scoped "Stay signed in for a week" — checked by default (Stripe); "Keep me signed in" + warning subtext "This is for personal devices only. Don't check this on shared devices to keep your account secure." — checked by default (Expedia); plain "Keep me signed in" — unchecked (Intercom); "Stay signed in" toggle (Behance).
3. Stripe complements it with a footer "Security tip" card about signing out on shared computers, with a Yes/No helpfulness vote.

## Use when
- Session length is short by default and users log in often — the control hands them the trade-off.
- Compliance/security posture requires explicit consent for long-lived sessions.

## Avoid when
- Sessions are already long-lived by default (Linear, Notion show no such control — they just persist); a checkbox that changes nothing is noise.
- Kiosk/shared-terminal products where persistent sessions should never be offered.

## Sad paths observed
- Shared-device misuse is the risk; Expedia mitigates with inline warning copy, Stripe with the security-tip footnote.

## Accessibility
- Native checkbox + label pairs (clickable label); warning subtext tied beneath the control, read in order.

## Default verdict for our stack
VIABLE — Better Auth supports rememberMe natively; only worth surfacing if we choose short default sessions, otherwise follow Linear/Notion and omit.
