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

  # Run Aider on the next requirement
  aider --model "$MODEL" \
        --read .planning/REQUIREMENTS.md \
        --read .planning/ROADMAP.md \
        --auto-commits \
        --message "Read .planning/REQUIREMENTS.md. Find this unchecked requirement: $NEXT
Build ONLY this one requirement. Write code and tests.
After building, check the box in REQUIREMENTS.md by changing [ ] to [x].
Run any available test commands to verify your work." \
        --yes 2>&1 | tee -a progress.txt

  # Log progress
  echo "[$i] $(date): Worked on: $NEXT" >> progress.txt

  # Check if tests pass
  if npm test 2>/dev/null; then
    echo "[$i] Tests passed" >> progress.txt
  else
    echo "[$i] Tests failed — may need review" >> progress.txt
  fi
done

echo ""
echo "=== Overnight build complete ==="
echo "Iterations run: $i"
echo "Review: git log --oneline $BRANCH"
echo "Progress: cat progress.txt"
