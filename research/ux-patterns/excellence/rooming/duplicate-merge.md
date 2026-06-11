# Pattern: Duplicate detection + merge with consequence statement
**Surface:** rooming · **Observed in:** folk, Salesforce, Front, Customer.io, Kajabi, ManyChat
(refs: https://mobbin.com/screens/75065e3c-d49c-43fc-8705-fc5d622b140c , https://mobbin.com/screens/eb7abb1d-f6fe-432c-b6f9-495dfdb360af , https://mobbin.com/screens/7dd16e14-0899-4b53-9525-a5fef2def520 , https://mobbin.com/screens/1923cdf0-453c-4552-9e2a-c8ce5e332b3b ; raw: `_raw/by-pattern.md` §P25)

## Flow
1. Detection surfaced with a count: "We've detected 1 possible duplicate contact." (folk).
2. Pick the survivor: "Use as principal" radio; field-by-field conflict resolution with both values shown, "[empty]" rendered explicitly (Salesforce).
3. Merged-preview third card shows the OUTCOME before commit (folk) — the strongest variant.
4. Conflicts counted and forced: "⚠ 1 conflict found for name" with a picker (Front).
5. Consequences and irreversibility stated, consent-gated: "The merge will delete the Secondary Contact and its Inbox records."; checkbox "I understand merging these contacts is instant and cannot be undone." (ManyChat/Kajabi).

## Use when
A delegate registered twice (agency + self), each copy carrying bookings — the merge must decide what happens to BOTH room assignments.

## Avoid when
Auto-merging silently — observed apps always keep a human in the loop with the outcome preview.

## Sad paths observed
Un-mergeable combinations stated as rules; irreversibility called out twice; conflicts blocking until resolved.

## Accessibility
Field conflict choices as labeled radios; consequence sentences before the gate, not in tooltips.

## Default verdict for our stack
VIABLE — lives mostly in the People module, but the rooming consequence line is the steal: "Keeps Hilton Twin Oct 10–14; releases Marriott King — hotel will be notified" + Kajabi consent checkbox.
