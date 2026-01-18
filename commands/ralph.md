# Ralph PRD Conversion Skill

Convert a markdown PRD into JSON format for Ralph autonomous coding loops.

## Instructions

### Step 1: Find the PRD

If the user doesn't specify a file:
1. Check for markdown files in `tasks/` directory
2. Look for files matching `prd-*.md` pattern
3. Ask user to confirm which PRD to convert

### Step 2: Parse the Markdown PRD

Extract from the markdown:
- Project name (from title)
- Branch name (from Branch section or generate as `ralph/[feature-name]`)
- Description (from Overview section)
- User stories with:
  - ID (US-001, US-002, etc.)
  - Title
  - Description
  - Acceptance criteria
  - Priority
  - Notes

### Step 3: Generate JSON

Create `prd.json` in the project root with this structure:

```json
{
  "project": "[Project Name]",
  "branchName": "ralph/[feature-name]",
  "description": "[Overview description]",
  "userStories": [
    {
      "id": "US-001",
      "title": "[Story Title]",
      "description": "[Full description]",
      "acceptanceCriteria": [
        "[Criterion 1]",
        "[Criterion 2]",
        "Typecheck passes",
        "Tests pass"
      ],
      "priority": 1,
      "passes": false,
      "notes": "[Any notes or empty string]"
    }
  ]
}
```

### Step 4: Validate

Check the generated JSON:
- [ ] All stories have unique IDs
- [ ] Priorities are sequential (1, 2, 3...)
- [ ] All stories have `passes: false`
- [ ] Acceptance criteria include feedback loops
- [ ] Branch name follows convention

### Step 5: Create Supporting Files

If they don't exist, create:

**progress.txt:**
```
# Ralph Progress Log
Created: [timestamp]
PRD: prd.json
Branch: [branchName]

```

### Step 6: Output Summary

Tell the user:
```
PRD converted successfully!

File: prd.json
Stories: [count]
Branch: [branchName]

To start Ralph:
  HITL:  ~/.claude/ralph/ralph-once.sh
  AFK:   ~/.claude/ralph/afk-ralph.sh 50

The loop will:
1. Create/switch to branch: [branchName]
2. Work through stories in priority order
3. Commit after each completed story
4. Update prd.json and progress.txt
```

## Example Conversion

**Input (tasks/prd-dark-mode.md):**
```markdown
# Dark Mode Toggle

## Overview
Add dark mode support to the application settings.

## Branch
`ralph/dark-mode`

## User Stories

### US-001: Add theme state management
**Priority:** 1
**Description:** As a developer, I need theme state so components can respond to theme changes.

**Acceptance Criteria:**
- [ ] Create ThemeContext with light/dark values
- [ ] Persist preference to localStorage
- [ ] Typecheck passes
```

**Output (prd.json):**
```json
{
  "project": "Dark Mode Toggle",
  "branchName": "ralph/dark-mode",
  "description": "Add dark mode support to the application settings.",
  "userStories": [
    {
      "id": "US-001",
      "title": "Add theme state management",
      "description": "As a developer, I need theme state so components can respond to theme changes.",
      "acceptanceCriteria": [
        "Create ThemeContext with light/dark values",
        "Persist preference to localStorage",
        "Typecheck passes"
      ],
      "priority": 1,
      "passes": false,
      "notes": ""
    }
  ]
}
```
