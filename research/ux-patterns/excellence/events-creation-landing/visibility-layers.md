# Pattern: Visibility as independent layers (discovery · link access · content gating · password)

**Surface:** events-creation-landing · **Observed in:** Posh web (https://mobbin.com/flows/ac5551d6-eec4-4cd0-81f8-57bcc3d7d0d9, https://mobbin.com/screens/750bfd6e-a317-4830-a40c-dc37ef81f3d1), Partiful web (https://mobbin.com/flows/0a82fa08-7f5d-48f1-b27d-d7e3205afe2b), Luma web (https://mobbin.com/flows/05561321-93a6-4d22-afb4-6b93137dac47, https://mobbin.com/flows/589cf657-0963-4905-97b4-b715a91f27cb), Circle web (https://mobbin.com/flows/77976c15-e6dc-41ef-a995-c0952a56c968), Cal.com web (https://mobbin.com/flows/cef86b70-66eb-4de7-a2c1-93a8f16d06b2), Vimeo web (https://mobbin.com/flows/9e8dfb58-472c-417b-a1e2-783588a5612a)

## Flow
1. Excellence apps decompose "public/private" into independent labeled layers:
   - **Discovery**: "Show on Explore" toggle — off = unlisted-but-linkable (Posh); Circle's granular "Hide from featured areas".
   - **Link access**: visibility dropdown at creation ("Public ⌄ / Private") with a "Private Event" pill rendered on the page (Luma); "Password Protected Event" toggle with inline password field (Posh).
   - **Audience broadcast**: Partiful's "Open Invite" dial replaces public/private with WHO: "All Hosts' Mutuals / Select Mutuals / Turned Off — Only people with the link have access".
   - **Content gating**: basics public, social layer gated — "RSVP to see location", "Only RSVP'd guests can view event activity & see who's going" (Partiful); "Guest list hidden from the event page — Show Who's Coming" inline control (Luma); "Hide attendees / Disable RSVP / Hide meta info" toggles + SEO meta title (Circle).
2. Hidden ≠ deleted: Cal.com's toggle-off renders a grey "Hidden" badge; the row stays manageable and the link copyable.
3. Interaction effects are warned at the moment of change: "When link privacy is set to Private, the embedded event won't be visible to everyone." (Vimeo).
4. Facts about exposure are stated where data is entered: "The address is shown publicly on the event page." (Luma).

## Use when
Events range from open-public to invite-only (medical conferences: member-only, sponsored, CME-gated). Any time "unlisted" is a real need distinct from "private".

## Avoid when
A two-state model truly covers the product — extra dials unused are confusion. Never use content-gating as dark-pattern data capture for professional audiences.

## Sad paths observed
- No app surfaced a dedicated "unlist a live event" flow — assembled from toggles; a purpose-built unlist remains unobserved (coverage-honest gap).
- Withheld location renders as a designed state ("Location Unavailable" chip / "RSVP to see location"), never a blank.

## Accessibility
Layer toggles carry full-sentence descriptions; the "Private Event" pill is text on the page, not just an icon.

## Default verdict for our stack
RECOMMENDED (two layers for V1) — published events need at minimum: listed vs unlisted-by-slug, and per-section landing visibility (guest list / capacity / program preview) as part of `publicPageSettings`. Password gates and audience dials are V2.
