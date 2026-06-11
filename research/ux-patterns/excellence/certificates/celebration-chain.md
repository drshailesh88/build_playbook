# Pattern: Celebration moment chained to share + next action

**Surface:** certificates / recipient-receive · **Observed in:** Coursera, Fiverr Learn, Codecademy, Replit (refs: https://mobbin.com/flows/d96738cf-f47a-494c-88b1-57402164db45, https://mobbin.com/screens/eeb9e354-0908-449c-a054-24cf2b04ed58, https://mobbin.com/flows/943886cb-68e4-4bba-84df-f6926b0bebd9, https://mobbin.com/flows/bbe22c41-e24b-43b3-a146-4de331ec14a1)

## Flow
1. The credential arrives as a MOMENT, not a row: "Congratulations on completing this course!" banner (Coursera); modal "You've Just Completed… Congrats On Earning Your New Badge." (Fiverr).
2. Share affordances ride the high: social icons inline in the congrats surface (Fiverr); prefilled post (Replit).
3. A next action is chained immediately: "Next course in Google UX Design — Get started" + degree-credit upsell (Coursera); feedback capture (Codecademy survey, Uxcel "Rate this course") rides the same moment.

## Use when
Recipient-facing certificate delivery — for EventState: the "your certificate is ready" landing should congratulate, offer share, and chain ONE next step (e.g., "Register for GEM 2027" / feedback survey).

## Avoid when
Admin-side surfaces — coordinators issuing 300 certificates do not need confetti; and don't stack more than one upsell on the moment (Coursera chains three asks; pick one).

## Sad paths observed
- None in-flow; failure mode is celebration without the artifact ready (see claim-ceremony's honest "Generating…" state).

## Accessibility
Celebration modals must be dismissible and not trap focus; toasts announced.

## Default verdict for our stack
VIABLE — never attempted in legacy (notification email links to a download). Boundary: the landing surface is module external-links (DEC-062); certificates supplies the moment's content (share card, feedback hook).
