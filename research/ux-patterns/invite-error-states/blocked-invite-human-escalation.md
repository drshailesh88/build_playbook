# Pattern: Blocked Invite with Human Escalation / Constraint Explanation
**Surface:** invite-error-states · **Observed in:** Whereby, Fresha, Linear (refs: [Whereby](https://mobbin.com/screens/98b1c0c3-5648-48e9-b8e0-0ca5f79e56bd), [Fresha](https://mobbin.com/screens/0446e356-4782-45d3-98ac-13b2fde58ebd), [Linear](https://mobbin.com/screens/7a0995a4-f085-45cd-b657-d88269272e9e))

## Flow
1. Access is blocked by a rule rather than a dead token; the page states the rule in plain language: Whereby "The host did not grant you access"; Fresha "Invite can't be accepted — You can only be part of 1 workspace at a time, please leave your current workspace ASMobbin to accept ASMobbin's invite."
2. The repair path names a human or a concrete action: Whereby "If you were invited to this room, please contact the person who invited you"; Fresha "You can leave or delete ASMobbin from the workspace page" + "View workspace" button; Linear "contact the workspace admins or Linear support."
3. One actionable CTA points at the place where the fix happens (Fresha "View workspace"); dismissal X available.

## Use when
Revocation, permission denial, seat/plan limits, or tenancy constraints block the accept — cases where re-requesting a link will NOT help and only an admin action or user decision can resolve it.

## Avoid when
Self-serve recovery exists (expired link → request new one) — pointing at a human for something the system could re-issue adds support load; also avoid constraint phrasing without the unlock action (Whereby gives no button, just advice — weakest form).

## Sad paths observed
All three ARE sad paths; the harvest insight: revoked invites never appear with explicit "revoked" copy anywhere in the sweep — apps either fold them into not-found/invalid (Clay, Jitter) or into contact-the-inviter language like these.

## Accessibility
State the rule as text (not toast); the named repair action must be an actual link/button; contact paths should be reachable links, not bare prose.

## Default verdict for our stack
RECOMMENDED — for revoked invites use neutral copy ("This invitation is no longer active") + "Ask {inviter or org admins} for a new invite" + "Go to login"; mirrors observed practice of not exposing 'revoked' while still giving a route forward.
