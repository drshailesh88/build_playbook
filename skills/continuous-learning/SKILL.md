---
description: Captures project-specific learnings automatically at session boundaries. Loads relevant learnings at session start. Makes every session smarter than the last.
---

# Continuous Learning System

Adapted from ECC's continuous learning v2 and gstack's /learn system.

## How It Works

### Session Start
The session-start hook loads:
1. Last session state (git status, branch, recent commits)
2. The 5 most recent project learnings
3. Any learnings tagged as high-confidence (0.8+)

### During Session
Learnings are captured when:
- The agent discovers a codebase pattern → `pattern`
- A bug is fixed → `pitfall` (record the root cause)
- The user corrects the agent → `preference`
- An architecture decision is made → `architecture`
- A tool behavior is discovered → `tool`
- Deployment knowledge is gained → `operational`

### Session End
The session-end hook:
1. Saves git state for next session pickup
2. Evaluates whether new learnings should be recorded
3. Writes learnings to project-specific JSONL

## Storage

```
~/.buildplaybook/projects/
  {project-slug}/
    learnings.jsonl          # All learnings for this project
    last-session.md          # State from most recent session
```

## Learning Format

```json
{
  "timestamp": "2026-05-28T10:30:00Z",
  "type": "pattern",
  "content": "This project uses Drizzle ORM with PostgreSQL. Schema in src/db/schema.ts.",
  "source": "session",
  "confidence": 0.85,
  "file_ref": "src/db/schema.ts"
}
```

## Confidence Scoring

- **0.3** — tentative (single observation)
- **0.5** — likely (observed twice)
- **0.7** — confident (multiple confirmations)
- **0.8** — reliable (used successfully in multiple sessions)
- **0.9** — near-certain (never contradicted)

Adjustments:
- +0.1 per confirmation (same pattern observed again)
- -0.2 per contradiction (pattern doesn't hold)

## Scope Rules

Learnings are PROJECT-SCOPED by default:
- Language/framework patterns
- File structure conventions
- Code style preferences
- Error handling approaches
- Tool configurations

## Commands

Use `/learn` to interact with the learning system:
- `/learn` — show recent learnings
- `/learn search [query]` — find relevant learnings
- `/learn add` — manually add a learning
- `/learn prune` — remove stale learnings
- `/learn export` — markdown export

## Two-Layer Architecture: Local + Supermemory

The learning system operates on two layers. Both run simultaneously.

| Layer | Local JSONL | Supermemory |
|-------|------------|-------------|
| **Speed** | Instant (filesystem read) | Network call (~200ms) |
| **Availability** | Always (offline works) | Requires network |
| **Scope** | Current project only | Cross-project, cross-machine |
| **Contradictions** | Manual prune via `/learn prune` | Automatic temporal superseding |
| **Forgetting** | Manual | Automatic (temporary context expires) |
| **Knowledge graph** | None (flat list) | Relationships: updates, extends, contradicts |

### What Goes Where

- **Local only**: File paths, git branch names, temporary debug context
- **Supermemory only**: Cross-project patterns, user preferences, tool behaviors
- **Both**: Error resolutions, architecture decisions, codebase patterns

### How They Interact

When a learning is captured (automatically or via `/learn add`), it writes to local JSONL as before. The session-end hook also instructs the agent to save key learnings to Supermemory via `memory()`.

At session start, the hook loads local state first (instant), then instructs the agent to call `recall()` and `/context` for richer cross-project memory.

If Supermemory is unavailable, the local system works exactly as before. No degradation.

## The Compound Effect

The system is designed to make session N+1 strictly better than session N. Over time, the agent accumulates deep project knowledge that would normally require reading the entire codebase and tribal knowledge from a senior developer.
