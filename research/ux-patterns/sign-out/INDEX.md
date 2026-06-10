# INDEX — sign-out (A6)

## Coverage
- **Queries run — by-pattern (2):** "account menu dropdown avatar sign out log out option", "active sessions devices list settings security revoke session" (platform=web).
- **Queries run — by-flow (2):** "log out sign out of account" (Origin, Pitch, Vapi, Runway flows), "log out of all devices end all sessions security" (Fireflies, HBO Max, Tripadvisor flows).
- **Cross-surface evidence reused:** Notion "Log out of all devices" row and Mercury/Later password-form checkboxes surfaced during A5 queries.
- **Apps swept:** YouTube, Vapi, Runway, Pitch, Hootsuite, Origin, Fresha, Posh, Bumble, Family, WhatsApp, Frame.io, Notion, Fireflies, HBO Max, Tripadvisor, GitHub, GitLab, Pipedrive, Figma, folk, Revolut.
- **NOT found / excluded:** No Slack-specific sign-out screen surfaced (Slack sign-out unverified — do not cite). No Linear sign-out screen captured. No B2B app showed a bare "Are you sure?" sign-out confirm — the only confirmation observed (WhatsApp) had a stated consequence. Posh/Bumble/Family screens were consumer account hubs; recorded only as placement evidence.
- Final flow query returned mostly already-seen apps — treated as dry.

## Patterns
- ★ `account-menu-immediate-signout` — sign out last in avatar/account menu, destructive styling, no confirm, land on login (YouTube, Vapi, Runway, Pitch, Hootsuite, Origin, Fireflies). ★ recommended default.
- `signout-confirmation-dialog` — confirm only with a stated consequence + alternative action (WhatsApp). AVOID as default for us.
- ★ `post-signout-login-banner` — "Signed out successfully" banner + prefilled email on login (Intercom, Gamma, Mailchimp, Docusign).
- ★ `active-sessions-list-revoke` — sessions page with device/location/time, current badge, per-row revoke (GitHub, GitLab, Pipedrive, Figma, folk, Revolut, Fireflies).
- ★ `logout-all-devices-control` — single "log out all other devices" action with scope-explicit copy and success confirmation (Notion, Frame.io, Fireflies, HBO Max, Tripadvisor).
