# Pattern: Unified table with status badges (members + invited in one list)
**Surface:** members-list · **Observed in:** Linear, Vercel, Exa, Fibery (refs: [Linear invited rows](https://mobbin.com/screens/ae99a607-158a-4642-a69f-00c024381bd0), [Linear pending badge](https://mobbin.com/screens/04950ee4-ca75-46f1-bc96-96eacc14ae38), [Vercel "Invitation Sent" badge](https://mobbin.com/screens/2bc2dd79-8a1f-4223-b006-61d22aed073e), [Exa flow](https://mobbin.com/flows/2fb3b980-3b0a-43de-975c-d1a63454eff7))

## Flow
1. Members table includes not-yet-accepted invitees as ordinary rows.
2. State is signalled on the row: Linear renders role as "Admin (Invited)" / a "Pending" pill; Vercel appends an "Invitation Sent" badge to the name; Exa has a dedicated "Invitation Status" column with Accepted (green) / Pending (yellow) badges.
3. Invited rows show email only (no avatar/name yet) — visually distinguishable at a glance.
4. Row actions adapt: Exa shows a delete icon only on pending rows; accepted rows get the role dropdown.

## Use when
- Team sizes are small-to-medium and admins think "who has access?" as one question.
- You want a single source of truth — no risk of an admin missing pending invites parked in another tab.

## Avoid when
- Invite volume is high (bulk events staffing): pending rows pollute search/sort of actual members — use a separate tab (see pending-invites/pending-tab-on-members-page).
- Pending rows need rich invite-specific metadata (expiry, invited-by, resend history) that would bloat the shared column set.

## Sad paths observed
- Linear toast after batch invite: "3 invites sent — Invited members have been notified by email" confirms the rows' provenance.
- Exa's pending rows expose only delete (revoke) — prevents editing a role on someone who hasn't accepted under the old terms.

## Accessibility
- Status conveyed by text badges, not color alone (Exa "Pending"/"Accepted" labels) — safe for color-blind users.

## Default verdict for our stack
VIABLE — clean for small orgs, but our pending-invites surface (B9) carries expiry/resend/revoke metadata that fits better in a dedicated tab; use badges only if B9 lands as same-table.
