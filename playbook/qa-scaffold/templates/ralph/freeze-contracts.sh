#!/usr/bin/env bash
# freeze-contracts.sh — frozen per-story success contracts (DEC-005)
#
# Compiles each prd.json story into ralph/contracts/<story-id>.contract.md
# BEFORE the build loop runs, and records its sha256 in
# ralph/contracts/manifest.sha256. The judge (judge.sh, tier T0) fails any
# story whose contract file no longer matches the frozen hash — the builder
# cannot renegotiate "done" mid-run.
#
# Freezing is append-only: stories already in the manifest are never
# re-generated, even if prd.json changed. A legitimate contract fix requires
# an explicit human-signed refreeze:
#
#   FREEZE_ACK=<story-id> ./ralph/freeze-contracts.sh --refreeze <story-id>
#
# Usage:
#   ./ralph/freeze-contracts.sh             # freeze stories not yet frozen
#   ./ralph/freeze-contracts.sh --verify [story-id]   # check hashes (judge uses this)
#   ./ralph/freeze-contracts.sh --status    # list frozen / unfrozen / mismatched
#   ./ralph/freeze-contracts.sh --refreeze <story-id>  # requires FREEZE_ACK
#
# Exit codes: 0 ok, 1 verification mismatch / error, 2 refreeze not acked.

set -euo pipefail
cd "$(dirname "$0")/.."

PRD=ralph/prd.json
CONTRACTS_DIR=ralph/contracts
MANIFEST=$CONTRACTS_DIR/manifest.sha256
FREEZE_LOG=$CONTRACTS_DIR/freeze-log.jsonl

if [ ! -f "$PRD" ]; then
  echo "ERROR: $PRD not found. Run /playbook:prd-to-ralph first." >&2
  exit 1
fi

mkdir -p "$CONTRACTS_DIR"
touch "$MANIFEST"

MODE="${1:-freeze}"
ARG="${2:-}"

sha_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

# Render a deterministic contract for one story id to stdout.
render_contract() {
  python3 - "$1" <<'PY'
import json, re, sys

sid = sys.argv[1]
prd = json.load(open('ralph/prd.json'))
story = next((s for s in prd if s.get('id') == sid), None)
if story is None:
    sys.exit(f"ERROR: story '{sid}' not found in ralph/prd.json")

def section(text, heading):
    m = re.search(rf'## {re.escape(heading)}\s*\n(.*?)(?=\n## |\Z)', text or '', re.DOTALL)
    return m.group(1).strip() if m else ''

behavior = story.get('behavior', '')
acceptance = section(behavior, 'Acceptance Criteria')
out_of_scope = section(behavior, 'Out of Scope — DO NOT BUILD THESE') or section(behavior, 'Out of Scope')
escalation = section(behavior, 'Escalation Conditions — STOP AND ABORT IF') or section(behavior, 'Escalation Conditions')
anchors = section(behavior, 'Verification Anchors')
tests = story.get('fail_to_pass', [])

lines = []
lines.append(f"# Contract: {sid}")
lines.append("")
lines.append(story.get('description', '(no description)').strip())
lines.append("")
lines.append("## Done Means — ALL Must Be True")
lines.append("")
n = 1
if tests:
    lines.append(f"{n}. These tests exist and pass:")
    for t in tests:
        lines.append(f"   - {t}")
    n += 1
lines.append(f"{n}. `npx tsc --noEmit` exits 0"); n += 1
lines.append(f"{n}. `npm run lint --if-present` exits 0"); n += 1
lines.append(f"{n}. A git commit with prefix \"RALPH: {sid}\" exists"); n += 1
if acceptance:
    lines.append(f"{n}. Every acceptance criterion below is satisfied:")
    lines.append("")
    lines.append(acceptance)
lines.append("")
if out_of_scope:
    lines.append("## Out of Scope — DO NOT BUILD")
    lines.append("")
    lines.append(out_of_scope)
    lines.append("")
if escalation:
    lines.append("## Escalation — STOP AND ABORT IF")
    lines.append("")
    lines.append(escalation)
    lines.append("")
if anchors:
    lines.append("## Verification Anchors")
    lines.append("")
    lines.append(anchors)
    lines.append("")
lines.append("## Immutability")
lines.append("")
lines.append("This contract was frozen before the build started. It cannot be")
lines.append("edited during a run. If it is wrong, a human must re-freeze it:")
lines.append(f"`FREEZE_ACK={sid} ./ralph/freeze-contracts.sh --refreeze {sid}`")
print("\n".join(lines))
PY
}

manifest_hash() {
  awk -v id="$1" '$2 == id {print $1}' "$MANIFEST" | tail -n 1
}

log_event() {
  printf '{"event":"%s","story_id":"%s","sha256":"%s","timestamp":"%s"}\n' \
    "$1" "$2" "$3" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$FREEZE_LOG"
}

