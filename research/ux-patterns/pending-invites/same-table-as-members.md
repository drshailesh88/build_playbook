# Pattern: Pending invites as badged rows in the members table (no separate tab)
**Surface:** pending-invites · **Observed in:** Linear, Exa, Fibery, Visitors (refs: [Linear](https://mobbin.com/screens/ae99a607-158a-4642-a69f-00c024381bd0), [Linear pending pill](https://mobbin.com/screens/04950ee4-ca75-46f1-bc96-96eacc14ae38), [Exa flow](https://mobbin.com/flows/2fb3b980-3b0a-43de-975c-d1a63454eff7), [Fibery flow](https://mobbin.com/flows/8fafe082-2716-4c06-a7e1-937aba52bb4d), [Visitors flow](https://mobbin.com/flows/384e0f66-ca2f-4149-bae9-a4ae5b3d8468))

## Flow
1. Invited users appear in the members table the moment the invite is sent: Linear rows read "Admin (Invited)"; Exa adds an "Invitation Status" column (Accepted / Pending badges); Visitors groups rows under an "Invited" section header beneath "Owner".
2. Row content is email-only until acceptance; metadata columns (Joined, Last seen) stay empty.
3. Actions are reduced on pending rows: Exa shows only a delete (revoke) icon; Visitors' dropdown offers only Remove.
4. On acceptance the row "fills in" — same row, richer data; no cross-tab move to notice.

## Use when
- Small orgs where "who has access" should be one glance — the access list is literally complete.
- The invite carries the final role already (Linear's "(Invited)" suffixes the granted role).

## Avoid when
- You need expiry dates, invited-by, resend history — those columns don't fit a shared schema (none of the same-table apps display expiry inline).
- High invite volume: pending rows pollute sort/search of real members.

## Sad paths observed
- No resend affordance observed in any same-table implementation — a real capability gap of this pattern (revoke-and-reinvite is the only recovery).

## Accessibility
- Status text badges ("Pending", "(Invited)") not color-only; section grouping (Visitors) gives screen readers structure.

## Default verdict for our stack
VIABLE — acceptable fallback if we cut the tab, but it can't carry expiry/resend per our B9 requirements; the tab pattern wins.
