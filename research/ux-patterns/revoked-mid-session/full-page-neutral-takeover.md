# Pattern: Full-page neutral takeover when the org disappears
**Surface:** revoked-mid-session · **Observed in:** Slack, Grain (refs: [Slack](https://mobbin.com/screens/e5409345-7993-48b4-957e-2c63432d64f4), [Grain](https://mobbin.com/screens/21737bd4-e867-4c6f-92c1-d8c4c18059d9))

## Flow
1. The workspace the user was in is deleted (or marked for deletion) while they're active; the app replaces the entire workspace UI with a neutral, chrome-light page — no stale tenant data remains visible.
2. Slack: card titled "Workspace Deleted" with a feedback contact ("Please get in touch at feedback@slack.com…") and an exit: "You can close this page or go to slack.com." The user's other-workspace switcher remains in the page header.
3. Grain: full-blank page, "This workspace has been marked for deletion by your workspace admin." with attribution of WHO did it (admin) and an appeal path: "If you believe this is an error, please contact Grain support."
4. No auto-redirect observed — the page is a terminal explanation with outbound links.

## Use when
The org itself is gone (deleted, suspended) — there is nothing to retry and the user needs: what happened, who/why, and where to go next.

## Avoid when
Only THIS user's access was revoked but the org lives — then route to the no-access-gate / org picker rather than implying the org is gone; avoid Grain's dead-end (no navigation to the user's other workspaces).

## Sad paths observed
This page IS the sad-path handler. Grain attributes cause ("by your workspace admin") and offers an error-appeal route; Slack offers feedback + a navigable exit. Neither shows the user's surviving orgs inline — both weaker than a picker.

## Accessibility
Single heading + short body + links; full takeover means no focus trapped in dead UI behind it.

## Default verdict for our stack
RECOMMENDED (adapted) — on revocation events (removed from org, org deleted), hard-replace the app with a neutral page stating what happened and who acted, then offer our org picker + sign out; never leave stale tenant UI interactive.
