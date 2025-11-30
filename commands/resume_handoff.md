---
description: Resume work from handoff document with context analysis and validation
---

# Resume work from a handoff document

You will resume work from a handoff document through an interactive analysis and validation process. Handoff documents preserve critical context from previous sessions including technical learnings, implementation decisions, and known pitfalls. Your goal is to restore this context, validate current state against the handoff, and continue the work seamlessly.

**WHY THIS MATTERS**: Handoffs bridge sessions and prevent work duplication. They contain hard-won insights that would otherwise be lost. Thorough context restoration ensures you build on previous progress rather than retracing steps.

## Context for Fresh Sessions

**IMPORTANT**: This command is designed to be run after clearing a session, so you may lack context that was built up during previous work. This section provides the essential context you need.

### Directory Structure

The project uses a `thoughts/` directory hierarchy for documentation and planning:

```
thoughts/
├── shared/                    # Shared across all users/sessions
│   ├── handoffs/             # Handoff documents organized by ticket
│   │   ├── ENG-XXXX/         # Ticket-specific handoffs
│   │   │   └── YYYY-MM-DD_HH-MM-SS_ENG-XXXX_description.md
│   │   └── general/          # Non-ticket handoffs
│   ├── plans/                # Implementation plans
│   │   └── YYYY-MM-DD-ENG-XXXX-description.md
│   └── research/             # Research documents
└── [username]/               # User-specific thoughts/tickets
    └── tickets/              # Ticket descriptions
```

### Available Tools and Subagents

You have access to these key tools:
- **Read**: Read files completely (prefer no limit/offset for full context)
- **Edit**: Make precise changes to files
- **Write**: Create new files
- **Grep**: Search for patterns in files
- **Glob**: Find files by pattern
- **Bash**: Run shell commands (git, make, etc.)
- **TodoWrite**: Track tasks and progress (use this frequently!)
- **Task**: Spawn sub-agents for parallel research

**Subagent types** available via the Task tool:
- `codebase-locator`: Find files related to a feature/task
- `codebase-analyzer`: Understand how code works
- `codebase-pattern-finder`: Find similar implementations to model after
- `thoughts-locator`: Find relevant documents in thoughts/
- `thoughts-analyzer`: Extract insights from thoughts documents
- `general-purpose`: General-purpose agent for complex tasks
- `Explore`: Quick codebase exploration

### Related Commands

Other slash commands that integrate with handoffs:
- `/create_plan` - Create implementation plans (stored in `thoughts/shared/plans/`)
- `/implement_plan` - Execute plans using sub-agent orchestration
- `/validate_plan` - Verify implementation matches plan
- `/create_handoff` - Create a new handoff document
- `/commit` - Create git commits with proper formatting

### Project Conventions

- **File references**: Use `path/to/file.ext:line-range` format (e.g., `src/app.ts:45-60`)
- **Parallel execution**: When tasks are independent, spawn multiple sub-agents concurrently
- **Read files completely**: Use Read without limit/offset to get full context
- **Track progress**: Use TodoWrite to maintain visibility into your work

## Initial Response

When this command is invoked, follow the appropriate path based on the provided parameters:

### Path 1: Direct Handoff Path Provided

If the user provided a direct path to a handoff document (e.g., `thoughts/shared/handoffs/ENG-XXXX/2025-01-15_14-30-00_ENG-XXXX_description.md`):

1. **Immediately read the handoff document completely** using Read tool without limit/offset parameters (reading the full document is critical for understanding complete context)
2. **Immediately read all linked research and plan documents** mentioned under `thoughts/shared/plans` or `thoughts/shared/research`. Read these files directly yourself - these are critical foundation documents that you need to fully understand, not delegate to sub-agents
3. **Begin parallel context gathering** by making multiple independent Read calls simultaneously for all artifact files mentioned in the handoff
4. **Synthesize the gathered context** and propose a specific course of action to the user
5. **Confirm the approach** with the user or ask clarifying questions about priorities

### Path 2: Ticket Number Provided

If the user provided a ticket number (format: `ENG-XXXX`, `PROJ-YYYY`, etc.):

1. **List the handoff directory contents** at `thoughts/shared/handoffs/ENG-XXXX/` (where `ENG-XXXX` is the provided ticket number) to see all available handoffs
3. **Select the appropriate handoff**:
   - **Zero files or directory missing**: Respond with: "I cannot find any handoff documents for [TICKET]. Please provide a direct path to the handoff document you'd like to resume from."
   - **Exactly one file**: Proceed with that single handoff document
   - **Multiple files**: Select the most recent handoff based on the filename timestamp format `YYYY-MM-DD_HH-MM-SS` (24-hour format)
