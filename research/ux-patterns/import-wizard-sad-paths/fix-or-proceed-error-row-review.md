# Pattern: Fix-or-proceed review of error rows before commit
**Surface:** import-wizard-sad-paths · **Observed in:** Remote, 7shifts, Deel (refs: [Remote time-off](https://mobbin.com/screens/d04c9f64-c644-4b9c-8e43-93de5b2fdbc0), [Remote expenses](https://mobbin.com/screens/3a5decfb-5aa1-4283-a804-2c9d9866d852), [Remote contractors](https://mobbin.com/screens/dc7418ac-6100-48dd-9210-afcf218a9e00), [7shifts](https://mobbin.com/screens/3f9ae96b-11de-4564-8953-3d5b423df734), [Deel](https://mobbin.com/screens/507660d4-16f9-4539-9008-d97510d00a3c))

## Flow
1. After upload + mapping, a review table renders every row with per-cell validation: bad cells highlighted red, hover/click reveals the specific error ("This employee is not eligible for the timeoff type…" — Remote).
2. A summary banner counts the damage: "1 time off record can't be added due to errors. You can fix them or proceed with the records that are ready" (Remote); "We're unable to import one or more of your employees. Either adjust and re-upload your file or continue and we'll only import the employees without errors" (7shifts).
3. Filter toggle "Show only rows with errors" (Remote) collapses big files down to the broken rows.
4. Three repair routes coexist: edit cells inline; "export rows to Excel, make corrections there, and then upload that file" (Remote); or "Re-upload your file" (7shifts).
5. Deel groups errors by field instead of by row: "17 required values are missing" with per-column accordions listing affected rows ("Rows 2 and 3 — Not specified") and inline edit pencils.
6. The commit button states the partial scope explicitly: "Continue with 1 time off record" (Remote), "Import employees (1/2)" (7shifts).
7. Remote also offers "Save as draft" so a half-fixed import can be resumed.

## Use when
- Errors are mostly cell-level and fixable in-app (typos, missing required values, bad enum values).
- You want failures handled BEFORE commit, so the post-import report only carries genuine surprises.
- Large files — the errors-only filter toggle is what keeps this usable at 10k rows.

## Avoid when
- Validation requires server-side context not available at preview time (e.g. cross-record dedupe at scale) — promising "all errors caught here" then failing rows later destroys trust.
- The importing persona never owns the data and always bounces the file back to someone else — export-and-fix beats inline editing there.

## Sad paths observed
- Count-in-button ("Import employees (1/2)") prevents the user committing without registering the loss.
- Deel's draft/step sidebar keeps "Validate data" as an explicit numbered step that blocks "Review and upload" until addressed.
- Remote tooltip errors explain the business rule, not just "invalid value."

## Accessibility
- Error cells combine red fill + count badge + tooltip text; the errors-only toggle is a labeled switch.
- Deel's grouped accordion list is keyboard-traversable list semantics rather than relying on scanning a wide grid for red cells.
- Action verbs name their scope ("Continue with 1 time off record") — no ambiguous "Continue."

## Default verdict for our stack
RECOMMENDED — our wizard already has a valid/error preview step; the deltas to adopt are the errors-only filter, the count-in-the-commit-button, and the explicit "fix here / export and fix / proceed without" triple path.
