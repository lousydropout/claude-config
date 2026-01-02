---
description: Create handoff document for transferring work to another session
---

# Create Handoff

Create a handoff document that enables seamless work transfer to another agent in a new session. The handoff must be thorough yet concise, preserving all key details while compacting context for efficient resumption.

**Why this matters**: Handoffs enable continuity across sessions. A well-crafted handoff allows the next agent to resume work immediately without redundant exploration or losing critical context.

## Context for Fresh Sessions

**IMPORTANT**: This command may be run during any session. This section ensures you have the context needed to create a useful handoff.

### Directory Structure

**Agent OS (check first):**
```
agent-os/specs/[current-spec]/
├── spec.md              # Current specification
├── tasks.md             # Task breakdown with checkboxes
└── planning/
    ├── requirements.md  # Requirements document
    └── visuals/         # Mockups, screenshots
```

**Thoughts (fallback):**
```
thoughts/shared/
├── handoffs/     # Handoff documents organized by ticket
│   ├── ENG-XXXX/ # Ticket-specific directories
│   └── general/  # Non-ticket handoffs
├── plans/        # Implementation plans to reference
└── research/     # Research documents to reference
```

### Key Tools

- **Read**: Review current work, plans, and research documents
- **Bash**: Run git commands to get metadata (commit hash, branch, timestamp)
- **Write**: Create the handoff document
- **TodoWrite**: Summarize task progress

### Related Commands

- `/resume_handoff path/to/handoff.md` - How the next session will resume
- `/create_plan` - Plans that should be referenced in handoffs
- `/implement_plan` - Implementation that should be documented

## Process

### 1. Gather Metadata & Determine Filepath

Execute these tasks in parallel to gather all necessary information:
- Run `git log -1 --format='%H'` to get the current commit hash
- Run `git branch --show-current` to get the current branch name
- Run `date -Iseconds` to get the current timestamp in ISO format
- Identify the ticket number from context (if present)
- Determine the repository name

Construct the filepath following this pattern:
`thoughts/shared/handoffs/ENG-XXXX/YYYY-MM-DD_HH-MM-SS_ENG-ZZZZ_description.md`

**Ensure directory exists**: Before writing the handoff, create the directory if needed:
```bash
mkdir -p thoughts/shared/handoffs/ENG-XXXX  # or 'general' if no ticket
```

**Filepath components**:
- `YYYY-MM-DD`: Today's date
- `HH-MM-SS`: Current time in 24-hour format (e.g., `13:00` for 1:00 PM)
- `ENG-XXXX`: Directory name - use ticket number or `general` if no ticket
- `ENG-ZZZZ`: In filename - include ticket number if present, otherwise omit entirely
- `description`: Brief kebab-case summary of the work

**Examples**:
- With ticket: `thoughts/shared/handoffs/ENG-2166/2025-01-08_13-55-22_ENG-2166_create-context-compaction.md`
- Without ticket: `thoughts/shared/handoffs/general/2025-01-08_13-55-22_create-context-compaction.md`

### 2. Check for Active Specs/Plans

Before writing the handoff, check if you are working from an Agent OS spec or implementation plan:

**Check Agent OS first** (run in parallel):
- Check if `agent-os/specs/` directory exists
- If it does, list subdirectories to find active specs
- For each active spec, read `spec.md` and `tasks.md` to determine status
- Look for checked `[x]` vs unchecked `[ ]` tasks to determine progress

**Fall back to thoughts/ plans**:
- Search `thoughts/shared/plans/` for plan documents matching the current ticket number
- Check the current session context for any plan document paths that were provided at session start
- Look for plan files in the current working directory or referenced in recent file reads

**Determine status**:
- **In Progress**: Actively implementing - note which tasks/phases are done vs remaining
- **Just Completed**: All tasks/phases finished - may need verification/testing
- **No Spec/Plan**: Working without a formal spec or plan (ad-hoc work, bug fixes, etc.)

**Record the following** (whichever source applies):

For Agent OS specs:
- Spec directory path (e.g., `agent-os/specs/user-auth/`)
- Completed tasks (count and list)
- Remaining tasks (count and list)
- Current task group being worked on

For thoughts/ plans:
- Absolute path to the plan document
- Current phase/step number and name
- Completion percentage or remaining items
- Any deviations from the plan

### 3. Write the Handoff Document

Create the handoff document at the filepath determined in step 1. Use the YAML frontmatter pattern followed by structured markdown content as shown in the template below.

**Why this structure**: The YAML frontmatter enables programmatic parsing and tracking, while the markdown sections provide human-readable context organized by priority and relevance.

