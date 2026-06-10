# Pattern: Request access with message-to-approver (in-shell)
**Surface:** no-access-gate · **Observed in:** Asana (refs: [Asana](https://mobbin.com/screens/92f8660a-4efb-48aa-a61f-35d3d45e3997))

## Flow
1. User opens a project they lack access to; the app shell (sidebar, nav) stays rendered — only the content pane is replaced.
2. Gate content: lock illustration + "To work in this project, you need to request access" + "The project's admins will be notified to review your request."
3. Optional free-text field "Message for approver (optional)" lets the requester add justification.
4. Primary "Request access" button; identity line below: "You're currently signed in as …@gmail.com."

## Use when
The user legitimately belongs to the org but lacks access to a sub-resource (project/event) — keeping the shell signals "you're in the right place, just not this room"; the message field raises approval rates when approvers don't know the requester.

## Avoid when
The user has no role in the org at all — rendering the org's shell (sidebar with project names) around the gate leaks tenant information; use the full-page gate instead.

## Sad paths observed
Notification routing is explicit ("admins will be notified"), pre-answering "what happens when I click this?"; pending/denied states not captured.

## Accessibility
The optional message textarea is explicitly labeled "(optional)"; one primary action; identity in plain text.

## Default verdict for our stack
VIABLE — right pattern for within-org restricted events later; for the org-level gate (C5 proper) the full-page version wins because our shell is org-scoped and must not render without a role.
