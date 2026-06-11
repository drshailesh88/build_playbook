# Pattern: Admin-extensible record schema (custom attributes with constraints, archive + undo)

**Surface:** people-registration / schema administration · **Observed in:** Attio, Airtable (refs: https://mobbin.com/flows/32f2c759-9915-4320-8cb7-48984d406fcb , https://mobbin.com/flows/68010b7b-10dc-46bf-a183-5f3f419d9075 , https://mobbin.com/flows/ed0e54dc-e653-4ca0-992b-a6b9e86be4b0)

## Flow
1. Settings → object → Attributes tab: table of attributes (Name / Type / Properties / Constraints) with "System" badges on built-ins and Unique/Required constraint chips; search + filter + "Create attribute".
2. Create/edit modal: Type (LOCKED after creation — greyed), Name, Description, options list with drag-reorder; per-option settings (Attio statuses: confetti toggle, time-in-status target).
3. Airtable's inline variant: "+" at the end of the header row → searchable type picker with per-type help tooltips and config (precision, currency), "+ Add description".
4. Per-attribute menu: Edit / Duplicate / Copy ID / Copy slug / Archive (red) — archive, not delete; undo toast + expandable Archived section.
5. Field-level permissions exist as a menu item (Airtable "Edit field permissions").

## Use when
Tenants genuinely need fields you cannot predict (a derm conference tracking "council member #"), and you have the platform maturity for per-tenant schema (EAV/JSONB), per-field permissions, and import/export of custom fields.

## Avoid when
V1 of a multi-tenant rebuild — custom fields multiply every downstream surface (filters, import mapping, exports, merge logic, RLS). A curated fixed schema + free-form tags covers conference ops; revisit only with concrete tenant demand.

## Sad paths observed
- Type is immutable post-creation (prevents data-corrupting type flips); destructive schema ops are archive+undo, never hard delete.
- System attributes are visibly badged and protected from edits.

## Accessibility
Attribute admin is a standard table+modal; drag-reorder of options has button alternatives (verify before copying — Mobbin screens show handles only).

## Default verdict for our stack
AVOID for V1 (scope-risk SYSTEM: touches import, filters, merge, tenancy). Recorded because both reference apps treat it as core; if tenant demand appears, Attio's archive-not-delete + locked-type rules are the safety model to copy.
