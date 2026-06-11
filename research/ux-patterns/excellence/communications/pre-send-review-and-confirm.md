# Pattern: Pre-send review — summary, recipient-count confirm, safety buffer, post-send close
**Surface:** broadcast-compose · **Observed in:** AutoSend, Mailchimp, Eventbrite, GoDaddy, Shopify, Square, Wix (refs: [AutoSend confirm](https://mobbin.com/screens/34d2c4f5-0fa8-4789-946e-c343627cd5c4), [Mailchimp confirm](https://mobbin.com/screens/719b47ce-4325-4a12-b475-8d5fecc86fee), [Eventbrite confirm](https://mobbin.com/screens/c659ef6e-f76b-4dfc-8f07-34b10072b6e8), [Eventbrite scheduled](https://mobbin.com/screens/57fb1a1f-2b19-4be0-82e9-fc398344b64c), [Shopify review](https://mobbin.com/screens/a8bcea24-b445-4a74-84ad-3679df971102), [Square review](https://mobbin.com/screens/1ce7c729-82db-4fdb-b4be-e25580d2c0c1), [Wix post-send](https://mobbin.com/screens/b778c7a8-0471-432c-b25e-8cdf0d10576d), [Eventbrite post-send](https://mobbin.com/screens/6415fc02-fc12-4168-bb6a-32e712a55f7f))

## Flow
1. Review page/modal restates the send as key-value rows: Subject / Preview text / From / Reply-To / To (list+count) / Exclusions / Unsubscribe group (AutoSend "Review & confirm details"), or To/Subject/From above a desktop|mobile preview (Shopify).
2. Final confirm names the blast radius in numbers: "You're about to send your campaign to **4 active subscribers**" (Eventbrite), "You're about to send a campaign to: Acme Corp — 4 subscribers" (Mailchimp), "You will be sending to 1 unique email addresses" (GoDaddy schedule variant).
3. Scheduled sends confirm differently: "You're sending your campaign to 1 active subscriber **on March 5 at 10:00 AM**" (Eventbrite).
4. Safety buffer disclosed at confirm: "We'll have a 2-minute buffer before sending the campaign, just to play it safe" (AutoSend) — a built-in undo window.
5. Post-send closure screen: confetti + "The campaign has been added to the queue and will be sent out shortly" + where to track it + next-action cards (Eventbrite "Nice work!", Wix "Way to go", GoDaddy).

## Use when
Any send that fans out to more than one recipient — the count in the confirm is the difference between confidence and accidental mass-blasts.

## Avoid when
Single-recipient transactional resends with their own focused dialog — a campaign-grade review reads as bureaucracy.

## Sad paths observed
- Review step doubles as the validation gate: missing content blocks Send AND Schedule with named errors (Customer.io review, GoDaddy rail).
- Quota visible at confirm time: Eventbrite shows "Daily limit 4/250" beside the campaign — over-quota is discoverable before, not after.

## Accessibility
Confirm modals are true dialogs with two clearly-labeled buttons; counts are in the sentence, not only in a badge.

## Default verdict for our stack
RECOMMENDED — recipient-count confirm + 2-minute cancellable buffer directly mitigates our scar history (double-sends, accidental blasts); post-send screen should link to the delivery log.
