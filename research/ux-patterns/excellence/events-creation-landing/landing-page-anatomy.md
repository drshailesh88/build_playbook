# Pattern: Conversion landing page anatomy (two-column, social proof above the fold, one state-swapping page)

**Surface:** events-creation-landing · **Observed in:** Luma web (https://mobbin.com/screens/a02338c1-09a9-400f-a4a3-d9f52ea37820, https://mobbin.com/screens/bb6dbae8-6030-4805-9ea2-51fab393a16f, https://mobbin.com/flows/48b7ea19-b9fb-4eee-a174-5d42ab1b67e8), Eventbrite web (https://mobbin.com/screens/1dde9727-11fc-4a1f-a20d-b238fad01a49, https://mobbin.com/screens/d9b43438-ab86-4c86-adf9-c3ed309f1651, https://mobbin.com/screens/50ebe5d6-11dc-48f3-b51d-d93c7281f4c2), Posh web (https://mobbin.com/flows/e82ee5c8-e973-4277-81e6-b864dedea635), Lex iOS (https://mobbin.com/flows/5df825b8-d319-4ab5-a480-d724ba8ab6f6)

## Flow
Canonical structure (Luma's two-column, collapses to one on mobile):
1. **Left rail (identity & proof):** square cover art · "Presented by {Calendar/Org}" with subscribe affordance · "Hosted By" avatar+name list · "37 Going" + avatar stack ("Elisha Tan, Ryan Teo and 35 others") · quiet footer "Contact the Host · Report Event".
2. **Right column (decision facts):** optional credibility eyebrow ("Featured in Singapore ›") · H1 title · date row with mini calendar-page icon + full text ("Wednesday, November 13 · 6:30 PM - 8:30 PM GMT+8") · venue row with pin + external arrow + city · registration card · "About Event" rich text · "Location" card with embedded map + address + arrival instructions.
3. Eventbrite adds: blurred-cover ambient page background; sticky right ticket card with urgency chip floating above ("📣 Ticket sales end soon"); "Agenda" day tabs (FRIDAY/SATURDAY/SUNDAY) with time rows; "Good to know" (duration chip "🕘 9 hours", "📱 Mobile eTicket"); expandable map with "How to get there" transport-mode icons.
4. ONE page serves every viewer via state swaps, never separate URLs: guest → registrant (card flips, countdown chip "Starting in 3h 59m" appears) → manager (inline banner "You are a manager of this event." + Manage button). Private events show a "Private Event" pill.
5. The page stays ALIVE between publish and event day: host "Posts" feed with Host badges + likes/comments (Luma); activity feed with system entries ("Sam (+1) updated their rsvp to Going 👍") (Partiful).
6. Minimum viable render proves the model: Lex ships cover + title + "Hosted by Sam" + "1 queers are going" + tear-off date block + address from 4 inputs.
7. Conference-shaped variants: Sana AI's editorial hero — date kicker, giant H1, venue line, two short paragraphs, then a "Speakers:" list (name, title, company) as THE social proof, with the registration form inline in the page flow (https://mobbin.com/screens/2e1f125d-238c-4770-94d0-bdff616ff172); Posh's sticky full-width RSVP pill at viewport bottom keeps the action available at any scroll depth (https://mobbin.com/screens/7840765d-4ad6-4a20-b3ac-f3b0076c2302); Product Hunt puts a share-icon row directly under the date and a "Virtual event" badge (https://mobbin.com/screens/5bd2c427-aae9-4dc9-bd0b-a798bd9618d8); Twitch community pages use anchor nav "About · Upcoming events · Past events · Organizers · Photos" (https://mobbin.com/screens/9a60ca6e-8d81-46c1-a870-a7ebb6404ed8).

## Use when
This IS the module's public deliverable. Two-column for desktop information density; the state-swap model whenever guests/registrants/managers hit the same URL.

## Avoid when
Don't add feed/posts for one-shot events with no community energy (empty feeds anti-sell). Don't put the org rail above decision facts on mobile — facts first when stacked.

## Sad paths observed
- See landing-sad-states.md (sold out, closed, cancelled, past/ended, finding-a-time, location withheld).
- Manager banner prevents the "is this live? am I seeing what guests see?" confusion.
- Coverage gap: no hour-by-hour agenda MODULE was observed on any landing page — closest are Eventbrite's day-tabbed agenda section, Sana AI's speakers list, and Luma's multi-session chooser; a full conference program block is a first-principles composition of these.

## Accessibility
Date icons decorative with full text adjacent; countdown is text; avatar stacks have name text; map supplements a text address; agenda tabs keyboard-reachable.

## Default verdict for our stack
RECOMMENDED — this is the never-built `publicPageSettings` surface. Old app renders name/description/dates/venue/capacity in plain cards: no cover, no host identity, no map, no agenda preview, no state-swapping. The Luma skeleton + Eventbrite's agenda/good-to-know blocks are the conference-shaped ceiling.
