# Pattern: Request Access With Identity Disclosure
**Surface:** cross-tenant-deep-link · **Observed in:** Notion, Mixpanel, Asana, Amplitude (refs: [Notion "No access to this page"](https://mobbin.com/screens/46abb577-0502-4c57-b90d-6d96ffa05115), [Mixpanel "You need permission"](https://mobbin.com/screens/8bc4ab67-6d62-4d1e-944c-05bc5bff956b), [Asana request access with approver message](https://mobbin.com/screens/92f8660a-4efb-48aa-a61f-35d3d45e3997), [Amplitude "Request Access to JD Mobbin"](https://mobbin.com/screens/b7d8e446-d611-47de-974d-cd8b75aa3cff))

## Flow
1. Signed-in user opens a link to a resource their identity cannot access.
2. Minimal blocked screen states the situation: "No access to this page — You can access this page if someone approves your request" (Notion); "You need permission — you want to view a report, but don't have access or you need to log into an account with permission" (Mixpanel).
3. The acting identity is always disclosed: "You're currently logged in as jsmith2@content-mobbin.com" (Notion), "You are logged in as [email]" (Mixpanel), "You're currently signed in as ...@gmail.com" (Asana).
4. Primary action: Request access — sends notification to admins/owner ("The project's admins will be notified" — Asana; "Your administrator will receive an email" — Amplitude). Asana adds an optional "Message for approver" textarea.
5. Secondary actions: "Back to my content" (Notion), "log in with a different email" (Notion), "or Login" (Mixpanel), "Go back to log in" (Amplitude) — wrong-identity escape hatch.
6. Terminal state is async: user waits for approval; no in-screen promise of when.

## Use when
- Combination (2): signed in but not a member of Org A — when the org allows discovery/requests from outsiders.
- Combination (4) at resource level: member, but the resource is restricted (Asana's project-level version).
- Identity disclosure is the load-bearing detail — most "wrong access" cases are wrong-account cases, and showing the email lets users self-diagnose.

## Avoid when
- Tenant existence must not be disclosed to non-members — a request-access screen confirms the resource exists. Use masked-not-found instead.
- There is no admin workflow to receive/approve requests — a Request button that goes nowhere is worse than a contact link (Whereby's terminal "host did not grant you access" is honest about this).

## Sad paths observed
- Request denied / never approved: Whereby shows the hard terminal version — "The host did not grant you access. If you were invited to this room, please contact the person who invited you" ([ref](https://mobbin.com/screens/98b1c0c3-5648-48e9-b8e0-0ca5f79e56bd)).
- Platform can't grant: Mixpanel disclaims "Mixpanel cannot grant access to projects. Please use the form above" — deflects support tickets.
- Wrong account entirely: every observed app pairs the request CTA with a switch-identity link rather than assuming the request is the fix.

## Accessibility
- Single heading + short explanation + two clearly labeled actions; no reliance on imagery.
- The logged-in identity is plain text adjacent to the actions, available to screen readers.
- Asana's optional message field is labeled ("Message for approver (optional)").

## Default verdict for our stack
RECOMMENDED — for combination (2) when the org opts into discoverability, and for combination (4) on role-restricted resources; must always render the acting email + "switch account" and notify org admins through an existing approval queue.
