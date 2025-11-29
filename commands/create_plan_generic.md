---
description: Create detailed implementation plans with thorough research and iteration
model: opus
---

# Implementation Plan

Your goal is to create comprehensive, actionable implementation plans through collaborative iteration with the user. This command produces technical specifications that execution agents can follow with minimal ambiguity.

**Why this matters**: High-quality plans prevent costly mid-implementation surprises, reduce rework, and enable autonomous execution agents to complete complex tasks successfully. Your thoroughness here directly impacts implementation success.

## Initial Response

Execute these steps based on whether parameters were provided:

**If parameters provided** (file path or ticket reference):
1. Read all provided files completely using the Read tool without limit/offset parameters
2. Proceed directly to Step 1: Context Gathering & Initial Analysis
3. Context: Reading files fully in the main context ensures you have complete information before delegating research tasks

**If no parameters provided**, respond with this exact message:
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

Then wait for the user's input before proceeding.

## Process Steps

### Step 1: Context Gathering & Initial Analysis

**Why this step matters**: Gathering complete context before asking questions enables you to ask informed, specific questions rather than basic clarifications the codebase could answer.

Execute these actions in order:

**1. Read all mentioned files completely in the main context**

Read these file types using the Read tool without limit/offset parameters:
- Ticket files (e.g., `thoughts/allison/tickets/eng_1234.md`)
- Research documents
- Related implementation plans
- JSON/data files mentioned

**Why read in main context first**: This ensures you have the full context before delegating tasks, enabling you to write more specific and effective research prompts for subagents.

**2. Launch parallel research tasks to gather codebase context**

Before asking the user any questions, spawn multiple specialized research agents in parallel using the Task tool. Make all independent task calls in a single response for efficiency:

Research tasks to spawn concurrently:
- **codebase-locator**: Find all files related to the ticket/task (e.g., "locate all files handling user authentication")
- **codebase-analyzer**: Understand current implementation (e.g., "analyze how the payment processing workflow currently works")
- **thoughts-locator** (if relevant): Find existing thoughts documents about this feature area

These specialized agents will:
- Locate relevant source files, configurations, and tests
- Trace data flow and identify key functions
- Return detailed explanations with specific file:line references
- Find existing patterns you should follow

**3. Read all files identified by research agents**

After research tasks complete, read ALL files they identified as relevant:
- Use the Read tool to load complete files into your main context
- Read files fully (no limit/offset parameters)
- **Why this matters**: Having the actual code in context enables accurate analysis and prevents planning based on outdated or incorrect assumptions

**4. Analyze and verify your understanding**

Perform these verification steps:
- Cross-reference ticket requirements against actual code implementation
- Identify discrepancies between what's requested and what currently exists
- List assumptions that require verification
- Calculate true scope based on codebase reality (not just ticket description)

**5. Present informed understanding and ask focused questions only**

Use this response format:
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

**Ask only questions you genuinely cannot answer through code investigation**. If the codebase can answer it, research deeper instead of asking the user.

### Step 2: Research & Discovery

**Why this step matters**: Comprehensive research uncovers hidden constraints, existing patterns, and design precedents that inform better architectural decisions.

After receiving initial clarifications from the user, execute these steps:

**1. Verify any user corrections through independent research**

If the user corrects a misunderstanding:
1. Spawn new research tasks to verify the corrected information
2. Read the specific files/directories they mention
3. Only proceed after you've verified the facts yourself through code examination

**Why verify independently**: Users may have outdated knowledge or misremember implementation details. Code is the source of truth.

**2. Create a research tracking list**

Use TodoWrite to create a structured todo list tracking all research tasks you need to complete. This helps you stay organized and shows the user your systematic approach.

**3. Launch comprehensive parallel research tasks**

Spawn multiple Task agents concurrently to research different aspects. Make all independent task calls in parallel for efficiency.

Select the appropriate specialized agents for each research need:

**For deeper investigation:**
- **codebase-locator**: Find specific files (e.g., "find all files that handle WebSocket connections")
- **codebase-analyzer**: Understand implementation details (e.g., "analyze how the authentication middleware chain works")
- **codebase-pattern-finder**: Find similar features to model after (e.g., "find existing pagination implementations")

