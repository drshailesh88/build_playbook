# classify-modules — Interactive tiers.yaml builder

Scans the target app's source tree, groups files by likely domain (auth,
payments, db, ui, other), and helps you classify each group into a tier
(critical_75, business_60, ui_gates_only) in `.quality/policies/tiers.yaml`.

## Tier Reminders

| Tier | Floor | Enforced via | Use for |
|---|---|---|---|
| `critical_75` | 75% mutation | Stryker + floor gate | Auth, payments, user data, core business logic |
| `business_60` | 60% mutation | Stryker + floor gate | Non-critical business logic, API handlers |
| `ui_gates_only` | none (no mutation floor) | Static + unit + Playwright + a11y + visual | UI components where mutation is hard to measure meaningfully |

## Steps

```bash
/playbook:classify-modules
```

The command is interactive:

1. Lists each `src/` subdir + top-level files.
2. For each group, proposes a tier based on path heuristics (e.g.
   `src/components/` → `ui_gates_only`, `src/payments/` → `critical_75`).
3. You confirm, override, or skip.
4. Writes `tiers.yaml` with `unclassified_behavior: fail_fast` so any
   subsequent uncategorized file halts `qa-run` loudly.

## Blueprint Reference

- 6b.iii strict default: **no unclassified source files**. Every file must
  match a glob.
- Module tiers are enforced on every Stryker measurement — modules can
  ratchet above their floor but can NEVER regress below once they've
  reached it.
