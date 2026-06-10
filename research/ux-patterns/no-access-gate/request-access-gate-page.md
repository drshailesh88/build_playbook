# Pattern: Full-page request-access gate with identity context
**Surface:** no-access-gate · **Observed in:** Notion, Mixpanel, Amplitude (refs: [Notion](https://mobbin.com/screens/46abb577-0502-4c57-b90d-6d96ffa05115), [Mixpanel](https://mobbin.com/screens/8bc4ab67-6d62-4d1e-944c-05bc5bff956b), [Mixpanel form](https://mobbin.com/screens/ce1eff2b-6a45-4d03-87d8-0eba2fa015cc), [Amplitude](https://mobbin.com/screens/b7d8e446-d611-47de-974d-cd8b75aa3cff))

## Flow
1. User hits a page/org they have no role in; instead of the content (fail closed), a centered full-page gate renders with the product logo.
2. Plain-language headline: "No access to this page" (Notion) / "You need permission" (Mixpanel) / "Request Access to JD Mobbin Design" (Amplitude).
3. Identity context is always shown: "You're currently logged in as jsmith2@…" (Notion), "You are logged in as …" callout (Mixpanel) — so the user can diagnose wrong-account before requesting.
4. Primary action: Request access — Notion: "You can access this page if someone approves your request"; Amplitude explains routing: "Your administrator will receive an email letting them know that you are requesting access."
5. Escape hatches: Notion "Back to my content" + "log in with a different email" link; Mixpanel "or Login"; Amplitude "Go back to log in". Mixpanel adds a support boundary: "Mixpanel cannot grant access to projects. Please use the form above to request access."
6. Mixpanel logged-out variant collects Full name + Email before Request Access.

## Use when
The viewer is authenticated but unauthorized for this org/resource and an approver exists — every fail-closed tenant page should resolve to this, never a blank 404/500.

## Avoid when
The resource's existence is itself confidential (request-access confirms existence — render not-found instead); or there is no approval workflow behind the button (a Request button that goes nowhere is worse than "contact your admin" text).

## Sad paths observed
Wrong-account is the #1 diagnosed cause — all three give an account-switch path; Mixpanel explicitly tells users support cannot shortcut the process (deflects tickets).

## Accessibility
Single-column centered content with one primary button and text links; identity line is plain text adjacent to the actions, read in sequence.

## Default verdict for our stack
RECOMMENDED — our fail-closed active-org gate should render exactly this: headline, "signed in as", Request access (notifies org admins), switch-org, sign-out-and-switch-account.
