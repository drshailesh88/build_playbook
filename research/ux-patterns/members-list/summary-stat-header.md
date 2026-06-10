# Pattern: Summary stat header above the members table
**Surface:** members-list · **Observed in:** Coda, Miro, Notion, 1Password (refs: [Coda flow](https://mobbin.com/flows/7e68441c-3c40-4431-b4be-5b67cecabc3e), [Miro](https://mobbin.com/screens/faace447-f5cd-4c6e-96db-c1f5a953e179), [Notion seats](https://mobbin.com/screens/c77d2a3a-7556-4f27-857a-3e7960411086), [1Password dashboard](https://mobbin.com/flows/18b64277-b032-44f9-85ef-9af58f24081f))

## Flow
1. Above the members table, a row of stat cards summarizes composition: Coda "3 Members / 1 Admin / 2 Doc Makers / 1 Editor"; Miro "Access requests 1 / Full Members 2/2 / Guests 1" with license allocation; Notion "Paid seats 2 / Current members 2 / Next billing period"; 1Password "4 Team members / 0 Suspended / 1 Guest".
2. Cards double as drill-downs (Miro "View requests" link; 1Password links into People/Invitations).
3. Table below stays the operational surface; cards answer "are we at our seat limit?" before any scrolling.

## Use when
- Role mix and seat/billing limits matter (per-seat pricing, license caps, guest quotas).
- 100+ members where counts can't be eyeballed from the list.

## Avoid when
- No seat economics and few roles — cards become decoration and push the table below the fold.

## Sad paths observed
- Miro surfaces "2/2 licenses allocated" + a dismissible permissions banner — at-capacity state is visible before an invite fails.
- Mural shows a red banner "There are unpaid members in your workspace... Exceeded by 1 member" above the users table ([ref](https://mobbin.com/screens/8838fac5-7c90-4088-a1f9-7c3f8ea920e7)).

## Accessibility
- Counts are plain text with labels; no observable issues. Drill-down links are real links.

## Default verdict for our stack
VIABLE — adopt a slim version (Members / Pending / per-role counts) only once Event State has seat-based billing or role quotas; skip at MVP.
