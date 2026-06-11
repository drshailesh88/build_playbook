# Pattern: Social proof & host trust stack on the landing page

**Surface:** events-creation-landing · **Observed in:** Luma web (https://mobbin.com/screens/a02338c1-09a9-400f-a4a3-d9f52ea37820), Eventbrite web (https://mobbin.com/screens/f300cc9d-d6e2-4c31-b243-552ce10df057, https://mobbin.com/screens/f04a0505-3233-4c7e-8439-a615340ef9c9, https://mobbin.com/flows/44c56cc4-3423-49b8-ad0a-6f8addc5910d), Posh web (https://mobbin.com/flows/e82ee5c8-e973-4277-81e6-b864dedea635), Partiful web (https://mobbin.com/flows/a77ba687-facd-4f2d-a111-edee4c8ebcc3), Lex iOS (https://mobbin.com/flows/5df825b8-d319-4ab5-a480-d724ba8ab6f6)

## Flow
1. **Going-count + avatar stack:** "37 Going" with avatars and named anchors — "Elisha Tan, Ryan Teo and 35 others" (Luma); "Samantha and 5 others going" (Posh); appears from the very first RSVP ("1 queers are going", Lex).
2. **Host identity block:** "Hosted By" avatar list with multiple hosts (Luma); "Organized by" card with avatar, follower count ("2.9k followers"), Follow + Contact buttons (Eventbrite).
3. **Institutional umbrella:** "Presented by {Calendar}" with subscribe bell and blurb (Luma); organizer profile as a reusable entity — "Each profile describes a unique organizer and shows all of their events on one page. Having a complete profile can encourage attendees to follow you." (Eventbrite).
4. **Earned trust badges:** "Lots of repeat customers ✓" chip; "Featured in 2 collections"; "Just Added!" freshness badge (Eventbrite); "Featured in {City} ›" eyebrow (Luma).
5. **Guest list as browsable surface (consumer variant):** clicking a guest opens profile cards with RSVP history and shared-event overlap (Partiful).
6. Live counters double as host motivation: dock counter "2 Going" → "4 Going" updating in place (Partiful host view).

## Use when
Open-registration events where strangers decide to attend — proof of life is the #1 conversion lever after date/venue. Host/org identity matters in EVERY context (who runs this conference?).

## Avoid when
Attendee privacy regimes (medical conferences with confidential attendance) — going-counts and guest lists must be opt-in per event via visibility settings. Never show named avatars without consent. Skip browsable guest profiles for professional contexts.

## Sad paths observed
- Zero registrants: Lex proves the line works from N=1; better to hide the block below a threshold than show "0 going".
- Hidden guest list is a designed state: "Guest list hidden from the event page — Show Who's Coming" (Luma organizer control).

## Accessibility
Counts and names are text; avatar stacks are decorative with text equivalents; Follow/Contact are labeled buttons.

## Default verdict for our stack
RECOMMENDED (tenant-shaped) — old app's landing page has zero identity: no host, no org, nothing alive. V1: "Organized by {tenant org}" block with logo + contact; "X delegates registered" as an organizer-controlled visibility toggle. Faculty/speaker blocks (program module edge) are the conference equivalent of the avatar stack.
