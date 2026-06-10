# Pattern: Source vs derived emptiness (CTA where data is created, zen where it flows in)
**Surface:** zero-data-empty-states · **Observed in:** Linear, Attio (refs: https://mobbin.com/screens/22a34806-c628-4add-a158-62792796917b, https://mobbin.com/screens/09d54562-4216-49dd-ab1d-1872ed602f79, https://mobbin.com/screens/44729082-a489-47f2-abf9-a1e6f73b6380, https://mobbin.com/screens/a427d7f8-bc0d-4840-9724-56b77e0f7dcf, https://mobbin.com/screens/5cc1bd35-b393-4c63-9b86-280b982247e0, https://mobbin.com/screens/2931cbdc-8ddc-4e3a-904c-1c3938d25e95, https://mobbin.com/screens/2f290a3f-3e6c-4a71-88b2-79f0c60e0f52)

## Flow
1. Modules where the user CREATES data get an educational empty card: what this view is, why it matters, then the create CTA — Linear "All Issues": "All Issues is the place where you can see all of your team's work in one view. Once you have created some issues... [Create a new issue]"; "Active Issues" explains backlog→active flow before the CTA; "Initiatives" adds the keyboard shortcut ("N then I") and a Documentation link.
2. Modules where data ARRIVES from elsewhere get a calm, CTA-free zen state — Linear Triage: "Nothing to triage" with a horizon illustration; My Issues/Assigned: a checkmark + "No issues". No button, because the fix isn't here.
3. The same split appears inside Attio record detail tabs: "No notes — Create a Note to keep track of important information [Create note]" (source) vs "No activity found — It seems Jane Doe does not have any activity history" (derived, no CTA).
4. Net effect: emptiness is sequenced — every empty module either offers the action that fills it, or implicitly says "this fills itself once upstream data exists".

## Use when
- Module B is useless until module A has data: B's empty state should explain the dependency and (ideally) link to A's create action rather than offer a dead local CTA.
- Inbox/triage/feed-style views where "empty" is success, not failure — celebrate calm instead of nagging.

## Avoid when
- Derived views in a brand-new tenant: Linear's "Nothing to triage" zen state is correct for an active team but indistinguishable from "not set up yet" for a new tenant — pure zen with no pointer strands the user (observed gap: Linear's derived empties never link upstream).
- Educational cards repeated on every visit after the user has learned the model — they earn their space only pre-activation.

## Sad paths observed
- Linear "Nothing to triage" gives a brand-new workspace no route to the action that would ever populate triage.
- Attio "No activity found" on a fresh record reads as an error ("It seems...") rather than guidance to connect email/calendar.

## Accessibility
- Linear's keyboard-shortcut hint ("N then I") is rendered as styled keycaps inside the button — ensure shortcut info is also plain text.
- Zen states that are illustration-only ("Nothing to triage" + drawing) still include a text line in all observed cases — keep text mandatory.

## Default verdict for our stack
RECOMMENDED — Event State's People/Program/Registrations modules pre-first-event should use the educational form with an explicit upstream pointer ("People attach to events — create your first event"), and reserve zen states for genuinely self-filling views (inbox, check-in feed) post-activation.
