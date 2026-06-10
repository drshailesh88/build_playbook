# Pattern: Re-confirm/change response via the same personal link (prior state shown struck-through)
**Surface:** tokened-access-landing · **Observed in:** Calendly (refs: https://mobbin.com/screens/6209330e-b33d-403d-8794-65e775246395, https://mobbin.com/screens/cd050934-0a00-43a9-a804-cc7ff82c7ce7, https://mobbin.com/screens/305e4110-0d7a-4d20-823d-84fa34d66511), Partiful (ref: https://mobbin.com/screens/de5315ea-9bf1-44ed-9af1-fe46d214fef2)

## Flow
1. Invitee re-opens the personal link from the original email after something changed.
2. Left panel shows the meeting summary with "Former Time (John): ~~1:00pm Monday, August 5~~" struck through — the old commitment stays visible while choosing the new one.
3. User picks new option (date/time grid), then "Enter Details" step pre-fills their email and adds a free-text "Reason for change" field.
4. Submit label is "Update Event" (not "Book") — language acknowledges this is a revision.
5. Partiful variant: "When the host picks a time, your RSVP will auto-update" — proactive disclosure that the commitment may shift without re-asking.

## Use when
- Our re-confirm variant: faculty responsibilities changed, link re-sent — show what changed (old vs new, strike-through or diff), ask to re-accept, capture optional reason on decline.
- Any flow where the same token URL must serve both first response and later edits.

## Avoid when
- The change is trivial (room number) — a notification is enough; forcing re-confirmation trains people to ignore the links.
- Never silently auto-update a B2B commitment without the Partiful-style disclosure.

## Sad paths observed
- Old time persistently displayed struck-through prevents "what did I originally agree to?" confusion.
- Reason-for-change is optional free text — low friction, still informative to the host.

## Accessibility
- Strike-through alone is invisible to screen readers — add "Former time:" prefix text (Calendly does).
- Pre-filled email field should remain editable and labeled.

## Default verdict for our stack
RECOMMENDED — the strike-through old-vs-new presentation plus "Update" verb is exactly the re-confirm-after-responsibilities-change surface; add a visible diff of responsibilities.