**For historical context:**
- **thoughts-locator**: Find research, plans, or decisions about this area
- **thoughts-analyzer**: Extract key insights from relevant documents

Each specialized agent provides:
- Specific file paths and code patterns
- Conventions and patterns to follow
- Integration points and dependencies
- File:line references for all claims
- Relevant tests and usage examples

**4. Wait for ALL sub-tasks to complete before proceeding**

**Why wait**: Synthesizing incomplete research leads to incorrect conclusions. Complete information enables better design decisions.

**5. Present research findings and design options**

Use this structured response format:
```
Based on my research, here's what I found:

**Current State:**
- [Key discovery about existing code with file:line reference]
- [Pattern or convention to follow with example]

**Design Options:**
1. [Option A] - [concrete pros/cons based on codebase reality]
2. [Option B] - [concrete pros/cons based on codebase reality]

**Open Questions:**
- [Technical uncertainty that requires human judgment]
- [Design decision that affects user experience]

Which approach aligns best with your vision?
```

Frame options positively (what each approach enables) rather than negatively (what each approach avoids).

### Step 3: Plan Structure Development

**Why this step matters**: Getting agreement on structure before writing details prevents wasted effort and ensures the plan matches the user's mental model of the work.

Once you and the user are aligned on the technical approach, execute these steps:

**1. Create and present initial plan outline**

Present a high-level structure using this format:
```
Here's my proposed plan structure:

## Overview
[1-2 sentence summary of what we're building and why]

## Implementation Phases:
1. [Phase name] - [what this phase accomplishes and delivers]
2. [Phase name] - [what this phase accomplishes and delivers]
3. [Phase name] - [what this phase accomplishes and delivers]

Does this phasing make sense? Should I adjust the order or granularity?
```

**Structure phases to be:**
- Independently testable and verifiable
- Incrementally valuable (each phase delivers working functionality)
- Ordered by dependencies (foundational work first)
- Scoped to 2-6 hours of work each when possible

**2. Iterate on structure based on user feedback**

Wait for user feedback before proceeding to detailed plan writing. Be prepared to:
- Reorder phases based on priority
- Split large phases into smaller increments
- Merge small phases that should be atomic
- Adjust phase boundaries based on user's preferred workflow

### Step 4: Detailed Plan Writing

**Why this step matters**: A well-structured plan becomes the contract between planning and execution, enabling autonomous agents to implement with confidence.

After the user approves the plan structure, write the complete implementation plan:

**1. Determine the plan file path**

Create the plan at: `thoughts/shared/plans/YYYY-MM-DD-ENG-XXXX-description.md`

File naming format:
- `YYYY-MM-DD`: Today's date (enables chronological sorting)
- `ENG-XXXX`: Ticket number (omit this part if no ticket exists)
- `description`: Brief kebab-case description of the work

Examples:
- With ticket: `2025-01-08-ENG-1478-parent-child-tracking.md`
- Without ticket: `2025-01-08-improve-error-handling.md`

**2. Write the plan using this template structure**

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

### Step 5: Review and Iteration

**Why this step matters**: User feedback catches blind spots, validates assumptions, and ensures the plan aligns with unstated requirements or preferences.

After writing the plan, execute these steps:

**1. Sync the thoughts directory**

Run the sync command to ensure the plan is properly indexed and available to other tools and agents.

**2. Present the plan location and request specific feedback**

Use this response format:
```
I've created the implementation plan at:
`thoughts/shared/plans/YYYY-MM-DD-ENG-XXXX-description.md`

Please review and provide feedback on:
- Are the phases properly scoped and ordered?
- Are the success criteria specific enough to verify completion?
- Do the technical approaches align with your preferences?
- Are there missing edge cases or considerations?
- Is anything out of scope that should be included (or vice versa)?
```

**Why ask specific questions**: Directed questions help users focus their review on the most important aspects rather than general "looks good" responses.

**3. Iterate based on user feedback**

Be prepared to make these types of revisions:
- Add missing phases or steps
- Adjust technical approach based on new information
- Clarify success criteria (both automated and manual verification)
- Add or remove scope items
- Reorder phases based on dependencies or priorities
- Add more detail to specific sections

**4. Continue refining until user approval**

Keep iterating until the user explicitly approves the plan or indicates readiness to proceed. A thorough plan saves hours during implementation.

