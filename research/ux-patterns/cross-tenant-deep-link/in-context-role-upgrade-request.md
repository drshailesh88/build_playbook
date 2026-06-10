# Pattern: In-Context Role Upgrade Request
**Surface:** cross-tenant-deep-link · **Observed in:** Figma, Asana (refs: [Figma "Request upgrade on Figma design"](https://mobbin.com/screens/61ac9513-8831-4bbc-b110-d5b81e57a5c5), [Asana request access with approver message](https://mobbin.com/screens/92f8660a-4efb-48aa-a61f-35d3d45e3997))

## Flow
1. Member opens a resource in their org but their role caps what they can do (viewer opening an edit link).
2. The resource RENDERS at the permitted level — Figma shows the file read-only with an "Edit file" affordance visible; access is degraded, not denied.
3. Attempting the gated action opens a request modal in place: "For you to edit this file in this team, your account needs to be upgraded by an admin" (Figma).
4. Optional context field: "Add a note (Optional) — Let admins know why you need an upgrade" (Figma); "Message for approver (optional)" (Asana).
5. "Send request" → async admin approval; user keeps working at their current level meanwhile.

## Use when
- Combination (4): member of the org but lacking role for THIS resource/action — show what their role allows and gate the rest, instead of blanket-blocking the link.
- The resource has a meaningful read-only projection (event page, attendee list view without edit).

## Avoid when
- Even viewing is above the user's role — partial rendering would leak data; use request-access-with-identity-disclosure or masked-not-found.
- The "upgrade" has billing consequences the requester can't see — say so in the modal (Figma's wording "upgraded by an admin" hints at seat economics; ours must be explicit if a paid seat is implied).

## Sad paths observed
- Request lands nowhere visible: neither observed app shows pending-state on the resource after sending; the user can re-request with no feedback. Build a "request pending" marker (first-principles addition — not observed).
- Figma's modal is reachable only from the gated action; users who never click "Edit file" don't learn an upgrade is possible.

## Accessibility
- Modal with a single labeled optional textarea and explicit Cancel / Send request buttons.
- The blocked-capability explanation is the modal's body text, read before the input.
- Degraded mode must still announce itself (Figma's "view only" state is visual — pair with a text badge for screen readers).

## Default verdict for our stack
RECOMMENDED — for combination (4): render the link target at the role's permitted level, gate mutations behind a role-request modal with optional note routed to org admins; never blanket-403 a member who can legitimately see a read-only projection.
