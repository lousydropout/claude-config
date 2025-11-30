---
description: Implement technical plans from thoughts/shared/plans with verification
---

# Implement Plan

Your goal is to implement an approved technical plan from `thoughts/shared/plans/` using an **orchestration pattern**. You act as the orchestrator, coordinating specialized sub-agents that handle implementation, testing, and validation. This keeps your context clean while sub-agents do the heavy lifting.

## Context for Fresh Sessions

**IMPORTANT**: This command may be run after clearing a session or resuming from a handoff. You may lack context from previous work. This section provides essential context.

### Directory Structure

```
thoughts/shared/
├── plans/        # Implementation plans (YYYY-MM-DD-ENG-XXXX-description.md)
├── handoffs/     # Handoff documents by ticket
└── research/     # Research documents
```

### How to Spawn Sub-agents

Use the **Task tool** with `subagent_type` parameter:
- `general-purpose`: For implementation, testing, validation, and fixing tasks
- `codebase-analyzer`: To understand existing code patterns
- `codebase-locator`: To find relevant files

**Example Task call**:
```
Task tool with:
- subagent_type: "general-purpose"
- prompt: [detailed instructions including full plan content]
```

### Key Tools

- **Read**: Read files completely (no limit/offset for full context)
- **TodoWrite**: Track orchestration progress (one item per phase)
- **Task**: Spawn sub-agents for each phase step

### Related Commands

- `/resume_handoff` - Resume from a handoff document
- `/validate_plan` - Verify implementation after completion
- `/create_handoff` - Create handoff if work is incomplete
- `/commit` - Create git commits

## Orchestrator Role

**Your responsibilities:**
- Read and understand the complete plan
- Track progress using TodoWrite
- Spawn appropriate sub-agents for each task
- Make decisions about issue severity (minor vs major)
- Provide detailed progress reports to the user
- Ensure quality gates are met before proceeding
- Escalate major issues to the user

**What you do NOT do directly:**
- Implement code (sub-agents do this)
- Run tests (sub-agents do this)
- Fix issues (sub-agents do this)

**Why this pattern:** Sub-agents get fresh context for each task, preventing the context accumulation issues that occur in long implementation sessions. You maintain the high-level view while they handle details.

## Getting Started

When given a plan path, execute these steps:

1. **Read the complete plan** - Use the Read tool to load the entire plan file
2. **Identify completed work** - Check for existing checkmarks (- [x]) indicating previous progress
3. **Gather file list** - Note all files mentioned in the plan that sub-agents will need
4. **Create orchestration todo list** - Use TodoWrite with one item per phase
5. **Begin orchestration** - Start spawning sub-agents for the first incomplete phase

If no plan path is provided, ask the user for the specific plan file path.

## Phase Execution Flow

For each phase, execute this sequence **sequentially**:

```
┌─────────────────────────────────────────────────────┐
│ 1. Spawn Implementer    → Makes code changes        │
│         ↓                                           │
│ 2. Spawn Tester         → Runs tests, finds gaps    │
│         ↓                                           │
│ 3. Spawn Validator      → Checks against plan       │
│         ↓                                           │
│ 4. Evaluate Results                                 │
│    ├── All pass → Report & proceed to next phase   │
│    ├── Minor issues → Spawn Fixer, then re-test    │
│    └── Major issues → Escalate to user             │
└─────────────────────────────────────────────────────┘
```

### Step 1: Spawn Phase Implementer

Launch a sub-agent to implement the phase:

```
Task tool with subagent_type: "general-purpose"
```

**Prompt template:**
```
# Phase Implementation Task

## Objective
Implement Phase [N]: [Phase Name] from the implementation plan.

## Plan Document
[Paste the FULL plan content]

## Current Phase Details
[Paste the specific phase section]

## Files to Read First
Read these files completely before making changes:
- [List all files mentioned in this phase]
- [Include dependencies and shared utilities]

## Implementation Requirements
1. Follow the plan's technical approach exactly
2. Add tests for all new functionality:
   - Unit tests for new functions/methods
   - Integration tests for component interactions
   - Edge case tests for boundary conditions
3. Ensure code follows existing codebase patterns
4. Update plan file checkboxes (- [ ] to - [x]) as you complete items

## Success Criteria
[Paste success criteria from plan for this phase]

## Output Required
Provide a structured report:
1. **Changes Made**: List each file with line ranges and description
   Format: `path/to/file.ts:45-67 - Description of change`
2. **Tests Added**: List new tests and what they cover
3. **Deviations**: Any differences from plan and reasoning
4. **Issues**: Any problems encountered
5. **Criteria Status**: Confirmation each success criterion is met
```