## Core Operating Principles

Apply these principles throughout the planning process:

**1. Verify Assumptions Through Code**
- Question vague requirements by examining actual implementation
- Identify potential issues early through codebase investigation
- Ask "why" and "what about" when requirements seem incomplete
- Verify every claim against the actual code, not documentation or memory

**Why this matters**: Assumptions based on outdated knowledge lead to plans that fail during implementation. Code is the source of truth.

**2. Work Collaboratively and Iteratively**
- Present work in stages rather than writing the full plan in one shot
- Get user buy-in at each major decision point
- Enable course corrections before investing in detailed planning
- Treat planning as a conversation, not a monologue

**Why this matters**: Interactive planning catches misalignments early and ensures the final plan matches the user's vision.

**3. Research Thoroughly and Systematically**
- Read all context files completely before planning (no partial reads)
- Launch parallel research sub-tasks for comprehensive codebase analysis
- Include specific file paths and line numbers in all references
- Separate success criteria into automated verification vs manual testing

**Why this matters**: Thorough research uncovers hidden constraints and existing patterns that dramatically impact implementation strategy.

**4. Plan Incrementally and Practically**
- Structure phases as incremental, testable changes that deliver value independently
- Consider migration paths and rollback strategies for risky changes
- Identify edge cases and error conditions explicitly
- Define "what we're NOT doing" to prevent scope creep

**Why this matters**: Practical, incremental plans reduce risk and enable faster feedback cycles during implementation.

**5. Track Planning Progress Visibly**
- Use TodoWrite to create and maintain a visible research task list
- Update todos as you complete research activities
- Mark planning tasks complete when done

**Why this matters**: Visible progress tracking shows systematic thinking and helps users understand where you are in the planning process.

**6. Resolve All Questions Before Finalizing**
- If you encounter open questions during planning, stop writing and resolve them immediately
- Research the codebase or ask the user for clarification
- Write the plan only when you have complete information
- The final plan must be actionable without additional decisions

**Why this matters**: Plans with open questions block execution agents and create costly delays. Complete plans enable autonomous execution.

## Success Criteria Guidelines

**Why success criteria matter**: Clear, measurable criteria enable execution agents to verify their work and know when to pause for human validation.

**Structure success criteria in two distinct categories:**

**1. Automated Verification** (execution agents can verify these independently)

Include criteria that can be verified by running commands or checking file existence:
- Test commands: `make test`, `npm run lint`, `go test ./...`
- Build commands: `npm run build`, `make compile`
- Type checking: `npm run typecheck`, `tsc --noEmit`
- Specific files that must exist after changes
- Database migrations that must apply cleanly
- API endpoints that must return expected responses

**2. Manual Verification** (requires human judgment and testing)

Include criteria that need human evaluation:
- UI/UX functionality and visual correctness
- Performance characteristics under realistic load
- Edge cases that are difficult to automate
- User experience and error message quality
- Cross-browser or cross-device compatibility

**Example format:**
```markdown
### Success Criteria:

#### Automated Verification:
- [ ] Database migration applies cleanly: `make migrate`
- [ ] All unit tests pass: `go test ./...`
- [ ] No linting errors: `golangci-lint run`
- [ ] API endpoint returns 200 with expected schema: `curl localhost:8080/api/new-endpoint`
- [ ] Type checking passes: `npm run typecheck`

#### Manual Verification:
- [ ] New feature renders correctly in the UI at /settings/notifications
- [ ] Performance remains acceptable with 1000+ notification items
- [ ] Error messages provide clear guidance to users
- [ ] Feature works correctly on mobile Safari and Chrome
```

**Be specific**: Instead of "tests pass," write "all unit tests pass: `npm test`". Instead of "check UI," write "verify notification badge appears in header when new notifications arrive".

## Common Implementation Patterns

These patterns provide proven approaches for structuring phases. Adapt them to your specific context.

**For Database Changes:**
1. Design and implement schema migration
2. Add store/repository methods for data access
3. Update business logic to use new schema
4. Expose changes via API layer
5. Update client code to consume new API

**Why this order**: Database changes are foundational. Building from data layer up ensures each layer can depend on the layer below.

