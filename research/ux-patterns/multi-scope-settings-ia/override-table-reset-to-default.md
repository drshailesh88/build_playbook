# Pattern: Override Table with Per-Row Reset to Default
**Surface:** multi-scope-settings-ia · **Observed in:** Churnkey (refs: [Churnkey text overrides](https://mobbin.com/screens/9abc8a58-37f1-456f-9864-9ef060f15c43))

## Flow
1. A "Text Overrides" page lists every overridable key in a table: column 1 = the key/tag (next, back, managedEmailTitle…), column 2 = "Your Override" as an editable input pre-filled with the effective value, column 3 = Actions with a per-row "Reset to Default" link.
2. A segmented filter "Show All / Show Overrides Only" lets the user isolate what actually diverges from the default.
3. A scope selector (language dropdown here) switches which override set is being edited; "Save All Changes" commits the batch, with a "Saved" state indicator.
4. Resetting a row discards the override and re-inherits silently — no confirmation observed.

## Use when
- Many small values can each be overridden independently — exactly our global→event template/copy override model from the legacy template editor.
- Reviewers need an audit view of "what did this event change?" — the overrides-only filter is that view.

## Avoid when
- Only one or two settings are overridable; a table shell around two rows is overkill — use the dropdown-with-named-default pattern.
- Overridden values are long-form (full email templates) — rows with inline inputs break down; link each row out to a full editor instead.

## Sad paths observed
- Single-app observation: no error state for an invalid override value was captured; "Reset to Default" with no undo is itself a foot-gun the design accepts.

## Accessibility
- Each override is a real labelled input in a table — keyboard reachable; "Reset to Default" is a text link, not an icon-only control.
- The overrides-only filter reduces table size for assistive-tech users scanning long lists.

## Default verdict for our stack
VIABLE — single-app evidence, but it is the only observed shape that fits our per-event template/copy overrides; pair it with the parent-allows-override card for enumerable settings.
