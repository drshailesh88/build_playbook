# Pattern: The share moment (post-create/publish success is a distribution screen)

**Surface:** events-creation-landing · **Observed in:** Luma iOS (https://mobbin.com/flows/08f11f1e-3068-45bd-9cb2-1c386f625901), Luma web (https://mobbin.com/flows/d83ae620-2181-4e0b-9621-a6bce23ccf17, https://mobbin.com/flows/1d427766-01b1-457b-b810-e4e606f9362a, https://mobbin.com/flows/589cf657-0963-4905-97b4-b715a91f27cb), Eventbrite web (https://mobbin.com/flows/49bae9fe-bcc3-4daf-91ea-5fc2c7b97de2), Partiful iOS (https://mobbin.com/flows/fa2023d7-38ef-4094-a6c6-dbe5518addf6), Posh web (https://mobbin.com/flows/2dbf6d84-2c78-4923-9019-b6a43647a55d)

## Flow
1. Create/publish success is never a dead end. Luma iOS: full-screen "Your Event is Created 🎉 — Personalize the event page, spread the word, and start welcoming guests on board!" with "Invite Guests" + "Share Event" buttons. Eventbrite: redirect to Marketing with "You published an event 🎉 Now, let's sell your first ticket!"
2. The manage hub leads with a distribution trio: "Invite Guests / Send a Blast / Share Event" action cards, and a mini live preview of the public page with the short URL ("lu.ma/bffi7c7z") + COPY overlay (Luma).
3. "Share This Event" modal: channel icon grid (Facebook / X / LinkedIn / Email / native / SMS) + "Share the link:" readonly input + Copy button flipping to "Copied!". Guest-side shares carry attribution tokens ("?tk=…").
4. Share artifacts beyond the URL: auto-generated designed flyer carousel with date+title baked in + QR code + Save/Messages/More ("Share Flyer — Post to socials or send with the link", Partiful); embeddable button/page widget with copy-paste HTML and a live working demo button (Luma); AI-captioned social post composer with platform preview and review disclaimer (Eventbrite, https://mobbin.com/flows/595fc812-4448-484b-aee7-4cf12a7760c0).
5. Distribution lives next to evidence it works: invite funnel stats "1/2 Invites Accepted · 2 Emails Opened · 0 Declined" (Luma); "Page Visits 16 → Conversions 25%" beside the link (Posh).

## Use when
Always — the moment after publish is peak organizer motivation; every observed excellence app spends it on distribution.

## Avoid when
Internal/private events where broadcast sharing is wrong — swap channels for scoped invite actions. Don't auto-post anywhere without explicit action.

## Sad paths observed
- Copy feedback always explicit ("Copied!" / toast "Event link copied to clipboard.").
- URL change after sharing kills old links — Luma warns: "When you choose a new URL, the current one will no longer work. Do not change your URL if you have already shared the event."

## Accessibility
Channel buttons have text labels; copy state change announced as text; QR paired with the plain URL.

## Default verdict for our stack
RECOMMENDED — V1: post-publish screen with public URL + copy + QR (medical conferences print posters; QR is native here) + email/WhatsApp share. The old app navigated to the workspace with no share affordance at all. Flyer generation and social composers are V2.