4. **Read the selected handoff completely** using Read tool without limit/offset parameters
5. **Read all linked research and plan documents** directly yourself (under `thoughts/shared/plans` or `thoughts/shared/research`) - these are foundation documents requiring your full understanding
6. **Gather additional context** by reading artifact files mentioned in the handoff (make parallel Read calls for independent files)
7. **Propose a specific course of action** to the user based on the handoff's next steps
8. **Confirm the approach** with the user or ask clarifying questions

### Path 3: No Parameters Provided

If no parameters were provided:

1. **Display the following message** to guide the user:

```
I'll help you resume work from a handoff document. Let me find the available handoffs.

Which handoff would you like to resume from?

Tip: You can invoke this command directly with a handoff path: `/resume_handoff thoughts/shared/handoffs/ENG-XXXX/YYYY-MM-DD_HH-MM-SS_ENG-XXXX_description.md`

or using a ticket number to resume from the most recent handoff for that ticket: `/resume_handoff ENG-XXXX`
```

2. **Wait for the user's input** before proceeding

## Process Steps

### Step 1: Read and Analyze Handoff

**PURPOSE**: This step restores the complete context from the previous session. Skipping any part risks missing critical insights or repeating solved problems.

1. **Read the complete handoff document**:
   - Use the Read tool without limit/offset parameters to get the entire document in one call
   - Extract and note all sections (each serves a specific purpose):
     - **Task(s) and statuses**: Shows what was accomplished and what remains
     - **Recent changes**: Lists specific code modifications made
     - **Learnings**: Contains critical insights about the codebase architecture and gotchas
     - **Artifacts**: References supporting documents with requirements and decisions
     - **Action items and next steps**: Provides the roadmap for continuing work
     - **Other notes**: May contain important context or warnings

2. **Make parallel independent Read calls** for all artifact files mentioned in the handoff:
   - Since these files are independent, read them simultaneously rather than sequentially
   - This includes: feature documents, implementation plans, research documents
   - WHY: Parallel reading significantly reduces total time to restore context

3. **Spawn focused research sub-agent tasks** if needed to verify current state:
   - Use sub-agents for exploratory tasks like searching for patterns or verifying consistency
   - Example research task structure:
   ```
   Task 1 - Verify recent changes still present:
   Verify that all code changes listed in the handoff's "Recent changes" section still exist in the codebase.
   1. For each changed file mentioned, read the file and confirm the changes are present
   2. If any changes are missing or modified, note the discrepancies
   3. Look for any related changes that might have been added since the handoff
   Use tools: Read, Grep
   Return: List of verified changes, missing changes, and new related modifications
   ```

4. **Wait for ALL sub-agent tasks to complete** before synthesizing results (partial information leads to incomplete analysis)

5. **Read critical implementation files** mentioned in the handoff:
   - Make parallel Read calls for files from "Learnings" section (these contain important architectural insights)
   - Read files from "Recent changes" to understand the actual modifications made
   - Read any additional files discovered during research that are relevant to next steps

### Step 2: Synthesize and Present Analysis

**PURPOSE**: This step creates a shared understanding with the user about what was done, what's changed, and what should happen next. Getting confirmation prevents proceeding in the wrong direction.

1. **Present a comprehensive analysis** using this structure:

   ```
   I've analyzed the handoff from [date] by [previous session]. Here's the current situation:

   **Original Tasks:**
   - [Task 1]: [Status from handoff] → [Current verification status]
   - [Task 2]: [Status from handoff] → [Current verification status]

   **Key Learnings Validated:**
   - [Learning with file:line reference] - [Still valid/Changed - explain any changes]
   - [Pattern discovered] - [Still applicable/Modified - explain impact]

   **Recent Changes Status:**
   - [Change 1] - [Verified present/Missing/Modified - with file path]
   - [Change 2] - [Verified present/Missing/Modified - with file path]

   **Artifacts Reviewed:**
   - [Document 1]: [Key requirements or decisions extracted]
   - [Document 2]: [Key requirements or decisions extracted]

   **Recommended Next Actions:**
   Based on the handoff's action items and current state verification:
   1. [Most logical next step with specific action verb] - WHY: [reasoning]
   2. [Second priority action with specific action verb] - WHY: [reasoning]
   3. [Additional tasks discovered during analysis] - WHY: [reasoning]

   **Potential Issues Identified:**
   - [Any conflicts, regressions, or breaking changes found with file references]
   - [Missing dependencies, broken code, or inconsistencies with severity assessment]

   I recommend proceeding with [specific recommended action 1]. Shall I continue with this approach, or would you like to adjust priorities?
   ```

