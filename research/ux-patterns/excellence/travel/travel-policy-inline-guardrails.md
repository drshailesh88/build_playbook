# Pattern: Inline policy guardrails + approval queue
**Surface:** travel · **Observed in:** KAYAK for Business (ref: https://mobbin.com/flows/c90ce0c5-2eb0-4c3d-91ff-d7695b190c71), Navan Approvals (ref: https://mobbin.com/flows/bd74505f-dcf4-4549-9322-2ad49ad36901)

## Flow
1. The policy is shown WHERE the choice happens: expandable panel atop flight results — "Your flight travel policy: Max allowed price $500 · Max cabin class per haul length · When to book (3–5 days in advance) · Remember to request approval if the flight is **out of policy**."
2. Compliant options get a green "In policy" badge on the fare card; non-compliant remain selectable but flagged (guardrail, not wall).
3. Approval back-office: Approvals → Bookings queue filtered by Pending; empty state teaches ("When a traveler requests approval it will show up here"); "Set temporary approver" handles absence.

## Use when
Money or policy constraints attach to travel choices (budget caps per delegate tier, advance-booking rules) and a second pair of eyes approves exceptions.

## Avoid when
The org books everything centrally with no per-record budget rules — policy chrome without policy is noise.

## Sad paths observed
- Out-of-policy is visible-but-flagged, not hidden — the human can still justify and proceed via approval.
- Approver absence handled explicitly (temporary approver), not by queue rot.

## Accessibility
Badges have text labels; policy panel is plain expandable text.

## Default verdict for our stack
AVOID for V1 / VIABLE for V2 — EventState V1 records travel, it doesn't book it; policy/approval becomes relevant only if budgets-per-delegate or booking workflows enter scope. Harvested for the library.
