# Pattern: Who-invited-you framing — inviter + org + product one-liner + single CTA
**Surface:** invite-email · **Observed in:** Linear, Clay, Jitter, GitHub, ClickUp, Pinterest (refs: [Linear](https://mobbin.com/screens/f2c717d4-6bb3-44c2-9605-9e32e813f18c), [Clay](https://mobbin.com/screens/c861efe0-7a55-4a5f-8286-f7c6589d0bcd), [Jitter](https://mobbin.com/screens/3b36a91c-c4b4-48b7-acb8-e2ac060a670f), [GitHub](https://mobbin.com/screens/d9f1f83e-95dd-4f1d-9230-1b057f2162ea), [ClickUp](https://mobbin.com/screens/771b2ba1-5347-45e3-be72-3b818fb39111), [Pinterest](https://mobbin.com/screens/7abdc468-bc34-4fb4-ac8f-4246833e0063))

> Coverage note: Mobbin does not capture inbox-rendered emails; these are the invite-acceptance landing pages the email CTA opens. Their content structure mirrors the email body (all reachable only from the email link) and is the strongest observable proxy.

## Flow
1. Org identity first: org avatar/initials block (Linear, Jitter, GitHub org icon).
2. Headline names the human inviter and the org: "samlee.mobbin@gmail.com has invited you to SLMobbin" (Linear); "@jsmith invited you to join their Workspace JMobbin 8 hours ago" (Clay); "Invited by Jane Doe" (GitHub).
3. One line of product context for invitees who don't know the app: "Linear helps your team streamline issues, sprints, and product roadmaps."
4. Single dominant CTA: "Accept invite" / "Join Mobmobdesign" / "Log in"; secondary decline/"No Thanks" kept visually quiet.
5. ClickUp's CTA restates the action: "Yes, join John Smith's Workspace" — no ambiguity about what the button does.

## Use when
- Always — trust in an invite email hinges on recognizing the inviter and the org; every reference uses person + org, never "You have a new invitation".

## Avoid when
- Don't substitute the platform brand for the org: the tenant (org) identity must lead; platform branding is the footer, not the headline.

## Sad paths observed
- Clay timestamps the invite ("8 hours ago") so stale invites are self-evident.
- GitHub includes a privacy disclosure ("Owners may be able to see: …") and "Opt out of future invitations from this organization" — anti-abuse affordance in the invite itself.

## Accessibility
- Single primary CTA as a real link/button; all content is text (no image-only email body observable).

## Default verdict for our stack
RECOMMENDED — email subject/body: "{Inviter name} invited you to {Org} on Event State", org-first branding, one-line product context, single Accept CTA.
