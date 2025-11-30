---
description: Iterate on existing implementation plans with thorough research and updates
model: opus
---

# Iterate Implementation Plan

Your task is to update existing implementation plans based on user feedback. Apply a skeptical, research-driven approach where every change is grounded in actual codebase reality. This ensures plans remain accurate and executable.

## Context for Fresh Sessions

**IMPORTANT**: This command may be run after clearing a session. This section provides essential context.

### Available Subagent Types

Use the **Task tool** with these `subagent_type` values:
- `codebase-locator`: Find files related to a feature/task
- `codebase-analyzer`: Understand how code works
- `codebase-pattern-finder`: Find similar implementations to model after
- `general-purpose`: General research tasks

### Key Tools

- **Read**: Read plan files completely (no limit/offset)
- **Edit**: Make precise changes to plan files
- **TodoWrite**: Track complex update tasks
- **Task**: Spawn sub-agents for research when needed

### Plan Storage

Plans are typically at: `thoughts/shared/plans/YYYY-MM-DD-ENG-XXXX-description.md`

## Initial Response

When this command is invoked:

1. **Parse the input to identify**:
   - Plan file path (e.g., `thoughts/shared/plans/2025-10-16-feature.md`)
   - Requested changes/feedback

2. **Handle different input scenarios**:

   **If NO plan file provided**:
   ```
   I'll help you iterate on an existing implementation plan.

   Which plan would you like to update? Please provide the path to the plan file (e.g., `thoughts/shared/plans/2025-10-16-feature.md`).

   Tip: You can list recent plans with `ls -lt thoughts/shared/plans/ | head`
   ```
   Wait for user input, then re-check for feedback.

   **If plan file provided but NO feedback**:
   ```
   I've found the plan at [path]. What changes would you like to make?

   For example:
   - "Add a phase for migration handling"
   - "Update the success criteria to include performance tests"
   - "Adjust the scope to exclude feature X"
   - "Split Phase 2 into two separate phases"
   ```
   Wait for user input.

   **If BOTH plan file AND feedback provided**:
   - Proceed immediately to Step 1
   - No preliminary questions needed

## Process Steps

### Step 1: Read and Understand Current Plan

1. **Read the existing plan file in its entirety**:
   - Use the Read tool WITHOUT limit/offset parameters to capture the complete context
   - Identify the current structure, phases, and scope
   - Note the success criteria and implementation approach
   - Understanding the full plan is critical for maintaining consistency when making updates

2. **Analyze the requested changes**:
   - Identify specific elements the user wants to add, modify, or remove
   - Determine whether changes require new codebase research
   - Assess the scope and impact of the update

### Step 2: Research If Needed

**Spawn research tasks ONLY when changes require new technical understanding** (e.g., new APIs, unfamiliar patterns, or validation of technical assumptions). Skip research for simple structural changes.

When research is needed:

1. **Create a research todo list** using TodoWrite to track parallel research efforts

2. **Launch parallel sub-tasks for research** - this accelerates the research phase:
   Select the appropriate agent for each type of investigation:

   **For code investigation:**
   - **codebase-locator** - Find relevant files and components
   - **codebase-analyzer** - Understand implementation details and patterns
   - **codebase-pattern-finder** - Locate similar patterns across the codebase

   **Provide full path context in all prompts** - specify exact directories to ensure agents search the correct locations

3. **Read discovered files completely into main context**:
   - Use Read tool WITHOUT limit/offset to get full context
   - Cross-reference findings with plan requirements
   - This ensures you have all necessary information for accurate updates

4. **Wait for ALL parallel sub-tasks to complete** before synthesizing findings and proceeding

### Step 3: Present Understanding and Approach

**Confirm your understanding before implementing changes** - this prevents misaligned updates and saves time:

```
Based on your feedback, I understand you want to:
- [Change 1 with specific detail]
- [Change 2 with specific detail]

My research found:
- [Relevant code pattern or constraint]
- [Important discovery that affects the change]

I will update the plan by:
1. [Specific modification to implement]
2. [Another modification to implement]

Does this align with your intent?
```

Wait for user confirmation before proceeding to Step 4.

### Step 4: Update the Plan

**Implement the changes directly** - make actual edits rather than suggesting changes.

1. **Apply focused, precise edits** to the existing plan:
   - Use the Edit tool for surgical modifications to specific sections
   - Preserve the existing structure unless explicitly changing it
   - Keep all file:line references accurate and up-to-date
   - Update success criteria when changes affect verification requirements

2. **Maintain consistency across all sections**:
   - When adding a new phase: follow the existing phase structure and numbering pattern
   - When modifying scope: update the "What We're NOT Doing" section to reflect new boundaries
   - When changing approach: update the "Implementation Approach" section with new methodology
   - Preserve the distinction between automated vs manual success criteria (this matters for execution agents)

