# Pattern: Assign-replacement-before-leaving wizard (inline, self-serve)
**Surface:** last-admin-guard · **Observed in:** Fireflies (refs: [picker state](https://mobbin.com/screens/7abccef0-e7ed-4128-9497-6a12439ccf2e), [resolved state](https://mobbin.com/screens/a12ee0c8-a412-4162-8be8-4064d1afcabd))

## Flow
1. The sole admin attempts to leave the team.
2. Instead of a blocking error, a modal opens: "Please assign admin before leaving your team — You are the admin of your team. To leave your team, please assign a new team admin."
3. The modal embeds the member list (avatars + names) with a "Make admin" action per eligible member; the leaver is labeled "(Myself)".
4. Continue is disabled until a new admin is assigned.
5. Clicking "Make admin" promotes inline; a toast confirms "Successfully changed role to admin", the promoted row shows a ✓ Admin badge, and Continue enables.
6. Continue proceeds with the original leave action in the same flow.

## Use when
The org has other members who can be promoted; you want the blocked action to be resolvable in one place without abandoning intent.

## Avoid when
The org has no other members (the picker is empty — must branch to delete-org instead, see Zoom variant); or when promotion requires the other person's consent (use nominate-and-accept from transfer-ownership surface).

## Sad paths observed
The disabled Continue is the guard itself — the flow cannot be completed in an invalid state rather than erroring after submit. Empty-member-list state not observed.

## Accessibility
Disabled-until-valid primary button communicates the precondition; promotion feedback arrives as both a toast and an inline ✓ state change (not toast-only).

## Default verdict for our stack
RECOMMENDED — resolve-in-place beats a dead-end error and fits Better Auth's role update + leave as two sequential calls; branch to delete-org when member count is 1.
