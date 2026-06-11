# Pattern: Composable landing-page sad states (the page never stops working)

**Surface:** events-creation-landing · **Observed in:** Luma web (https://mobbin.com/screens/b330d0a0-e5d2-4eb8-885b-8f48c83311e9, https://mobbin.com/screens/7dbb0d17-e56b-4ed2-8e02-74caafbde1bc, https://mobbin.com/screens/a5560ae7-54e4-4913-b0a6-38ad869bfb3d), Posh web (https://mobbin.com/flows/e82ee5c8-e973-4277-81e6-b864dedea635), Partiful web (https://mobbin.com/screens/54d65d1e-5de8-4ee7-99b1-d17893e1e90b), Cal.com web (https://mobbin.com/screens/ae2c874a-98e8-4b13-ad9c-9f474a308037), Discord web (https://mobbin.com/screens/af86f40b-3343-4fb3-ad15-33f973aa151a)

## Flow
States are COMPOSABLE banners/swaps on the same card — never separate pages:
1. **Scarcity:** "⏳ Limited Spots Remaining — Hurry up and register before the event fills up!" banner stacked on the registration card; list chips "Near Capacity", red "Sold Out" visible BEFORE click-through (Luma).
2. **Approval-gated:** "Approval Required — Your registration is subject to approval by the host." + CTA swaps to "Apply to Join" (Luma).
3. **Sales closed, page alive:** CTA replaced by grey pill "Ticket sales are closed for this event" while the page keeps selling the future — avatars ("Samantha and 5 others going"), upcoming series dates, content, referral banner (Posh). The landing page never stops converting.
4. **Date not set:** "Finding a Time… The host will pick one when they're ready!" with candidate date chips + RESPOND button — a legitimate intermediate state instead of a broken TBD page (Partiful).
5. **Cancelled:** the shared URL resolves to an honest tombstone — "This event is canceled" + reason + struck-through date + surviving fact sheet (Cal.com); per-occurrence "Canceled" tag inside a living series page (Discord).
6. **Past/ended:** grey "ENDED" pill next to the title with the original date, page retained, organizer block keeps "Follow" and "Contact" CTAs (Eventbrite, https://mobbin.com/screens/6870b925-45a9-4663-9e42-2c272c403580); X swaps the CTA for "▶ Play recording" (https://mobbin.com/screens/c3fbe3a2-bb2b-43ca-95b0-00e273dca849); Twitch community pages keep a "Past events · Photos" archive in the anchor nav (https://mobbin.com/screens/9a60ca6e-8d81-46c1-a870-a7ebb6404ed8). The dead page still converts — into a follow, a replay, or an archive visit.
7. **Registration withdrawn:** card flips to "You're Not Going — We hope to see you next time! Changed your mind? You can register again." — fully recoverable (Luma).
8. **Location withheld:** "Location Unavailable" chip / "RSVP to see location" (Luma/Partiful).

## Use when
Every public event page. Design the full state matrix up front: {draft-preview, open, near-capacity, approval, sold-out+waitlist, closed, in-progress, past, cancelled, date-TBD} × {visitor, registrant, manager}.

## Avoid when
Scarcity banners ("Hurry up!") read as dark-pattern pressure for professional/medical audiences — keep the state, soften the copy ("Few seats remaining"). Don't use Partiful's date-poll for formal conferences.

## Sad paths observed
This card IS the sad-path inventory. Remaining coverage gaps after all three sweeps: no big-numeral countdown module pre-registration (only relative-time chips like "Starts in 3 days"), and no date-changed banner on the landing page itself (reschedule notices observed only as organizer-side email gates — see cancel-event-protocol.md §6).

## Accessibility
State chips are text (not color-only); strikethrough always paired with explicit text; banners precede the CTA in DOM order.

## Default verdict for our stack
RECOMMENDED — old app has exactly ONE non-open state ("Registration is currently closed", undifferentiated for draft/completed/cancelled/full). The state matrix above, with toned-down copy, is the single highest-leverage upgrade to the public surface. For conferences, the ENDED state's afterlife content is program archive + certificates link (our equivalent of "Play recording").
