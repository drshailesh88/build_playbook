# Pattern: Organizer identity as a reusable entity (profile feeds the page's trust block)

**Surface:** events-creation-landing · **Observed in:** Eventbrite web (https://mobbin.com/flows/44c56cc4-3423-49b8-ad0a-6f8addc5910d, https://mobbin.com/screens/f04a0505-3233-4c7e-8439-a615340ef9c9), Luma web (https://mobbin.com/screens/a02338c1-09a9-400f-a4a3-d9f52ea37820), Partiful iOS (https://mobbin.com/flows/cb584971-4dc5-45bd-941e-3abe09447aeb), Posh web (https://mobbin.com/flows/2dbf6d84-2c78-4923-9019-b6a43647a55d)

## Flow
1. The organizer is an entity, not a string: "Organizer profiles — Each profile describes a unique organizer and shows all of their events on one page. Having a complete profile can encourage attendees to follow you." — square image ("This is the first image attendees will see…"), about text, all-events page (Eventbrite).
2. The profile feeds the landing page's "Organized by" card: avatar + name + follower count + Follow + Contact (Eventbrite); "Presented by {Calendar}" umbrella with subscribe bell above the host list (Luma).
3. Identity is chosen at create time: "Choose the calendar of the event. Creating an event in a calendar will allow its admins to manage it." (Luma iOS); personal vs org profiles with a switcher — "Switched to Party Planning" toast (Partiful).
4. Publish-time hook: "Adding a name will create an organizer profile after publishing, and this event will appear on the organizer's profile page." (Eventbrite).
5. Attendee-facing contact policy disclosed where entered: "Contact Email — Your email will be displayed to attendees." / "This phone number will not be shown to attendees unless they dispute a charge…" (Posh).

## Use when
Multi-tenant or multi-brand hosting — the org's public identity, its event portfolio, and its contact surface should exist once and be referenced by every event page.

## Avoid when
Single-org deployments where the brand is global chrome anyway. Don't add Follow mechanics without a notification system behind them.

## Sad paths observed
- Events created under the wrong identity: the create-time calendar/org picker with admin-consequence copy is the prevention.
- Contact-info leakage: disclosure-at-entry is the guard.

## Accessibility
Profile blocks are labeled links; Follow/Contact are buttons with text.

## Default verdict for our stack
RECOMMENDED (structural fit) — EventState's tenant org IS this entity (Better Auth organization = tenant, DEC-030). The steal: an org public profile (logo, about, contact policy) rendered as the landing page's "Organized by" block, with contact-visibility disclosures at entry. Follower mechanics AVOID for V1.
