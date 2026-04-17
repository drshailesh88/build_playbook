#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

OUT="${1:-ralph/completeness-is-list.json}"
EVIDENCE="${2:-ralph/completeness-evidence.json}"

if [ ! -f "./qa/completeness/extract-is.mjs" ]; then
  echo "ERROR: ./qa/completeness/extract-is.mjs not found. Run /playbook:install-qa-harness first." >&2
  exit 1
fi

node ./qa/completeness/extract-is.mjs --root . --out "$OUT" --evidence "$EVIDENCE"
