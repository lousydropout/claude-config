---
description: Create detailed implementation plans through interactive research and iteration
model: opus
---

# Implementation Plan

You are creating detailed implementation plans through an interactive, iterative process. Your goal is to produce actionable, comprehensive technical specifications that enable successful implementation without requiring additional research.

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
- `thoughts-locator`: Find existing research/plans in thoughts/
- `thoughts-analyzer`: Extract insights from thoughts documents
- `general-purpose`: General research tasks

### Key Tools

- **Read**: Read files completely (no limit/offset for full context)
- **TodoWrite**: Track research and planning tasks
- **Task**: Spawn sub-agents for parallel research
- **Write/Edit**: Create and modify plan files

**Core Principles:**
- **Be skeptical and thorough** - Question assumptions, verify facts in code, identify risks early
- **Work collaboratively** - Engage the user at key decision points, don't write the entire plan in isolation
- **Be explicit and specific** - Include file paths, line numbers, command examples, and measurable criteria
- **Leverage parallelism** - When research tasks have no dependencies, execute them concurrently for efficiency
- **Verify before concluding** - Every open question must be resolved before finalizing the plan

## Initial Response

**Objective:** Quickly establish context and begin research without unnecessary delays.

**Action Steps:**

1. **If parameters were provided** (e.g., `/create_plan thoughts/allison/tickets/eng_1234.md`):
   - Read all provided files FULLY using the Read tool (without limit/offset parameters)
   - Begin the research process immediately (proceed to Step 1)
   - This immediate action saves time and demonstrates proactivity

2. **If no parameters provided**, display this message and wait for user input:
```
I'll help you create a detailed implementation plan. Let me start by understanding what we're building.

Please provide:
1. The task/ticket description (or reference to a ticket file)
2. Any relevant context, constraints, or specific requirements
3. Links to related research or previous implementations

I'll analyze this information and work with you to create a comprehensive plan.

Tip: You can also invoke this command with a ticket file directly: `/create_plan thoughts/allison/tickets/eng_1234.md`
For deeper analysis, try: `/create_plan think deeply about thoughts/allison/tickets/eng_1234.md`
```

## Process Steps

### Step 1: Context Gathering & Initial Analysis

**Objective:** Build comprehensive understanding through parallel research before engaging the user with questions.

**Why this matters:** Reading files yourself ensures you have direct context, while parallel research maximizes efficiency. This combination enables informed, specific questions rather than generic clarifications.

**Action Steps:**

1. **Read all mentioned files completely in the main context**:
   - Read ticket files (e.g., `thoughts/allison/tickets/eng_1234.md`)
   - Read research documents
   - Read related implementation plans
   - Read any JSON/data files mentioned
   - **Always use Read tool WITHOUT limit/offset parameters** - partial reads lead to misunderstanding
   - **Read these files yourself first** before spawning sub-tasks - this gives you grounding in requirements

2. **Launch parallel research tasks to gather codebase context**:

   **Execute these specialized research agents concurrently** (they have no dependencies):
   - **codebase-locator** - Find all files related to the ticket/task
   - **codebase-analyzer** - Understand how current implementation works
   - **thoughts-locator** - Find existing thoughts documents about this feature (if relevant)

   **Why parallel execution:** These agents investigate independent areas of the codebase. Running them concurrently reduces total research time significantly.

   **What these agents provide:**
   - Relevant source files, configs, and tests with specific paths
   - Directory focus based on context (e.g., specific subdirectories relevant to the feature)
   - Data flow traces and key function identification
   - File:line references for all findings

3. **After research tasks complete, read all identified files**:
   - Read ALL files the agents identified as relevant
   - Read them FULLY into the main context using the Read tool
   - **Why this matters:** Direct file access ensures you understand the actual code, not just summaries

4. **Synthesize findings and verify understanding**:
   - Cross-reference ticket requirements against actual code implementation
   - Identify discrepancies between expectations and reality
   - List assumptions requiring verification
   - Determine true scope based on codebase evidence

5. **Present informed understanding with focused questions**:
   ```
   Based on the ticket and my research of the codebase, I understand we need to [accurate summary].

   I've found that:
   - [Current implementation detail with file:line reference]
   - [Relevant pattern or constraint discovered]
   - [Potential complexity or edge case identified]

   Questions that my research couldn't answer:
   - [Specific technical question requiring human judgment]
   - [Business logic clarification]
   - [Design preference affecting implementation]
   ```

   **Only ask questions you genuinely cannot answer through code investigation** - this respects the user's time and demonstrates thoroughness.

### Step 2: Research & Discovery

**Objective:** Conduct deep, targeted research to resolve all technical uncertainties before planning.

**Why this matters:** Comprehensive research now prevents implementation blockers later. Parallel execution of independent research tasks dramatically reduces total time to completion.

