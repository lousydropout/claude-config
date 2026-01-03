---
description: Create git commits with user approval and no Claude attribution
---

# Commit Changes

Your task is to create git commits for the changes made during this session with **hunk-level granularity**. Cherry-pick specific sections of code into logical commits rather than staging entire files.

## Why This Matters

You have the full context of what was accomplished in this session. The user trusts your judgment to organize changes into logical commits with clear messages. Your goal is to create a clean git history that accurately represents the work done—even when a single file contains multiple unrelated changes.

## Step 1: Analyze Changes (Make Parallel Calls)

Execute these git commands in parallel to understand the current state:
- Run `git status` to see all staged and unstaged changes
- Run `git diff --no-color` to view the actual modifications with hunk boundaries
- Run `git log --oneline -5` to see recent commit style

While reviewing the diff, identify individual **hunks** (sections marked by `@@` lines). Each hunk is a discrete change that can be staged independently.

## Step 2: Plan Commit Strategy (Hunk-Level)

Based on your analysis, determine:
- **Logical grouping at hunk level**: Which hunks belong together based on purpose
  - A single file may have hunks belonging to different commits
  - Multiple files may have hunks belonging to the same commit
- **Atomic commits**: Each commit = one complete, coherent change
- **Commit messages**: Write in imperative mood, focus on WHY and WHAT

## Step 3: Present Plan for Approval

Show the user your commit strategy with specific line ranges:

```
I plan to create [N] commit(s):

Commit 1: [Commit message]
Changes:
- `path/to/file1.ts`: Lines 10-25 (validation logic)
- `path/to/file1.ts`: Lines 100-105 (related error handling)
- `path/to/file2.ts`: Full file

Commit 2: [Commit message]
Changes:
- `path/to/file1.ts`: Lines 50-60 (refactor helper)
- `path/to/file3.ts`: Full file

Shall I proceed with these commits?
```

## Step 4: Execute Commits

Once the user confirms:

**For hunk-level staging** (when file has mixed changes):
1. Create patch files in `/tmp/commits/` containing only relevant hunks
2. Apply each patch: `git apply --cached /tmp/commits/commit-N.patch`
3. Commit: `git commit -m "message"`

**For whole-file staging** (when all changes in file belong together):
1. Add files: `git add [file1] [file2]`
2. Commit: `git commit -m "message"`

After all commits:
3. Run `git log --oneline -n [number]` to show created commits
4. Run `git status` to verify no unexpected changes remain
5. Cleanup: `rm -rf /tmp/commits`

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