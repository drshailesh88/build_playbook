#!/bin/bash
# Simple overnight build loop using Aider
# Usage: ./overnight.sh [iterations] [model]
# Example: ./overnight.sh 20 glm-5

ITERATIONS=${1:-20}
MODEL=${2:-openai/glm-5}
BRANCH="overnight/$(date +%Y-%m-%d)"

echo "Starting overnight build: $ITERATIONS iterations with $MODEL"
echo "Branch: $BRANCH"

git checkout -b "$BRANCH" 2>/dev/null || git checkout "$BRANCH"

for ((i=1; i<=$ITERATIONS; i++)); do
  echo ""
  echo "=== Iteration $i/$ITERATIONS ==="
  echo ""

  # Find next unchecked requirement
  NEXT=$(grep -n "^- \[ \]" .planning/REQUIREMENTS.md | head -1)

  if [ -z "$NEXT" ]; then
    echo "All requirements complete!"
    break
  fi

  echo "Working on: $NEXT"

  # Run Aider WITHOUT auto-commits
  aider --model "$MODEL" \
        --read .planning/REQUIREMENTS.md \
        --read .planning/ROADMAP.md \
        --no-auto-commits \
        --message "Read .planning/REQUIREMENTS.md. Find this unchecked requirement: $NEXT
Build ONLY this one requirement. Write code and tests.
Do NOT check the box in REQUIREMENTS.md — the script handles that after verification.
Run any available test commands to verify your work." \
        --yes 2>&1 | tee -a progress.txt

  # Log progress
  echo "[$i] $(date): Worked on: $NEXT" >> progress.txt

  # Gate: only commit and mark complete if tests pass
  if npm test 2>/dev/null; then
    echo "[$i] Tests PASSED — committing and marking requirement complete" >> progress.txt
    # Check the box by line number
    REQ_LINE=$(echo "$NEXT" | cut -d: -f1)
    if [ -n "$REQ_LINE" ]; then
      sed -i '' "${REQ_LINE}s/- \[ \]/- [x]/" .planning/REQUIREMENTS.md
    fi
    git add -A
    git commit -m "feat: $(echo "$NEXT" | cut -d: -f2- | head -c 60) (overnight)" 2>/dev/null || true
  else
    echo "[$i] Tests FAILED — reverting all uncommitted changes" >> progress.txt
    git checkout -- . 2>/dev/null || true
    git clean -fd 2>/dev/null || true
  fi
done

echo ""
echo "=== Overnight build complete ==="
echo "Iterations run: $i"
echo "Review: git log --oneline $BRANCH"
echo "Progress: cat progress.txt"