**Action Steps:**

1. **If the user corrects any misunderstanding**:
   - Verify the correction independently - don't just accept it at face value
   - Spawn new research tasks to confirm the corrected information
   - Read the specific files/directories the user mentions
   - **Only proceed after verifying facts yourself** - this prevents propagating misunderstandings into the plan

2. **Create a research todo list** using TodoWrite:
   - Track all research tasks you plan to execute
   - Mark them complete as you finish
   - **Why:** Provides transparency and helps organize multi-faceted research

3. **Launch parallel sub-tasks for comprehensive research**:

   **Execute multiple specialized agents concurrently** - they investigate independent aspects:

   **For deeper codebase investigation (run these in parallel):**
   - **codebase-locator** - Find specific files (e.g., "find all files handling [component]")
   - **codebase-analyzer** - Understand implementation details (e.g., "analyze how [system] works")
   - **codebase-pattern-finder** - Locate similar features to model after

   **For historical context (run these in parallel):**
   - **thoughts-locator** - Find research, plans, or decisions about this area
   - **thoughts-analyzer** - Extract key insights from the most relevant documents

   **What each agent provides:**
   - Specific files and code patterns with exact paths
   - Conventions and patterns to follow
   - Integration points and dependencies
   - File:line references for all findings
   - Test patterns and examples

4. **Wait for ALL sub-tasks to complete before proceeding**:
   - **Why:** You need the complete picture to make informed design decisions
   - Attempting to proceed with partial information leads to rework

5. **Read all files identified by research agents**:
   - Read them FULLY into your main context
   - **Why:** Summaries miss critical details - direct file access gives you the truth

6. **Present findings and design options**:
   ```
   Based on my research, here's what I found:

   **Current State:**
   - [Key discovery about existing code with file:line reference]
   - [Pattern or convention to follow with example]

   **Design Options:**
   1. [Option A] - Pros: [specific benefits], Cons: [specific drawbacks]
   2. [Option B] - Pros: [specific benefits], Cons: [specific drawbacks]

   **Recommendation:** [Option X] because [specific reasoning based on research findings]

   **Open Questions:**
   - [Technical uncertainty requiring human judgment]
   - [Design decision needing user preference]

   Which approach aligns best with your vision?
   ```

   **Provide clear recommendations based on evidence** - don't just list options without guidance.

### Step 3: Plan Structure Development

**Objective:** Establish the plan's structure and phasing before writing detailed specifications.

**Why this matters:** Getting alignment on structure first prevents wasted effort if phases need to be reordered or rescoped.

**Action Steps:**

1. **Create and present the initial plan outline**:
   ```
   Here's my proposed plan structure:

   ## Overview
   [1-2 sentence summary of what we're implementing and why]

   ## Implementation Phases:
   1. [Phase name] - [what it accomplishes and why this comes first]
   2. [Phase name] - [what it accomplishes and dependencies on phase 1]
   3. [Phase name] - [what it accomplishes and why this comes last]

   **Rationale for this ordering:** [Explain why phases are sequenced this way]

   Does this phasing make sense? Should I adjust the order or granularity?
   ```

2. **Wait for user feedback on structure**:
   - Get explicit approval before proceeding to detailed writing
   - Adjust phasing based on feedback
   - **Why:** This checkpoint prevents extensive rework if the approach needs adjustment

### Step 4: Detailed Plan Writing

**Objective:** Write a comprehensive, actionable implementation plan with complete specifications.

**Why this matters:** A well-structured plan enables implementation without additional research. Clear success criteria (both automated and manual) ensure the implementation can be verified systematically.

**Action Steps:**

1. **Write the plan** to `thoughts/shared/plans/YYYY-MM-DD-ENG-XXXX-description.md`

   **File naming format:** `YYYY-MM-DD-ENG-XXXX-description.md` where:
   - YYYY-MM-DD is today's date (2025-11-29)
   - ENG-XXXX is the ticket number (omit if no ticket exists)
   - description is a brief kebab-case description

   **Examples:**
   - With ticket: `2025-11-29-ENG-1478-parent-child-tracking.md`
   - Without ticket: `2025-11-29-improve-error-handling.md`
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

- Original ticket: `thoughts/allison/tickets/eng_XXXX.md`
- Related research: `thoughts/shared/research/[relevant].md`
- Similar implementation: `[file:line]`
````

### Step 5: Review and Iterate

**Objective:** Make the plan available for review and iterate to perfection.

**Why this matters:** Iterative refinement ensures the plan is truly actionable before implementation begins.

**Action Steps:**

