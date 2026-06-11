# Pattern: Actionable notification inbox (list + in-context detail)

**Surface:** dashboard-reports / notifications · **Observed in:** Linear (refs: https://mobbin.com/flows/2ee08fdf-b415-43f3-8a8b-6d36107b5c6f, https://mobbin.com/flows/0ebbf5cb-6487-4466-9b42-58704b3773a9, https://mobbin.com/flows/7d012661-6196-4343-9ac7-7e46227009c7)

## Flow
1. Inbox is a first-class pane, not a bell drawer: left list (unread dot, actor avatar, reason line "alexsmith assigned to you", relative time), right pane renders the FULL referenced object — issue with properties, activity timeline, and a working comment box. The user acts where they read.
2. Unread count badges the sidebar item; empty state shows the inbox icon + count summary.
3. Notifications take structured filters like any list: "Notification type is Issue assignment" + "Project is X" chips with "Match all filters"; filtered-to-empty shows "No notifications matching the filters."
4. Read/unread toggles per item (circle control); mark-all is a header action.

## Use when
Notification volume is high enough that triage IS a workflow (50 failed sends during a blast, day-of-event flag storms) and items need in-place action (retry, review, dismiss).

## Avoid when
Volume is low and items are pure deep-links — the old app's 20-item drawer (done-spec §3.29, D8) is the right weight for a single-tenant event; a full inbox pane for 3 notifications/day is furniture.

## Sad paths observed
- Filtered-empty vs truly-empty are distinct states with distinct copy (Linear).
- Read-only-role action gating: the old app's "Mark all read" rejects silently inside startTransition for read-only users (done-spec §2) — excellence answer: hide or disable with tooltip, never a no-op click.

## Accessibility
List + detail panes are keyboard-navigable; unread state is conveyed by dot + bold + ARIA, not color alone.

## Default verdict for our stack
VIABLE — keep the drawer for V1 (oracle behavior, already proven) but adopt Linear's discipline inside it: filters (All/Unread/Failed already exist), distinct empty states, and visible read-only gating on "Mark all read".
