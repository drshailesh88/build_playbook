# Pattern: Lane/venue management — drag-to-order, archive, inherited rules, honest constraints

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** Deputy, 7shifts (refs: [Deputy areas flow](https://mobbin.com/flows/c35a9552-1e9c-4aef-986d-d4d02148eafa), [7shifts locations/departments/roles flow](https://mobbin.com/flows/18bef6a3-f096-4e81-a3e2-77ab2bad68ef))

## Flow
1. Lanes (areas/halls) are managed where they're defined, with the grid consequence stated: "Drag the Areas to change the order of how they are arranged on the Scheduling screen." (Deputy).
2. Resource hierarchy: location → department → role (7shifts) — maps to venue → hall → track.
3. Whole-location Archive (not delete); per-area edit/delete inline.
4. Notification rules inherit down the hierarchy with the lock stated: "Inherited from location '{name}'. Go to this location to edit this rule."
5. Hard limits surfaced honestly: "To move roles between departments please reach out to 7shifts support for assistance." + Contact support.

## Use when
Halls/tracks are first-class configured resources whose order matters on the schedule grid.

## Avoid when
Hiding what can't be done — the honest-constraint banner beats a silently missing affordance.

## Sad paths observed
- Inherited-rule lock state with a pointer to the editable source; in-app-impossible operation disclosed.

## Accessibility
Drag-to-reorder paired with the explanatory banner; hierarchy as labeled lists.

## Microcopy worth stealing
"Drag the {lanes} to change the order of how they are arranged on the Scheduling screen." · "Inherited from {parent}. Go to {parent} to edit this rule."

## Default verdict for our stack
RECOMMENDED — halls already have sortOrder in the schema with no reorder UI; drag-to-order in hall management (with the grid-consequence sentence) completes it. Archive-not-delete matches the module's soft-cancel philosophy.
