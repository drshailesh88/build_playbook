---
description: Fact-forcing gate that fires before any code edit. Requires investigation of callers, public interface, and user intent before modification. Proven +2.25 quality improvement. Use automatically via hooks — do not invoke manually.
---

# GateGuard — Fact-Forcing Pre-Edit Gate

Adapted from ECC's GateGuard system. The single highest-impact quality intervention from either repo.

## What It Does

Before editing any file for the first time in a session, GateGuard forces the agent to:

1. **Grep for importers** — find every file that imports/requires this file
2. **Read the file** — understand the current public interface
3. **State the change** — what function/export is changing and why
4. **Quote the instruction** — what did the user actually ask for?

Only after this investigation does the edit proceed.

## Why It Works

Most AI coding mistakes happen because the agent:
- Doesn't know who calls the function it's changing
- Doesn't understand the existing interface contract
- Makes assumptions instead of reading the code
- Drifts from what the user actually asked for

GateGuard eliminates all four by making investigation mandatory.

## The Three-Stage Pattern

```
Stage 1: DENY
  → Agent attempts to edit a file it hasn't investigated
  → Hook returns: "Investigate this file's callers and interface first"
  → Edit is blocked

Stage 2: FORCE INVESTIGATION
  → Agent must:
    - grep -r "import.*from.*filename" . (find all callers)
    - Read the file (understand current state)
    - State what's changing and why (prove understanding)

Stage 3: ALLOW
  → Agent retries the edit
  → Hook sees file was already investigated this session
  → Edit proceeds
```

## Gate Types

| Tool | Investigation Required |
|------|----------------------|
| **Edit** | List importers, identify affected functions, state the change |
| **Write** (new file) | Confirm no existing file with similar purpose, name callers |
| **Destructive Bash** | List what will be deleted, confirm rollback procedure |

## Data Schema Checks

When editing files that handle data:
- Always include redacted/synthetic values in examples, never real production data
- Verify that validation logic matches the actual data shapes
- Check that error messages don't expose internal data structure

## Implementation

GateGuard runs as a PreToolUse hook (see `hooks/scripts/gateguard-fact-force.sh`).
Session state tracked at `~/.gstack/gateguard/session-YYYYMMDD.txt`.

## Disabling

Set `BUILDPLAYBOOK_GATEGUARD=off` to disable for a session.
Not recommended — the +2.25 quality improvement is consistent.
