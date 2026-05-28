---
description: Always-loaded coding style guidelines. Applies to all code written or modified.
globs: "**/*.{ts,tsx,js,jsx,py,rb,go,rs}"
---

# Coding Style Rules

## Immutability

Prefer creating new objects/arrays over mutating existing ones. This is the single most effective way to prevent state-related bugs.

- Use `const` by default, `let` only when reassignment is unavoidable
- Prefer `map`, `filter`, `reduce` over mutating loops
- Return new objects from functions instead of modifying parameters
- Use spread operators or `Object.assign` for object updates

## File Organization

- One module per file. One concern per module.
- 200-400 lines is the sweet spot. Over 500 lines — split.
- Group by feature, not by type (components/auth/ not components/ + services/ + types/)
- Index files re-export only — no logic in barrel files

## Naming

- Functions: verb + noun (`createUser`, `validateInput`, `fetchOrders`)
- Booleans: `is`, `has`, `should`, `can` prefix (`isValid`, `hasPermission`)
- Constants: UPPER_SNAKE for true constants, camelCase for config-like values
- Files: kebab-case for files, PascalCase for React components
- Types/Interfaces: PascalCase, no `I` prefix

## Error Handling

- Handle errors at system boundaries (API endpoints, CLI entry points, event handlers)
- Let errors propagate through internal code — don't catch-and-ignore
- Every error message must be actionable: what happened, why, and what to do next
- Never swallow errors with empty catch blocks
- Use typed errors when the caller needs to distinguish error types

## Comments

- Default: no comments. Well-named code is self-documenting.
- Write a comment ONLY when the WHY is non-obvious: hidden constraints, workarounds, surprising behavior
- Never comment WHAT the code does — rename the function instead
- Never reference the current task, PR, or issue in comments — that context rots

## Functions

- Small functions that do one thing
- 3 parameters maximum. Use an options object for more.
- Pure functions where possible (same input → same output, no side effects)
- Early returns over nested conditionals

## Dependencies

- Check if the runtime or standard library already solves it before adding a package
- Prefer well-maintained packages with active communities
- Pin versions. Review changelogs before upgrading.
- Audit transitive dependencies for security issues
