# Pattern: Link landing addressed to a named recipient with "not you?" escape
**Surface:** tokened-access-landing · **Observed in:** Fresha (ref: https://mobbin.com/screens/78f4747e-1fc6-4a69-8903-473013a20cfe), Asana (ref: https://mobbin.com/screens/ee582543-9cf5-4d2e-801f-adba1028c325), Jitter (ref: https://mobbin.com/screens/8e377ce4-ec67-4894-8310-589e6b2a25bd), Google Classroom (ref: https://mobbin.com/screens/45531da0-3dd5-4981-97dc-fcd49094f5ec), Frame.io (ref: https://mobbin.com/screens/04cb2804-b240-4a19-b934-73f5617d08f1), Cake Equity (ref: https://mobbin.com/screens/08722f65-af1a-4222-a3df-4688dd93d495)

## Flow
1. Recipient opens invite/magic link; page greets them by name: "You're almost there Alex!" (Fresha), "Join your team — Jane invited you… Log in as jonsmith@…" (Jitter).
2. The acting identity is stated explicitly near the primary action: "You're joining as alexsmith@gmail.com" (Asana), "You're signed in as John Smith (jsmith@…)" (Google Classroom).
3. One primary action: Accept Invite / Join / Accept.
4. Identity escape adjacent in small text: "or use another account?" (Fresha), "Not the right account?" (Asana), "SWITCH ACCOUNT" (Google Classroom), "Change account" (Cake Equity), "Create my own account" (Frame.io).

## Use when
- Every tokened landing in our product: state plainly WHO the link is for ("This link is for Dr. A. Sharma — faculty, Cardiology Summit") before any action with side effects.
- Links delivered over email AND WhatsApp where forwarding is common — the named header is the cheapest defense against wrong-person actions.

## Avoid when
- Don't render full email/phone on links that may be screen-shared publicly — mask partially (j•••@gmail.com) when the page is more public than the inbox.
- Our externals have no accounts, so "switch account" becomes "Not Dr. Sharma? This link was sent to them personally — contact the organizer" rather than a login switcher.

## Sad paths observed
- Wrong identity is anticipated, not an error: escape link sits beside the CTA on every example.
- Cake Equity adds a second factor: invitation code from the email must be entered even while logged in — defense against forwarded sessions.

## Accessibility
- Identity statement is body text, not placeholder — readable by screen readers before the button in DOM order.
- Escape links are real links with descriptive text ("Not the right account?"), not icon-only.

## Default verdict for our stack
RECOMMENDED — non-negotiable convention for all five sub-areas: name the link holder, one primary action, adjacent "not you? contact organizer" escape (no login switcher since externals have no accounts).
