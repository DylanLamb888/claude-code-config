#!/bin/bash
# Pre-commit test hook: Runs tests before allowing commits
# Exit code 2 = Block the commit if tests fail

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Only intercept git commit commands
if [[ ! $command == *"git commit"* ]]; then
  exit 0
fi

# Check if package.json exists (indicates a Node.js project)
if [[ ! -f "package.json" ]]; then
  exit 0
fi

# Check if test script exists
if ! grep -q '"test"' package.json 2>/dev/null; then
  exit 0
fi

echo "🧪 Running tests before commit..." >&2

# Run tests and capture result
if npm test 2>&1 | tail -20; then
  echo "✓ Tests passed!" >&2
  exit 0
else
  echo "" >&2
  echo "❌ Tests failed - commit blocked" >&2
  echo "Please fix the failing tests before committing." >&2
  exit 2
fi
