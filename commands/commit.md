---
description: Create git commits with user approval (context-efficient)
---

# Commit Changes

Spawn the `commit-handler` sub-agent to analyze changes and create a commit plan with **hunk-level granularity**.

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

The sub-agent will:
1. Analyze changes at the **hunk level** (individual code sections)
2. Group related hunks across files into logical commits
3. Create patch files in `/tmp/commits/` for each commit
4. Return a structured plan

### Step 2: Present Plan to User

Show the sub-agent's commit plan to the user and ask for approval:
- Display the recommended commits with **specific line ranges/hunks**
- Show which parts of files go into which commit
- Ask: "Shall I proceed with these commits?"

### Step 3: Execute (After Approval)

Once user confirms, execute commits using the patch files:

```bash
# For each commit:
git apply --cached /tmp/commits/commit-1.patch
git commit -m "[message]"

git apply --cached /tmp/commits/commit-2.patch
git commit -m "[message]"

# Verify and cleanup
git log --oneline -n [N]
rm -rf /tmp/commits
```

**Alternative for simple cases** (entire file belongs to one commit):
```bash
git add path/to/file.ts
git commit -m "[message]"
```

### Step 4: Handle Remaining Changes

After all commits, check for any remaining unstaged changes:
```bash
git status
git diff
```

If changes remain, either:
- Create another commit for them
- Ask user if they should be left uncommitted

## Critical Rules

- Always get user approval before executing commits
- Never use `git add -A` or `git add .`
- No AI attribution in commit messages
- Cherry-pick at hunk level when a file contains multiple unrelated changes
- Use whole-file staging only when ALL changes in a file belong together
