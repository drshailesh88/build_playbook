---
description: Always-loaded rule requiring Context7 documentation verification before writing code that uses any library, framework, SDK, or API. Prevents hallucinated API signatures.
globs: "**/*.{ts,tsx,js,jsx,py,rb,go,rs,java,swift,kt}"
---

# Library Verification Rule

## The Problem

LLM training data goes stale. Libraries ship breaking changes, rename methods, deprecate APIs, and change default behaviors between versions. Writing code from memory against a library you haven't verified produces bugs that look correct but fail at runtime.

## The Rule

**Before writing code that calls a library/framework/SDK API, verify the API signature with Context7.**

This applies when:
- Using a library method you haven't verified in this session
- Implementing against a framework pattern (routing, middleware, ORM queries, auth)
- Configuring a tool (bundler, linter, test runner, CI)
- Calling a cloud service API (AWS, GCP, Supabase, Stripe, etc.)
- Using CLI tool flags or configuration options

This does NOT apply when:
- Using language built-ins (String methods, Array methods, etc.)
- Using project-internal modules (your own code)
- Simple operations you've already verified this session
- Refactoring code that doesn't change API calls

## How to Verify

```bash
# Step 1: Resolve the library ID
npx ctx7@latest library "<library-name>" "<what you need>"

# Step 2: Fetch the relevant docs
npx ctx7@latest docs <library-id> "<specific API or pattern>"
```

Or use the Context7 MCP tools if available:
1. `resolve-library-id` to find the library
2. `query-docs` to fetch the specific API documentation

## When to Verify (Decision Tree)

```
Am I about to write code that calls a library API?
  ├── YES: Have I verified this API in this session?
  │    ├── YES → proceed
  │    └── NO → verify with Context7 first
  └── NO → proceed
```

## Common Traps This Prevents

| Library | Common Hallucination | Reality |
|---------|---------------------|---------|
| Next.js | `getServerSideProps` in App Router | App Router uses `generateMetadata`, server components |
| Prisma | `prisma.user.findOne()` | Correct: `prisma.user.findUnique()` |
| Drizzle | Old query syntax | API changes frequently between versions |
| Tailwind | Made-up class names | Classes must exist in the framework |
| Playwright | `page.waitForTimeout()` | Deprecated in favor of `page.waitForURL()` etc. |
| React | Class component patterns | Hooks are the current API |
| Supabase | Old auth methods | Auth API changed significantly in v2 |

## Integration with Search Before Building

This rule is Layer 1 of the "Search Before Building" principle from ETHOS.md:

```
Layer 1: Context7 (current docs)     ← YOU ARE HERE
Layer 2: Ecosystem (packages, patterns)
Layer 3: First principles (build from scratch)
```

Always check Context7 before checking npm/PyPI. The docs are more reliable than blog posts.
