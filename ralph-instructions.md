# Ralph Autonomous Coding Instructions

When running as part of a Ralph loop, follow these guidelines.

## One Task Per Iteration
- Work on exactly ONE user story per iteration
- Complete it fully before stopping
- Let the next iteration handle the next story

## Feedback Loops Are Mandatory
Before committing, always run:
1. **TypeScript**: `npm run typecheck` or `tsc --noEmit`
2. **Tests**: `npm test` or the project's test command
3. **Lint**: `npm run lint` or the project's lint command

Never commit if any check fails. Fix issues first.

For language-specific commands, see `~/.claude/feedback-loops.md`

## Enforcing Feedback Loops with Husky

When starting a Ralph session on a Node.js/TypeScript project, read `~/.claude/husky-setup.md` and set up Husky if not already configured. This makes feedback loops automatic - git blocks commits if checks fail.

## Progress Documentation
Always append to `progress.txt` (never replace):
- What was implemented
- Files changed
- Key decisions and why
- Learnings for future iterations

## AGENTS.md Updates
When you discover genuinely reusable knowledge:
- Add it to the appropriate AGENTS.md (project root or directory-level)
- Include: API patterns, testing approaches, configuration, gotchas
- Exclude: Story-specific details, temporary notes

## Completion Signal
When ALL user stories have `passes: true`, output exactly:
```
<promise>COMPLETE</promise>
```
