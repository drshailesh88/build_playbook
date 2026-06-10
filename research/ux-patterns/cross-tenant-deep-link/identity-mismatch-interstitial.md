# Pattern: Identity-Mismatch Interstitial (Prompt Before Switch)
**Surface:** cross-tenant-deep-link · **Observed in:** Better Stack, Descript, Sketch, Fresha, The New Yorker (refs: [Better Stack "Switch accounts"](https://mobbin.com/screens/79ff5d94-60a3-441e-a5e4-d535330f7948), [Descript "Join Alex's Drive as...?"](https://mobbin.com/screens/fc5c2dba-e81a-4f41-a8c7-17ad447a01f0), [Sketch accept-invitation](https://mobbin.com/screens/63ebd23e-0196-400c-8bf7-0b9ee5338476), [Fresha join flow](https://mobbin.com/flows/dfe3e557-de7c-4e86-ae30-71c0de4a8caa), [New Yorker select-an-account](https://mobbin.com/screens/7655bbac-d2ec-49c1-a2df-40039506c0c6))

## Flow
1. User opens a link whose target context doesn't match the current session context.
2. App PAUSES instead of acting: full-screen/modal interstitial states the mismatch in one sentence — "You clicked a magic link for a different user. What do you want to do?" (Better Stack); "Join Alex's Drive as samlee.mobbin@gmail.com?" (Descript).
3. Both concrete identities are shown verbatim: "Switch account to jonsmith.mobbin@gmail.com" vs "Stay signed in as jsmith.mobbin2@gmail.com" (Better Stack). Sketch: "Accept this invitation using jonsmith.mobbin@gmail.com" / "Request access with a different email". Fresha: "Would you like to use alexsmith.mobbin@gmail.com or use another account?"
4. The action implied by the link is the visually primary button; staying put / using another identity is secondary.
5. One click resolves: context switches (or doesn't) and the link continues to its destination.

## Use when
- Combination (1): member of Org A with Org B active — this is the closest observed precedent for "prompt, don't silently switch": name both orgs, make "Switch to Org A and open" primary, "Stay in Org B" secondary.
- Invite/magic links bound to a specific identity or org, where acting under the wrong context has consequences.

## Avoid when
- The switch is zero-cost and reversible AND the user has signaled a standing preference — interrupting every link gets noisy (Runway ships a "Don't show again" checkbox on its select-workspace modal: [ref](https://mobbin.com/screens/228d6f10-a4f2-45e9-82c8-a46cf52f1bde)).
- The user is NOT a member of the target org — prompting to switch to something they can't enter is a dead end; use request-access instead.

## Sad paths observed
- Constraint makes the action impossible: Fresha "Invite can't be accepted — You can only be part of 1 workspace at a time, please leave your current workspace to accept" with a "View workspace" remediation button ([flow](https://mobbin.com/flows/dfe3e557-de7c-4e86-ae30-71c0de4a8caa)).
- Stale link: Linear "Invitation already accepted — if you think this is a mistake... contact the workspace admins", with "Logged in as:" shown top-right ([ref](https://mobbin.com/screens/7a0995a4-f085-45cd-b657-d88269272e9e)).
- Wrong identity entirely: Descript pairs Accept with "Log out" guidance ("If this is not the Descript account you want to link, please logout and login with the desired email").

## Accessibility
- Two mutually exclusive, fully spelled-out buttons (verb + identity in the label) — no ambiguous "OK/Cancel".
- The mismatch explanation is body text above the choices, first in reading order.
- Full-screen takeover (Better Stack, Fresha) avoids focus-trap complexity of layered modals.

## Default verdict for our stack
RECOMMENDED — the default for combination (1): interstitial naming both orgs ("This event belongs to Org A — switch from Org B and open?"); switching updates session.activeOrganizationId only on explicit confirm, which keeps DEC-057/058 invariants (fail closed on active org) intact.
