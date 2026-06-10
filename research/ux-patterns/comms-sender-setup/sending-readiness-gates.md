# Pattern: Sending Readiness Gates (shared-default banners, review holds, upgrade walls)
**Surface:** comms-sender-setup · **Observed in:** Customer.io, Intercom, GoDaddy, HubSpot, Maze, Loops (refs: [Customer.io review banner + sending domains](https://mobbin.com/screens/5535ba2e-002b-4a9e-b844-5b177a958b0e), [Customer.io shared IP pool](https://mobbin.com/screens/2daae461-0deb-4083-a5c9-f1f62acfefc3), [Intercom default sender choice](https://mobbin.com/screens/5c84d386-0575-4e30-b8b7-921353b71eb0), [GoDaddy rewrite warning](https://mobbin.com/screens/46e19324-ac50-4d7c-b7be-ee372a9d99c6), [HubSpot rewrite note](https://mobbin.com/screens/70bb4d38-df38-4511-aaaa-1a61fdd2f570), [Maze upgrade gate](https://mobbin.com/flows/61e2ed87-96a8-4419-b287-5bcca6ba0f9a), [Loops skippable setup](https://mobbin.com/screens/47f1732c-e739-40a5-bc28-f3c0031b8519))

## Flow
1. Account-review hold as a persistent top banner: Customer.io pins "We're currently reviewing your account information. In the meantime, keep exploring and we'll let you know when you can start sending." across ALL settings pages — sending is gated, exploring is not.
2. Shared-vs-own-domain is an explicit CHOICE, not a hidden default: Intercom renders two selectable cards — "Use your domain and email address (Recommended)" vs "Use temporary Intercom email address … Only recommended for temporary or trial usage" — with the degraded option labeled as such.
3. When sending proceeds on shared/rewritten infrastructure, the rewrite is disclosed at the field: GoDaddy ("will be sent from …@bounces.cloud.em.secureserver.net, due to your provider's restrictions"), HubSpot ("we'll change your from address to …@hubspotemail.net").
4. Shared infrastructure is named even AFTER verification: Customer.io's verified domain shows "Shared IP Pool - Default — Enabled … Reach out to our deliverability team to send emails through a dedicated IP."
5. Custom domain as a plan gate: Maze's "Add custom email domains" carries an ENT lock icon; attempting it opens "Upgrade needed — Sending campaigns from your domain can help build trust" with an Explore plans CTA and a mock "Sent from Jane@YourCompany.com ✓" visual.
6. Deliverability setup is offered as a skippable onboarding step: Loops' "Improve deliverability — Ensure your emails hit the inbox" wizard step has a "Set up later" link; the records table remains reachable afterwards.

## Use when
- Tenants can send SOMETHING before domain verification (our likely shared-domain default): always pair the capability with a named degraded state ("sending from events-mail.eventstate.com until yourdomain.com is verified") — every observed app discloses, none silently degrade.
- Compliance/review holds exist — the Customer.io banner shape (explain + promise notification + don't block exploration) is the observed standard.

## Avoid when
- Blocking the whole product UI behind verification — no observed app does this; gates scope to the SEND action only.
- Hiding the shared default entirely: undisclosed rewrites destroy trust when recipients see a strange from-address.

## Sad paths observed
- Customer.io trial: domains list shows three Unverified domains with per-domain "Verify Domain" CTAs while the global review banner explains why sending is off anyway — two independent gates visible at once without contradiction.
- Maze: the gate fires on ATTEMPT (clicking Add), not by hiding the section — discoverability of the paid capability is preserved.

## Accessibility
- Banners are persistent text regions at a fixed location, not transient toasts — re-readable by assistive tech.
- Intercom's choice cards carry full sentences describing consequences; selection state is shown with a checkmark plus border, not color alone.

## Default verdict for our stack
RECOMMENDED — three-part readiness model: (1) persistent banner naming the current sending state, (2) Intercom-style explicit shared-vs-custom choice at setup, (3) field-level rewrite disclosure wherever a from-address will differ from what the user typed.
