#!/bin/bash
# Overnight build loop using Codex CLI
# Usage: ./overnight.sh [iterations]
# Example: ./overnight.sh 20

ITERATIONS=${1:-20}
BRANCH="codex/$(date +%Y-%m-%d)"

# Portable in-place sed (works on macOS and Linux)
portable_sed_i() {
  if [ "$(uname)" = "Darwin" ]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}

echo "Starting Codex overnight build: $ITERATIONS iterations"
echo "Branch: $BRANCH"
echo ""

git checkout -b "$BRANCH" 2>/dev/null || git checkout "$BRANCH"

# ─── SAFETY: Require clean working tree ──────────────────────────────────────
DIRTY=$(git status --porcelain 2>/dev/null | grep -v "^??" | wc -l | tr -d ' ')
if [ "$DIRTY" -gt 0 ]; then
  echo "Working tree has $DIRTY uncommitted changes. Commit or stash first."
  exit 1
fi

for ((i=1; i<=$ITERATIONS; i++)); do
  echo ""
  echo "=== Codex iteration $i/$ITERATIONS ==="
  echo ""

  # Find next unchecked requirement
  NEXT=$(grep -n "^- \[ \]" .planning/REQUIREMENTS.md | head -1)

  if [ -z "$NEXT" ]; then
    echo "All requirements complete!"
    break
  fi

  # Capture line number
  REQ_LINE=$(echo "$NEXT" | cut -d: -f1)
  REQ_TEXT=$(echo "$NEXT" | cut -d: -f2-)

  echo "Working on: $REQ_TEXT"

  # Snapshot untracked files
  ITER_UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | sort)

  # Run Codex — build only, do NOT commit or check boxes
  codex exec --full-auto \
    "Read .planning/STATE.md to find the current phase.
     Read .planning/REQUIREMENTS.md and find this requirement: $REQ_TEXT
     Read AGENTS.md for project rules.
     Build ONLY this one requirement. Write code and tests.
     Do NOT check the box in REQUIREMENTS.md.
     Do NOT commit.
     Run: npm test to verify your work." \
    || true

  # Script-level verification — don't trust Codex's judgment
  if npm test 2>/dev/null; then
    echo "[$i] Tests PASSED — committing" >> progress.txt

    # Check the box by line number (portable)
    portable_sed_i "${REQ_LINE}s/- \[ \]/- [x]/" .planning/REQUIREMENTS.md

    # Stage only changed + new files
    CHANGED=$(git diff --name-only 2>/dev/null)
    NEW_FILES=$(git ls-files --others --exclude-standard 2>/dev/null | sort | comm -13 <(echo "$ITER_UNTRACKED") - 2>/dev/null)
    [ -n "$CHANGED" ] && echo "$CHANGED" | xargs git add 2>/dev/null || true
    [ -n "$NEW_FILES" ] && echo "$NEW_FILES" | xargs git add 2>/dev/null || true
    git add .planning/REQUIREMENTS.md progress.txt 2>/dev/null || true
    git commit -m "feat: $(echo "$REQ_TEXT" | head -c 60) (overnight)" 2>/dev/null || true
  else
    echo "[$i] Tests FAILED — reverting" >> progress.txt
    CHANGED=$(git diff --name-only 2>/dev/null)
    [ -n "$CHANGED" ] && echo "$CHANGED" | xargs git checkout -- 2>/dev/null || true
    NEW_FILES=$(git ls-files --others --exclude-standard 2>/dev/null | sort | comm -13 <(echo "$ITER_UNTRACKED") - 2>/dev/null)
    [ -n "$NEW_FILES" ] && echo "$NEW_FILES" | xargs rm -f 2>/dev/null || true
  fi

  # Log progress
  echo "[$i] $(date): Worked on: $REQ_TEXT" >> progress.txt
  echo "" >> progress.txt
done

echo ""
echo "=== Overnight build complete ==="
echo "Iterations: $i/$ITERATIONS"
echo "Review: git log --oneline $BRANCH"
echo "Progress: cat progress.txt"
echo "Diff from main: git diff main..$BRANCH --stat"
