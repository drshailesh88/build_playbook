# Pattern: Consequence-stating confirmation on role change / demotion
**Surface:** change-role · **Observed in:** Whop, ClickUp, Twist, Remote, WhatsApp (refs: [Whop](https://mobbin.com/screens/661e0854-e759-4525-9f95-80a4378ee1b3), [ClickUp](https://mobbin.com/screens/d2ef5aeb-1e50-4275-a774-207450250c79), [Twist](https://mobbin.com/screens/3a2e59e0-3752-4d46-8b83-0c86cb9485bf), [Remote](https://mobbin.com/screens/f3b8f697-ddcd-4fc2-89b0-6a9454330f5d), [WhatsApp](https://mobbin.com/screens/85ac967d-4b03-4797-8e7a-4f0c8381443c))

## Flow
1. Selecting a new role triggers a dialog before commit.
2. The dialog names person, old role, and new role concretely: Whop — "jsmith@gmail.com will be assigned the role of Operations and the previous role admin will be removed."
3. Consequences are spelled out as capability deltas: ClickUp — "Converting Jane Doe to a Guest will remove access from Spaces, and prevent them from creating Spaces, Folders, and Lists" (+ a note on what they keep); WhatsApp — "They won't be able to send announcements, manage the community or use other admin tools."
4. Escalating friction for bigger demotions: Twist requires ticking "Yes, I'm absolutely sure." before "Downgrade to guest" enables.
5. Reversibility is addressed either way: Remote — "This can't be undone, but you can always reassign these people…"; confirm button restates the action verb ("Convert to Guest", "Downgrade to guest", "Save").

## Use when
- Privilege escalation (→ Admin/Super Admin) and demotion of privileged roles — the cases where a mis-click changes tenant security posture.
- Capability deltas between roles are non-obvious.

## Avoid when
- Lateral or low-stakes changes (Member → Ops) — confirming everything erodes the signal; observed apps confirm only downgrade/guest-conversion-grade changes.

## Sad paths observed
- Twist's checkbox-gate is a deliberate double-confirm for the most destructive demotion.
- ClickUp's "Note: Jane will still have access to Folders, Lists, or Tasks they've been invited to" prevents false belief that demotion equals full lockout.

## Accessibility
- Dialogs use explicit verb buttons (never OK/Cancel only — except WhatsApp's weaker OK); checkbox gate is a real labelled checkbox.

## Default verdict for our stack
RECOMMENDED — confirm only on escalation to admin-grade and demotion from it, with old→new role named and 2–3 capability-delta bullets; verb-labelled confirm button.
