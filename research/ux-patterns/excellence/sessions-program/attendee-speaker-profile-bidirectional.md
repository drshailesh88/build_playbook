# Pattern: Bidirectional speaker↔sessions linking with one-line credential

**Surface:** sessions-program / attendee-program · **Observed in:** Ten Percent Happier, Open, Polywork (refs: [TPH teacher page](https://mobbin.com/screens/94804c57-b0ed-435d-99c1-1f25a9608bcb), [TPH guided-by block](https://mobbin.com/screens/9d6c2c60-fc38-4bdb-8d2c-46fbfd3f1b96), [Open speaker profile](https://mobbin.com/screens/79766f0c-63a2-4544-90a9-588095fe8757), [Polywork profile](https://mobbin.com/screens/3cbc700b-3a54-4e1b-bfce-d8aed99a0a4c))

## Flow
1. Session → speaker: a "Guided by" block on the session page — avatar, name, ONE-LINE credential ("World-renowned meditation teacher") — links to the profile.
2. Speaker → sessions: the profile lists their sessions ("MORE WITH MANOJ / SEE ALL →"), each row saveable in place.
3. Profile anatomy: bio with "Read more" truncation, then sectioned content beyond talks — "My Writing / My Media Appearances / My Presentations" (Polywork) — relevant for medical faculty (publications, affiliations).
4. Optional follow: "Follow +" = subscribe to a speaker across events.

## Use when
Speakers are a draw (medical conferences absolutely) — attendees navigate by person as much as by topic.

## Avoid when
Speaker data is thin (name only) — an empty profile page is worse than a name+credential chip inline; ship profiles only when bio/photo exist (see speaker-accept-completes-profile card for how to collect them).

## Sad paths observed
- None surfaced; the dependent risk is profile-data sparsity, solved at invite-accept time.

## Accessibility
Numbered/structured session lists; credential is text under the name; "Read more" is a real button.

## Microcopy worth stealing
"Guided by" · "More with {name}" · the one-line credential slot

## Default verdict for our stack
RECOMMENDED — speaker tap-through profiles were spec'd in the old app and NEVER ATTEMPTED (deferred D5); every excellence reference treats speaker↔session navigation as table stakes. Speaker directory page (browsable index of all faculty) was observed nowhere — first-principles candidate.
