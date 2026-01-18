# Husky + lint-staged Setup

Enforce feedback loops automatically with git pre-commit hooks.

## Check if already set up

```bash
ls .husky/pre-commit 2>/dev/null && echo "Husky is set up" || echo "Husky not found"
```

## Installation

```bash
# Install dependencies
npm install --save-dev husky lint-staged prettier

# Initialize Husky
npx husky init

# Create pre-commit hook
cat > .husky/pre-commit << 'EOF'
npx lint-staged
npm run typecheck
npm test
EOF

# Create lint-staged config
cat > .lintstagedrc << 'EOF'
{
  "*": "prettier --ignore-unknown --write"
}
EOF
```

## What this does

- **Husky** - git hooks framework, blocks commits if checks fail
- **lint-staged** - runs formatters only on staged files (fast)
- **Prettier** - auto-formats code before commit
- **Pre-commit hook** runs: lint-staged → typecheck → tests

## Customization

Add ESLint to lint-staged:
```json
{
  "*": "prettier --ignore-unknown --write",
  "*.{js,jsx,ts,tsx}": "eslint --fix"
}
```

Skip tests for faster commits (not recommended for Ralph):
```bash
# In .husky/pre-commit, remove or comment out:
# npm test
```