1. **Present the draft plan location and request specific feedback**:
   ```
   I've created the initial implementation plan at:
   `thoughts/shared/plans/YYYY-MM-DD-ENG-XXXX-description.md`

   Please review and provide feedback on:
   - **Phasing:** Are the phases properly scoped and sequenced?
   - **Success Criteria:** Are both automated and manual verification steps specific enough?
   - **Technical Details:** Any technical decisions that need adjustment?
   - **Edge Cases:** Any missing considerations or edge cases?
   - **Scope:** Is the "What We're NOT Doing" section accurate?
   ```

3. **Iterate based on feedback** - implement these changes:
   - Add missing phases or split overly large phases
   - Adjust technical approach based on new insights
   - Clarify success criteria (ensure clear separation of automated vs manual)
   - Add/remove scope items to align with expectations

4. **Continue refining until user confirms the plan is ready**:
   - Make edits using the Edit tool
   - **Why:** This iterative approach ensures the plan is comprehensive and accurate

## Important Guidelines

These principles guide every aspect of plan creation:

### 1. Be Skeptical and Verify

**What to do:**
- Question vague requirements and ask for concrete examples
- Identify potential issues early through code investigation
- Ask "why" questions to understand underlying goals
- Verify every assumption by reading actual code

**Why this matters:** Assumptions that aren't verified in code lead to implementation blockers. Skepticism prevents wasted effort on incorrect approaches.

### 2. Be Interactive and Collaborative

**What to do:**
- Get user buy-in at each major decision point (approach, structure, details)
- Present options with clear recommendations based on evidence
- Allow course corrections by checking in frequently
- Make incremental progress visible

**Why this matters:** Writing the full plan in isolation risks misalignment with user expectations. Collaboration ensures the plan reflects the actual requirements.

### 3. Be Thorough and Specific

**What to do:**
- Read all context files COMPLETELY using the Read tool (no limit/offset)
- Launch parallel sub-tasks to research independent aspects concurrently
- Include specific file paths and line numbers in all references
- Write measurable success criteria with clear automated vs manual distinction
- Use `make` commands for automated verification when available (e.g., `make check` or `make test`)

**Why this matters:** Vague plans lead to implementation ambiguity. Specific details enable execution agents to work autonomously without additional research.

### 4. Be Practical and Incremental

**What to do:**
- Design phases as incremental, independently testable changes
- Consider migration paths for existing data/systems
- Identify edge cases during planning, not during implementation
- Include "What We're NOT Doing" section to prevent scope creep
- Think about rollback strategies for each phase

**Why this matters:** Monolithic changes are risky and hard to debug. Incremental phases enable progressive validation and easier debugging.

### 5. Track Progress Transparently

**What to do:**
- Use TodoWrite to create and maintain a research task list
- Update todos as you complete research tasks
- Mark tasks complete when finished
- Keep the todo list current and accurate

**Why this matters:** Visible progress tracking helps users understand what's happening and builds confidence in the planning process.

### 6. Resolve All Open Questions Before Finalizing

**Critical requirement:**
- If you encounter open questions during planning, **STOP immediately**
- Research the question using appropriate tools/agents, or ask the user for clarification
- **NEVER write the plan with unresolved questions or TODOs**
- The implementation plan must be 100% complete and actionable
- Every technical decision must be resolved before finalizing

**Why this matters:** Open questions in the plan force implementation agents to make architectural decisions, which often leads to incorrect implementations. The planning phase is where all decisions must be made.

## Success Criteria Guidelines

**Objective:** Define clear, testable verification steps that enable systematic validation of each phase.

**Why this matters:** Separating automated from manual criteria enables execution agents to verify what they can programmatically, while clearly indicating what requires human judgment. This prevents false confidence from passing automated checks while missing critical issues.

### Required Format: Two Categories

**1. Automated Verification** (executable by agents without human intervention):
- Commands that can be executed: `make test`, `npm run lint`, `make migrate`
- File existence checks
- Code compilation and type checking
- Automated test suite execution
- API response validation with curl/HTTP clients

**2. Manual Verification** (requires human testing and judgment):
- UI/UX functionality and visual correctness
- Performance under realistic load conditions
- Edge cases that are difficult or expensive to automate
- User experience and acceptance criteria
- Cross-browser or cross-platform compatibility

### Template Format:

```markdown
### Success Criteria:

#### Automated Verification:
- [ ] Database migration runs successfully: `make migrate`
- [ ] All unit tests pass: `go test ./...`
- [ ] No linting errors: `golangci-lint run`
- [ ] Type checking passes: `npm run typecheck`
- [ ] API endpoint returns 200: `curl localhost:8080/api/new-endpoint`

#### Manual Verification:
- [ ] New feature appears correctly in the UI at /settings/features
- [ ] Performance is acceptable with 1000+ items loaded
- [ ] Error messages are clear and user-friendly
- [ ] Feature works correctly on mobile devices (iOS and Android)
```

**Best practices:**
- Make automated criteria executable - include exact commands
- Make manual criteria specific - include exact locations/scenarios to test
- Prefer `make` commands when available for consistency
- Include expected outcomes (e.g., "returns 200", "no errors")