### Step 2: Spawn Phase Tester

After implementation, launch a sub-agent to verify tests:

```
Task tool with subagent_type: "general-purpose"
```

**Prompt template:**
```
# Phase Testing Task

## Objective
Verify test coverage and run all tests for Phase [N]: [Phase Name].

## Implementation Summary
The implementer reported these changes:
[Paste summary from implementer]

## Testing Requirements

### 1. Run Test Suite
- Execute: `make test` (or project-specific command)
- Capture all output including failures
- Note any flaky tests

### 2. Analyze Coverage
For each change in the implementation summary:
- Verify adequate tests exist
- Check edge cases and error paths
- Identify untested code paths

### 3. Categorize Test Gaps

**Minor gaps** (quick to add):
- Simple utility function tests
- Getter/setter tests
- Basic validation tests

**Major gaps** (need discussion):
- Integration tests across components
- Tests requiring complex setup
- Performance/load tests
- Security-sensitive code paths

## Output Required
1. **Test Results**: Pass/fail counts, any failures with details
2. **Minor Gaps**: List with suggested test cases
3. **Major Gaps**: List with explanation of complexity
4. **Assessment**: PASS / MINOR_ISSUES / MAJOR_ISSUES
```

### Step 3: Spawn Phase Validator

After testing, launch a sub-agent to validate against the plan:

```
Task tool with subagent_type: "general-purpose"
```

**Prompt template:**
```
# Phase Validation Task

## Objective
Validate Phase [N]: [Phase Name] implementation matches plan requirements.

## Plan Document
[Paste FULL plan content]

## Phase Requirements
[Paste specific phase section]

## Implementation Summary
[Paste summary from implementer]

## Test Results
[Paste summary from tester]

## Validation Checklist

### Completeness
- [ ] All phase items implemented
- [ ] Plan checkboxes accurately marked
- [ ] No requirements skipped

### Correctness
- [ ] Matches technical approach in plan
- [ ] Follows specified patterns
- [ ] Edge cases handled

### Quality
- [ ] Tests exist for new functionality
- [ ] Error handling appropriate
- [ ] Consistent with codebase style

### Success Criteria
[List each criterion with status and evidence]

## Output Required
1. **Status**: PASSED / FAILED
2. **Unmet Requirements**: List any gaps
3. **Deviations**: Beneficial vs problematic
4. **Recommendations**: Fixes needed if FAILED
```

### Step 4: Evaluate and Decide

Based on sub-agent reports:

**All pass:** Update todo list, report to user, proceed to next phase.

**Minor issues only:**
- Spawn fixer sub-agent (see below)
- Re-run tester and validator after fixes
- Maximum 2 fix cycles, then escalate

**Major issues:**
- Stop execution immediately
- Report full context to user
- Wait for user guidance before continuing

**Fixer prompt template:**
```
# Phase Fix Task

## Objective
Fix minor issues in Phase [N]: [Phase Name].

## Issues to Fix
[List specific issues from tester/validator]

## Files to Modify
[List specific files]

## Constraints
- ONLY fix listed issues
- Do NOT refactor unrelated code
- Add missing tests identified as "minor gaps"
- Run tests after fixes

## Output Required
1. **Fixes Applied**: file:line references
2. **Tests Added**: List new tests
3. **Test Results**: Confirmation all pass
4. **Unfixable Issues**: Anything that needs escalation
```

## Progress Reporting

After each phase completes, provide a **detailed summary** to the user:

