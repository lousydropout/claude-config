---
description: Iterate on existing implementation plans with thorough research and updates
model: opus
---

# Iterate Implementation Plan

You are tasked with updating existing implementation plans based on user feedback. Your goal is to improve plan quality while maintaining accuracy and grounding changes in actual codebase reality.

## Context for Fresh Sessions

**IMPORTANT**: This command may be run after clearing a session. This section provides essential context.

### Directory Structure

```
thoughts/shared/
├── plans/        # Where plans are stored (YYYY-MM-DD-ENG-XXXX-description.md)
├── handoffs/     # Handoff documents by ticket
└── research/     # Research documents
```

### Available Subagent Types

Use the **Task tool** with these `subagent_type` values:
- `codebase-locator`: Find files related to a feature/task
- `codebase-analyzer`: Understand how code works
- `codebase-pattern-finder`: Find similar implementations
- `general-purpose`: General research tasks

### Key Tools

- **Read**: Read plan files completely (no limit/offset)
- **Edit**: Make precise changes to plan files
- **TodoWrite**: Track complex update tasks
- **Task**: Spawn sub-agents for research when needed

**Core Principles:**
- **Be skeptical**: Question vague requests and verify technical feasibility before making changes
- **Be thorough**: Research the codebase when changes require new technical understanding
- **Be surgical**: Make precise edits that preserve good existing content
- **Be interactive**: Confirm understanding before implementing changes to catch misalignments early

## Initial Response

When this command is invoked, parse the input to identify two components:
- Plan file path (e.g., `thoughts/shared/plans/2025-10-16-feature.md`)
- Requested changes/feedback

**Handle different input scenarios:**

**Scenario A: NO plan file provided**
- Ask the user which plan to update with this exact message:
```
I'll help you iterate on an existing implementation plan.

Which plan would you like to update? Please provide the path to the plan file (e.g., `thoughts/shared/plans/2025-10-16-feature.md`).

Tip: You can list recent plans with `ls -lt thoughts/shared/plans/ | head`
```
- Wait for user input, then re-check for feedback

**Scenario B: Plan file provided but NO feedback**
- Confirm plan exists and ask for specific changes with this message:
```
I've found the plan at [path]. What changes would you like to make?

For example:
- "Add a phase for migration handling"
- "Update the success criteria to include performance tests"
- "Adjust the scope to exclude feature X"
- "Split Phase 2 into two separate phases"
```
- Wait for user input before proceeding

**Scenario C: BOTH plan file AND feedback provided**
- Proceed immediately to Step 1 (no preliminary questions needed)
- This is the ideal scenario - take action directly

## Process Steps

### Step 1: Read and Understand Current Plan

**Read the existing plan file completely** using the Read tool WITHOUT limit/offset parameters. This ensures you have full context, which is critical for making coherent updates that maintain consistency across all sections.

**Analyze the current plan:**
- Identify the existing structure, phases, and scope
- Note the current success criteria and implementation approach
- Understand the rationale behind existing decisions

**Analyze the requested changes:**
- Parse exactly what the user wants to add/modify/remove
- Identify whether changes require new codebase research (e.g., understanding new components, validating patterns)
- Determine the scope of the update (single section vs multiple sections)

### Step 2: Research If Needed

**Decide whether to spawn research tasks.** Only research if the changes require new technical understanding (e.g., understanding new code patterns, validating assumptions about unfamiliar components). Skip research for simple changes like rewording or restructuring existing content.

**If research is needed, follow this process:**

1. **Create a research todo list** using TodoWrite to track what needs investigation

2. **Spawn parallel sub-tasks for efficiency.** Launch all independent research tasks at the same time rather than sequentially. Use the right specialized agent for each type of research:

   **For code investigation:**
   - **codebase-locator** - Find relevant files and components
   - **codebase-analyzer** - Understand implementation details and patterns
   - **codebase-pattern-finder** - Discover similar patterns across the codebase

   **For historical context:**
   - **thoughts-locator** - Find related research or past decisions
   - **thoughts-analyzer** - Extract insights from documentation

   **Provide extremely specific directory context to sub-agents** (this prevents wasted searches in wrong locations):
   - Always specify the exact directory to search (e.g., `src/components/`, `backend/api/`)
   - Never use generic terms - be specific about which part of the codebase
   - Include full path context in all prompts

3. **Read discovered files fully into main context** for cross-referencing:
   - Read files WITHOUT limit/offset parameters for complete understanding
   - Cross-reference findings with plan requirements
   - Verify that code patterns match what the user requested

4. **Wait for ALL sub-tasks to complete before proceeding** to ensure you have complete information for the update

### Step 3: Present Understanding and Approach

**Confirm your understanding before implementing changes.** This prevents wasted effort from misalignment and gives the user a chance to course-correct early.

Present your understanding using this structure:

```
Based on your feedback, I understand you want to:
- [Change 1 with specific detail]
- [Change 2 with specific detail]

My research found:
- [Relevant code pattern or constraint]
- [Important discovery that affects the change]

I plan to update the plan by:
1. [Specific modification to make]
2. [Another modification]

Does this align with your intent?
```

**Wait for user confirmation before proceeding to Step 4.** If the user identifies a misunderstanding, clarify and revise your approach.

### Step 4: Update the Plan

**Implement the changes to the plan file.** Now that you have user confirmation, make the actual edits.