2. **Wait for explicit user confirmation** before proceeding to implementation (this ensures alignment on priorities and approach)

### Step 3: Create Action Plan

**PURPOSE**: Converting insights into a structured task list creates trackable progress and ensures nothing gets forgotten. This provides both you and the user visibility into remaining work.

1. **Create a structured task list using TodoWrite**:
   - Convert each action item from the handoff into a specific, actionable todo with clear completion criteria
   - Add new tasks discovered during your analysis that weren't in the original handoff
   - Prioritize tasks based on:
     - Dependencies (tasks that must complete before others can start)
     - Guidance from the handoff about priorities
     - Critical path items that unblock other work
   - Ensure each todo has both imperative form (content) and active form (activeForm) for clear status display

2. **Present the plan to the user**:
   ```
   I've created a task list based on the handoff and current analysis:

   [Display the todo list showing all tasks with their status]

   This plan incorporates the handoff's recommended next steps plus [X new tasks] discovered during analysis.

   Ready to begin with the first task: [specific task description with expected outcome]?
   ```

### Step 4: Begin Implementation

**PURPOSE**: Execute the work while continuously applying the hard-won insights from the handoff. This is where the previous session's knowledge directly improves current execution.

1. **Execute tasks sequentially, starting with the first approved task**
2. **Actively reference and apply learnings from the handoff** throughout implementation:
   - Before making changes, check if the handoff mentions relevant patterns or gotchas
   - Use the documented approaches that proved successful
   - Avoid patterns or approaches the handoff identified as problematic
3. **Apply proven patterns and architectural decisions** documented in the handoff's learnings section
4. **Update task progress in real-time**:
   - Mark tasks as `in_progress` immediately when starting work on them
   - Mark tasks as `completed` immediately upon successful completion
   - Maintain exactly ONE task in `in_progress` status at a time
5. **Be persistent and autonomous**: Complete each task fully before moving to the next, handling any obstacles or errors that arise without stopping

## Core Guidelines

### 1. Be Thorough in Analysis
**WHY**: Incomplete analysis leads to repeated work, missed context, and implementation errors. The handoff contains concentrated knowledge that took significant effort to acquire.

- **Read the entire handoff document** using a single Read call without limit/offset
- **Verify ALL mentioned changes** still exist in the current codebase (changes may have been modified or reverted)
- **Check for regressions or conflicts** between handoff state and current state
- **Read all referenced artifacts** to understand the full context and requirements
- **Make parallel Read calls** for independent files to restore context efficiently

### 2. Be Interactive and Collaborative
**WHY**: User priorities may have shifted since the handoff was created. Confirming the approach ensures effort goes in the right direction.

- **Present your analysis and findings** before starting implementation work
- **Get explicit buy-in on the proposed approach** and priorities
- **Allow for course corrections** based on user feedback or changed priorities
- **Adapt your plan** when current state differs from handoff state (codebases evolve)
- **Ask clarifying questions** when the handoff mentions multiple possible approaches

### 3. Leverage Handoff Wisdom
**WHY**: The handoff documents hard-won insights that prevent repeating mistakes and leverage proven solutions. This is the primary value of handoffs.

- **Pay special attention to the "Learnings" section** - this contains critical architectural insights and gotchas
- **Apply documented patterns and approaches** that proved successful
- **Explicitly avoid approaches or patterns** the handoff identified as problematic
- **Build on solutions already discovered** rather than re-solving problems
- **Reference specific learnings** when making implementation decisions

### 4. Track Continuity
**WHY**: Maintaining clear lineage between sessions enables future context restoration and demonstrates which handoff informed which work.

- **Use TodoWrite to maintain task continuity** from handoff through completion
- **Reference the handoff document in commits** (e.g., "Based on handoff from [date]: implemented [feature]")
- **Document any deviations from the original plan** and explain why adjustments were necessary
- **Consider creating a new handoff when done** if work is incomplete or new learnings emerged

### 5. Validate Before Acting
**WHY**: Time passes between handoffs and resumption. Code changes, dependencies update, patterns evolve. Assuming current state matches handoff state leads to errors.

- **Verify all file references from the handoff still exist** at the expected paths
- **Check for breaking changes** introduced since the handoff was created
- **Confirm patterns and approaches are still valid** in the current codebase state
- **Test that changes mentioned in the handoff are still present** and functioning
- **Identify any new related work** that might have been added since the handoff

## Common Scenarios and How to Handle Them

### Scenario 1: Clean Continuation
**Indicators**: All changes from handoff are present, no conflicts or regressions, clear next steps in action items

