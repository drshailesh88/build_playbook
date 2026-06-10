# Pattern: Type-name-to-confirm immediate ownership transfer
**Surface:** transfer-ownership · **Observed in:** Maze (refs: [Maze](https://mobbin.com/screens/2c0bad91-7796-492a-b479-d4eea6f3382f))

## Flow
1. Owner opens Team settings; a transfer row has a member dropdown ("Jane Doe (jdoe@…)") and a Transfer action.
2. Modal "Transfer ownership" states both consequences explicitly: "Transferring ownership of the SLMobbin team will give full control to Jane Doe & demote you to an admin role" plus an info line "Once completed, you'll be redirected to the homepage."
3. Type-to-confirm field: "Enter team name to confirm" with the full team name required.
4. Cancel + destructive-styled "Transfer ownership" button.
5. Transfer applies immediately (no acceptance step); the now-demoted user is redirected.

## Use when
Both parties are trusted/internal and the org needs the transfer to take effect now (offboarding, last-admin resolution); the typed org name forces attention to which org is affected.

## Avoid when
The recipient hasn't agreed to take on ownership (billing responsibility) — use nominate-and-accept; or for low-stakes role changes where typing the org name is disproportionate.

## Sad paths observed
Self-demotion and post-action redirect are disclosed before confirm, preventing the "where did my admin settings go" surprise. Wrong-name entry behavior not captured.

## Accessibility
Labeled text input states exactly what to type; destructive button presumably gated on exact match (button shown enabled-styled in capture; gating not directly observable).

## Default verdict for our stack
RECOMMENDED — immediate transfer + type-org-name + explicit "you will be demoted to admin" line; pair with a Better Auth session-freshness re-auth (see reauth-gate card) instead of relying on typing alone.
