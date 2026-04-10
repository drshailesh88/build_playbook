# Linear Adapter — Multi-Agent Sprint Execution

Provider-agnostic build→review→fix loop using Linear as the coordination layer.
Any agent that can run shell commands can participate.

## Prerequisites

```bash
brew install schpet/tap/linear   # Install Linear CLI
linear auth login                 # Authenticate (opens browser)
```

## Workflow

```
GSD Requirements → /playbook:gsd-to-linear → Linear Issues → sprint-executor.sh → Built
                                                    ↓                                ↓
                                        .planning/linear-execution-plan.md    merge-coordinator.sh
                                        (dependency map + parallel groups)           ↓
                                                                                   Done
```

Workers (sprint-executor, ralph-loop) build features on isolated branches and mark them "Built".
The merge-coordinator serially integrates those branches, running tests after each merge.
This prevents the parallel-builds-shared-files merge conflict problem.

## Sprint Executor

Runs one issue through: **Read from Linear → TDD Build → Adversarial Review → Fix → Merge → Update Linear**

```bash
# Default: Claude builds, Codex reviews
./sprint-executor.sh DRS-10

# Mix agents
BUILDER_AGENT=aider REVIEWER_AGENT=codex ./sprint-executor.sh DRS-10
BUILDER_AGENT=qwen REVIEWER_AGENT=claude ./sprint-executor.sh DRS-10

# Sequential batch
./sprint-executor.sh DRS-10 DRS-11 DRS-12
```

### Supported Agents

| Agent | Env Value | Builds | Reviews | Needs |
|-------|-----------|--------|---------|-------|
| Claude Code | `claude` | Yes | Yes | `claude` CLI |
| Codex | `codex` | Yes | Yes | `codex` CLI |
| Aider | `aider` | Yes | Yes | `aider` + OPENROUTER_API_KEY |
| Qwen Code | `qwen` | Yes | Yes | `qwen-code` CLI |

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `BUILDER_AGENT` | `claude` | Agent that implements the feature |
| `REVIEWER_AGENT` | `codex` | Agent that adversarially reviews |
| `FIXER_AGENT` | `$BUILDER_AGENT` | Agent that fixes review findings |
| `NOTIFY_WEBHOOK` | (none) | Slack/Discord/Telegram webhook URL |
| `TEST_CMD` | auto-detect | Override test command |
| `TYPE_CHECK_CMD` | `npx tsc --noEmit` | Override type check command |
| `LINEAR_TEAM` | auto-detect | Override Linear team key |
| `AIDER_MODEL` | `openrouter/qwen/qwen3-coder-480b` | Model for Aider |

## Parallel Sprint

Runs multiple issues simultaneously, respecting dependency groups.

```bash
# Run all issues in Group A (no dependencies)
./parallel-sprint.sh --group A

# Run all groups sequentially (A finishes → B starts → C starts...)
./parallel-sprint.sh --all

# Run specific issues in parallel (you manage dependencies)
./parallel-sprint.sh DRS-10 DRS-11 DRS-12
```

Logs for each parallel issue are written to `.planning/parallel-logs/`.

## Merge Coordinator

After parallel builds complete, serially integrates branches with test gates.

```bash
# Integrate all built branches
./merge-coordinator.sh

# Filter by project
./merge-coordinator.sh --project "My Project"

# Skip auto-resolution
./merge-coordinator.sh --no-auto-resolve
```

Creates an integration branch, merges each built branch one at a time, runs tests after each.
If conflicts occur, attempts auto-resolution with Claude Code. Reviews the integration branch
before merging to main.

## Monitoring

```bash
# From terminal
linear issue list --team DRS --sort priority --all-states

# From phone/browser
# https://linear.app/[workspace]/project/[slug]

# Machine-readable status
cat .planning/sprint-executor-status.json
```

## Linear CLI Cheat Sheet

```bash
# Read
linear issue view DRS-10                           # Full issue details
linear issue list --team DRS --sort priority        # All issues

# Write
linear issue update DRS-10 --state "In Progress"    # Start work
linear issue update DRS-10 --state "Done"            # Complete
linear issue comment add DRS-10 --body "message"     # Log progress
linear issue comment add DRS-10 --body-file report.md  # From file

# Create
linear issue create --team DRS --project "My Project" \
  --title "Task title" --description "Details" --no-interactive
```