```
═══════════════════════════════════════════════════════════════
Phase [N] Complete: [Phase Name]
═══════════════════════════════════════════════════════════════

Changes Made:
• src/components/UserForm.tsx:45-67 - Added email validation
• src/components/UserForm.tsx:89-102 - Error state handling
• src/utils/validation.ts:12-28 - New validateEmail() function
• src/api/users.ts:156-178 - Updated createUser endpoint

Tests Added:
• src/__tests__/validation.test.ts - 4 tests for validateEmail()
• src/__tests__/UserForm.test.tsx - 3 tests for error states
• Coverage: All new functions tested, edge cases covered

Test Results:
• 48/48 passing (6 new tests added)
• No regressions detected

Validation:
• ✓ All success criteria met
• ✓ Implementation matches plan approach
• Note: Used Zod instead of manual validation (beneficial - matches codebase pattern)

───────────────────────────────────────────────────────────────
Proceeding to Phase [N+1]: [Next Phase Name]
───────────────────────────────────────────────────────────────
```

This transparency ensures the user:
- Knows exactly what changed
- Can verify tests were added
- Sees any deviations from plan
- Can intervene if something looks wrong

## Issue Escalation

### Minor Issues (Auto-Fix)
- Missing tests for simple utilities
- Minor style inconsistencies
- Simple null checks
- Documentation gaps
- Basic validation oversights

### Major Issues (Escalate to User)
- Architectural deviations from plan
- Missing tests for complex logic
- Security concerns
- Performance problems
- Integration failures
- Unclear requirements
- Changes affecting other features

**Format for escalation:**
```
═══════════════════════════════════════════════════════════════
⚠️  Major Issue - User Input Required
═══════════════════════════════════════════════════════════════

Phase: [N] - [Phase Name]
Issue Type: [Architectural / Security / Integration / etc.]

Problem:
[Clear description of what went wrong]

Evidence:
[Specific errors, test failures, or validator findings]

Impact:
[What this affects and why it matters]

Options:
1. [Option A with trade-offs]
2. [Option B with trade-offs]
3. [Other suggestions]

How would you like to proceed?
═══════════════════════════════════════════════════════════════
```

**When in doubt, escalate.** It's better to ask than to auto-fix incorrectly.

## Handling Plan Mismatches

When reality doesn't match the plan (file doesn't exist, function has different signature, approach won't work):

1. **Stop immediately** - Don't work around without understanding
2. **Analyze root cause** - Why does this mismatch exist?
3. **Escalate to user** with this format:

```
Issue in Phase [N]:
Expected: [what the plan says]
Found: [actual situation]
Impact: [how this affects implementation]

How should I proceed?
```

## Resuming Incomplete Work

If the plan has existing checkmarks (- [x]):

1. **Trust completed work** - Assume checked items were done correctly
2. **Find starting point** - Locate first unchecked item
3. **Verify if needed** - Only re-examine previous work if you find inconsistencies

## Final Completion

After all phases complete:

1. **Spawn final validator** for the entire plan
2. **Report to user:**

```
═══════════════════════════════════════════════════════════════
Implementation Complete: [Feature/Ticket Name]
═══════════════════════════════════════════════════════════════

Phases Completed:
✓ Phase 1: [Name]
✓ Phase 2: [Name]
✓ Phase 3: [Name]

Total Changes:
• [X] files modified
• [Y] new tests added
• All automated checks passing

Manual Testing Required:
- [ ] [Manual test item 1 from plan]
- [ ] [Manual test item 2 from plan]

Ready for: Code review and manual testing

Would you like me to:
• Create a commit? (/commit)
• Create a PR? (gh pr create)
• Run additional validation?
═══════════════════════════════════════════════════════════════
```

## Context Management

**What to pass to sub-agents:**
- Always: Full plan document
- Always: All files mentioned in current phase
- Always: Clear success criteria
- For validators: Summaries from implementer and tester
- For fixers: Specific issue list only

**What NOT to pass:**
- Previous phases' detailed logs
- Full conversation history
- Files not relevant to current phase

## Core Principles

- **Orchestrate, don't implement** - You coordinate; sub-agents execute
- **Report transparently** - Users should never wonder what happened
- **Escalate appropriately** - Auto-fix minor issues, ask about major ones
- **Maintain momentum** - Complete phases fully before proceeding
- **Trust but verify** - Sub-agents do the work, you verify the results