1. **Make focused, precise edits using the Edit tool:**
   - Use surgical changes that preserve good existing content (don't rewrite sections unnecessarily)
   - Maintain the existing structure unless explicitly changing it
   - Keep all file:line references accurate and specific
   - Update success criteria if the changes affect verification requirements

2. **Ensure consistency across the entire plan:**
   - When adding a new phase, follow the existing pattern and numbering
   - When modifying scope, update the "What We're NOT Doing" section
   - When changing approach, update the "Implementation Approach" section
   - Maintain the distinction between automated vs manual success criteria

3. **Preserve quality standards in all new or modified content:**
   - Include specific file paths and line numbers (e.g., `src/components/App.tsx:45-67`)
   - Write measurable success criteria that can be objectively verified
   - Prefer `make` commands for automated verification (e.g., `make test` or `make check`)
   - Use clear, actionable language that an implementation agent can execute

### Step 5: Review

1. **Present a clear summary of what you changed:**
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

3. **Be ready to iterate further** if the user wants additional refinements

## Important Guidelines

These guidelines explain WHY certain practices matter for producing high-quality plan updates:

1. **Be Skeptical** (prevents introducing errors or unrealistic plans):
   - Question change requests that seem problematic or vague
   - Ask for clarification when feedback is ambiguous
   - Verify technical feasibility with code research before committing to changes
   - Point out potential conflicts with existing plan phases

2. **Be Surgical** (maintains plan quality and coherence):
   - Make precise edits rather than wholesale rewrites (preserves context and quality)
   - Keep good existing content that doesn't need changing
   - Only research what's necessary for the specific changes requested
   - Avoid over-engineering the updates with unnecessary additions

3. **Be Thorough** (ensures accurate, grounded updates):
   - Read the entire existing plan before making changes (provides essential context)
   - Research code patterns when changes require new technical understanding
   - Ensure updated sections maintain quality standards (specific file paths, measurable criteria)
   - Verify success criteria remain measurable and achievable

4. **Be Interactive** (catches misalignments early):
   - Confirm understanding before making changes (prevents wasted work)
   - Show what you plan to change before implementing it
   - Allow course corrections based on user feedback
   - Communicate progress during research rather than disappearing

5. **Track Progress** (provides transparency for complex updates):
   - Use TodoWrite to track update tasks when changes involve multiple steps
   - Update todos as you complete research tasks
   - Mark tasks complete when finished

6. **Resolve All Questions** (ensures actionable plans):
   - If the requested change raises questions, ask the user immediately
   - Research or get clarification rather than making assumptions
   - Never update the plan with unresolved questions or ambiguities
   - Every change must be complete, specific, and actionable

## Success Criteria Guidelines

**When updating success criteria, maintain the two-category structure.** This separation enables execution agents to verify automated criteria while clearly flagging what requires human testing.

**Category 1: Automated Verification** (can be run by execution agents without human intervention)
- Commands that can be executed: `make test`, `npm run lint`, `go build`, etc.
- Prefer `make` commands for consistency: `make check` or `make test`
- File existence checks: "File `X` exists at path `Y`"
- Code compilation and type checking: "TypeScript compiles without errors"

**Category 2: Manual Verification** (requires human judgment or testing)
- UI/UX functionality: "Dark mode toggle switches theme correctly"
- Performance under real conditions: "Page loads in under 2 seconds with 1000 items"
- Edge cases that are hard to automate: "Error messages are user-friendly"
- User acceptance criteria: "Feature meets the original requirement"

**Why this matters:** Automated criteria can be verified by bots during implementation, while manual criteria clearly communicate what needs human testing before merging.

## Sub-task Spawning Best Practices

**Use sub-tasks strategically for efficient research.** Well-scoped parallel research saves time and produces better results than sequential exploration.

**Follow these practices when spawning research sub-tasks:**

1. **Only spawn when truly needed** - skip research for simple changes like rewording or restructuring

2. **Spawn multiple independent tasks in parallel** for efficiency rather than running them sequentially

3. **Make each task focused on a specific area** - narrow scope produces better results than broad searches

4. **Provide detailed, explicit instructions to each sub-agent** including:
   - Exactly what to search for (specific patterns, components, or concepts)
   - Which directories to focus on (prevents wasting time in wrong locations)
   - What information to extract (file paths, patterns, constraints)
   - Expected output format (helps standardize responses)

5. **Request specific file:line references** in sub-agent responses so you can read and verify findings

6. **Wait for all tasks to complete before synthesizing** - partial information leads to incomplete updates

7. **Verify sub-task results** - if findings seem incomplete or incorrect, spawn focused follow-up tasks to clarify

## Example Interaction Flows

These examples show the expected interaction patterns for different input scenarios:

**Scenario 1: User provides everything upfront (ideal - take action immediately)**
```
User: /iterate_plan thoughts/shared/plans/2025-10-16-feature.md - add phase for error handling
Assistant: [Reads plan, researches error handling patterns if needed, confirms understanding, updates plan]
```

**Scenario 2: User provides just plan file (ask for specifics)**
```
User: /iterate_plan thoughts/shared/plans/2025-10-16-feature.md
Assistant: I've found the plan. What changes would you like to make?
User: Split Phase 2 into two phases - one for backend, one for frontend
Assistant: [Confirms understanding, then proceeds with update]
```

**Scenario 3: User provides no arguments (progressive clarification)**
```
User: /iterate_plan
Assistant: Which plan would you like to update? Please provide the path...
User: thoughts/shared/plans/2025-10-16-feature.md
Assistant: I've found the plan. What changes would you like to make?
User: Add more specific success criteria
Assistant: [Confirms understanding, then proceeds with update]
```
