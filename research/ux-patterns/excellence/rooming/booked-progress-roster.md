# Pattern: Booked-progress roster ("N/M booked", per-person service status, gap list, reminders)
**Surface:** rooming · **Observed in:** Navan, TravelPerk, KAYAK for Business
(refs: https://mobbin.com/flows/1a36de0c-77a1-4014-8df7-e24330d95f22 , https://mobbin.com/screens/878d11cb-1955-424d-b832-1e0c66cbb85a , https://mobbin.com/flows/2e2fe01b-2540-40d7-a35c-60bb6a4013e9 , https://mobbin.com/screens/896cdeda-685c-41b5-83df-d5e070f64d07 ; raw: `_raw/by-app.md` §A9/A17/A22, `_raw/by-flow.md` §F22)

## Flow
1. Event row carries completion fraction + countdown: "0/3 booked [progress bar] · In 98 days · $0 actual / $3,714 estimated" (Navan group travel).
2. Roster table per participant: per-service columns (Flight / Hotel / Car) holding "Allowed / Not allowed" entitlements, status cell ("• Invited", "Not invited yet", "DRAFTS"), per-row actions (link, edit, email, duplicate, delete) (Navan guest travel).
3. RSVP-bucket tabs with counts: "Attending 2 / Invited 0 / Not attending 0"; per-row per-service booked icons; "Download csv" + "Send message" (TravelPerk Events).
4. One-click gap list: "Who's missing?" link on the adoption card (Navan admin).
5. Bulk nudge/revoke on selection: "Invites selected (1) — [Send a reminder] [Revoke invites]"; toast "Successfully resent invite email." (Navan).
6. Bulk-add at scale: paste-emails modal "0 / 500 added", per-person permissions checkboxes, "Adding participants, it might take a minute or two" (Navan).

## Use when
Ops tracks hundreds of delegates toward "everyone roomed/confirmed" with a deadline; identifying and nudging the unroomed tail.

## Avoid when
Single-digit rosters — a plain list already answers "who's missing".

## Sad paths observed
"Not invited yet" / "DRAFTS" (booked-nothing) states; invitation expiry ("Expires in 30 days"); out-of-policy as a permanent tab; 500-participant cap stated.

## Accessibility
Progress fraction as text + bar; status dots paired with words.

## Default verdict for our stack
RECOMMENDED — the module header becomes "Roomed 38/120 · cutoff in 12 days · Who's missing?" with a roster whose rows read avatar + assignment status + nights + flags. This is the closest end-to-end analog Mobbin has to conference rooming ops.