**For New Features:**
1. Research existing similar features in the codebase first
2. Design and implement data model
3. Build backend business logic
4. Add API endpoints
5. Implement UI components last

**Why this order**: Backend-first development allows UI to be built against a working API, enabling independent testing of business logic.

**For Refactoring:**
1. Document current behavior thoroughly (write tests if missing)
2. Plan incremental changes that maintain working code at each step
3. Maintain backwards compatibility during transition
4. Include migration or deprecation strategy for consumers
5. Remove old code only after migration is complete

**Why this order**: Incremental refactoring with backwards compatibility reduces risk and allows rollback at any point.

## Sub-task Spawning Best Practices

**Why spawn sub-tasks**: Parallel research tasks complete faster than sequential investigation and leverage specialized agents optimized for specific research types.

**Execute these practices when spawning research sub-tasks:**

**1. Launch multiple tasks in parallel for efficiency**

Make all independent Task tool calls in a single response. This dramatically reduces research time compared to sequential investigation.

**2. Focus each task on a specific research area**

Give each task a clear, bounded scope:
- "Find all database migration files in the last 6 months"
- "Analyze how the current authentication middleware works"
- "Locate all React components that handle form validation"

**3. Provide detailed, specific instructions to each task**

Include in each task prompt:
- Exactly what to search for (be specific, not vague)
- Which directories or file patterns to focus on
- What information to extract (patterns, conventions, examples)
- Expected output format (bullet points, code snippets, file:line references)
- Full path context (e.g., "in the /home/user/project/backend directory")

**4. Specify read-only tools for research tasks**

Direct tasks to use: Read, Grep, Glob, Bash (for read-only commands like `git log`)

**5. Request specific file:line references in responses**

Instruct tasks to cite their findings: "Include file:line references for all code examples and claims"

**6. Wait for ALL tasks to complete before synthesizing**

Incomplete research leads to incorrect conclusions. Wait for all parallel tasks to finish before proceeding.

**7. Verify sub-task results independently**

When sub-task results seem incorrect or unexpected:
- Spawn follow-up tasks to investigate further
- Read the files yourself to verify claims
- Cross-check findings against actual codebase
- Trust code over documentation or task responses

**Example of effective parallel task spawning:**
```python
# Launch these tasks concurrently in a single response:
tasks = [
    Task("Database schema research", "Find all database migration files in migrations/ directory and identify the current user table schema"),
    Task("API pattern research", "Analyze how existing API endpoints in api/handlers/ handle authentication and return the common patterns"),
    Task("UI component research", "Locate all React form components in frontend/src/components/ and document the validation patterns used"),
    Task("Test pattern research", "Find test files for similar features and extract the testing patterns and helper functions used")
]
```

## Example Interaction Flow

This example demonstrates the collaborative planning process in action:

```
User: /create_plan thoughts/allison/tickets/eng_1478.md
Assistant: [Reads file completely]

I'm launching parallel research tasks to understand the current implementation...

[Spawns multiple parallel tasks: codebase-locator, codebase-analyzer, thoughts-locator]
[Tasks complete]

Based on the ticket and my research, I understand we need to add parent-child tracking for Claude sub-task events.

I've found that:
- The daemon stores events in hld/store/events.go:45
- Sub-task creation happens in hld/claude/subtask.go:122
- No existing parent_id field in events table

Questions my research could not answer:
- Should we track full ancestor chain or just immediate parent?
- Expose via REST API immediately?

User: Just immediate parent. Yes, expose via API.

Assistant: Perfect. Let me propose a plan structure:

## Overview
Add parent_id tracking to sub-task events for better task hierarchy visibility

## Implementation Phases:
1. Database Schema - Add parent_id column to events table
2. Store Layer - Update methods to accept and store parent_id
3. API Layer - Expose parent_id in event responses
4. Client Updates - Update sub-task creation to pass parent_id

Does this phasing make sense?

User: Yes, looks good.

Assistant: Great\! I'll write the detailed plan now...

[Writes plan to thoughts/shared/plans/2025-01-15-ENG-1478-parent-child-tracking.md]
[Syncs thoughts directory]

I've created the implementation plan at:
thoughts/shared/plans/2025-01-15-ENG-1478-parent-child-tracking.md

Please review and let me know if any adjustments are needed.
```
