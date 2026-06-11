# Pattern: Working empty states (twin create/import CTAs; filtered-empty ≠ zero-data)

**Surface:** people-registration / empty & zero states · **Observed in:** Front, Luma, folk, Notion, Attio (refs: https://mobbin.com/flows/707ab494-e532-423f-b5bf-6e13bade31c7 , https://mobbin.com/flows/a8601b45-a4de-450f-8026-8e0b4732872d , https://mobbin.com/flows/b4c3bac2-0e97-461c-bd67-3a18e4fd2981 , https://mobbin.com/flows/3250dd04-9241-4db0-843a-51e4a8a5bf34)

## Flow
1. Zero-data empty state repeats the page's primary actions inside the canvas: Front shows "No shared contacts" + the same "Create / Import" buttons that sit in the header (Import styled primary — bulk ingestion is the realistic first move).
2. The text explains what the surface is for, not just that it's empty ("Shared Contacts allow you to manage contact information shared across your entire company…" + Learn more).
3. Filtered-empty is a DIFFERENT state: Notion offers "Edit filters" inline — the user un-sticks themselves without hunting for the active filter.
4. Status-empty states promise the service level: folk's duplicates page — "Our algorithms are constantly running… If found, they will appear on this page."
5. Domain empty states coach the next move: Luma "No Guests Yet — Share the event or invite people to get started!"; Attio's empty Files tab is itself a drag-drop upload target.

## Use when
Every list/tab/queue in the module — empty is the FIRST state every new tenant sees (critical for a multi-tenant SaaS where onboarding is self-serve).

## Avoid when
Don't put twin CTAs on states the user cannot act on (a read-only role's empty list should explain scope — "people linked to your assigned events appear here" — not dangle a disabled Add).

## Sad paths observed
- Zero-results-from-search names the query and offers clearing it (GEM already does a filter-aware empty state — keep).
- Coordinator-with-zero-assignments sees an empty list by design (GEM RBAC) — that state needs the scope explanation, or it reads as a bug.

## Accessibility
Empty states are headed regions; CTAs are real buttons; illustrations are decorative (alt="").

## Default verdict for our stack
RECOMMENDED — inventory all empty states in this module (list, roster, duplicates queue, import history, history tab) and write each per this card; the read-only/zero-assignment scope explainer is the one GEM-specific addition.
