# Pattern: Suppression management — reason-split lists with consequence copy
**Surface:** failure-ops / compliance · **Observed in:** AutoSend, HubSpot, Podia, Customer.io (refs: [AutoSend suppressions](https://mobbin.com/screens/d36ca2c2-346b-4aca-a931-9b33f309be17), [empty state](https://mobbin.com/screens/1f55aa39-6156-4d83-b11a-06465fafd18d), [HubSpot tools](https://mobbin.com/screens/86e027ff-64af-47d1-8ac1-c4fb8653e078), [Podia confirm](https://mobbin.com/screens/16af5d46-267b-4cd7-8491-ab9e39a81a8a))

## Flow
1. Suppressions split into tabs BY REASON: Global Unsubscribes / Group Unsubscribes / Reported Spam / Bounces / Invalid Emails (AutoSend).
2. Each tab opens with one sentence of consequence: "Contacts who have unsubscribed from all emails from you. Any future emails sent to them will not be delivered."
3. Rows are minimal — email + when — searchable by address, with checkbox selection.
4. Manual unsubscribe is a guarded action with consequence copy: "If you unsubscribe them, they will stop receiving broadcast and campaign emails from you until they resubscribe" — [Keep subscribed] [Unsubscribe-red] (Podia).
5. Adjacent ops tools live in one menu: "Create list of hard bounced contacts", "Import opt-out list", "Manage allowlisting", "View sending limits" (HubSpot).
6. Suppressed is a first-class delivery status in the log (AutoSend pill; Customer.io filter), distinct from Failed.

## Use when
Any system that sends marketing-ish broadcasts (newsletters, announcements) — suppression is a compliance floor; also when bounced addresses should stop consuming send quota.

## Avoid when
Purely operational/transactional messages (itineraries, certificates) may legitimately bypass marketing suppressions — conflating the two lists blocks critical mail.

## Sad paths observed
- Empty state is reassuring, not blank: "Great news! No one has unsubscribed from your emails yet. If they do, you'll see them here." (AutoSend).
- Suppressed-vs-Failed distinction prevents ops from "retrying" a person who opted out.

## Accessibility
Tabs + tables; destructive action confirmed with explicit consequence text and red labeled button.

## Default verdict for our stack
RECOMMENDED (scoped) — per-event/per-tenant suppression for broadcast-class sends with the transactional/operational class exempted by design; the old app had no unsubscribe story at all.
