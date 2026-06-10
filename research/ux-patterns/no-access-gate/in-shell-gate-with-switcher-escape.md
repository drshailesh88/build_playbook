# Pattern: In-shell denial with workspace switcher as the escape
**Surface:** no-access-gate · **Observed in:** Framer (refs: [gate](https://mobbin.com/screens/23ea2dbf-a2a6-4fe9-a118-8dda59d4c846), [switcher open](https://mobbin.com/screens/3b4cd422-7e5f-4382-9a5f-7b03ebc3a5ba))

## Flow
1. User lands in a workspace they can't access; the dashboard chrome renders but the content area shows: "Something went wrong — Looks like you don't have access to this workspace. Contact the owner and try again."
2. The top-left workspace switcher remains functional; opening it lists the user's workspaces (with plan badges), "Request Editor Access", "Add Workspace", and "Sign Out".
3. User self-rescues by switching to a workspace they do have, requesting access, or signing out.

## Use when
Multi-org users frequently land on the wrong tenant (stale deep links, multiple accounts) — the switcher converts a dead end into one-click recovery.

## Avoid when
The headline copy is the anti-lesson: "Something went wrong" misclassifies an authorization state as an error, suggesting retry will help; don't copy that. Also avoid if any org-specific data would render in the chrome around the gate.

## Sad paths observed
The state IS the sad path; recovery actions (switch / request / sign out) are all reachable without leaving the page. "Contact the owner" is advice-only — no mailto or owner identity provided (weak).

## Accessibility
Switcher is a standard menu; the denial message is plain centered text — no live-region/announce behavior observable from stills.

## Default verdict for our stack
VIABLE — the switcher-as-escape is the piece to keep (merge into ★ full-page gate as a "Switch organization" action); the "Something went wrong" framing and bare "contact the owner" are below bar.
