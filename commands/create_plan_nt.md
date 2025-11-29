---
description: Create implementation plans with thorough research (no thoughts directory)
model: opus
---

# Implementation Plan

You are tasked with creating detailed implementation plans through an interactive, iterative process. You should be skeptical, thorough, and work collaboratively with the user to produce high-quality technical specifications.

## Initial Response

When this command is invoked:

1. **Check if parameters were provided**:
   - If a file path or ticket reference was provided as a parameter, skip the default message
   - Read any provided files FULLY (use Read tool WITHOUT limit/offset parameters)
   - Begin the research process immediately

2. **If no parameters provided**, respond with:
```
I'll help you create a detailed implementation plan. Let me start by understanding what we're building.

Please provide:
1. The task/ticket description (or reference to a ticket file)
2. Any relevant context, constraints, or specific requirements
3. Links to related research or previous implementations

I'll analyze this information and work with you to create a comprehensive plan.

Tip: You can also invoke this command with a ticket file directly: `/create_plan thoughts/shared/tickets/eng_1234.md`
For deeper analysis, try: `/create_plan think deeply about thoughts/shared/tickets/eng_1234.md`
```

Then wait for the user's input.

**Why this matters**: Reading files fully in the main context ensures you have complete understanding before delegating to subagents. Partial reads lead to missing critical details.

## Process Steps

### Step 1: Context Gathering & Initial Analysis

1. **Read all mentioned files immediately and FULLY**:
   Read these files in the main context using the Read tool WITHOUT limit/offset parameters:
   - Ticket files (e.g., `thoughts/shared/tickets/eng_1234.md`)
   - Research documents
   - Related implementation plans
   - Any JSON/data files mentioned

   **Why this matters**: You must read files fully in the main context before delegating to subagents. This ensures you have complete understanding to give accurate research instructions. Partial reads or delegating file reading to subagents leads to missing critical context and misaligned research.

2. **Spawn initial research tasks to gather context in parallel**:
   After reading all mentioned files yourself, spawn multiple specialized agents concurrently to research different aspects. If tool calls have no dependencies, make all independent calls in parallel:

   - Use the **codebase-locator** agent to find all files related to the ticket/task
   - Use the **codebase-analyzer** agent to understand how the current implementation works

   These agents will:
   - Find relevant source files, configs, and tests
   - Identify the specific directories to focus on based on the feature area
   - Trace data flow and key functions
   - Return detailed explanations with file:line references

3. **Read all files identified by research tasks**:
   After research tasks complete, read ALL files they identified as relevant. Read them FULLY into the main context using the Read tool without limit/offset parameters.

   **Why this matters**: Reading files into your main context (not just having subagents read them) allows you to cross-reference information, identify patterns, and form accurate insights. This is essential for creating accurate plans.

4. **Analyze and verify understanding**:
   With all files read into your context, perform cross-referencing analysis:
   - Compare ticket requirements with actual code implementation
   - Identify any discrepancies or misunderstandings in the ticket
   - Note assumptions that need verification
   - Determine true scope based on codebase reality, not just ticket description

   **Why this matters**: Tickets are often incomplete or make incorrect assumptions. Your analysis prevents implementing the wrong thing.

5. **Present informed understanding and focused questions**:
   ```
   Based on the ticket and my research of the codebase, I understand we need to [accurate summary].

   I've found that:
   - [Current implementation detail with file:line reference]
   - [Relevant pattern or constraint discovered]
   - [Potential complexity or edge case identified]

   Questions that my research couldn't answer:
   - [Specific technical question that requires human judgment]
   - [Business logic clarification]
   - [Design preference that affects implementation]
   ```

   **Important**: Only ask questions that you genuinely cannot answer through code investigation. Most technical details can be discovered through thorough codebase research - questions should focus on business logic, user preferences, and ambiguous requirements.

### Step 2: Research & Discovery

After getting initial clarifications:

1. **If the user corrects any misunderstanding**:
   - Verify corrections by investigating the codebase yourself
   - Spawn new research tasks if needed to confirm the correct information
   - Read the specific files/directories they mention
   - Only proceed once you've verified the facts yourself

   **Why this matters**: Users sometimes have incorrect beliefs about their own codebase. Always verify with actual code before accepting corrections.

2. **Create a research todo list** using TodoWrite to track exploration tasks

   **Why this matters**: Todo lists provide structured tracking that helps you stay organized and shows the user your progress. Use TodoWrite for tracking tasks, not for notes.

