# Merge Coordinator — Serial Integration of Built Branches

After agents build features in parallel (via sprint-executor, ralph-loop, or parallel-sprint), this script serially integrates their branches onto a single integration branch, running tests after each merge to catch conflicts and regressions.

Input: $ARGUMENTS (optional: `--project "Name"` to filter by Linear project)

## Why This Exists

Parallel builds are fast but produce independent branches. Merging them all at once causes conflicts — especially when multiple features touch shared files (CSS, types, barrel exports, migrations). Serial replay means each merge sees the latest integrated state, conflicts are caught early, and tests validate the combined result — not just each branch alone.

## Flow

```
sprint-executor / ralph-loop / parallel-sprint
    ↓ (produces branches labeled "built")
merge-coordinator.sh
    ↓ (serially merges, runs tests after each)
integration/<timestamp> branch
    ↓ (you review)
git merge to main
```

For each Built branch (in dependency order):
1. Merge onto integration branch
2. If conflict → attempt auto-resolution with Claude Code
3. Run tests after merge (not before — catches integration failures)
4. Tests pass → mark "Done" in Linear
5. Tests fail → attempt auto-fix with Claude → if still failing, mark "Blocked"

## How to Run

```bash
# All built branches
./adapters/linear/merge-coordinator.sh

# Filter by Linear project
./adapters/linear/merge-coordinator.sh --project "My Project"

# Specific branches in order
./adapters/linear/merge-coordinator.sh --branches wt/sprint-DRS-10-123 wt/sprint-DRS-11-456

# Skip auto-resolution (just mark conflicts as Blocked)
./adapters/linear/merge-coordinator.sh --no-auto-resolve
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `LINEAR_TEAM` | auto-detect | Linear team key |
| `INTEGRATION_BRANCH` | `integration/<timestamp>` | Target branch name |
| `TEST_CMD` | auto-detect | Test command |
| `TYPE_CHECK_CMD` | `npx tsc --noEmit` | Type check command |
| `NOTIFY_WEBHOOK` | (none) | Slack/Discord/Telegram webhook |

## After Integration

```bash
# Review what was integrated
git log --oneline main..integration/<branch>

# Merge to main when satisfied
git checkout main
git merge integration/<branch> --no-ff
git push
```

## Monitoring

```bash
# Machine-readable status
cat .planning/merge-coordinator-status.json

# Full log
cat .planning/merge-coordinator-log.jsonl

# Linear
linear issue list --team DRS --project "My Project" --all-states
```
