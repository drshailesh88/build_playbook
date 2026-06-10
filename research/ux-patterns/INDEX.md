# UX Pattern Library — Auth & Tenancy + External/SaaS-ification (Harvests 2026-06-10)

Frozen Mobbin harvest, two rounds same day: round 1 = 147 cards across 26
auth/tenancy surfaces (7 agents); round 2 = 72 cards across 7 surfaces for
external-participant access and SaaS-ification (6 agents, scoped by oracle
cross-check — see project ORACLE-CROSSCHECK-2026-06-10.md). All swept
by-app / by-pattern / by-flow, loop-until-dry. Each
surface directory has its own INDEX.md with per-surface coverage notes and
the recommended default marked ★. Cards record OBSERVED patterns with
mobbin.com refs only — no invented attributions, no binary content.

Reference apps targeted: Raycast, Linear, Slack, Notion, Vercel, Stripe
(plus the wider Mobbin web index where the named six were absent).

## Surfaces

| Surface | Cards | Theme |
|---|---|---|
| sign-up | 10 | form shape, social stack, progressive vs single-step, post-auth workspace setup |
| sign-in | 10 | method ordering, identifier-first, SSO escape, credential errors |
| password-reset | 8 | request form, enumeration-safe confirm, reset form, expired link |
| email-verification | 10 | blocking OTP/link gates, soft gates, resend cooldown, capability gates (incl. C4 unverified-gate) |
| rate-limit-lockout | 5 | too-many-attempts, captcha interstitial, blocked identifier, disabled wall |
| account-settings | 9 | settings shell (page vs modal), change email/password, sessions |
| sign-out | 5 | menu placement, no-confirm consensus, sign-out-everywhere |
| session-expiry | 8 | in-place re-auth modal, pre-expiry countdown, cause banners, step-up |
| org-onboarding | 6 | create-org card, join-or-create gate, inline invite step, wizards |
| org-switcher | 4 | sidebar popover, account-menu submenu, topbar scope selector |
| org-settings | 5 | grouped-nav settings page, identity form, slug/IDs, danger zone |
| members-list | 5 | settings table, scale toolbar, unified status badges |
| invite-member | 6 | modal repeater, role descriptions, guardrails, share link |
| invite-email | 5 | who-invited-you framing, expiry statement, email binding (PROXY-evidence, see surface INDEX) |
| pending-invites | 5 | pending tab, resend/revoke, expiry columns |
| change-role | 5 | inline dropdown, consequence confirm, self/last-owner guards |
| accept-invite-new-user | 6 | locked-email signup, OAuth one-click, org-context header |
| accept-invite-existing-user | 5 | join interstitial, identity check, switch-account chooser |
| invite-error-states | 5 | expired/revoked/already-member dead-ends and recovery CTAs |
| remove-member | 5 | confirm + consequence line, content transfer, re-auth gate |
| leave-org | 2 | danger-zone leave, inline leave + picker landing |
| last-admin-guard | 2 | transfer-first wizard, blocking dialog with actions |
| transfer-ownership | 3 | type-name immediate, nominate-and-accept, re-auth gate |
| delete-org | 6 | type-org-name modal, itemized acknowledgement, email-code gate |
| no-access-gate | 4 | request-access page, in-shell denial + switcher, 403 anti-floor |
| revoked-mid-session | 3 | neutral takeover, in-shell denial + live switcher, eviction banner |

### Round 2 — external participants + SaaS-ification

| Surface | Cards | Theme |
|---|---|---|
| tokened-access-landing | 15 | RSVP accept/decline landing, magic-link conventions, expired/reused tokens, link-based forms, ticket/cert download (apps: Luma, Calendly, Partiful, Eventbrite + airline check-in) |
| cross-tenant-deep-link | 8 | workspace router, tenant-scoped sign-in wall, identity-mismatch interstitial, masked not-found, in-context role upgrade |
| zero-data-empty-states | 13 | checklist-hero dashboard, hollow widgets, single-action takeover, source-vs-derived emptiness, demo sandbox, filtered-vs-true empty |
| first-run-onboarding | 11 | setup checklist + deferral, guided first-object wizard, template-vs-blank, role-aware split, celebration/retirement (tours = observed AVOID) |
| import-wizard-sad-paths | 13 | partial-failure error file, revert window, batch tagging, bulk dedupe policy, sheet handling, import history, background completion |
| multi-scope-settings-ia | 6 | scope-swapped chrome, breadcrumb scope tokens, parent-grants-override inheritance, in-resource settings entry |
| comms-sender-setup | 6 | sender roster, DNS lifecycle + delegation helpers, send-test modal, readiness gates (WhatsApp/SMS: zero Mobbin coverage — vendor-docs work) |

Round-2 coverage honesty (also in surface INDEXes): Tito/Doodle/Hopin/Splash
absent from Mobbin; no reg#/phone identity gate before download; no silent
auto-switch evidence; no restore-checklist-after-dismissal; no undo-countdown
UI; no in-app import-completion toast (email-only everywhere); WhatsApp
template approval states unobservable.

## Library-level coverage honesty

- **Raycast**: effectively absent from Mobbin's web index for every surface
  swept — the one named reference app with no evidence. Do not cite it.
- **Stripe**: surfaced for sign-up/sign-in/invite-modal only; its settings,
  members table, and transfer flows never appeared.
- **Slack admin settings** live on a separate site Mobbin doesn't capture.
- **No precedent found anywhere** (design from first principles, flagged in
  surface INDEXes): timed lockout countdown; draft-restored-after-re-auth;
  last-member-leaves-org treatment; request-access pending/denied states;
  org soft-delete/restore window; explicit "invite was revoked" copy;
  inbox-rendered invite emails (accept-landing pages used as labeled proxy);
  privilege-escalation confirm (observed confirms are all demotions).

## Consumption rule

Builders implement DECIDED patterns: project DEC records cite these cards
by path; pathways cite DEC + card. This library is frozen — refresh only by
deliberately re-running /ux-pattern-harvest, never mid-build.
