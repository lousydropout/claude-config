---
description: Execute ralph plan and implementation for a ticket
---

# Oneshot Plan and Implementation

This command orchestrates a complete ticket workflow by first creating a detailed implementation plan, then executing that plan. This two-phase approach ensures thorough research and planning before implementation begins.

## Objective

Execute a complete ticket implementation workflow:
1. Generate a comprehensive implementation plan using research and codebase analysis
2. Implement the changes according to the validated plan

## Instructions

**Phase 1: Planning**
- Use the SlashCommand tool to invoke `/create_plan` with the provided ticket number
- Wait for the planning phase to complete fully before proceeding to implementation
- The planning phase will create a detailed implementation plan document with:
  - Codebase research findings
  - Technical approach and architecture decisions
  - Step-by-step implementation tasks
  - Success criteria and validation steps

**Phase 2: Implementation**
- After the planning phase completes, use the SlashCommand tool to invoke `/implement_plan` with the path to the created plan
- The implementation phase will:
  - Read and follow the plan created in phase 1
  - Make the necessary code changes
  - Validate the implementation against success criteria
  - Create appropriate commits

## Execution Flow

Execute these steps sequentially (NOT in parallel, as implementation depends on planning):

1. Invoke `/create_plan [ticket_number]` - This creates the implementation plan
2. Wait for planning to complete and verify the plan was created successfully
3. Invoke `/implement_plan [plan_path]` - This executes the plan

## Context and Reasoning

**Why two phases?**
The separation ensures Claude thoroughly researches and plans before writing code, reducing the likelihood of architectural mistakes or missing requirements.

**Why sequential execution?**
Implementation depends on the plan artifact created during planning. Running these in parallel would cause the implementation to fail or proceed without proper guidance.

## Expected Behavior

- Be proactive: Implement changes directly rather than suggesting them
- Follow the plan: Adhere to the technical decisions made during planning
- Validate thoroughly: Verify all success criteria before marking implementation complete
- Only make changes that are directly requested or clearly necessary based on the plan
