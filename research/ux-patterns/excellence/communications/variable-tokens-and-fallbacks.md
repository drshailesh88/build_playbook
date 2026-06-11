# Pattern: Variable insertion — token chips, autocomplete, and missing-value fallbacks
**Surface:** template-editor · **Observed in:** AutoSend, Posh, Customer.io, Mailchimp, Apollo, folk, Attio (refs: [AutoSend autocomplete](https://mobbin.com/screens/2368a4fe-0ee5-429a-b189-0db164804062), [Posh insert-field](https://mobbin.com/screens/7ee06c31-c10a-4888-8b53-4925d50904b9), [Customer.io merge tags](https://mobbin.com/screens/2f8eb1e5-ec79-4a97-acab-dc2c16ad64b5), [Mailchimp merge tag](https://mobbin.com/flows/23d57674-555e-4c47-9981-b50bca0dc76c), [Apollo fallbacks](https://mobbin.com/screens/7bb8cdcb-384f-417f-9739-e8b8600dc11a), [folk chips](https://mobbin.com/flows/0f633d24-030d-4ae3-823f-a1e734b6245c))

## Flow
1. Typing `{` opens a VARIABLES autocomplete listing only valid tokens ({{email}}, {{firstName}}, {{createdAt}}…) — invalid variables can't be typed in by accident (AutoSend).
2. Alternative affordances: explicit "[⊞ Insert Field]" button inserting a COLORED TOKEN CHIP inline (Posh, with confirmation toast "Inserted FIRST NAME field"); toolbar "Merge tags ▾" + "Special links ▾" menus (Customer.io); variable chips rendered as pills in the body (folk's ⟨Name⟩); "Insert variable / Use variable" on every action-config field (Attio).
3. Subject lines get the same treatment ("Add variable ▾" on subject — Cal.com, Apollo).
4. Missing-value policy is an explicit authoring choice: Apollo's fallback radios — "Mark as failed / Use email template / Ignore missing variables".
5. System-injected tokens are visible in the template body, not magic: footer shows `{{ "now" | date: "%Y" }}` and "The email was sent to {{customer.email}}… unsubscribe here" (Customer.io).

## Use when
Any template authoring surface — chips/autocomplete eliminate the typo class of render failures and teach the available data model in place.

## Avoid when
Never skip it where variables exist; only a fully static template surface can omit it.

## Sad paths observed
- Apollo forces authors to decide what happens when data is missing per template — failure mode chosen up front, not discovered in production.
- Token-chip rendering makes a half-deleted variable visually obvious vs. a broken `{{fir` in plain text.

## Accessibility
Autocomplete is keyboard-driven; chips remain text-readable tokens; insert buttons are labeled.

## Default verdict for our stack
RECOMMENDED — chips/autocomplete fed by `allowedVariablesJson` (already stored and validated server-side in the old app, UI never built) + an explicit missing-variable policy per template; pairs with our required-vars validation.
