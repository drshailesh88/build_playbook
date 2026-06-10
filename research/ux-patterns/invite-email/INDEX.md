# INDEX — invite-email (B6)

## Coverage — read this first
- Queries run — by-pattern: "invitation email you've been invited to join team workspace email message CTA accept invite", "branded transactional email invitation accept button organization logo expires"; by-flow: "accepting a team invitation from email notification". By-app email queries were folded into these (app-named email queries return app UI, not emails). Platform: web only.
- HONEST GAP: Mobbin effectively does not archive inbox-rendered transactional emails. Two consecutive email-targeted queries returned zero invite-email bodies for invitee recipients. The ONLY true email capture is Superhuman's inviter-side "Team invite sent!" email (rendered inside Superhuman's own client).
- What was harvested instead: the invite-acceptance LANDING pages (Linear, Clay, GitHub, Sketch, Plane, Attio, Pinterest, ClickUp, Jitter, Otter, Todoist, Glide, Loops) — every one is reachable only from the invite email, so their content (inviter framing, expiry, role, disclosure, CTA) is treated as the observable contract of the email itself. Cards below are explicit about this proxy.
- Apps swept: Linear, Clay, Jitter, ClickUp, GitHub, Pinterest, Sketch, Attio, Plane, Otter.ai, Todoist, Glide, Loops, Superhuman, 1Password, Airwallex, Dub, Slack.
- NOT found: actual HTML email templates with org branding for any reference app; no expiry countdowns in email bodies; nothing from Raycast/Stripe/Vercel on this surface.

## Patterns
- ★ who-invited-you-framing — inviter name + org-first identity + product one-liner + single CTA (Linear, Clay, Jitter, GitHub, ClickUp, Pinterest)
- ★ expiry-statement — invitation lifetime stated in words, echoed at compose and pending list (Clay, Dub, 1Password, Slack)
- ★ email-binding-wrong-account-path — "log in as X" binding + request-with-different-email escape (Linear, Sketch, Todoist, Glide)
- accept-decline-with-disclosure — subordinate decline + what-admins-can-see disclosure + role shown pre-accept (GitHub, Pinterest, Attio, Plane, Loops, Otter)
- inviter-side-notifications — invite-sent email to inviter, acceptance notifications, lifecycle tracker (Superhuman, 1Password, Airwallex)

★ = recommended defaults — together they specify the email: subject "{Inviter} invited you to {Org} on Event State", body = org identity, inviter, role, product one-liner, single Accept CTA, expiry date; CTA lands on a binding-aware accept page with decline.
