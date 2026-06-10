# Pattern: Bulk role change via row selection
**Surface:** change-role · **Observed in:** Coda, Google Workspace (refs: [Coda flow](https://mobbin.com/flows/7e68441c-3c40-4431-b4be-5b67cecabc3e), [Google Workspace bulk update](https://mobbin.com/screens/81dd320c-cfac-4303-baf8-2db1ac4c6c05))

## Flow
1. Members table rows carry checkboxes; selecting any row swaps the toolbar into selection mode: Coda shows "Cancel · Select all · Change roles ▾ · Copy emails".
2. "Change roles" dropdown lists the role set (Doc Maker (Admin) / Doc Maker / Editor) plus "Remove" as the final item — one menu for the whole selection.
3. Apply → toast confirms with a count: "Role updated — 1 member's role was updated."
4. Google Workspace exposes "Bulk update users" at directory scale (CSV-driven) alongside per-row hover actions.

## Use when
- Recurring batch operations: end-of-event demotion of temporary Ops staff, onboarding a cohort to the same role — directly relevant to events seasonality.
- Table already has selection checkboxes for other bulk ops (export, remove).

## Avoid when
- MVP with rare role changes — selection mode adds toolbar complexity; ship per-row first.
- Mixed-permission selections (some rows the actor can't modify) unless rows are clearly excluded — no observed app showed partial-failure handling, so design it explicitly if built.

## Sad paths observed
- Coda's count-in-toast makes partial application detectable ("1 member's role was updated" after selecting 1).
- "Remove" living in the same bulk menu as roles (Coda) is a mis-click risk — separate destructive bulk actions if we adopt this.

## Accessibility
- Checkbox column with select-all; selection-mode toolbar must be announced (aria-live) — not observable from screens, flagged as build requirement.

## Default verdict for our stack
VIABLE — defer to v1.5; valuable for event-staff cohorts, but per-row dropdown covers MVP and bulk adds partial-failure design work.
