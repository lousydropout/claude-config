---
description: Create git commits with user approval and no Claude attribution
---

# Commit Changes

Your task is to create git commits for the changes made during this session. The user wants you to take ownership of the commit process while maintaining their authorship.

## Why This Matters

You have the full context of what was accomplished in this session. The user trusts your judgment to organize changes into logical commits with clear messages. Your goal is to create a clean git history that accurately represents the work done.

## Step 1: Analyze Changes (Make Parallel Calls)

Execute these git commands in parallel to understand the current state:
- Run `git status` to see all staged and unstaged changes
- Run `git diff` to view the actual modifications
- Run `git log --oneline -5` to see recent commit style

While reviewing these results, also consider the conversation history to understand the purpose and scope of changes.

## Step 2: Plan Commit Strategy

Based on your analysis, determine:
- **Logical grouping**: Which files belong together based on their purpose (e.g., feature changes separate from test updates, frontend separate from backend)
- **Atomic commits**: Each commit should represent one complete, coherent change
- **Commit messages**: Write in imperative mood ("Add feature" not "Added feature"), focus on WHY the change was made and WHAT problem it solves

## Step 3: Present Plan for Approval

Show the user your commit strategy in this format:

```
I plan to create [N] commit(s):

Commit 1: [Commit message]
Files: [list of files]

Commit 2: [Commit message]
Files: [list of files]

Shall I proceed with these commits?
```

This preview ensures alignment before making irreversible changes.

## Step 4: Execute Commits

Once the user confirms:
1. Add specific files using `git add [file1] [file2]` (specify exact files, never use `-A` or `.` to maintain precise control)
2. Create each commit with `git commit -m "message"`
3. Run `git log --oneline -n [number]` to show the created commits
4. Confirm completion to the user

## Commit Message Format

Structure each commit message with:

### Subject Line (Required)
- Imperative mood: "Add", "Fix", "Update", "Remove"
- Concise summary (50-72 characters)

### Body (Required for non-trivial changes)
After a blank line, include:

1. **Why**: The problem being solved or goal being achieved
   - What motivated this change?
   - What wasn't working or what's being improved?

2. **Approach**: High-level strategy and architectural decisions
   - How does this solution work conceptually?
   - What design pattern or approach was chosen and why?
   - Any trade-offs considered?

3. **Key Changes**: What someone would need to understand to reproduce this
   - Core logic or algorithm changes (describe, don't paste code)
   - New abstractions or interfaces introduced
   - Integration points or dependencies affected
   - Configuration or behavior changes

### What NOT to Include
- Actual code snippets (unless absolutely crucial for understanding)
- Line-by-line change descriptions

### Example
```
Add rate limiting to API endpoints

Why: Users were experiencing throttling from upstream services due to
unbounded request rates during peak usage.

Approach: Implemented token bucket algorithm at the middleware level.
Chose this over fixed windows for better burst handling. Rate limits
are configurable per-endpoint via environment variables.

Key changes:
- RateLimiter middleware wraps all /api routes
- Token replenishment runs on configurable interval
- Exceeded limits return 429 with Retry-After header
- Limits stored in Redis for distributed deployments
```

## Critical Rules - Authorship

The commits must appear as if the user created them directly:
- Write commit messages in the user's voice
- Include ONLY the core commit message
- Omit any AI attribution, signatures, or co-author tags
- Do not add "Generated with Claude" or similar phrases
- Do not add "Co-Authored-By: Claude" or any co-author lines

**Why**: The user made the decisions and directed the work. Your role is to execute their intent, not to claim co-authorship. Clean git history maintains professional standards and avoids cluttering the repository with tool-specific metadata.