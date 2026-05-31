# eval-check — Deterministic Playbook Command Evals

Run lightweight file-based evals for the playbook's own commands. This is deterministic validation only: no LLM judging, no semantic scoring, no model calls.

No arguments needed.

## Why This Exists

Playbook commands generate files and schemas that downstream commands depend on. This command checks those outputs with fixtures and shell assertions so regressions are visible before they reach real projects.

## Eval Layout

Eval directories live under:

```
.quality/evals/
```

Each eval directory may contain:

```
rules.txt              # required; one shell assertion per line
expected-files.txt     # optional; one project-root-relative path per line
expected-schema.json   # optional; JSON shape expected from the command output
```

Blank lines and lines beginning with `#` are ignored.

## Process

### 1. Discover Evals

Scan `.quality/evals/` for child directories. Skip files directly inside `.quality/evals/`.

If `.quality/evals/` does not exist, stop with:

```
No evals found. Create .quality/evals/<name>/rules.txt first.
```

### 2. Check Expected Files

If `expected-files.txt` exists, verify every listed path exists relative to the project root.

Report:

```
[PASS] Expected files exist (N/N)
[FAIL] Expected files exist (N/M missing: path, path)
```

### 3. Run Rules

For each non-comment line in `rules.txt`, run it as a shell command from the project root. The rule passes if it exits `0`.

Display a readable label:
- If the previous comment line describes the rule, use that comment text
- Otherwise use the command itself

Report each failing rule individually. If all rules pass, collapse to:

```
[PASS] All rules pass (N/N)
```

### 4. Validate Expected Schema

If `expected-schema.json` exists, validate JSON structure deterministically with `python3`.

Rules:
- The schema file describes required keys and primitive JSON types
- Objects require the listed keys
- Arrays validate each item against the first schema item when present
- Primitive values validate by JSON type: `string`, `number`, `boolean`, `object`, `array`, `null`

If the schema target is not specified inside `expected-schema.json`, default to `ralph/prd.json`.

### 5. Report Results

Output exactly:

```
EVAL RESULTS
━━━━━━━━━━━━
prd-to-ralph:
  [PASS] Expected files exist (3/3)
  [PASS] Rule: risk_domain field present
  [FAIL] Rule: dependencies array non-empty
  Result: FAIL (1/3 rules failed)

scaffold-ralph:
  [PASS] Expected files exist (11/11)
  [PASS] All rules pass (5/5)
  Result: PASS

Summary: 1 PASS, 1 FAIL (2 evals)
```

Use the real eval names and counts.

## Rules

- This command never calls an LLM
- This command never edits generated outputs
- Run each eval independently; one failing eval must not stop the rest
- Use exit code `0` only when every eval passes
- Use exit code `1` when any eval fails
- Keep output deterministic so it can be diffed in CI
