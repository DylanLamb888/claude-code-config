# Preflight

Run all verification checks before committing.

## Instructions

Run these in sequence, stop on first failure:

### 1. Type Check
```bash
npm run typecheck || bun run typecheck || npx tsc --noEmit
```

### 2. Lint
```bash
npm run lint || bun run lint
```

### 3. Tests
```bash
npm test || bun run test
```

### 4. Build
```bash
npm run build || bun run build
```

## Reporting

- On failure: Show the error, identify root cause, suggest fix
- On success: Report "Preflight passed - ready to commit"
