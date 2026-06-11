# Pattern: System template registry — event-keyed table with override badges and version history
**Surface:** template-management · **Observed in:** Employment Hero, Clerk, HubSpot, AutoSend, Intercom, Outseta (refs: [Employment Hero table](https://mobbin.com/screens/fc9cfef8-dbdc-4b05-8e78-1972b91cd217), [actions menu](https://mobbin.com/screens/26137ce5-0c9f-46f7-a7cb-88308db1faa4), [Clerk emails grid](https://mobbin.com/screens/8bf785fe-f63b-4a6d-b4d7-af2178169bab), [HubSpot templates](https://mobbin.com/screens/0e0c23a9-330a-46fa-a7ac-0711788b7b1b), [AutoSend templates](https://mobbin.com/screens/03314795-b46e-45cf-955d-58b8e4b4bfb1), [Intercom default](https://mobbin.com/screens/581e2a87-2fe3-4c83-bbd3-4eccee0724ae))

## Flow
1. Registry table: Name / Status (Active badge) / Type / EVENT — a plain-language trigger sentence ("An admin/owner on-boards a new employee with a contract") / RECIPIENT (Employee | Contractor) / Actions ▾ (Preview, Clone) (Employment Hero).
2. Expanding a row reveals a VERSION HISTORY sub-table: Version ID / Clone status / Subject / Last updated.
3. Clerk's grid variant: one card per system email, each badged **Default** vs **Edited** — customized templates are visually distinct from stock at a glance, with "Updated X ago".
4. Channel tabs unify per-channel variants in one hub: Email / WhatsApp (HubSpot, with "2 of 5,000 created" quota and folders).
5. Default-template picker: "This template will be pre-selected when you compose a new email" (Intercom); shared layout wrapper split as Layouts vs Emails tabs (Outseta).

## Use when
The product ships seeded system templates that tenants can override — the registry must answer "what fires this?", "who gets it?", and "have we customized it?" without opening each template.

## Avoid when
Users author all templates from scratch (pure newsletter tools) — a gallery beats a registry.

## Sad paths observed
- Default-vs-Edited badge prevents the "did we already brand this?" audit crawl (Clerk).
- Version sub-table gives rollback context after a bad edit (Employment Hero).

## Accessibility
Plain table semantics; badges paired with text; expandable rows keyboard-toggleable.

## Default verdict for our stack
RECOMMENDED — our 16-key × email/WhatsApp registry should show: plain-language trigger sentence per key, recipient resolution, Default/Edited badge (global vs event-override), versionNo history (already in schema), and channel tabs.
