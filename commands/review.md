# Review — Deep Pre-Landing Code Review

Adapted from gstack's /review pipeline with multi-specialist dispatch. This is NOT a rubber stamp. This finds bugs before production finds them for you.

## Prerequisites

- Changes committed on a feature branch (or staged changes on main)
- All Tier 1 checks passing (typecheck + lint)

## Process

### Step 1: Scope Detection

```bash
# Determine what's being reviewed
git log --oneline main..HEAD 2>/dev/null || git log --oneline -5
git diff main..HEAD --stat 2>/dev/null || git diff --staged --stat
```

Read the diff. Understand the INTENT — check `.planning/` artifacts if available.

**Scope Drift Check:** Does the diff match the stated intent? If the PR says "add auth" but also refactors the database layer, flag it.

### Step 2: Critical Pass

These categories produce production incidents. Check EVERY ONE against the diff:

| Category | What to Look For |
|----------|-----------------|
| **SQL & Data Safety** | Raw string interpolation, missing parameterization, N+1 queries |
| **Race Conditions** | Shared mutable state, missing locks, TOCTOU bugs |
| **LLM Output Trust** | Treating AI-generated content as trusted input |
| **Shell Injection** | User input in exec/spawn commands |
| **Enum Completeness** | Switch without default, unhandled union discriminants |
| **Error Swallowing** | Empty catch blocks, ignored rejections |
| **Auth Bypass** | Missing permission checks, exposed admin routes |
| **Data Exposure** | Sensitive fields in API responses, PII in logs |

### Step 3: Specialist Dispatch

Spawn subagent reviewers for each applicable domain. Run them in parallel:

1. **Security Specialist** — if diff touches auth, payments, user data, API endpoints
2. **Database Specialist** — if diff touches schemas, migrations, queries
3. **Performance Specialist** — if diff touches hot paths, large datasets, real-time features
4. **Testing Specialist** — are the tests comprehensive? Happy + sad + edge?
5. **Accessibility Specialist** — if diff touches UI components

Each specialist reports findings with severity and confidence.

### Step 4: Finding Classification

For each finding:
- **Confidence 80%+** → show as primary finding
- **Confidence 50-80%** → show with caveat in appendix
- **Confidence <50%** → suppress (noise erodes trust)

Severity:
- **CRITICAL** — will cause production incident. Must fix.
- **HIGH** — will cause bugs in edge cases. Should fix.
- **MEDIUM** — maintainability or performance concern. Recommended.
- **LOW** — style or preference. Optional.

### Step 5: Auto-Fix + Report

For CRITICAL and HIGH findings with clear fixes:
- Apply the fix directly
- Show what was changed and why

For findings that need human judgment:
- Present as a batch with options

## Output Format

```markdown
## Review Report

**Scope:** [summary of changes]
**Files Changed:** [count]
**Lines Added/Removed:** [+N/-N]

### Critical Findings (must fix)
[numbered list with file:line, description, fix applied]

### High Findings (should fix)
[numbered list with file:line, description, recommendation]

### Improvements (optional)
[numbered list]

### Quality Score
PR Quality = max(0, 10 - (critical * 2 + high * 1 + medium * 0.5))

### Verdict
- [ ] BLOCKED — critical issues remain
- [ ] APPROVED WITH NOTES — non-critical suggestions
- [ ] CLEAN — ship it
```

## The Rule

Every finding must have a file:line reference and a specific fix recommendation. Vague findings ("consider improving error handling") are not findings.
