# Pattern: OAuth One-Click Accept
**Surface:** accept-invite-new-user · **Observed in:** Optimal Workshop, HubSpot, Steep, Slack, Charma, Air, Fibery (refs: [Optimal Workshop](https://mobbin.com/screens/1b067f3a-09be-49d4-9175-9d165a543250), [HubSpot](https://mobbin.com/screens/42bc77a6-9cc2-431d-84e6-5fdf77927e6f), [Steep flow](https://mobbin.com/flows/5e806a28-dd2f-4b93-b0b7-1d81123ace6f), [Slack](https://mobbin.com/screens/ffe87cb7-2628-4751-a368-9010a5cdead0), [Charma](https://mobbin.com/screens/02a6dc7a-717f-4533-bd8a-b89b8a3ca34c), [Air](https://mobbin.com/screens/caafc887-7761-4c10-9af3-5a35a12e5b64), [Fibery flow](https://mobbin.com/flows/49bf3863-b754-4a82-be03-bb19182051cb))

## Flow
1. Invite landing offers OAuth as the topmost option; Optimal Workshop literally labels it "Sign up with Google and accept" — one click does signup + accept.
2. Email/password form sits below an "or" divider as the fallback (Charma, Air); HubSpot is a modal with Google/Microsoft/Apple stacked above "Continue with email"; Steep and Fibery offer ONLY OAuth/SSO buttons on the landing.
3. After provider auth, the user returns and is joined to the org without further fields.

## Use when
Your audience has corporate Google/Microsoft accounts (B2B events teams do); you want sub-10-second accepts; the OAuth email matches the invited email.

## Avoid when
The OAuth account email may differ from the invited email and your backend would create an orphan account instead of consuming the invite — requires explicit email-mismatch handling first (see B8 wrong-account patterns); also avoid OAuth-only (Steep) if buyers require SSO-less email logins.

## Sad paths observed
None on-screen; the mismatch case (Google account ≠ invited email) is conspicuously unhandled in most captures — only ClickUp/Descript-style messaging covers it elsewhere.

## Accessibility
Provider buttons are large single-purpose targets; keep them real buttons with provider name in the accessible label, not icon-only.

## Default verdict for our stack
RECOMMENDED — as the top option above the email form (Better Auth social providers), but only with explicit invited-email vs provider-email mismatch handling; never OAuth-only.
