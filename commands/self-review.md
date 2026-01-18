# Self Review

Review staged/unstaged changes before committing.

## Instructions

1. Run `git diff` to see unstaged changes
2. Run `git diff --cached` to see staged changes

3. Check for common issues:
   - Unused imports
   - Console.log statements (unless intentional)
   - Hardcoded values that should be config
   - Missing error handling
   - TODO comments without context
   - Commented-out code
   - Type `any` that could be specific
   - Missing null checks

4. Report findings:
   - List each issue with file and line
   - Suggest fixes
   - If clean: confirm ready to commit
