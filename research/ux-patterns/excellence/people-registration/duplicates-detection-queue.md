# Pattern: Standing duplicates queue (auto-detection, review, ignore, merge-all)

**Surface:** people-registration / dedup · **Observed in:** folk, Square, Pipedrive, Clay (refs: https://mobbin.com/flows/b4c3bac2-0e97-461c-bd67-3a18e4fd2981 , https://mobbin.com/flows/f4ebc84b-57c8-4696-8741-d6205c58241b , https://mobbin.com/flows/7338268f-021e-412f-a4c2-fae6e36bf06a )

## Flow
1. Detection runs continuously, not only at import time; results land in a standing queue surfaced from the nav: folk's sidebar "Duplicates" item with count badge; Square's inline "① 1 Duplicate Suggestion >" chip next to the directory's group selector; Pipedrive keeps "Merge duplicates" as a permanent Tools item.
2. Queue page header explains itself: "We've detected 1 possible duplicate contact. You can merge them into one contact." (folk).
3. Each duplicate SET shows the candidate records side-by-side with their distinguishing fields visible (email vs phone-only), plus per-set actions: Ignore / Merge (Square), Don't merge / Merge (folk).
4. Batch path: "Merge All" applies all suggestions at once (Square); completion screen accounts for what happened ("1 duplicate proposal was successfully merged") with per-record Edit links.
5. Empty state promises the service level: "No duplicate in your contacts now — Our algorithms are constantly running to detect duplicates… If found, they will appear on this page." (folk).

## Use when
Multiple ingestion paths (public registration, CSV import, manual add) can create the same human — guaranteed in conference ops.

## Avoid when
Exact-key dedup at write time already blocks ALL duplicate classes (not true once fuzzy-name/nickname variants exist). Avoid auto-merge without review for medical/academic data — title and affiliation conflicts need a human.

## Sad paths observed
- "Ignore" / "Don't merge" is as prominent as Merge — false positives must be dismissible, and dismissed pairs stay dismissed.
- Queue count badge goes to zero with a confirming empty state, never a dead page.

## Accessibility
Duplicate sets are grouped regions labeled by the matched name; Ignore/Merge are per-set buttons.

## Default verdict for our stack
RECOMMENDED — GEM's `findDuplicates()` (fuzzy name + email/phone, Fuse.js) is fully built and tested with ZERO callers (done-spec §32, M62→M57 handoff never wired). Wire it into (a) the import success page ("Review N possible duplicates") and (b) a standing queue with count badge on the people list.
