# Playbook Evals

Each directory under `.quality/evals/` is one deterministic eval for a playbook command.

Required:
- `rules.txt` — one shell assertion per line. Blank lines and lines beginning with `#` are ignored.

Optional:
- `expected-files.txt` — one project-root-relative path per line. Every listed file must exist.
- `expected-schema.json` — JSON shape validation for command output. If no target file is specified, the eval defaults to `ralph/prd.json`.

Run:

```bash
/playbook:eval-check
```

Rules run from the project root and pass when they exit `0`. Evals are file-based and deterministic; they do not use LLM evaluation.