Use the following template structure:
```markdown
---
date: [Current date and time with timezone in ISO format]
researcher: [Username from git config user.name or $USER]
git_commit: [Current commit hash]
branch: [Current branch name]
repository: [Repository name]
topic: "[Feature/Task Name] Implementation Strategy"
tags: [implementation, strategy, relevant-component-names]
status: complete
last_updated: [Current date in YYYY-MM-DD format]
last_updated_by: [Researcher name]
type: implementation_strategy
agent_os_spec: [Spec directory path, or null if not using Agent OS]
agent_os_tasks_completed: [Count of completed tasks, or null]
agent_os_tasks_remaining: [Count of remaining tasks, or null]
plan_path: [Absolute path to thoughts/ plan, or null if no plan]
plan_status: [in_progress | completed | null]
plan_phase: [Current phase/step name, or null if no plan]
---

# Handoff: ENG-XXXX {very concise description}

## Task(s)
Describe each task you were working on with its current status:
- **Completed**: Tasks finished and verified
- **In Progress**: Tasks started but not completed (specify what's done and what remains)
- **Planned/Discussed**: Tasks identified but not started

## Spec/Plan Status
**Include this section if working from an Agent OS spec or thoughts/ plan. Omit if neither exists.**

### If using Agent OS spec:

**Spec Directory**: `agent-os/specs/[spec-name]/`
**Status**: [In Progress | Just Completed]

**Task Progress**:
- Completed: [X] tasks
- Remaining: [Y] tasks
- Current task group: [e.g., "API Layer - Task Group 2"]

**Completed Tasks**:
- [x] Task 1.0: Description
- [x] Task 1.1: Description

**Remaining Tasks**:
- [ ] Task 2.0: Description
- [ ] Task 2.1: Description

### If using thoughts/ plan:

**Plan Document**: `[absolute/path/to/plan.md]`
**Status**: [In Progress | Just Completed]
**Current Phase**: [Phase X: Phase Name] (if in progress)

If **In Progress**:
- List completed phases/steps with checkmarks
- Indicate current phase and specific step within it
- List remaining phases/steps
- Note any blockers or deviations from the plan

If **Just Completed**:
- Confirm all phases are implemented
- Note any verification/testing still needed
- List any follow-up items identified during implementation

**Why this matters**: The next agent needs to know exactly where implementation stands to avoid re-doing work or skipping steps.

## Critical References
List 2-3 most important documents that define requirements, architecture, or design decisions. These are documents the next agent MUST read to understand constraints and requirements. Include absolute file paths.

**Purpose**: Prevents the next agent from making changes that violate established decisions or patterns.

## Recent Changes
List changes you made to the codebase using `file:line` syntax (e.g., `src/app.ts:45-60`). Focus on meaningful changes rather than minor formatting edits.

**Format**: `path/to/file.ext:line-range - Brief description of change`

## Learnings
Document important discoveries made during your work:
- Patterns observed in the codebase
- Root causes of bugs investigated
- Unexpected behaviors or gotchas
- Key architectural insights

Include absolute file paths where relevant. These insights save the next agent time by sharing your exploration work.

## Artifacts
Provide an exhaustive list of all artifacts you created or modified:
- Feature documents
- Implementation plans
- Architecture diagrams
- Test files
- Configuration files

Use absolute file paths or `file:line` references. The next agent should read these to understand your complete output.

## Action Items & Next Steps
List concrete next steps in priority order. Each item should be actionable and specific.

**Format**:
- [ ] Action item with enough detail to execute immediately
- [ ] Next action item

Base these on task statuses and logical workflow progression.

## Other Notes
Include any additional context that doesn't fit above categories:
- Locations of relevant codebase sections
- Related documentation
- Dependency information
- Performance considerations
- Testing notes

**Purpose**: Capture everything useful for continuity that doesn't fit structured sections above.
```
---

### 4. Provide Resume Instructions

After creating the handoff document, respond to the user with the exact resume command using the actual filepath you created. Use this response format (do NOT include the XML tags in your actual response):

<template_response>
Handoff created! You can resume from this handoff in a new session with the following command:

```bash
/resume_handoff path/to/handoff.md
```
</template_response>

**Example response** (do NOT include the XML tags in your actual response):

<example_response>
Handoff created! You can resume from this handoff in a new session with the following command:

```bash
/resume_handoff thoughts/shared/handoffs/ENG-2166/2025-01-08_13-44-55_ENG-2166_create-context-compaction.md
```
</example_response>

---

## Content Guidelines

Follow these principles when writing handoff content:

**Prioritize completeness over brevity**: The template defines minimum required sections. Include additional information when it aids understanding. More context is better than less for enabling smooth resumption.

**Balance detail levels**: Include both high-level objectives (the "what" and "why") and specific technical details (the "how" and "where"). Both are necessary for effective handoff.

**Use file references instead of code blocks**: Reference specific locations using `path/to/file.ext:line-range` syntax (e.g., `packages/dashboard/src/app/dashboard/page.tsx:12-24`). This allows the next agent to read current code rather than potentially stale snippets. Include brief code snippets only when essential for understanding (e.g., when debugging a specific error pattern).

**Write for immediate action**: The next agent should be able to start working immediately after reading your handoff. Anticipate questions and answer them proactively.
