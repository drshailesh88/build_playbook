# Pattern: Tri-state RSVP modal with inline identity capture (no account)
**Surface:** tokened-access-landing · **Observed in:** Partiful (refs: https://mobbin.com/screens/a29986cf-f78b-4fb9-a8a8-466acba9f71e, https://mobbin.com/screens/91746e73-56d2-4103-9fea-3a931e5dd60b, https://mobbin.com/flows/746c6688-1714-4ca0-8e30-01311aaf2ec5)

## Flow
1. Public/open-invite event page shows three big emoji response chips: "I'm Going / Maybe / Can't Go".
2. Tapping one opens a modal with the chosen state highlighted (switchable in place).
3. Inline fields: Your Name, Phone Number with reassurance microcopy "Just for event updates. No spam.", attendee count (+1s).
4. Optional comment + GIF before submitting; Cancel / Continue.
5. Host-configured questionnaire and COVID/safety acknowledgement ("Accept & Continue") can be injected as extra modal steps before completion.

## Use when
- Open or forwardable links where the responder's identity is NOT known from the token, so minimal contact capture must ride along with the response.
- Social events where "Maybe" is an acceptable answer and you want comments/energy.

## Avoid when
- B2B faculty confirmation — identity is already in the token; re-asking name/phone is friction and invites mismatched data.
- "Maybe" is not actionable for operations (catering counts, session assignments) — offer binary accept/decline plus a "propose change" path instead.

## Sad paths observed
- Spots counter ("10/10 spots left → 8/10") shown live on the page — implies a full-event state exists upstream.
- Switching response later: returning users see their current state on the page and can reopen the modal to change it.

## Accessibility
- Emoji-only chips carry text labels underneath ("I'm Going") — keep both; emoji alone is not accessible.
- Modal stacking (questionnaire → safety → confirm) needs focus trapping per step.

## Default verdict for our stack
VIABLE — good for open delegate RSVP pages without personal tokens; for tokened faculty links prefer the named-invite panel (identity pre-resolved) and skip re-collection.
