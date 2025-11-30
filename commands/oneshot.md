---
description: Research ticket and launch planning session
---

# Oneshot: Research and Launch Planning Session

Your goal is to research a ticket and then create a comprehensive implementation plan for it.

## Context for Fresh Sessions

**IMPORTANT**: This command may be run after clearing a session. This section provides essential context.

### Available Subagent Types

Use the **Task tool** with these `subagent_type` values:
- `codebase-locator`: Find files related to a feature/task
- `codebase-analyzer`: Understand how code works
- `codebase-pattern-finder`: Find similar implementations
- `thoughts-locator`: Find existing research/plans in thoughts/
- `general-purpose`: General research tasks

### Directory Structure

```
thoughts/
├── shared/
│   ├── plans/     # Implementation plans
│   ├── handoffs/  # Handoff documents
│   └── research/  # Research documents
└── [username]/
    └── tickets/   # Ticket descriptions
```

### Related Commands

- `/create_plan` - Used in Step 4 to create the implementation plan

## What This Command Does

This command automates the workflow of researching a ticket's context and then creating a detailed implementation plan. It combines the research and planning phases into a single streamlined workflow.

**Why this matters:** Having thorough research before planning prevents gaps in the implementation plan. This command ensures you understand the full context before committing to an approach.

## Execution Steps

Execute these steps sequentially:

### Step 1: Gather Context

If a ticket file path was provided (e.g., `/oneshot thoughts/tickets/eng_1234.md`):
1. Read the ticket file completely using the Read tool
2. Identify any referenced files, related documentation, or dependencies mentioned in the ticket
3. Read all referenced files to build complete context

If a ticket identifier was provided without a path:
1. Search for the ticket in the thoughts/ directory using the thoughts-locator agent
2. Read the located ticket file and any related documentation

### Step 2: Research the Codebase

Launch parallel research tasks to understand the current state:

**Execute these agents concurrently:**
- **codebase-locator**: Find all files related to the ticket's feature area
- **codebase-analyzer**: Understand how the current implementation works
- **codebase-pattern-finder**: Find similar implementations to use as templates
- **thoughts-locator**: Find any existing research, plans, or decisions about this area

Wait for all research tasks to complete before proceeding.

### Step 3: Synthesize Research Findings

After research completes:
1. Read all files identified by the research agents
2. Compile a summary of:
   - Current state of the relevant code
   - Patterns and conventions to follow
   - Existing similar implementations
   - Any historical context from thoughts/

Present your research findings to the user:
```
## Research Summary for [Ticket]

### Current State
- [Key findings about existing implementation]
- [Relevant file locations with paths]

### Patterns to Follow
- [Identified patterns from similar features]
- [Conventions in use]

### Historical Context
- [Relevant decisions or research from thoughts/]

### Ready to Create Plan
Based on this research, I'm ready to create a detailed implementation plan.
Shall I proceed with planning?
```

### Step 4: Create Implementation Plan

Once the user confirms, proceed to create the implementation plan:

1. Use the `/create_plan` workflow to generate a comprehensive plan
2. Include all research findings in the plan's "Current State Analysis" section
3. Reference specific files and patterns discovered during research
4. Ensure the plan follows the established conventions found in the codebase

## Usage Examples

```bash
# With a ticket file path
/oneshot thoughts/tickets/eng_1234.md

# With just a ticket identifier (will search for it)
/oneshot ENG-1234

# With a description
/oneshot "implement user authentication feature"
```

## Important Notes

- Execute research steps in parallel where possible to maximize efficiency
- Always wait for all research to complete before synthesizing findings
- Get user confirmation before proceeding from research to planning
- The plan should reference specific files and patterns found during research
