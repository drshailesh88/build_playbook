# Pattern: Dispatch board with unassigned queue (drag-drop + equivalent gestures)

**Surface:** transport · **Observed in:** Onfleet, Samsara, Limo Anywhere, Moovs, Tookan
(refs: A1, A2, P1, F1, F2, F3 — URLs in `_raw/by-app.md`, `_raw/by-pattern.md`, `_raw/by-flow.md`; key: https://support.onfleet.com/hc/en-us/articles/360023910111-Task-Assignment, https://kb.limoanywhere.com/docs/new-dispatch-grid/)

## Flow
1. Unassigned passengers/trips sit in a dedicated, always-visible queue (Onfleet: top of sidebar; Tookan: "Unassigned" tab).
2. Assignment is multi-gesture — all equivalent: drag onto a vehicle/driver name (appends to end), drag into a specific position (inserts), right-click → Assign, assign-at-create, or double-click the driver cell in the grid row (Moovs).
3. The order shown on the board IS the order the driver sees (Onfleet) — no hidden re-sorting.
4. Grid variants add a details side panel, stacked filters with savable presets/tabs, and Batch Edit for multi-trip updates (Limo Anywhere).
5. Assignment dropdowns can pre-filter to available/idle resources only (Tookan shows idle agents).

## Use when
An ops user is hand-placing passengers onto vehicles inside a batch — the core kanban loop. Multiple gestures matter at scale (drag for 5 passengers, multi-select + right-click for 50).

## Avoid when
The assignment is machine-proposed (use the suggest-review-publish gate instead) or the user is on mobile (drag-drop fails — needs tap-to-assign alternative; see day-of-boarding card).

## Sad paths observed
- Samsara: unassigned routes are invisible to drivers unless the org explicitly enables self-selection — unassigned things must live somewhere ops can't miss.
- Tookan maintains a dedicated "Can't assign tasks to agents" help article — blocked assignment is an expected state needing an explanation, not a silent failure.

## Accessibility
Not observable from documentation sources. Note: every product pairs drag-drop with a click/menu equivalent — keyboard-reachable assignment comes free if we keep that parity.

## Default verdict for our stack
RECOMMENDED — the legacy kanban already matches the column model; steal the gesture parity (right-click/menu assign + multi-select) and savable filter tabs.
