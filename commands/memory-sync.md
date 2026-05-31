# Memory Sync — Persistent Memory Operations

Explicit interface to Supermemory's persistent memory layer. For automatic memory (session start/end), see the hooks. This command is for manual save, recall, and management.

## Prerequisites

Supermemory MCP must be installed:
```bash
npx -y install-mcp@latest https://mcp.supermemory.ai/mcp --client claude --oauth=yes
```

## Commands

### Save a pattern or decision
```
/memory-sync save "description of what you learned"
```

Saves the description as a memory scoped to the current project. Uses the project slug as containerTag.

**What to save:** Architecture decisions, error resolutions, codebase patterns, library quirks, QA findings.
**What NOT to save:** Trivial fixes, intermediate debug steps, full code blocks, temporary state.

Implementation:
1. Derive project slug from `$CLAUDE_PROJECT_DIR` (lowercase basename, spaces to dashes)
2. Call `memory(content: "<description>", action: "save", containerTag: "<project-slug>")`
3. Confirm: "Saved to persistent memory for project {slug}."

### Recall past knowledge
```
/memory-sync recall "query"
```

Searches memories for relevant past knowledge. Searches the current project first, then cross-project.

Implementation:
1. Call `recall(query: "<query>", includeProfile: true, containerTag: "<project-slug>")`
2. Display returned memories with relevance context
3. If few results, also call `recall(query: "<query>")` without containerTag for cross-project matches

### Show user profile
```
/memory-sync profile
```

Displays your persistent user profile — stable preferences and recent activity as Supermemory understands them.

Implementation:
1. Call the `/context` prompt to load the full user profile
2. Display the stable preferences section and the recent activity section

### Teach a cross-project pattern
```
/memory-sync teach "pattern description"
```

Saves a pattern that applies to ALL your projects, not just the current one. Saved without a containerTag so it's globally accessible.

**Use for:** Coding style preferences, framework conventions, error handling philosophy, tool configurations that you want everywhere.

Implementation:
1. Call `memory(content: "<pattern>", action: "save")` — no containerTag
2. Confirm: "Saved as a global pattern (accessible from all projects)."

### Forget outdated information
```
/memory-sync forget "description of what to forget"
```

Explicitly removes outdated information from memory. Use when a pattern has changed and you want to ensure no stale recall.

Note: Supermemory handles most contradictions automatically via temporal reasoning. You only need `/memory-sync forget` when you want to actively purge something.

Implementation:
1. Call `memory(content: "<description>", action: "forget")`
2. Confirm: "Memory marked for forgetting."

## How This Relates to /learn

| Feature | `/learn` | `/memory-sync` |
|---------|----------|----------------|
| Storage | Local JSONL | Cloud (Supermemory) |
| Scope | Current project only | Cross-project capable |
| Contradictions | Manual prune | Automatic superseding |
| Offline | Always works | Requires network |
| Forgetting | Manual prune | Automatic + manual |

Both systems run in parallel. Local is the fallback. Supermemory is the upgrade.
