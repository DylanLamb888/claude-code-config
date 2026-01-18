# PRD Generation Skill

Generate a structured Product Requirements Document for Ralph autonomous coding loops.

## Instructions

Help the user create a PRD for their feature. Follow this process:

### Step 1: Gather Requirements

Ask the user about their feature:
1. What is the feature name and high-level goal?
2. What are the main capabilities or behaviors needed?
3. Are there any technical constraints or preferences?
4. What does "done" look like?

### Step 2: Explore the Codebase

Before writing the PRD:
- Understand the existing architecture
- Identify relevant files and patterns
- Note any dependencies or integration points
- Check for existing AGENTS.md files

### Step 3: Break Down into User Stories

Create user stories that are:
- **Right-sized**: Completable in a single context window
- **Specific**: Clear acceptance criteria
- **Ordered**: Dependencies reflected in priority
- **Testable**: Verifiable completion

Good story size examples:
- "Add database column and migration"
- "Create API endpoint for X"
- "Add UI component to page Y"

Bad story size examples:
- "Build the dashboard" (too vague)
- "Implement entire auth system" (too large)

### Step 4: Write the PRD

Create a markdown file at `tasks/prd-[feature-name].md` with this structure:

```markdown
# [Feature Name]

## Overview
[2-3 sentence description of the feature and its value]

## Branch
`ralph/[feature-name]`

## User Stories

### US-001: [Story Title]
**Priority:** 1
**Description:** As a [user type], I want [capability] so that [benefit].

**Acceptance Criteria:**
- [ ] [Specific, testable criterion]
- [ ] [Another criterion]
- [ ] Typecheck passes
- [ ] Tests pass

**Notes:** [Any implementation hints or constraints]

---

### US-002: [Story Title]
...
```

### Step 5: Confirm with User

Show the PRD to the user and ask:
1. Does this capture all requirements?
2. Are the stories right-sized?
3. Is the priority order correct?
4. Anything missing?

Make revisions based on feedback.

### Step 6: Next Steps

Tell the user:
1. PRD saved to `tasks/prd-[feature-name].md`
2. To convert to JSON for Ralph: run `/ralph` command
3. To start HITL loop: `~/.claude/ralph/ralph-once.sh prd.json`
4. To start AFK loop: `~/.claude/ralph/afk-ralph.sh 50 prd.json`

## Quality Checklist

Before finalizing, verify:
- [ ] Each story fits in one context window
- [ ] Acceptance criteria are specific and testable
- [ ] Priorities reflect dependencies
- [ ] Risky/architectural work is prioritized first
- [ ] Feedback loops (typecheck, test, lint) are in criteria
- [ ] Branch name follows `ralph/` convention
