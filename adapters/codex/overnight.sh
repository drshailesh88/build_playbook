#!/bin/bash
# Overnight build loop using Codex CLI
# Usage: ./overnight.sh [iterations]
# Example: ./overnight.sh 20

ITERATIONS=${1:-20}
BRANCH="codex/$(date +%Y-%m-%d)"

echo "Starting Codex overnight build: $ITERATIONS iterations"
echo "Branch: $BRANCH"
echo ""

git checkout -b "$BRANCH" 2>/dev/null || git checkout "$BRANCH"

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

  echo "Working on: $NEXT"

  # Run Codex in full-auto mode
  codex exec --full-auto \
    "Read .planning/STATE.md to find the current phase.
     Read .planning/REQUIREMENTS.md and find this requirement: $NEXT
     Build ONLY this one requirement following the instructions in AGENTS.md.
     Write code and tests. Run npm run typecheck && npm test to verify.
     If tests pass, check the box [x] in REQUIREMENTS.md and commit.
     If tests fail, try to fix (max 2 attempts). If still failing,
     add a <!-- BLOCKED: reason --> comment and move on." \
    2>&1 | tee -a progress.txt

  # Log progress
  echo "[$i] $(date): Worked on: $NEXT" >> progress.txt
  echo "" >> progress.txt
done

echo ""
echo "=== Overnight build complete ==="
echo "Iterations: $i/$ITERATIONS"
echo "Review: git log --oneline $BRANCH"
echo "Progress: cat progress.txt"
echo "Diff from main: git diff main..$BRANCH --stat"
