---
description: Always-loaded security constraints for every session. Applies to all code written, reviewed, or modified.
globs: "**/*.{ts,tsx,js,jsx,py,rb,go,rs,java,sql}"
---

# Security Rules

## Secrets

- NEVER hardcode API keys, tokens, passwords, or connection strings
- NEVER commit .env files, credentials.json, or service account keys
- Use environment variables for all secrets; document required vars in .env.example
- If you see a secret in code, flag it immediately — do not continue until it's removed

## Input Validation

- Validate ALL external input at system boundaries (API endpoints, form handlers, CLI args)
- Never trust user input, query parameters, headers, or webhook payloads
- Use allowlists over denylists for input validation
- Sanitize before rendering (HTML encode for XSS, parameterize for SQL)

## OWASP Top 10 — Mandatory Checks

| Vulnerability | Prevention |
|--------------|------------|
| Injection (SQL, NoSQL, OS command) | Parameterized queries, never string concatenation |
| Broken Authentication | bcrypt/argon2 for passwords, secure session management |
| Sensitive Data Exposure | HTTPS only, encrypt at rest, minimize data collection |
| XXE | Disable external entity processing in XML parsers |
| Broken Access Control | Check permissions server-side on every request |
| Security Misconfiguration | No default credentials, disable debug in production |
| XSS | Context-aware output encoding, CSP headers |
| Insecure Deserialization | Never deserialize untrusted data without validation |
| Known Vulnerabilities | Keep dependencies updated, audit regularly |
| Insufficient Logging | Log auth failures, access control failures, input validation failures |

## Defaults

- CORS: restrictive by default, explicit allowlist
- Headers: set X-Content-Type-Options, X-Frame-Options, Strict-Transport-Security
- Cookies: HttpOnly, Secure, SameSite=Strict
- File uploads: validate type, size, and content; never serve from the same domain
- Rate limiting on authentication endpoints

## When To Escalate

If a change touches authentication, authorization, payments, or user data — invoke the security-reviewer agent before merging. No exceptions.
