# Pattern: In-shell denial with live workspace switcher (session preserved)
**Surface:** revoked-mid-session · **Observed in:** Framer (refs: [gate](https://mobbin.com/screens/23ea2dbf-a2a6-4fe9-a118-8dda59d4c846), [switcher](https://mobbin.com/screens/3b4cd422-7e5f-4382-9a5f-7b03ebc3a5ba))

## Flow
1. User's access to the current workspace is gone (revoked or never valid); content area renders the denial ("Looks like you don't have access to this workspace. Contact the owner and try again.") while the session and minimal chrome survive.
2. Workspace switcher (top-left) still lists the user's remaining workspaces plus "Request Editor Access", "Add Workspace", "Sign Out".
3. User switches to a surviving workspace in one click — no re-login, no full eviction.

## Use when
Org-scoped revocation in a multi-tenant product where the user predictably has other orgs — this is the closest observed approximation of the Slack-desktop "evict to picker" behavior on web.

## Avoid when
The revoked org's data could still be visible in surrounding chrome (must be fully purged); when the user has exactly one org, a switcher with nothing to switch to needs a different empty state (create-org / request access).

## Sad paths observed
Toast-vs-takeover question is answered implicitly: no toast observed anywhere — the state change is communicated by the page itself on next interaction/navigation. Real-time push eviction (mid-keystroke) was not observable from stills.

## Accessibility
Recovery actions live in one menu reachable from a stable landmark (top-left); denial text is static and centered.

## Default verdict for our stack
RECOMMENDED (as the org-scoped branch) — on active-org revocation: invalidate active org, render neutral denial + org picker in place, keep session; pair with the full-page takeover copy ("You were removed from X by an admin") for honesty Framer lacks.
