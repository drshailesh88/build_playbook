# Learn — Project Learnings Management

Adapted from gstack's /learn system. Stores and retrieves per-project learnings so every session is smarter than the last.

## Storage

Learnings are stored at:
```
~/.buildplaybook/projects/{project-slug}/learnings.jsonl
```

Each learning is a JSON line:
```json
{"timestamp":"2026-05-28T10:30:00Z","type":"pattern","content":"This project uses Drizzle ORM, not Prisma","source":"session","confidence":0.9}
```

## Learning Types

| Type | When to Record |
|------|---------------|
| `pattern` | Discovered a codebase convention or project-specific approach |
| `pitfall` | Found something that breaks easily or has a non-obvious failure mode |
| `preference` | User expressed a preference for how things should be done |
| `architecture` | Architectural decision or constraint discovered |
| `tool` | Tool/library behavior that's non-obvious or undocumented |
| `operational` | Deployment, environment, or infrastructure knowledge |

## Commands

### Show recent learnings (default)
```
/learn
/learn show
```
Displays the 10 most recent learnings for this project.

### Search learnings
```
/learn search [query]
```
Semantic search across all learnings. Useful when investigating a problem that might have been encountered before.

### Add a learning manually
```
/learn add
```
Prompts for type and content. Use when you discover something worth remembering.

### Prune stale learnings
```
/learn prune
```
Reviews learnings against the current codebase. If the referenced file no longer exists, the pattern has changed, or the tool has been replaced, mark as stale and offer to remove.

### Export learnings
```
/learn export
```
Outputs all learnings as a readable markdown document, grouped by type.

## Automatic Learning Capture

Learnings are also captured automatically by the session-end hook when:
- A bug was fixed (record as `pitfall`)
- A codebase pattern was discovered (record as `pattern`)
- An architecture decision was made (record as `architecture`)
- The user corrected the agent (record as `preference`)

## How Learnings Are Used

1. **Session start**: The 5 most recent learnings are loaded into context
2. **During investigation**: `/learn search` finds relevant past discoveries
3. **During review**: Learnings inform what to check for
4. **During planning**: Architecture learnings shape design decisions

## The Compound Effect

Session 1: Everything is discovery. Every pattern is new.
Session 10: Common pitfalls are known. Preferences are respected.
Session 50: The system knows the codebase as well as a senior developer who's been on the project for months.

This is the difference between an AI that starts fresh every time and one that gets better with every session.
