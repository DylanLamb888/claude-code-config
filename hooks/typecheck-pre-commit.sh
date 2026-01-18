#!/bin/bash
# Typecheck hook: Runs TypeScript check before allowing commits
# Exit code 2 = Block the commit if typecheck fails

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Only intercept git commit commands
if [[ ! $command == *"git commit"* ]]; then
  exit 0
fi

# Check if package.json exists
if [[ ! -f "package.json" ]]; then
  exit 0
fi

# Check if it's a TypeScript project
if [[ ! -f "tsconfig.json" ]]; then
  exit 0
fi

echo "🔍 Running typecheck before commit..." >&2

# Try different typecheck commands
if grep -q '"typecheck"' package.json 2>/dev/null; then
  result=$(npm run typecheck 2>&1)
elif grep -q '"type-check"' package.json 2>/dev/null; then
  result=$(npm run type-check 2>&1)
else
  result=$(npx tsc --noEmit 2>&1)
fi

if [[ $? -eq 0 ]]; then
  echo "✓ Typecheck passed!" >&2
  exit 0
else
  echo "$result" | tail -20 >&2
  echo "" >&2
  echo "❌ Typecheck failed - commit blocked" >&2
  echo "Please fix type errors before committing." >&2
  exit 2
fi
