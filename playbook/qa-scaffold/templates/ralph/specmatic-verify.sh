#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

BASE_URL="${SPECMATIC_BASE_URL:-http://127.0.0.1:3000}"
REPORT="${SPECMATIC_REPORT:-ralph/specmatic-report.json}"
SPEC_PATH="${SPECMATIC_SPEC:-}"

if [ ! -f "./qa/completeness/specmatic-ci.mjs" ]; then
  echo "ERROR: ./qa/completeness/specmatic-ci.mjs not found. Run /playbook:install-qa-harness first." >&2
  exit 1
fi

ARGS=(--root . --base-url "$BASE_URL" --out "$REPORT")
if [ -n "$SPEC_PATH" ]; then
  ARGS+=(--spec "$SPEC_PATH")
fi

node ./qa/completeness/specmatic-ci.mjs "${ARGS[@]}"
