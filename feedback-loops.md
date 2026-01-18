# Feedback Loop Commands by Language

Run these before committing to catch errors early.

## Node.js/TypeScript
```bash
npm run typecheck  # or: npx tsc --noEmit
npm test
npm run lint
```

## Python
```bash
mypy .
pytest
ruff check .
```

## Go
```bash
go build ./...
go test ./...
golangci-lint run
```
