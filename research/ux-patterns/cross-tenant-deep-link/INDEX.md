# cross-tenant-deep-link — Pattern Index

## Coverage note
Sweep executed 2026-06-10 against Mobbin MCP. Queries: **by-app screens (web) x7** (Slack workspace interstitial, Notion request-access, Figma file permission, Google-Docs-style need-access, Linear workspace/no-access, Vercel team permission, you-need-access-with-account), **by-pattern screens x5** (account chooser, sign-in-required-to-view, switch-workspace prompt, permission-denied error states, auto-switched-workspace notice), **by-flow x3** (open shared link without access, accept invite while signed in elsewhere, request access + owner approves), **iOS x1** (Notion workspace switch on notification). Stopped after two consecutive queries yielded no new patterns (final flow query returned owner-side sharing flows; iOS query returned only standard switchers).

**Apps swept/observed:** Slack, Notion, Figma, Linear, Vercel, Hex, Runway, Current, Plain, Steep, Copy.ai, Fresha, Better Stack, Descript, Sketch, Clearbit, Framer, Mixpanel, Asana, Amplitude, Proton, Grammarly, Confluence, Whereby, ClickUp, The New Yorker, Height, Udemy, Coinbase, Microsoft Loop, Craft.

**NOT found (no silent truncation):**
- **Auto-switch-on-link-open with notice** ("switched you to Org A" toast/banner): zero stills evidence in 16 queries — and stills inherently cannot prove silent behavior. Treat as **first-principles** territory.
- A "Switch workspace to view this page" modal naming the TARGET org for a member-of-both user: not directly observed. Better Stack/Descript/Fresha prove the prompt shape at the **account** level only; the org-level version is an adaptation, not a copy.
- Vercel-specific cross-team resource link handling: queries returned only settings screens; Vercel's "404-on-wrong-team" behavior is not captured in Mobbin stills.
- Google Workspace's actual "You need access / Switch accounts" page: not in Mobbin's web corpus; Mixpanel/Asana/Amplitude are the observed equivalents.
- Post-request **pending state** on the blocked resource: no app showed one (gap worth designing).

## Patterns
| Card | One-liner | Apps |
|---|---|---|
| [post-auth-workspace-router](post-auth-workspace-router.md) | Full-page "choose your workspace" chassis after auth or on unresolvable context | Slack, Hex, Linear, Current, Plain, Steep, Runway |
| [tenant-scoped-sign-in-wall](tenant-scoped-sign-in-wall.md) | Deep link → sign-in page named for the target org, destination preserved, "already signed in to" escape | Slack |
| [request-access-with-identity-disclosure](request-access-with-identity-disclosure.md) | Blocked screen showing acting email + Request Access + switch-identity link | Notion, Mixpanel, Asana, Amplitude |
| [tenant-blocked-named-org](tenant-blocked-named-org.md) | "Your current team X does not have access" — org is the blocked unit, external remediation | Clearbit, Framer |
| [identity-mismatch-interstitial](identity-mismatch-interstitial.md) | "This link is for a different context — switch or stay?" prompt before acting | Better Stack, Descript, Sketch, Fresha, The New Yorker |
| [account-chooser](account-chooser.md) | "Choose an account to continue to X" across remembered identities | Proton, Grammarly, Confluence, Whereby, ClickUp |
| [in-context-role-upgrade-request](in-context-role-upgrade-request.md) | Render read-only, gate the action, request upgrade with optional note | Figma, Asana |
| [masked-not-found](masked-not-found.md) | 404-over-403: no-access and doesn't-exist are indistinguishable, shell stays alive | Linear, Height, Udemy, Coinbase |

## Default per combination
- **(1) Signed in, Org B active, member of Org A too:** ★ [identity-mismatch-interstitial](identity-mismatch-interstitial.md) — prompt naming both orgs, switch only on explicit confirm. **Auto-switch (silent) has NO observed precedent — first-principles decision**; if chosen, Runway's "Don't show again" opt-out is the only observed adjacent evidence. Fallback chassis: ★ [post-auth-workspace-router](post-auth-workspace-router.md).
- **(2) Signed in, NOT a member of Org A:** ★ [masked-not-found](masked-not-found.md) as fail-closed default (composes with DEC-057); upgrade to [request-access-with-identity-disclosure](request-access-with-identity-disclosure.md) per-org when discoverability is enabled; [tenant-blocked-named-org](tenant-blocked-named-org.md) for org-level entitlement blocks.
- **(3) Logged out entirely:** ★ [tenant-scoped-sign-in-wall](tenant-scoped-sign-in-wall.md) — reason banner + org-named sign-in + callback to the deep link; [account-chooser](account-chooser.md) only if multi-session/remembered identities ship.
- **(4) Member but lacking role for the resource:** ★ [in-context-role-upgrade-request](in-context-role-upgrade-request.md) — degraded render + gated-action request modal; hard role walls fall back to [request-access-with-identity-disclosure](request-access-with-identity-disclosure.md). Post-request pending state: no precedent observed — design first-principles.
