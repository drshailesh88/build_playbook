# Pattern: "Send Test" Button in Editor Header → Prefilled Modal
**Surface:** comms-sender-setup · **Observed in:** Eventbrite, Mailchimp, beehiiv, Customer.io, Front, Churnkey, HubSpot (refs: [Eventbrite test modal](https://mobbin.com/screens/8e67ae8e-d600-467a-965a-928724e4c4d8), [Mailchimp send-a-test](https://mobbin.com/screens/22ddae4d-c48b-4ee6-9b1b-ffcede295cc5), [beehiiv send-a-test](https://mobbin.com/screens/e7e43f26-31a2-45f6-bfd9-1a2e40790e1f), [Customer.io send test](https://mobbin.com/screens/3a5bafa0-9dc7-42b6-8728-a9adf7f3d09c), [Front sequence test](https://mobbin.com/screens/1462b1bf-8792-4f48-8904-dddce825cbfc), [Churnkey simulated send](https://mobbin.com/screens/ad734223-e92f-406e-8d73-0c91ff2fd2c8), [HubSpot send-test-email button](https://mobbin.com/screens/70bb4d38-df38-4511-aaaa-1a61fdd2f570))

## Flow
1. Placement: a persistent "Send test email" / "Send test…" button in the campaign/template editor's top bar (Eventbrite, Mailchimp, Customer.io, HubSpot) — Churnkey additionally puts a "Send Test Email" button inline beneath the content block it tests.
2. Click opens a small modal: recipient field PREFILLED with the current user's email; Mailchimp accepts comma-separated multiples, beehiiv shows a checkbox list of org members (up to 10).
3. The modal restates what will be sent — Eventbrite shows a subject+from preview card ("Subject: You're invited to… From: Jane"); Front warns "This email will use data from a sample recipient."
4. Test-marking and simulation options: Customer.io ships an "Add [TEST] to subject" checkbox; beehiiv's Advanced section adds a "Simulated Subscriber" whose data personalizes the test; Churnkey frames it as "receive a simulated payment recovery email."
5. Primary action stays verb-exact: "Send test email" / "Send Test" / "Send email" — never plain "OK".

## Use when
- Any per-event template or campaign editor we ship — test-send is the single most reused affordance across all comms reference apps; placement belongs in the editor header, not in settings.
- Personalization tokens exist — beehiiv's simulated-subscriber input is the observed answer to "test with real merge data".

## Avoid when
- Sender identity/domain is unverified and the test would silently use a rewritten address — Mailchimp instead warns inside the modal ("limitations of free From addresses … could stop you from getting your test email") rather than letting the test mislead.
- Allowing unlimited arbitrary recipients: beehiiv restricts tests to org emails (external requires support) to prevent test-send abuse as a free sending channel.

## Sad paths observed
- Mailchimp pre-empts "my test never arrived" with the free-From-address limitation note inside the modal.
- beehiiv's restriction copy ("If you need to send tests to emails outside of your organization, contact support") names the recovery path.
- Result feedback beyond modal close (delivery confirmation toast) was NOT observed in any captured screen — feedback evidence is a gap.

## Accessibility
- Modals are small, single-purpose, with one labelled input and explicit Cancel/Send buttons.
- Customer.io's [TEST] subject prefix is a recipient-side accessibility win — tests are distinguishable in the inbox without opening.

## Default verdict for our stack
RECOMMENDED — header-placed "Send test" with self-prefilled recipient, org-member-only recipients, [TEST] subject toggle, and an unverified-sender warning inside the modal.
