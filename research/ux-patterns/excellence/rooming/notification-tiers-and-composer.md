# Pattern: Change-notification system — per-watcher tiers, delta-sentence feed, computed-audience composer
**Surface:** rooming · **Observed in:** Flighty, Air NZ, Qantas, Deel, Jira, 7shifts, Mailchimp, Kit, Outseta, HubSpot, Eventbrite
(refs: https://mobbin.com/flows/2f515440-2670-40a0-98e5-9b6ab0cc55a7 , https://mobbin.com/screens/118195ff-27e2-4fab-8ec4-741446a6e310 , https://mobbin.com/screens/e39db09c-30c9-4ee0-93f9-edf0bc5f6cf5 , https://mobbin.com/screens/bb464668-61b9-4621-ab2c-f0bf1cdb9faf ; raw: `_raw/by-app.md` §A4/A5/A19, `_raw/by-pattern.md` §P10/P27, `_raw/by-flow.md` §F36/F38)

## Flow
1. Severity tiers per watcher, named with one-line scopes: "None — No alerts please. I'll just view their flights in the app. / Just Landed / Basics — major disruptions… / Everything"; default + per-entity override ("Customize this per friend") (Flighty).
2. Change sentence formula — what changed, by how much, new value: "Your flight on Fri 31 Oct 2025 now leaves 10 minutes later at 11:20 AM."; every feed item carries its context chip + one-tap next action (Air NZ).
3. Delta-from-plan status surfaces: "Arrived 33m Early"; unknown-yet values rendered as "–" not hidden (Flighty/Qantas).
4. Feed hygiene: unread = dot + bold, "Mark all as read", "Only show unread", "You're all caught up!"; consequence-bearing bodies ("…to avoid delays in contract activation") (Deel/Jira).
5. Publish = the notification moment: "Schedule published … for [range]" entries; "Send update" on edits with participants (7shifts/Skiff).
6. Computed-audience composer with commit recap: To = filter with live count ("6 subscribers"), "Don't send to" exclusions (HubSpot), final gate "Prepare for Launch — You're about to send a broadcast to: [list] (0 subscribers)" surfacing even the zero-recipient trap (Outseta); Send disabled until checklist complete (Mailchimp).
7. Watch semantics for passive subscription: "Saved – we'll notify you if prices change." (Skyscanner §F38).

## Use when
Rooming changes fan out to delegates, hotels, and co-organizers at different severities; ops batches a change affecting many people.

## Avoid when
Notifying on draft-state churn — tie sends to publish boundaries (`assignment-grid-draft-publish.md`).

## Sad paths observed
Zero-recipient sends made visible; disruption alerts are an explicit tier ingredient; unpublished-drift between draft and what people last saw flagged.

## Accessibility
Tier names + scope sentences beat toggle matrices; feeds never color-only.

## Default verdict for our stack
RECOMMENDED — compose: Flighty tiers (hotel hears Everything; delegate hears Basics), Air NZ change-sentence as the template for rooming-change emails, and the Outseta "about to notify 42 delegates and 2 hotels" recap. The full cascade-reallocation composer has no single precedent — `first-principles-gaps.md` #5.
