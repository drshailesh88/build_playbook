# Pattern: Template editor with real-person sample-data preview and content linting
**Surface:** template-editor · **Observed in:** Customer.io, Apollo, AutoSend, Shopify (refs: [Customer.io editor](https://mobbin.com/flows/effe83a3-f78b-4724-95c9-5a3a4944def3), [Customer.io code view](https://mobbin.com/screens/63076d49-befa-4854-8b4b-932ff5f086e8), [Apollo contact preview](https://mobbin.com/screens/161cf5d8-a3df-406d-a9aa-dd73b281bdec), [AutoSend editor](https://mobbin.com/screens/2368a4fe-0ee5-429a-b189-0db164804062))

## Flow
1. Persistent "Sample data" rail: search people by email / add filters, pick a real profile; the rail lists that person's actual attributes; the preview renders the template WITH that person's data (Customer.io). Apollo's lighter version: "Generate Preview for Contact (optional)" dropdown above the preview pane.
2. Editor and preview live side by side (visual editor, or split HTML-source | rendered for the code view) with a Refresh control and from/to header resolved for the sample person.
3. Inline validation in the header: "✓ No errors" pill flips to "⚠ Review Errors"; subject empty is flagged red at the field AND in review ("Subject can't be blank"); "Review Links" checks hrefs.
4. Under-preview lint tabs: Source / Problems (count + line numbers — "An lang attribute must be present on <html> elements. 2:6") / Links / Images / Accessibility (Customer.io).
5. Send-test and spam-check sit in the editor header (AutoSend SEND TEST + SPAM CHECK; see base-library card `comms-sender-setup/send-test-email-modal.md` for the test-send modal itself).
6. Desktop/Mobile preview toggle (AutoSend, Mailchimp, Shopify review).

## Use when
Templates contain variables — a preview with a REAL person's data catches blank-variable and broken-personalization bugs that lorem-ipsum previews structurally cannot.

## Avoid when
Static announcement with zero variables — a plain rendered preview suffices, though desktop/mobile toggle still pays.

## Sad paths observed
- Unresolvable variables become visible blanks/literals in the live preview before any send.
- Problems tab catches accessibility/HTML issues with line numbers at edit time (Customer.io).
- "You have unsaved changes" + Discard/Save footer guards navigation (Customer.io).

## Accessibility
The editor lints the EMAIL's accessibility (lang attribute, image alts) — accessibility as a content-quality gate, not just app chrome.

## Default verdict for our stack
RECOMMENDED — preview-with-sample-data over real event people (with PII-conscious selection) is the single highest-leverage editor feature; our M39 editor has none of it today.
