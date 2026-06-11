# Pattern: Needs-attention feed with counts, deep links, and zero-state pride

**Surface:** dashboard-reports / overview · **Observed in:** Stripe, Eventbrite, Linear (refs: https://mobbin.com/flows/29a0bba1-f256-494d-9756-77cb7bb2ef4f (Failed payments card), https://mobbin.com/flows/e45fde58-390e-48e3-bdcd-d1b40e013c14 (organizer checklist), https://mobbin.com/flows/a21b30a0-4995-4adb-b339-2e411ed0fb5a)

## Flow
1. Stripe's overview embeds a "Failed payments" card: each row is a concrete failing item (amount, customer, Failed badge, timestamp) with "3 of 3 results" and a link to the full filtered list — counts AND specimens, not just "3 failures".
2. Eventbrite's organizer home runs a checklist + planner timeline: each pending item states the task and the next action ("Start selling tickets… Send an email campaign…").
3. Every attention item deep-links to the EXACT filtered view that resolves it (the old app already does this: /flags, /communications/failed, /faculty/invite — and its SCARS prove hrefs must be route-existence-tested).
4. Items are typed and exhaustive by design: the old app declared `upcoming_no_kit` (warn when an upcoming event lacks an emergency kit) but never wired detection — dead attention types are silent risk.

## Use when
The dashboard's job is "what do I do next" — for event ops in the pre-event ramp this beats any chart. Counts alone create anxiety; count + first specimens + one-click resolution creates motion.

## Avoid when
An item has no resolving action — "informational attention" is just a notification; keep the feed strictly actionable or it becomes a second inbox.

## Sad paths observed
- All-clear state: show an explicit "nothing needs attention" (zero-state pride), never an empty div — absence of warnings must be distinguishable from failure-to-load.
- Stale counts: pair the feed with a freshness stamp (see dashboard-freshness-stamps) so "0 failed sends" is trusted.

## Accessibility
Items are links with full-sentence labels ("3 failed notifications — review in Communications"), already the old app's copy style.

## Default verdict for our stack
RECOMMENDED — the old app's needs-attention is genuinely good; the excellence delta is (a) wiring `upcoming_no_kit`, (b) specimen rows à la Stripe, (c) a proud all-clear state.
