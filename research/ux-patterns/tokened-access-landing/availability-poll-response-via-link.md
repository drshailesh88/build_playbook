# Pattern: Availability poll response via shared link (vote, no account)
**Surface:** tokened-access-landing · **Observed in:** Calendly (refs: https://mobbin.com/screens/8b81ac40-561d-4f97-8a65-1a720f5f1835, https://mobbin.com/screens/c2e9b6cc-5fc6-49e0-8b9b-8850e2f061d2), Partiful (refs: https://mobbin.com/screens/de5315ea-9bf1-44ed-9af1-fe46d214fef2, https://mobbin.com/screens/41d2fdb8-e71b-4622-b932-960f57b4eea7)

## Flow
1. Recipient opens the poll link; header instructs: "MEETING POLL — Select all the times you're available to meet" with the organizer's name and duration visible.
2. Time-zone selector defaults to the viewer's zone (Calendly).
3. Each slot shows current vote count (thumbs-up + n); selecting toggles slots, footer tracks "1 Vote · 0 times selected → Next".
4. Partiful "Find a Time": per-date emoji votes (will go / maybe / can't) with disclosure "When the host picks a time, your RSVP will auto-update."
5. Identity is collected at submit (name/contact) since the link is shared, not personal.

## Use when
- Pre-event scheduling with faculty (find a slot for rehearsal/briefing) where no account exists on either side.
- Showing existing vote counts is desirable social proof and speeds convergence.

## Avoid when
- Votes should be private between organizer and each respondent (sensitive availability) — hide counts.
- A personal tokened link already identifies the voter — skip the name capture step.

## Sad paths observed
- Auto-update disclosure (Partiful) handles "the time moved after I voted" without re-contacting everyone.
- Time-zone mistakes pre-empted by the explicit selector with current local time printed (Calendly).

## Accessibility
- Vote chips are buttons with counts as text; emoji votes carry text labels ("Will Go", "Maybe") under the icons.
- Keep the running "n times selected" status as live-region text.

## Default verdict for our stack
VIABLE — useful for scheduling faculty briefings, but it is an upstream nicety, not core to participation confirmation; adopt only if scheduling-by-poll enters scope.