3. **Spawn parallel sub-tasks for comprehensive research**:
   Create multiple Task agents concurrently to research different aspects in parallel. If tool calls have no dependencies, make all independent calls in parallel:
   - Use the right specialized agent for each type of research
   - Give each agent clear, specific instructions
   - Let agents work concurrently to save time

   **For deeper investigation:**
   - **codebase-locator** - To find more specific files (e.g., "find all files that handle [specific component]")
   - **codebase-analyzer** - To understand implementation details (e.g., "analyze how [system] works")
   - **codebase-pattern-finder** - To find similar features we can model after

   Each agent knows how to:
   - Find the right files and code patterns
   - Identify conventions and patterns to follow
   - Look for integration points and dependencies
   - Return specific file:line references
   - Find tests and examples

4. **Wait for ALL sub-tasks to complete** before proceeding

   **Why this matters**: You need complete information from all research streams before synthesizing findings. Proceeding with partial information leads to incomplete plans.

5. **Present findings and design options**:
   ```
   Based on my research, here's what I found:

   **Current State:**
   - [Key discovery about existing code]
   - [Pattern or convention to follow]

   **Design Options:**
   1. [Option A] - [pros/cons]
   2. [Option B] - [pros/cons]

   **Open Questions:**
   - [Technical uncertainty]
   - [Design decision needed]

   Which approach aligns best with your vision?
   ```

### Step 3: Plan Structure Development

Once aligned on approach:

1. **Create initial plan outline**:
   Present a structured outline for approval before writing detailed sections:
   ```
   Here's my proposed plan structure:

   ## Overview
   [1-2 sentence summary]

   ## Implementation Phases:
   1. [Phase name] - [what it accomplishes]
   2. [Phase name] - [what it accomplishes]
   3. [Phase name] - [what it accomplishes]

   Does this phasing make sense? Should I adjust the order or granularity?
   ```

2. **Get feedback on structure** before writing details

   **Why this matters**: Getting structural approval early prevents wasting time writing detailed plans that need major reorganization. The user can course-correct before you invest time in details.

### Step 4: Detailed Plan Writing

After structure approval:

1. **Write the plan** to `thoughts/shared/plans/YYYY-MM-DD-ENG-XXXX-description.md`

   **File naming format**: `YYYY-MM-DD-ENG-XXXX-description.md` where:
   - YYYY-MM-DD is today's date (2025-11-29)
   - ENG-XXXX is the ticket number (omit if no ticket)
   - description is a brief kebab-case description

   **Examples**:
   - With ticket: `2025-01-08-ENG-1478-parent-child-tracking.md`
   - Without ticket: `2025-01-08-improve-error-handling.md`

   **Why this matters**: Consistent file naming makes plans easy to find and sort chronologically. Including the ticket number enables quick cross-referencing.

2. **Use this template structure**:

````markdown
# [Feature/Task Name] Implementation Plan

## Overview

