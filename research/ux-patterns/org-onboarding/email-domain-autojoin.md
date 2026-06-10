# Pattern: Email-domain auto-join / workspace discovery
**Surface:** org-onboarding · **Observed in:** Slack, Notion (refs: [Slack domain checkbox at create](https://mobbin.com/screens/b58ce3ef-5180-4cee-a62c-20347539d2ea), [Slack "Is your team already on Slack?"](https://mobbin.com/screens/c9ac097e-c08a-4e5b-a5cd-5be966f5c4cd), [Notion "Suggested · Join" in switcher](https://mobbin.com/screens/3934d9e2-d212-4a31-a5bd-a67f120833b9), [Notion allowed email domains setting](https://mobbin.com/screens/0f69714a-080a-43ed-b1c6-7103ea8fadfe))

## Flow
1. At workspace creation, an opt-in checkbox: "Let anyone with an @content-mobbin.com email join this workspace" (Slack, pre-checked when domain is corporate).
2. Setting persists in org settings as "Allowed email domains — Anyone with email addresses at these domains can automatically join your workspace" (Notion).
3. On a new user's signup with a matching domain, the app surfaces existing workspaces: Slack runs discovery before create ("We couldn't find any existing workspaces for the email address…"); Notion lists discovered workspaces inline in the switcher tagged "Suggested" with a "Join" action.
4. Joining bypasses the explicit invitation flow entirely.

## Use when
- Customers are companies with corporate email domains and you want to kill the duplicate-org problem (two people from the same company each creating an org).

## Avoid when
- Tenants are agencies/consultancies sharing domains with clients, or consumer gmail domains dominate — auto-join becomes a data-leak vector (gmail.com must always be excluded).
- Strict tenancy isolation/compliance: joining must stay admin-approved.

## Sad paths observed
- Slack handles "no workspaces found for this email" with an explanatory card + "Try a Different Email" instead of silently showing only create.
- Notion keeps Suggested workspaces non-blocking — they sit in the switcher; user is never forced to join.

## Accessibility
- Checkbox with full-sentence label at creation; discovery results are plain list rows with Join buttons.

## Default verdict for our stack
VIABLE — strong retention lever for B2B, but ship later: requires verified-domain logic and a public-domain blocklist before it's safe; not needed for v1 invites.
