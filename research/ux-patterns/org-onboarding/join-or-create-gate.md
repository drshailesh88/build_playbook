# Pattern: Forced join-or-create gate
**Surface:** org-onboarding · **Observed in:** Notion, Slack, Linear, Cycle (refs: [Notion gate w/ invite](https://mobbin.com/screens/1f794a8f-3b4d-4f47-99a5-158c604317dc), [Notion gate, no invites](https://mobbin.com/screens/89ff35d8-d58d-4ea6-8afa-4c1832d36ef9), [Slack workspace discovery](https://mobbin.com/screens/c9ac097e-c08a-4e5b-a5cd-5be966f5c4cd), [Linear full-screen create](https://mobbin.com/screens/dc1e55eb-22df-482e-9b8f-01acacc0a676), [Cycle join interstitial](https://mobbin.com/screens/ef73c053-c982-432e-aa66-7cb2f70c11d0))

## Flow
1. User authenticates but has no active org/workspace.
2. App renders a full-screen blocking gate (no app chrome): "Join teammates or create a workspace".
3. Pending invitations / discovered workspaces are listed as cards with a per-row "Join" action (Notion shows "You've been invited to 1 workspace"; Slack looks up workspaces matching the verified email domain and reports "Is your team already on Slack? We couldn't find any existing workspaces" with "Try a Different Email").
4. Primary CTA below the list: "Create new workspace".
5. Only escape hatches are account-level: "Log out" (Linear top-left) / "Cancel" — there is no way into the app without an org.

## Use when
- The org IS the tenant and every authenticated route requires `activeOrganizationId` — this is the canonical zero-org state.
- Invitations exist as first-class records that can be surfaced at this gate.

## Avoid when
- The product has a meaningful personal/no-org mode (then a gate is hostile).
- You can't query invites at this point — a gate that always shows "create only" wastes the join half.

## Sad paths observed
- No invites found: Slack explicitly says it couldn't find workspaces for that email and offers "Try a Different Email" rather than a dead end.
- Notion keeps a marketing-consent checkbox on the gate — legal copy lives here, not in the wizard.
- Linear's create screen shows "Logged in as <email>" + "Log out" so a wrong-account user can recover without finishing creation.

## Accessibility
- Single-column, single-decision screens; one primary button. No keyboard-specific affordances observed.

## Default verdict for our stack
RECOMMENDED — maps 1:1 to Better Auth session without activeOrganizationId; gate route that lists pending invites + create CTA is the cleanest forced state.