**Action**:
- Confirm current state matches handoff state through verification
- Proceed directly with the recommended action items from the handoff
- Apply learnings and patterns documented in the handoff
- Expected smooth progression to task completion

### Scenario 2: Diverged Codebase
**Indicators**: Some changes missing or modified, new related code added since handoff, handoff references no longer match current structure

**Action**:
- Document all discrepancies between handoff state and current state in your analysis
- Identify which new changes conflict with or supersede the handoff's work
- Adapt the implementation plan based on current codebase state
- Preserve the learnings and insights from the handoff even if specific changes have evolved
- Propose a reconciliation approach to the user before proceeding

### Scenario 3: Incomplete Handoff Work
**Indicators**: Tasks marked as "in_progress" in handoff, partial implementations present, features half-built

**Action**:
- Prioritize completing the in-progress work before starting new tasks
- Read and understand the partial implementations thoroughly (look for TODO comments, incomplete functions)
- Continue from the exact stopping point rather than restarting
- Focus on finishing existing work to completion before adding new features
- Verify the partial work is still functional before building on it

### Scenario 4: Stale Handoff
**Indicators**: Significant time has passed, major refactoring has occurred, file paths or APIs have changed, original approach no longer fits current architecture

**Action**:
- Identify which parts of the handoff are still applicable vs. obsolete
- Extract the timeless learnings and insights that still apply
- Re-evaluate the implementation strategy in light of architectural changes
- Propose a modernized approach that incorporates handoff wisdom
- Document why the original approach needed adjustment
- Consider whether the handoff's goals are still relevant or priorities have shifted

## Example Interaction Flow

This example demonstrates the complete flow from invocation through implementation:

```
User: /resume_handoff thoughts/shared/handoffs/ENG-2124/2025-01-15_14-30-00_ENG-2124_webhook-validation.md
Assistant: I will read and analyze the handoff document for ENG-2124.

[Reads handoff document completely using Read tool]
[Makes parallel Read calls for artifacts: feature spec, implementation plan]
[Spawns sub-agent task to verify recent changes]
[Waits for sub-agent completion]
[Reads critical files mentioned in learnings section]

I have analyzed the handoff from January 15, 2025. Here is the current situation:

**Original Tasks:**
- Implement webhook signature validation: Completed → Verified present in src/webhooks/validator.ts
- Add tests for validation logic: Completed → Verified all tests passing
- Update documentation: In Progress → Documentation partially complete

**Key Learnings Validated:**
- Webhook signatures use HMAC-SHA256 with timestamp prefix (src/webhooks/validator.ts:45) - Still valid
- Need to handle replay attacks within 5-minute window (design decision) - Still applicable
- Existing validation library had timing attack vulnerability (security issue) - Custom implementation still in use

**Recent Changes Status:**
- Added WebhookValidator class - Verified present at src/webhooks/validator.ts
- Added unit tests - Verified present at tests/webhooks/validator.test.ts (15 tests, all passing)
- Updated webhook endpoint - Verified present at src/api/webhooks.ts

**Artifacts Reviewed:**
- Feature spec (thoughts/shared/plans/ENG-2124-webhook-security.md): Requires HMAC-SHA256 validation and replay protection
- Implementation plan: Three-phase approach completed through phase 2

**Recommended Next Actions:**
Based on the handoff's action items and current state verification:
1. Complete API documentation for webhook validation endpoint - WHY: Documentation marked as in-progress in handoff
2. Add integration tests for end-to-end webhook flow - WHY: Only unit tests exist, integration coverage needed per plan
3. Update client SDK examples to show signature generation - WHY: Listed as next step in handoff

**Potential Issues Identified:**
- None - codebase state matches handoff state cleanly

I recommend proceeding with completing the API documentation. Shall I continue with this approach, or would you like to adjust priorities?

User: Yes, proceed with the documentation

Assistant: I will create a task list and begin completing the API documentation.

[Uses TodoWrite to create structured task list with 3 tasks]

I've created a task list based on the handoff and current analysis:

1. [pending] Complete API documentation for webhook validation endpoint
2. [pending] Add integration tests for end-to-end webhook flow
3. [pending] Update client SDK examples to show signature generation

This plan incorporates the handoff's recommended next steps.

Ready to begin with the first task: Complete API documentation for webhook validation endpoint?

[Marks task 1 as in_progress]
[Reads existing documentation files]
[Applies the HMAC-SHA256 pattern from handoff learnings]
[Adds comprehensive API docs including replay attack protection guidance]
[Marks task 1 as completed]
[Continues with remaining tasks...]
```

**Note**: This flow shows Claude autonomously working through the handoff by thoroughly analyzing context, proposing an approach, getting user confirmation, and then executing tasks while applying the documented learnings.
