---
description: Create git commits with user approval (context-efficient)
---

# Commit Changes

Spawn the `commit-handler` sub-agent to analyze changes and create a commit plan.

**Why sub-agent**: The analysis phase (git status, diff, log parsing) generates significant context. Running it in a sub-agent keeps the main context clean.

## Instructions

### Step 1: Get Commit Plan

Use the Task tool with:
- `subagent_type`: `commit-handler`
- `prompt`: Include context about the session's work:
  - What tasks were completed
  - What files were changed and why
  - Any grouping preferences

Example:
```
Task tool:
  subagent_type: commit-handler
  prompt: |
    Analyze changes and create a commit plan.

    Session context:
    - Task: [what was worked on]
    - Key changes: [summary of changes]
```

### Step 2: Present Plan to User

Show the sub-agent's commit plan to the user and ask for approval:
- Display the recommended commits with files and messages
- Ask: "Shall I proceed with these commits?"

### Step 3: Execute (After Approval)

Once user confirms, execute the git commands from the plan:
1. `git add [files]` for each commit
2. `git commit -m "[message]"`
3. Show `git log --oneline -n [N]` to confirm

## Critical Rules

- Always get user approval before executing commits
- Never use `git add -A` or `git add .`
- No AI attribution in commit messages
