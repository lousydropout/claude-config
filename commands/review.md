---
description: Review code against Agent OS standards (global and project-level)
---

# Code Review

Review code against the standards defined in your Agent OS skills.

## Usage

The user may provide:
- **A file path**: Review a specific file
- **A directory**: Review all relevant files in directory
- **A scope keyword**: `frontend`, `backend`, `tests`, `all`
- **Nothing**: Review recent changes (`git diff`)

## Instructions

### Step 1: Determine Target

Parse the user's request to identify what to review:

```
/review                     → Review git diff (uncommitted changes)
/review src/components/     → Review all components
/review src/machines/foo.ts → Review specific file
/review frontend            → Review src/components + src/machines
/review backend             → Review server/ or backend/ or api/
/review tests               → Review **/*.test.* files
/review all                 → Full codebase review (use sparingly)
```

### Step 2: Spawn Reviewer Agent

Use the Task tool with:
- `subagent_type`: `code-reviewer`
- `prompt`: Include the target files and any context

Example:
```
Task tool:
  subagent_type: code-reviewer
  prompt: |
    Review the following files against Agent OS standards:

    Target: [path or scope]
    Files: [list files if specific, or describe scope]

    Context: [any relevant session context]
```

### Step 3: Present Findings

Show the review findings to the user:
- Summarize critical issues first
- Group by severity (Critical → Warning → Suggestion)
- Include specific file:line references
- Show compliance scores

### Step 4: Offer Actions

After presenting findings, offer to help:
- "Would you like me to fix the critical issues?"
- "Should I create a todo list from these findings?"

## Scope Mappings

| Keyword | Directories | Standards Applied |
|---------|-------------|-------------------|
| `frontend` | `src/components/`, `src/machines/`, `src/utils/` | MVVM pattern, state machines |
| `backend` | `server/`, `backend/`, `api/`, `src/api/` | API, models, queries |
| `tests` | `**/__tests__/`, `**/*.test.*`, `**/*.spec.*` | Test writing standards |
| `styles` | `**/*.css`, `**/*.scss`, `src/styles/` | CSS standards |
| `all` | Entire `src/` directory | All applicable standards |

## MVVM Layer Review

When reviewing frontend code, the reviewer checks layer separation:

| Layer | Files | Key Checks |
|-------|-------|------------|
| View | `*View.tsx` | No hooks, props only, pure rendering |
| ViewController | `[Feature].tsx` | useMachine, derives props, no business logic |
| ViewModel | `*.machine.ts` | XState v5, no React imports |
| Model | `utils/*.ts` | Framework-agnostic, pure logic |

## Quick Review (Default)

When no target specified, review uncommitted changes:

```bash
git diff --name-only  # Get changed files
git diff              # Get actual changes
```

This provides a focused review of work-in-progress.

## Example Output

```
## Review Summary

**Scope**: src/components/UserProfile.tsx
**Standards Applied**: frontend-components, global-coding-style, global-error-handling

## Findings

### Critical Issues (1)
- `UserProfile.tsx:45`: API call directly in component (violates frontend-components)

### Warnings (2)
- `UserProfile.tsx:12`: Missing error boundary consideration
- `UserProfile.tsx:67`: Complex logic should be in machine

### Suggestions (1)
- `UserProfile.tsx:30`: Could use more descriptive variable name

## Compliance Score: 6/10

Would you like me to fix the critical issue by moving the API call to an XState machine?
```