[Brief description of what we're implementing and why]

## Current State Analysis

[What exists now, what's missing, key constraints discovered]

## Desired End State

[A Specification of the desired end state after this plan is complete, and how to verify it]

### Key Discoveries:
- [Important finding with file:line reference]
- [Pattern to follow]
- [Constraint to work within]

## What We're NOT Doing

[Explicitly list out-of-scope items to prevent scope creep]

## Implementation Approach

[High-level strategy and reasoning]

## Phase 1: [Descriptive Name]

### Overview
[What this phase accomplishes]

### Changes Required:

#### 1. [Component/File Group]
**File**: `path/to/file.ext`
**Changes**: [Summary of changes]

```[language]
// Specific code to add/modify
```

### Success Criteria:

#### Automated Verification:
- [ ] Migration applies cleanly: `make migrate`
- [ ] Unit tests pass: `make test-component`
- [ ] Type checking passes: `npm run typecheck`
- [ ] Linting passes: `make lint`
- [ ] Integration tests pass: `make test-integration`

#### Manual Verification:
- [ ] Feature works as expected when tested via UI
- [ ] Performance is acceptable under load
- [ ] Edge case handling verified manually
- [ ] No regressions in related features

**Implementation Note**: After completing this phase and all automated verification passes, pause here for manual confirmation from the human that the manual testing was successful before proceeding to the next phase.

---

## Phase 2: [Descriptive Name]

[Similar structure with both automated and manual success criteria...]

---

## Testing Strategy

### Unit Tests:
- [What to test]
- [Key edge cases]

### Integration Tests:
- [End-to-end scenarios]

### Manual Testing Steps:
1. [Specific step to verify feature]
2. [Another verification step]
3. [Edge case to test manually]

## Performance Considerations

[Any performance implications or optimizations needed]

## Migration Notes

[If applicable, how to handle existing data/systems]

## References

- Original ticket: `thoughts/shared/tickets/eng_XXXX.md`
- Related research: `thoughts/shared/research/[relevant].md`
- Similar implementation: `[file:line]`
````

### Step 5: Review

1. **Present the draft plan location**:
   ```
   I've created the initial implementation plan at:
   `thoughts/shared/plans/YYYY-MM-DD-ENG-XXXX-description.md`

   Please review it and let me know:
   - Are the phases properly scoped?
   - Are the success criteria specific enough?
   - Any technical details that need adjustment?
   - Missing edge cases or considerations?
   ```

2. **Iterate based on feedback** - be ready to:
   - Add missing phases
   - Adjust technical approach
   - Clarify success criteria (both automated and manual)
   - Add/remove scope items

3. **Continue refining** until the user is satisfied

## Important Guidelines

1. **Be Skeptical and Verify**:
   - Question vague requirements - ask for specifics
   - Identify potential issues early in the planning process
   - Ask "why" and "what about" to surface hidden complexity
   - Verify everything with actual code - never assume based on ticket descriptions alone

   **Why this matters**: Tickets often contain incorrect assumptions or vague requirements. Your skepticism and verification prevent implementing the wrong solution.

2. **Be Interactive and Collaborative**:
   - Break planning into stages and get buy-in at each major step
   - Present options and design choices for user input
   - Allow course corrections throughout the process
   - Work collaboratively - this is a dialogue, not a monologue

   **Why this matters**: Interactive planning catches misalignments early and ensures the final plan matches user expectations. Writing everything in one shot risks major rework.

3. **Be Thorough in Research**:
   - Read all context files COMPLETELY before planning (use Read without limit/offset)
   - Research actual code patterns using parallel sub-tasks for efficiency
   - Include specific file paths and line numbers in your plan
   - Write measurable success criteria with clear automated vs manual distinction
   - Use `make` commands for automated steps whenever possible (e.g., `make check` or `make test`)

   **Why this matters**: Thorough research produces accurate plans. Generic plans without specific file references are hard to implement. Using make commands ensures consistency with project conventions.

4. **Be Practical and Incremental**:
   - Focus on incremental, testable changes that can be verified at each step
   - Consider migration strategy and rollback procedures
   - Think through edge cases and error scenarios
   - Explicitly list "what we're NOT doing" to prevent scope creep

   **Why this matters**: Incremental changes are easier to implement, test, and debug. Clear boundaries prevent scope creep and keep implementation focused.

5. **Track Progress with Structured Tools**:
   - Use TodoWrite to track planning tasks (structured format for task tracking)
   - Update todos as you complete research steps
   - Mark planning tasks complete when finished

   **Why this matters**: TodoWrite provides structured tracking that helps you stay organized and shows users your progress. Use it for tasks, not notes.

6. **Resolve All Open Questions Before Finalizing**:
   - If you encounter open questions during planning, STOP immediately
   - Research the codebase or ask for clarification
   - Resolve questions before continuing to write the plan
   - The implementation plan must be complete and actionable with zero ambiguity
   - Every decision must be made before finalizing the plan

   **Why this matters**: Plans with open questions block implementation. Resolving questions during planning (when research context is fresh) is far more efficient than resolving them during implementation.

## Success Criteria Guidelines

**Always separate success criteria into two categories:**

This separation is critical because execution agents can verify automated criteria autonomously, while manual criteria require human confirmation.

1. **Automated Verification** (can be run by execution agents without human involvement):
   - Runnable commands: `make test`, `npm run lint`, `go build`, etc.
   - File existence checks
   - Code compilation and type checking
   - Automated test suites
   - API endpoint responses

2. **Manual Verification** (requires human testing and judgment):
   - UI/UX functionality and appearance
   - Performance under real-world conditions
   - Edge cases that are difficult or expensive to automate
   - User acceptance criteria
   - Visual design and user experience

**Why this matters**: Execution agents need clear, unambiguous criteria they can verify autonomously. Manual criteria must wait for human confirmation. Mixing the two causes confusion about when a phase is truly complete.

**Format example:**
```markdown
### Success Criteria:

#### Automated Verification:
- [ ] Database migration runs successfully: `make migrate`
- [ ] All unit tests pass: `go test ./...`
- [ ] No linting errors: `golangci-lint run`
- [ ] API endpoint returns 200: `curl localhost:8080/api/new-endpoint`

#### Manual Verification:
- [ ] New feature appears correctly in the UI
- [ ] Performance is acceptable with 1000+ items
- [ ] Error messages are user-friendly
- [ ] Feature works correctly on mobile devices
```

## Common Patterns

### For Database Changes:
- Start with schema/migration
- Add store methods
- Update business logic
- Expose via API
- Update clients

### For New Features:
- Research existing patterns first
- Start with data model
- Build backend logic
- Add API endpoints
- Implement UI last

### For Refactoring:
- Document current behavior
- Plan incremental changes
- Maintain backwards compatibility
- Include migration strategy

## Sub-task Spawning Best Practices

When spawning research sub-tasks, follow these practices to maximize efficiency and accuracy:

1. **Spawn multiple tasks in parallel for efficiency**
   - If tool calls have no dependencies, make all independent calls in parallel
   - Launch all research sub-tasks concurrently to save time
   - Don't wait for task 1 to complete before launching task 2 if they're independent

   **Why this matters**: Parallel execution dramatically reduces research time. Sequential research wastes time waiting.

2. **Make each task focused on a specific area**
   - One task per research question or component
   - Narrow scope enables deeper investigation
   - Clear boundaries prevent overlap between tasks

3. **Provide detailed, explicit instructions to each sub-task**:
   - Specify exactly what to search for (be specific, not vague)
   - Identify which directories to focus on (use exact paths)
   - Describe what information to extract
   - Define the expected output format

   **Why this matters**: Vague instructions produce vague results. Explicit instructions enable focused, useful research.

4. **Be EXTREMELY specific about directories and paths**:
   - Always specify the exact directory to search (e.g., `src/components/`, `backend/api/`)
   - Never use generic terms - be specific about which part of the codebase
   - Always include the full path context in your prompts

   **Why this matters**: Sub-tasks search the entire repository if you don't specify directories. This wastes time and produces irrelevant results.

5. **Specify which read-only tools to use**
   - Guide sub-tasks to use appropriate tools (Grep, Glob, Read)
   - This prevents them from attempting to modify code during research

6. **Request specific file:line references in responses**
   - Require agents to cite exact locations for their findings
   - This makes their research verifiable and actionable

7. **Wait for all tasks to complete before synthesizing**
   - Don't proceed with partial information
   - Synthesis requires the full picture from all research streams

8. **Verify sub-task results against the codebase**:
   - If a sub-task returns unexpected results, spawn follow-up tasks to investigate
   - Cross-check findings by reading the actual files yourself
   - Don't accept results that seem incorrect - investigate further

   **Why this matters**: Sub-tasks sometimes misunderstand or miss important details. Your verification catches these issues before they become plan errors.

**Example of parallel task spawning**:
```python
# Launch these tasks concurrently (all in parallel, not sequentially):
tasks = [
    Task("Research database schema in db/migrations/", db_research_prompt),
    Task("Find API patterns in backend/api/", api_research_prompt),
    Task("Investigate UI components in frontend/src/components/", ui_research_prompt),
    Task("Check test patterns across all packages", test_research_prompt)
]
# All four tasks run simultaneously, saving time
```

Note how each task specifies the exact directory to focus on. This produces focused, relevant results.

## Example Interaction Flow

This example demonstrates the interactive, research-driven approach:

```
User: /create_plan
Assistant: I'll help you create a detailed implementation plan. Let me start by understanding what we're building...

User: We need to add parent-child tracking for Claude sub-tasks. See thoughts/shared/tickets/eng_1478.md
Assistant: Let me read that ticket file completely first...

[Reads file fully using Read tool without limit/offset]

Based on the ticket, I understand we need to track parent-child relationships for Claude sub-task events in the hld daemon. Let me spawn research tasks in parallel to investigate the current implementation.

[Spawns multiple research tasks concurrently to analyze codebase]
[Reads all files identified by research tasks]
[Analyzes findings and cross-references with ticket requirements]

Based on my research, I've found:
- Current event tracking in hld/internal/events/store.go
- The Event struct doesn't have parent/child fields yet
- Similar pattern used for request tracking in hld/internal/requests/

I have one clarification question: Should parent-child relationships be queryable (e.g., "find all children of task X"), or just stored for audit purposes?

User: They should be queryable - we want to trace the full task tree.
Assistant: Good - that affects the database schema design. Let me verify this by researching how similar queryable relationships are handled in the codebase.

[Spawns follow-up research tasks to investigate indexing patterns]
[Reads additional files to verify approach]

Perfect. Here's my proposed plan structure:

## Overview
Add parent-child task tracking to enable querying the full task execution tree

## Implementation Phases:
1. Database Schema Extension - Add parent_task_id field and index
2. Event Store Updates - Modify store methods to handle relationships
3. API Extensions - Add query endpoints for task trees
4. Testing - Unit and integration tests for tree queries

Does this phasing make sense?

User: Yes, looks good. Go ahead and write the full plan.

[Assistant creates detailed plan with all phases, specific file changes, success criteria, etc.]

[Interactive process continues with review and refinement...]
```

**Key points demonstrated**:
- Files read FULLY in main context before delegation
- Multiple research tasks spawned in parallel for efficiency
- Verification of corrections through actual code investigation
- Interactive approval at key milestones
- Specific, focused questions based on research gaps
- Clear separation of what can be discovered vs what needs human input