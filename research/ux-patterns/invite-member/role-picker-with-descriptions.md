# Pattern: Role picker with inline permission descriptions
**Surface:** invite-member · **Observed in:** Vercel, Plane, GitBook, Slack, Stripe, Exa, Notion (refs: [Vercel](https://mobbin.com/screens/a10e73e0-e3cd-4d17-a267-1d84051af6a8), [Plane](https://mobbin.com/screens/8e8989db-cc2d-4a2d-ae6a-79de9bde1ec4), [GitBook](https://mobbin.com/screens/1944a6f5-6de7-4693-af25-89c86c133fb4), [Slack](https://mobbin.com/screens/25019c93-8f16-4c0c-a8c5-b7343f8ebf25), [Stripe](https://mobbin.com/screens/59346a7c-6296-4444-b7d7-281d1574a94e), [Exa flow](https://mobbin.com/flows/2fb3b980-3b0a-43de-975c-d1a63454eff7), [Notion](https://mobbin.com/screens/c77d2a3a-7556-4f27-857a-3e7960411086))

## Flow
1. Role dropdown opens listing each role as title + one-line permission summary: Vercel "Member — Create deployments, manage integrations and domains"; Exa "Owner — Can modify billing, subscribe to plans, manage team members and API keys…"; Notion "Member — Cannot change workspace settings or invite new members".
2. Current selection check-marked; descriptions phrased as capabilities ("Can…") or explicit limits ("Cannot…", Slack's "Guest – limited to select channels, files and directory").
3. Escalation paths linked from the dropdown: Vercel "Compare all Team Roles ↗"; Stripe shows a side panel that fills with the description of whichever role is hovered/checked.

## Use when
- Always, anywhere a role is chosen (invite, change-role, onboarding) — every reference app that has roles does this.
- Especially with 3+ roles whose names alone are ambiguous (our Ops vs Coordinator).

## Avoid when
- Never omit outright; only compress (tooltip instead of inline text) if the picker appears in an extremely dense table row.

## Sad paths observed
- GitBook disables-but-shows plan-gated roles with "Upgrade" badges rather than hiding them.
- Notion appends the destructive "Remove from workspace" as the dropdown's last item, separated — role menu doubles as the row action menu.

## Accessibility
- Descriptions inside the option are read by screen readers with the option label — better than tooltip-only. Keep one option = one selectable element.

## Default verdict for our stack
RECOMMENDED — non-negotiable for our 4-role model; shadcn Select/Combobox items with title + muted description line, "Cannot…" phrasing for Read-only.
