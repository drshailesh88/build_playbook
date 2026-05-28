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

## The Compound Effect

The system is designed to make session N+1 strictly better than session N. Over time, the agent accumulates deep project knowledge that would normally require reading the entire codebase and tribal knowledge from a senior developer.
