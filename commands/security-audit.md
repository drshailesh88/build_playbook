# Security Audit — Full Security Review of Your Codebase

Run a comprehensive security audit: scan for leaked secrets, check dependencies for known vulnerabilities, review code against OWASP Top 10, verify auth implementation, and check API route security. Produces one prioritized report.

Optional: $ARGUMENTS (module or directory to scope the audit, or "full" for entire project)

## Why This Exists

Security problems are invisible until they're catastrophic. A leaked API key, an unvalidated input, an exposed admin route — any one of these ends your product. This command runs 6 security checks in sequence and produces a single report with everything ranked by severity.

Adapted from: Trail of Bits security skills, AgentSecOps SecOpsAgentKit, Claude Code's built-in /security-review, OWASP Top 10:2025.

## Process

### Check 1: Secrets Scanning

Search the entire codebase for leaked credentials:

```bash
# API keys, tokens, passwords in source files
grep -rn "sk-\|sk_live\|sk_test\|api_key\|apikey\|API_KEY\|secret\|SECRET\|password\|PASSWORD\|token\|TOKEN" \
  --include="*.ts" --include="*.tsx" --include="*.js" --include="*.json" --include="*.env*" --include="*.yml" --include="*.yaml" \
  . | grep -v node_modules | grep -v ".git/" | grep -v ".env.example" | grep -v ".env.local.example"

# Common secret patterns
grep -rn "-----BEGIN.*KEY-----\|ghp_\|gho_\|github_pat_\|xoxb-\|xoxp-\|sk-ant-\|pk_live_\|pk_test_\|AKIA[A-Z0-9]" \
  --include="*.ts" --include="*.tsx" --include="*.js" --include="*.json" --include="*.env*" \
  . | grep -v node_modules | grep -v ".git/"

# Check if .env files are gitignored
grep -q ".env" .gitignore 2>/dev/null && echo "✅ .env in .gitignore" || echo "❌ .env NOT in .gitignore"

# Check git history for leaked secrets
git log --all --oneline --diff-filter=A -- "*.env" ".env.*" 2>/dev/null | head -5
```

**Severity: CRITICAL** — any found secret must be rotated immediately.

### Check 2: Dependency Vulnerabilities

```bash
# npm audit for known CVEs
npm audit --production 2>&1

# Check for outdated packages with known issues
npm outdated --long 2>&1 | head -30

# Count severity levels
npm audit --production --json 2>/dev/null | python3 -c "
import json,sys
try:
    d=json.load(sys.stdin)
    v=d.get('metadata',{}).get('vulnerabilities',{})
    print(f\"Critical: {v.get('critical',0)}, High: {v.get('high',0)}, Moderate: {v.get('moderate',0)}, Low: {v.get('low',0)}\")
except: print('Could not parse audit output')
" 2>/dev/null
```

**Severity: HIGH** — critical/high CVEs must be fixed before deploy.

### Check 3: OWASP Top 10 Code Review

Use a subagent to review code against OWASP Top 10:2025:

```
Task subagent with tools: Read, Grep, Glob

Prompt: |
  Review the codebase against OWASP Top 10:2025. For each category,
  search for vulnerable patterns and report findings with file:line.
  
  A01: Broken Access Control
  - Are all API routes protected by auth middleware?
  - Can users access other users' data by changing an ID in the URL?
  - Are admin routes separated and protected?
  grep -rn "params\.\|searchParams\.\|req\.query\.\|req\.params\." src/app/api/
  
  A02: Cryptographic Failures
  - Is sensitive data encrypted at rest?
  - Are passwords hashed (not stored in plaintext)?
  - Is data transmitted over HTTPS only?
  
  A03: Injection
  - Is user input used directly in SQL queries?
  - Is user input used in HTML without sanitization?
  - Are there any raw SQL queries (not parameterized)?
  grep -rn "sql\`.*\${\|\.raw(\|\.unsafe(" src/
  
  A04: Insecure Design
  - Are there rate limits on auth endpoints (login, register, password reset)?
  - Are there rate limits on expensive operations (AI calls, search)?
  
  A05: Security Misconfiguration
  - Are debug/development features disabled in production?
  - Are default passwords/configs changed?
  - Are unnecessary features/endpoints exposed?
  grep -rn "console\.log\|console\.error\|debug:\s*true" src/ | grep -v "node_modules"
  
  A06: Vulnerable Components
  - (Covered by npm audit in Check 2)
  
  A07: Authentication Failures
  - Is session management secure?
  - Are password requirements enforced?
  - Is there brute-force protection?
  
  A08: Data Integrity Failures
  - Is data validated on the server side (not just client)?
  - Are file uploads validated (type, size, content)?
  grep -rn "req\.body\|request\.json\|formData" src/app/api/
  
  A09: Logging Failures
  - Are security events logged (login attempts, access denied, admin actions)?
  - Are logs free of sensitive data (no passwords, tokens in logs)?
  
  A10: Server-Side Request Forgery (SSRF)
  - Does the app fetch external URLs based on user input?
  - Are internal network addresses blocked?
  grep -rn "fetch(\|axios\.\|http\.get" src/ | grep -v node_modules
```

