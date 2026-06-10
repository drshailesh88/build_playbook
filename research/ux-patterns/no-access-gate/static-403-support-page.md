# Pattern: Static 403 page with support link
**Surface:** no-access-gate · **Observed in:** Udemy (refs: [Udemy](https://mobbin.com/screens/bc53aef5-5697-43e8-8de9-21b60197b3ef))

## Flow
1. Unauthorized request renders a bare page: illustration + "You don't have permission to access this page".
2. Single recourse: "Visit our support page for further assistance."

## Use when
Truly terminal denials with no self-serve resolution (banned account, geo/legal restriction) where any richer affordance would be false hope.

## Avoid when
Any approver or alternate identity could resolve the situation — this page strands recoverable users: no identity context, no switch-account, no request-access, no navigation back.

## Sad paths observed
None handled — the page is itself an unhandled sad path with a support-ticket exit only.

## Accessibility
Heading + one inline link; trivially navigable, but the illustration carries no alt-observable meaning.

## Default verdict for our stack
AVOID — fails every C5 requirement (no switch org, no sign out, no request access); documented as the floor we must stay above.
