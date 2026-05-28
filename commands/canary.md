# Canary — Post-Deploy Production Monitoring

Adapted from gstack's canary monitoring skill. Watches your production deployment for problems in the critical first minutes after shipping.

## When to Use

- Immediately after `/ship` merges to main
- After any production deployment
- When you suspect something broke in production

## Process

### Phase 1: Baseline Capture

If this is the first run or `--baseline` is passed, capture the current state:

```bash
mkdir -p .canary
```

For each important page/endpoint:
1. Load the page
2. Record: load time, HTTP status, console errors, visual state
3. Save as baseline

### Phase 2: Page Discovery

Identify the top 5-10 pages/endpoints to monitor:
- Homepage / landing page
- Main feature page (the one the deploy changed)
- Authentication flow (login page)
- API health endpoint (if available)
- Any page mentioned in the PR description

### Phase 3: Health Checks

For each monitored page, check:

| Check | Method | Alert Level |
|-------|--------|-------------|
| Page loads | HTTP status 200 | CRITICAL if fails |
| No new console errors | Compare to baseline | HIGH if new errors |
| Load time reasonable | Compare to baseline | MEDIUM if 2x slower |
| No broken images/assets | Check network tab | MEDIUM |
| No 404s on resources | Check network tab | LOW |
| API endpoints respond | Fetch key endpoints | CRITICAL if fails |

### Phase 4: Monitoring Report

```markdown
## Canary Report — [timestamp]

### Overall Status: [HEALTHY / DEGRADED / CRITICAL]

### Per-Page Results

| Page | Status | Load Time | Console Errors | Notes |
|------|--------|-----------|---------------|-------|
| / | 200 | 1.2s | 0 | Healthy |
| /dashboard | 200 | 2.1s | 0 | Healthy |
| /api/health | 200 | 0.1s | N/A | Healthy |

### New Issues Since Deploy
[list any new errors, performance regressions, or broken functionality]

### Recommendation
- HEALTHY: Deploy is clean. No action needed.
- DEGRADED: Non-critical issues found. Monitor and fix in next sprint.
- CRITICAL: Rollback recommended. [specific issue]
```

### Phase 5: Persistence Rules

A potential issue must appear in 2+ consecutive checks before alerting. This prevents false positives from:
- Transient network issues
- CDN cache warming
- Cold starts

## Save Report

```bash
.canary/report-YYYY-MM-DD-HHMMSS.md
```

## Integration with /learn

After canary monitoring, if issues are found, automatically suggest a learning:
- "Pattern: [what broke] after [what was deployed]"
- Type: `pitfall`
- This prevents the same deployment mistake in future sessions