3. **Apply quality standards to all new content**:
   - Include specific file paths and line numbers (e.g., `src/auth/login.ts:45-67`)
   - Write measurable success criteria with concrete verification steps
   - Reference `make` commands or other executable validation steps for automated criteria
   - Use clear, imperative language (e.g., "Implement X" not "Consider implementing X")

### Step 5: Sync and Review

**Present the changes made**:
   ```
   I've updated the plan at `thoughts/shared/plans/[filename].md`

   Changes made:
   - [Specific change 1]
   - [Specific change 2]

   The updated plan now:
   - [Key improvement]
   - [Another improvement]

   Would you like any further adjustments?
   ```

**Be ready to iterate further** based on feedback

## Important Guidelines

1. **Apply Healthy Skepticism**:
   - Challenge change requests that seem technically problematic or inconsistent
   - Request clarification when feedback is vague or ambiguous
   - Verify technical feasibility through code research before accepting changes
   - Identify and highlight potential conflicts with existing plan phases
   - This prevents incorporating flawed or contradictory updates

2. **Make Surgical Edits**:
   - Apply precise modifications to specific sections rather than rewriting entire documents
   - Preserve high-quality existing content that doesn't require changes
   - Limit research scope to what's necessary for the requested changes
   - Make directly requested changes only - avoid over-engineering
   - This maintains plan stability and prevents unnecessary churn

3. **Be Thorough in Analysis**:
   - Read the entire existing plan before implementing any changes (context is critical)
   - Conduct code research when changes require new technical understanding
   - Apply quality standards consistently to all updated sections
   - Verify success criteria remain measurable and executable
   - This ensures updates maintain the plan's overall quality

4. **Maintain Interactive Dialogue**:
   - Confirm your understanding before implementing changes
   - Present your planned modifications before executing them
   - Create opportunities for course corrections
   - Communicate your progress, especially during research phases
   - This ensures alignment and prevents wasted effort

5. **Track Complex Work**:
   - Use TodoWrite to track update tasks when changes involve multiple steps
   - Update todo status as you complete research subtasks
   - Mark tasks complete immediately upon finishing
   - This provides visibility into progress

6. **Resolve All Questions Before Updating**:
   - Ask immediately when requested changes raise questions or uncertainties
   - Conduct research or obtain clarification before proceeding
   - Implement changes only when you have complete understanding
   - Ensure every update is complete and actionable
   - Plans with open questions cannot be executed effectively

## Success Criteria Guidelines

**Maintain the two-category structure when updating success criteria** - this separation enables execution agents to verify automated criteria while humans handle manual checks:

1. **Automated Verification** (execution agents can run these):
   - Executable commands: `make test`, `npm run lint`, `go test ./...`
   - File existence checks: specific files that should exist at exact paths
   - Code compilation and type checking commands
   - These should be completely automatable with clear pass/fail outcomes

2. **Manual Verification** (requires human judgment):
   - UI/UX functionality and visual correctness
   - Performance characteristics under realistic conditions
   - Edge cases that are difficult or expensive to automate
   - User acceptance criteria requiring subjective evaluation

## Sub-task Spawning Best Practices

**When spawning research sub-tasks, prioritize parallel execution for efficiency:**

1. **Spawn only when truly needed** - skip research for simple structural changes
2. **Launch multiple independent tasks in parallel** - this dramatically reduces research time
3. **Focus each task on a specific area** - narrow scope produces better results
4. **Provide detailed, explicit instructions** to each sub-task including:
   - Exactly what to search for (specific function names, patterns, or concepts)
   - Which directories to focus on (full absolute paths)
   - What information to extract (e.g., "API signatures" or "error handling patterns")
   - Expected output format (e.g., "list of file:line references with code snippets")
5. **Request specific file:line references** in sub-task responses for traceability
6. **Wait for all parallel tasks to complete** before synthesizing findings
7. **Verify sub-task results for accuracy** - spawn follow-up tasks if findings seem incomplete or inconsistent

## Example Interaction Flows

**Scenario 1: User provides everything upfront**
```
User: /iterate_plan thoughts/shared/plans/2025-10-16-feature.md - add phase for error handling
Assistant: [Reads plan, researches error handling patterns, updates plan]
```

**Scenario 2: User provides just plan file**
```
User: /iterate_plan thoughts/shared/plans/2025-10-16-feature.md
Assistant: I've found the plan. What changes would you like to make?
User: Split Phase 2 into two phases - one for backend, one for frontend
Assistant: [Proceeds with update]
```

**Scenario 3: User provides no arguments**
```
User: /iterate_plan
Assistant: Which plan would you like to update? Please provide the path...
User: thoughts/shared/plans/2025-10-16-feature.md
Assistant: I've found the plan. What changes would you like to make?
User: Add more specific success criteria to phase 4
Assistant: [Proceeds with update]
```