all_story_ids() {
  python3 -c "import json; print('\n'.join(s['id'] for s in json.load(open('$PRD')) if s.get('id')))"
}

freeze_one() {
  local sid="$1"
  local file="$CONTRACTS_DIR/$sid.contract.md"
  if [ -n "$(manifest_hash "$sid")" ]; then
    return 0  # already frozen — append-only, never regenerate
  fi
  render_contract "$sid" > "$file"
  local hash
  hash=$(sha_file "$file")
  printf '%s  %s\n' "$hash" "$sid" >> "$MANIFEST"
  log_event "freeze" "$sid" "$hash"
  echo "[freeze] $sid frozen ($hash)"
}

verify_one() {
  local sid="$1"
  local file="$CONTRACTS_DIR/$sid.contract.md"
  local expected
  expected=$(manifest_hash "$sid")
  if [ -z "$expected" ]; then
    echo "[verify] $sid: NOT FROZEN (no manifest entry)" >&2
    return 1
  fi
  if [ ! -f "$file" ]; then
    echo "[verify] $sid: contract file MISSING" >&2
    return 1
  fi
  local actual
  actual=$(sha_file "$file")
  if [ "$actual" != "$expected" ]; then
    echo "[verify] $sid: HASH MISMATCH — contract was modified after freezing" >&2
    echo "[verify]   frozen:  $expected" >&2
    echo "[verify]   current: $actual" >&2
    return 1
  fi
  return 0
}

# Commit the contracts dir in its own FREEZE commit. This keeps contract
# files out of builder/QA story commits — so judge.sh's locked-path rule
# only fires when an agent actually modified a frozen contract.
commit_contracts() {
  local msg="$1"
  if ! git diff --quiet -- "$CONTRACTS_DIR" 2>/dev/null \
     || [ -n "$(git status --porcelain -- "$CONTRACTS_DIR" 2>/dev/null)" ]; then
    git add "$CONTRACTS_DIR"
    git commit -q -m "$msg" -- "$CONTRACTS_DIR" 2>/dev/null \
      || git commit -q -m "$msg" 2>/dev/null || true
  fi
}

case "$MODE" in
  freeze)
    COUNT=0
    while IFS= read -r sid; do
      [ -z "$sid" ] && continue
      if [ -z "$(manifest_hash "$sid")" ]; then
        freeze_one "$sid"
        COUNT=$((COUNT + 1))
      fi
    done < <(all_story_ids)
    TOTAL=$(all_story_ids | wc -l | tr -d ' ')
    if [ "$COUNT" -gt 0 ]; then
      commit_contracts "FREEZE: $COUNT story contracts"
    fi
    echo "[freeze] done — $COUNT newly frozen, $TOTAL total stories"
    ;;

  --verify)
    if [ -n "$ARG" ]; then
      verify_one "$ARG"
    else
      FAIL=0
      while IFS= read -r sid; do
        [ -z "$sid" ] && continue
        verify_one "$sid" || FAIL=1
      done < <(all_story_ids)
      exit "$FAIL"
    fi
    ;;

  --status)
    while IFS= read -r sid; do
      [ -z "$sid" ] && continue
      if [ -z "$(manifest_hash "$sid")" ]; then
        echo "UNFROZEN   $sid"
      elif verify_one "$sid" >/dev/null 2>&1; then
        echo "FROZEN     $sid"
      else
        echo "MISMATCH   $sid"
      fi
    done < <(all_story_ids)
    ;;

  --refreeze)
    if [ -z "$ARG" ]; then
      echo "ERROR: --refreeze requires a story id." >&2
      exit 1
    fi
    if [ "${FREEZE_ACK:-}" != "$ARG" ]; then
      echo "ERROR: refreeze of '$ARG' not acknowledged." >&2
      echo "A human must sign off: FREEZE_ACK=$ARG $0 --refreeze $ARG" >&2
      exit 2
    fi
    FILE="$CONTRACTS_DIR/$ARG.contract.md"
    OLD_HASH=$(manifest_hash "$ARG")
    render_contract "$ARG" > "$FILE"
    NEW_HASH=$(sha_file "$FILE")
    # Rewrite manifest without the old entry, then append the new one.
    grep -v "  $ARG\$" "$MANIFEST" > "$MANIFEST.tmp" || true
    mv "$MANIFEST.tmp" "$MANIFEST"
    printf '%s  %s\n' "$NEW_HASH" "$ARG" >> "$MANIFEST"
    log_event "refreeze" "$ARG" "$NEW_HASH"
    commit_contracts "FREEZE: refreeze $ARG (human-acked)"
    echo "[refreeze] $ARG re-frozen (old: ${OLD_HASH:-none}, new: $NEW_HASH)"
    ;;

  *)
    echo "Usage: $0 [freeze | --verify [story-id] | --status | --refreeze <story-id>]" >&2
    exit 1
    ;;
esac
