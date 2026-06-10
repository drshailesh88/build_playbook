# Pattern: Inline invite-teammates step with skip + invite link
**Surface:** org-onboarding · **Observed in:** Linear, Slack (refs: [Linear invite by email](https://mobbin.com/screens/ea105d60-40f2-4cfc-9854-c051dca7875b), [Linear invite link + copy toast](https://mobbin.com/screens/4c68b2ea-c524-40a6-bd17-3fd0fbc80f90), [Linear invites-sent toast](https://mobbin.com/screens/ec0253f4-370c-4358-8cab-4228b65d9c34), [Slack invite step](https://mobbin.com/screens/4f8dec97-5f38-4f55-a455-74c4a5f0aafb))

## Flow
1. Immediately after org creation, a dedicated "Invite co-workers to your team" step with rationale copy ("Linear is meant to be used with your team").
2. Multi-email input (comma-separated placeholder "email@example.com, email2@example.com…").
3. Alternate channels beside email: "Copy Invite Link" (Slack button; Linear shows shareable `linear.app/<org>/join/<token>` URL with Copy) and "Add from Google Contacts" (Slack).
4. "Send invites" → non-blocking toast "Invites sent — They have been notified with email to sign up"; copy-link → toast "Invite link copied to clipboard".
5. Two-tier exit: primary "Continue" plus low-emphasis "I'll do this later" / "Skip this step" — invites never block completion.
6. Linear extra: "Add to team" picker so invitees land in a specific team, not just the org.

## Use when
- Multi-tenant B2B where a single-member org is a low-activation org — invite belongs in first-run, not buried in settings.

## Avoid when
- Invitee emails trigger billing (seat-priced) without warning — then inviting needs a cost notice, not a casual wizard step.
- Solo-first products where the step is irrelevant noise.

## Sad paths observed
- Skip is always present and visually subordinate — never a dead-end requirement.
- Feedback is toast-based (invites sent / link copied), keeping the user in the wizard rather than navigating away.

## Accessibility
- Single text area accepting pasted lists lowers effort; toasts announce result (visual only — no ARIA observable from screenshots).

## Default verdict for our stack
RECOMMENDED — email multi-input + copy invite link + "I'll do this later", wired to Better Auth invitations, mirrors Linear exactly.
