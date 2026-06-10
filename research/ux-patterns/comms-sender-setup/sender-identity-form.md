# Pattern: Sender Identity Form + Senders Roster (from-name / from-address / reply-to)
**Surface:** comms-sender-setup · **Observed in:** AutoSend, Pipedrive, HubSpot, Wix, GoDaddy, folk (refs: [AutoSend senders table](https://mobbin.com/screens/3b583957-d564-40ed-ad57-39bd46bed24f), [Pipedrive sender modal](https://mobbin.com/screens/c6566fa4-6c40-43ea-a4f2-c34916aeef64), [HubSpot email settings](https://mobbin.com/screens/70bb4d38-df38-4511-aaaa-1a61fdd2f570), [Wix add sender](https://mobbin.com/screens/1269036a-cd62-46d1-90f8-45806ceb0afe), [GoDaddy sender details](https://mobbin.com/screens/46e19324-ac50-4d7c-b7be-ee372a9d99c6), [folk senders page](https://mobbin.com/screens/8ba46458-4a2e-4f09-b13f-202ddc4729dc))

## Flow
1. Tenant-level "Senders" page lists saved identities in a table — AutoSend columns: Sender name · From email · Reply-to · Actions, with an "Add Sender" primary button and definition copy ("A sender represents the email address with authorized domain to send emails on your behalf… not spoofed").
2. Creating a sender is a small modal: Sender name, Sender email, Reply-to (optional) — Pipedrive adds a sharing acknowledgment checkbox ("I understand that all users who are sending campaigns can use this sender email") because senders are tenant-shared assets.
3. At campaign time the identity is a PICKER, not free text: HubSpot's "From name" and "From address" are dropdowns over saved identities, with "Use this as my reply-to address" as a checkbox shortcut.
4. folk groups senders UNDER their domain ("1 custom domain → content-mobbin.com [Unverified] → Sam Lee [Unverified]"), tying identity status to domain status visually.
5. GoDaddy includes compliance fields in the same form (physical address, timezone) — sender identity doubles as the CAN-SPAM record.

## Use when
- Building the tenant-level sending identity the legacy app lacks: a senders roster owned by the org, consumed by per-event pickers (the per-event display name becomes an override on top of a roster entry).
- Multiple events/users share identities — the roster + acknowledgment checkbox (Pipedrive) prevents accidental identity sprawl.

## Avoid when
- Free-typed from-addresses at send time — every observed app constrains the address to verified senders/domains; free text reintroduces spoofing and bounce risk.
- Reply-to is forced required: every observed app marks it optional.

## Sad paths observed
- GoDaddy: yellow inline warning that campaigns "will be sent from alexsmith.mobbin+1.gmail.com@bounces.cloud.em.secureserver.net, due to your provider's restrictions" — unverified/free-mail senders get a visible address rewrite notice, not silent degradation.
- HubSpot: "To make sure your email is delivered, we'll change your from address to …@hubspotemail.net" under the From address field — same rewrite disclosure, placed at point of use.
- folk: "Unverified" chips on both the domain and each sender row, with the Verify domain CTA inline.

## Accessibility
- Plain labelled form fields and tables throughout; required fields marked with asterisks (GoDaddy, Pipedrive).
- Warnings are text blocks adjacent to the field they affect, not toasts — persist for screen readers.

## Default verdict for our stack
RECOMMENDED — org-level senders roster (name/from/reply-to) with status chips, consumed by per-event from-name pickers; it converts our legacy per-event display name into an override of a governed tenant asset.
