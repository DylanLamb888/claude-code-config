#!/bin/bash
# Security hook: Prevents commits containing sensitive data patterns
# Exit code 2 = Block the action, Claude sees the error message

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Only check git commit commands
if [[ ! $command == *"git"* ]] || [[ ! $command == *"commit"* ]]; then
  exit 0
fi

# Patterns that indicate sensitive data
patterns=(
  "\.env"
  "STRIPE_SECRET"
  "STRIPE_KEY"
  "PRIVATE_KEY"
  "DATABASE_URL"
  "API_KEY"
  "API_SECRET"
  "SECRET_KEY"
  "AWS_SECRET"
  "GITHUB_TOKEN"
  "password="
  "passwd="
)

for pattern in "${patterns[@]}"; do
  if echo "$command" | grep -qi "$pattern"; then
    echo "Warning: Blocked commit - command references sensitive data pattern: $pattern" >&2
    echo "Please ensure no secrets are included in your commit." >&2
    exit 2
  fi
done

exit 0