## Common Patterns

These patterns provide proven approaches for different types of work:

### For Database Changes:

**Recommended sequence:**
1. Design and implement schema/migration first
2. Add store methods (data access layer)
3. Update business logic to use new store methods
4. Expose functionality via API endpoints
5. Update clients to consume the new API

**Why this order:** Database schema is the foundation. Building from bottom-up (data → logic → API → UI) ensures each layer has what it needs from the layer below.

### For New Features:

**Recommended sequence:**
1. Research existing patterns in the codebase first (find similar features)
2. Design the data model (what data structures are needed)
3. Build backend logic and business rules
4. Add API endpoints to expose functionality
5. Implement UI last (frontend consumes the stable API)

**Why this order:** Research ensures consistency with existing patterns. Backend-first development means the UI is built on stable, tested foundations.

### For Refactoring:

**Recommended sequence:**
1. Document current behavior comprehensively (establish baseline)
2. Plan incremental changes with clear intermediate states
3. Maintain backwards compatibility throughout (or plan explicit breaking change)
4. Include migration strategy for existing data/usage
5. Add tests before refactoring to prevent regressions

**Why this order:** Understanding current behavior prevents accidental changes. Incremental steps enable rollback if issues arise. Backwards compatibility prevents breaking existing users.

## Sub-task Spawning Best Practices

**Objective:** Execute comprehensive research efficiently through parallel, well-scoped sub-tasks.

**Why this matters:** Parallel execution dramatically reduces research time. Clear, specific instructions ensure agents return actionable findings rather than generic summaries.

### Best Practices for Spawning Sub-tasks:

**1. Execute independent tasks in parallel**
   - Identify which research tasks have no dependencies on each other
   - Spawn all independent tasks simultaneously
   - **Why:** Parallel execution can reduce 20 minutes of sequential research to 5 minutes

**2. Make each task narrowly focused**
   - One task per specific area or question
   - Avoid vague, catch-all tasks like "research everything about X"
   - **Why:** Focused tasks produce specific, actionable findings

**3. Provide comprehensive instructions to each agent, including:**
   - Exactly what to search for (specific files, patterns, or concepts)
   - Which directories to focus on (with exact paths)
   - What information to extract (data structures, patterns, examples)
   - Expected output format (file:line references, code snippets, explanations)
   - Which tools to use (Read, Grep, Glob for read-only research)

**4. Be extremely specific about directories and paths:**
   - Use exact directory names from the monorepo structure
   - Always specify exact directories to search (e.g., `src/`, `backend/`, `frontend/`)
   - Be specific about which part of the codebase to search
   - Never use ambiguous terms like "UI" when you mean "WUI"
   - Include full path context so agents search the right locations
   - **Why:** Generic instructions lead to agents searching wrong directories

**5. Request specific output formats:**
   - Require file:line references for all code findings
   - Ask for concrete examples with code snippets
   - Request explanations with evidence
   - **Why:** Specific formats make findings immediately actionable

**6. Wait for ALL tasks to complete before synthesizing:**
   - Don't proceed with partial results
   - **Why:** You need the complete picture to make informed decisions

**7. Verify and validate sub-task results:**
   - If results seem unexpected, spawn follow-up tasks to investigate
   - Cross-check findings by reading the identified files yourself
   - Don't accept results that contradict your understanding
   - **Why:** Agents sometimes misinterpret or miss nuances - verification ensures accuracy

### Example: Spawning Parallel Research Tasks

```python
# These tasks investigate independent aspects - spawn them all concurrently:
tasks = [
    Task("Research database schema",
         "Find all database migration files in hld/ and identify the schema for task events. Return file:line references for relevant table definitions."),

    Task("Find API patterns",
         "Search hld/ for existing API endpoint patterns. Find examples of POST endpoints that create resources. Return file:line references and code snippets."),

    Task("Investigate UI components",
         "Search frontend/src/components/ for form components. Find examples of React forms that submit data to APIs. Return file:line references."),

    Task("Check test patterns",
         "Find integration tests in hld/ that test API endpoints. Identify the testing patterns and setup used. Return file:line references.")
]
# All tasks execute concurrently, complete in parallel
```

**Key principle:** If tasks have no dependencies, always execute them in parallel to maximize efficiency.

## Example Interaction Flow

This example demonstrates the collaborative, iterative approach in action:

```
User: /create_plan thoughts/allison/tickets/eng_1478.md

Assistant: [Reads ticket file, spawns parallel research, reads identified files]

Based on my research, I understand the requirement. Let me create a plan outline...

[Iterative collaboration continues through structure approval, detailed writing, and refinement]
```

**This collaborative approach ensures the final plan is thoroughly researched, technically sound, and aligned with user expectations.**
