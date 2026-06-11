# Pattern: Invite-funnel tracker (sent → opened → accepted/declined at a glance)

**Surface:** sessions-program / speaker-lifecycle · **Observed in:** Luma (refs: [Guests flow](https://mobbin.com/flows/a8601b45-a4de-450f-8026-8e0b4732872d))

## Flow
1. Event overview carries an Invites panel with funnel stats: "1 / 2 Invites Accepted", "2 Emails Opened", "0 Declined", plus a "Recently Accepted" name list.
2. Guests tab "At a Glance": count against capacity ("1 guest · cap 1,000") with a "1 Going · 1 Invited" breakdown on a progress bar.
3. Guest list table: searchable, filterable, sortable by register time; per-row name, email, status badge ("Going" green / "Invited" blue), relative date.

## Use when
The coordinator's question is "where are my invites stuck?" — funnel numbers answer it before they open the table.

## Avoid when
Single-digit invite counts on a page the coordinator already scans row-by-row — the funnel summary duplicates what's visible.

## Sad paths observed
- Empty state with the next action in it: "No Guests Yet — Share the event or invite people to get started!"

## Accessibility
Status badges are colored text + word, not color alone.

## Microcopy worth stealing
"Invites Accepted" · "Emails Opened" · "No Guests Yet — Share the event or invite people to get started!"

## Default verdict for our stack
RECOMMENDED — the old app has per-invite status rows but no funnel rollup; a 4-number strip (sent / opened / accepted / declined) above the faculty-invite list is cheap and answers the coordinator's real question. Open-tracking already exists in the invite FSM (`opened` state).
