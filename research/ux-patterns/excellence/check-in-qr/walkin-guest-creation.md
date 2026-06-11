# Pattern: Walk-in guest creation at the door (no ticket, no account)

**Surface:** check-in-qr / exceptions · **Observed in:** Posh (refs: https://mobbin.com/flows/4022cce6-c624-4831-9f9f-b52243749684)

## Flow
1. Door staff opens the guestlist and hits **+ Create Guest** — right where check-in happens, not in a separate registration admin.
2. Minimal record: Name, **Additional Guests (+N)** count, free-text Description ("CPO of Mobbin Team" — the WHY they're comped).
3. Explicit framing: "This is a private guestlist. Names added here will not receive a ticket and are not prompted to create an account."
4. Created guest is immediately checkable from the same table (status chip Not Checked In → ✓ → Checked In).
5. Row actions include delete (🗑) — door mistakes are removable.

## Use when
Events with on-site registration, comps, VIPs, press, or plus-ones — any door where "I'm not on the list but I should be" is resolvable by an authorized staffer in <30 seconds.

## Avoid when
Credentialed events where every attendee MUST pass eligibility/payment checks — there the door action should deep-link into real registration (pre-filled, fast-tracked), never bypass it.

## Sad paths observed
- Comp inflation: the Description field + creator attribution is the accountability trail observed; no approval gate seen (gap for stricter events).

## Accessibility
The create form is short enough for one-handed use at a door; keep it that way (3 fields max observed).

## Default verdict for our stack
VIABLE — legacy has NO door-side person creation (census: check-in only matches existing confirmed registrations; walk-ins require the separate registration module mid-queue). For medical conferences the avoid-when applies: prefer a fast-tracked real registration deep link from the check-in surface over a parallel untracked list. The founder must pick which half of this pattern to take.
