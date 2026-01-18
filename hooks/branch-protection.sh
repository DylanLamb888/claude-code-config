#!/bin/bash
# Branch protection hook: Prevents direct commits/pushes to main/master
# Exit code 2 = Block the action

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Only check git commit and push commands
if [[ ! $command == *"git commit"* ]] && [[ ! $command == *"git push"* ]]; then
  exit 0
fi

# Get current branch
current_branch=$(git branch --show-current 2>/dev/null)

# Protected branches
protected_branches=("main" "master" "production")

for branch in "${protected_branches[@]}"; do
  if [[ "$current_branch" == "$branch" ]]; then
    echo "⚠️  Branch protection: Cannot commit/push directly to '$branch'" >&2
    echo "Please create a feature branch first:" >&2
    echo "  git checkout -b feature/your-feature-name" >&2
    exit 2
  fi
done

exit 0
