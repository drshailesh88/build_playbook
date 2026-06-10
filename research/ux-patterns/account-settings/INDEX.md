# INDEX — account-settings (A5)

## Coverage
- **Queries run — by-app (4):** "Linear account settings profile preferences modal", "Vercel account settings profile page", "Notion settings modal sidebar my account", "Slack edit profile photo full name display name" (all platform=web).
- **Queries run — by-pattern (1):** "change password form current password new password settings".
- **Queries run — by-flow (1):** "change account email address with verification" (Chatbase, Babbel, Preply, Record Club flows).
- **Apps swept:** Linear, Vercel, Notion, Slack, Dub, Patreon, Origin, Mercury, Airbnb, Gorgias, Later, Cohere, Chatbase, Babbel, Preply, Record Club, Frame.io, GitHub, GitLab, Pipedrive, folk.
- **NOT found / excluded:** No Stripe Dashboard or Raycast account-settings screens surfaced in these queries (Stripe/Raycast remain unverified for this surface — do not cite them). No iOS queries run (web results were rich). Two-factor/passkey setup screens were seen (Notion, Origin, Kraken) but are out of A5 scope and not carded. Delete-account/danger-zone seen (Notion, Record Club, Origin) but out of scope.
- Last sweep round returned only repeat screens — treated as dry.

## Patterns
- ★ `full-page-settings-two-zone-sidebar` — dedicated settings route, sidebar split Workspace vs My Account (Linear, Vercel, GitHub, GitLab, Pipedrive, folk, Frame.io). ★ recommended shell.
- `settings-modal-overlay` — Notion/Figma-style settings modal over the workspace; routing-hostile, viable alternative.
- ★ `card-per-setting-inline-save` — Vercel card stack, per-card Save + constraint footer. ★ recommended content layout inside the shell.
- ★ `change-email-verification-link` — verify new address by link before switch (Linear, Chatbase, Preply, Record Club).
- `change-email-password-gated` — current password required to start email change (Babbel, Notion); combine with verification-link.
- ★ `change-password-current-required` — current+new+confirm, proactive requirements, forgot escape hatch (Airbnb, Origin, Gorgias, Cohere, Dub, Patreon).
- ★ `password-change-revoke-other-sessions` — pre-checked "log out other devices" checkbox on password form (Mercury, Later).
- `avatar-upload-crop-modal` — click-to-upload + crop/zoom dialog + remove (Linear, Slack, Vercel). Recommended for avatar specifically.
- `edit-profile-contextual-modal` — Slack atomic profile-edit dialog; viable companion, not primary.