### Check 4: API Route Security

```bash
# Find all API routes
find src/app/api -name "route.ts" -o -name "route.js" 2>/dev/null | sort

# For each route, check:
# 1. Does it have auth middleware?
# 2. Does it validate input?
# 3. Does it have rate limiting?
# 4. Does it handle errors properly (not leaking stack traces)?
```

Use subagent to review each API route:
```
For each API route file:
1. Does it check authentication? (Clerk's auth(), getAuth(), currentUser())
2. Does it validate the request body? (Zod schema, manual validation)
3. Does it catch errors and return safe error messages? (not stack traces)
4. Does it check authorization? (does user own this resource?)
5. Does it have rate limiting?
```

### Check 5: Auth Implementation Review

```bash
# Find auth middleware
grep -rn "auth()\|getAuth()\|currentUser()\|clerkMiddleware\|authMiddleware" src/ | grep -v node_modules

# Find unprotected routes (routes without auth checks)
# Compare list of all API routes vs routes with auth

# Check middleware configuration
cat src/middleware.ts 2>/dev/null || cat middleware.ts 2>/dev/null

# Check if public routes are intentionally public
grep -rn "publicRoutes\|ignoredRoutes\|matcher" src/middleware.ts 2>/dev/null
```

### Check 6: Security Headers

```bash
# Check if security headers are configured
grep -rn "Content-Security-Policy\|X-Frame-Options\|X-Content-Type-Options\|Strict-Transport-Security\|Referrer-Policy\|Permissions-Policy" \
  next.config.* vercel.json wrangler.toml .htaccess nginx.conf 2>/dev/null

# Check for CORS configuration
grep -rn "Access-Control-Allow-Origin\|cors\|CORS" src/ next.config.* 2>/dev/null | grep -v node_modules
```

### Step 7: Produce the Security Report

```markdown
# Security Audit Report: [Project Name]
**Date:** [date]
**Scope:** [full project / specific module]
**Auditor:** Automated (Claude Code security-audit)

## Summary

| Severity | Count |
|----------|-------|
| 🔴 CRITICAL | [N] |
| 🟠 HIGH | [N] |
| 🟡 MEDIUM | [N] |
| 🔵 LOW | [N] |
| ✅ PASS | [N] checks passed |

## Findings (ordered by severity)

### 🔴 CRITICAL — Fix Immediately

**[CRIT-1] [Title]**
- File: [path:line]
- Description: [what's wrong]
- Impact: [what could happen if exploited]
- Fix: [specific code change to make]

### 🟠 HIGH — Fix Before Next Deploy

**[HIGH-1] [Title]**
- File: [path:line]
- Description: [what's wrong]
- Impact: [what could happen]
- Fix: [specific code change]

### 🟡 MEDIUM — Fix This Sprint

...

### 🔵 LOW — Fix When Convenient

...

## Checks Passed ✅

- [List of checks that passed with no issues]

## Recommendations

1. [Top recommendation based on findings]
2. [Second recommendation]
3. [Third recommendation]

## Re-Audit

Run `/security-audit` again after fixing critical and high findings to verify fixes.
```

### Step 8: Commit

```bash
git add -N .planning/security-audit-*.md  # Don't commit secrets findings to public repos!
# If the report contains actual secret values, save locally only
echo "Security audit complete. Report saved to .planning/security-audit-[date].md"
```

**WARNING**: If secrets were found, the report contains sensitive information. Do NOT commit it to a public repository. Save locally or in a private location.

## Rules

- **NEVER skip any of the 6 checks** — a partial audit gives false confidence
- **NEVER downplay CRITICAL findings** — a leaked API key IS critical, even if "it's just a test key"
- **ALWAYS provide specific file:line references** — "you have a security issue" is not helpful. "src/app/api/users/route.ts:42 accepts unvalidated user ID" is helpful.
- **ALWAYS provide specific fix code** — don't just say "validate input." Show the Zod schema or the auth check.
- **ALWAYS check git history for secrets** — a secret that was in code and later removed is STILL compromised. It's in git history.
- **Order findings by severity** — CRITICAL first, LOW last. The founder reads top-down and might stop.
- **Be careful with the report** — it may contain actual secrets found in code. Don't commit to public repos.
