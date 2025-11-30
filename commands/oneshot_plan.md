---
description: Execute ralph plan and implementation for a ticket
---

# Oneshot Plan and Implementation

This command orchestrates a complete ticket workflow using specialized sub-agents. You act as the **orchestrator**, coordinating planning and implementation while sub-agents handle the detailed work. This keeps your context clean for high-level coordination.

## Orchestrator Role

**Your responsibilities:**
- Read and understand the overall plan
- Spawn appropriate sub-agents for each task
- Track progress and maintain the todo list
- Make decisions about issue severity (minor vs major)
- Report progress and blockers to the user
- Ensure quality gates are met before proceeding

**What you do NOT do:**
- Implement code directly (sub-agents do this)
- Run tests directly (sub-agents do this)
- Debug issues directly (sub-agents do this)

## Workflow Overview

```
Phase 1: Planning
└── Invoke /create_plan to generate implementation plan

Phase 2: Implementation (for each phase in plan)
├── Spawn: phase-implementer (implements the phase)
├── Spawn: phase-tester (runs tests, identifies coverage gaps)
├── Spawn: phase-validator (validates against plan requirements)
├── If issues:
│   ├── Minor → Spawn: phase-fixer (auto-fix)
│   └── Major → Escalate to user
└── Update progress, proceed to next phase

Phase 3: Completion
└── Final summary and handoff to user
```

## Execution Steps

### Step 1: Planning Phase

Invoke the planning command to generate a comprehensive implementation plan:

```
/create_plan [ticket_number]
```

Wait for planning to complete. The plan will be created at a path like:
`thoughts/shared/plans/[ticket]/[date]_[description].md`

Once complete, read the plan fully and create your orchestration todo list.

### Step 2: Prepare Orchestration

After reading the plan:

1. **Create a master todo list** using TodoWrite with one item per phase
2. **Identify all files** mentioned in the plan that sub-agents will need
3. **Note the success criteria** for each phase (automated and manual)

### Step 3: Execute Each Phase

For each phase in the plan, execute this sequence **sequentially**:

#### 3a. Spawn Phase Implementer

Launch a sub-agent to implement the phase:

```
Task tool with subagent_type: "general-purpose"
```

Note: Using `general-purpose` with detailed prompts. Specialized agent types can be created later for optimized tool access.

**Prompt template for phase-implementer:**
```
# Phase Implementation Task

## Objective
Implement Phase [N]: [Phase Name] from the implementation plan.

## Plan Document
[Paste the FULL plan content here]

## Current Phase Details
[Paste the specific phase section from the plan]

## Files to Read First
Read these files completely before making changes:
- [List all files mentioned in this phase]
- [Include any shared utilities or types referenced]

## Implementation Requirements
1. Follow the plan's technical approach exactly
2. Add tests for all new functionality (unit tests, integration tests as appropriate)
3. Ensure code follows existing patterns in the codebase
4. Update the plan file checkboxes as you complete items

## Success Criteria for This Phase
[Paste the success criteria from the plan for this phase]

## Output Required
When complete, provide:
1. Summary of changes made (file:line references)
2. Tests added and their coverage
3. Any deviations from the plan and why
4. Any issues encountered
5. Confirmation that phase success criteria are met
```

#### 3b. Spawn Phase Tester

After implementation completes, launch a sub-agent to verify tests:

```
Task tool with subagent_type: "general-purpose"
```

**Prompt template for phase-tester:**
```
# Phase Testing Task

## Objective
Verify test coverage and run all tests for Phase [N]: [Phase Name].

## Context
Phase [N] was just implemented. The implementer reported these changes:
[Paste the summary from phase-implementer]

## Testing Requirements

### 1. Run Existing Tests
Execute the test suite and report results:
- Run: `make test` or equivalent
- Capture all output including failures
- Note any flaky tests

### 2. Analyze Test Coverage
For each change made in this phase:
- Identify if adequate tests exist
- Flag any untested code paths
- Check edge cases and error handling

### 3. Identify Test Gaps
Categorize any missing tests:

**Minor gaps** (simple, quick to add):
- Utility function tests
- Simple getter/setter tests
- Straightforward validation tests

**Major gaps** (complex, require discussion):
- Integration tests spanning multiple components
- Tests requiring significant setup/fixtures
- Tests for complex business logic
- Performance or load tests

## Output Required
Provide:
1. Test execution results (pass/fail counts, any failures)
2. List of minor test gaps (with suggested test cases)
3. List of major test gaps (with explanation of complexity)
4. Overall assessment: PASS / MINOR_ISSUES / MAJOR_ISSUES
```

#### 3c. Spawn Phase Validator

After testing, launch a sub-agent to validate against the plan:

```
Task tool with subagent_type: "general-purpose"
```

**Prompt template for phase-validator:**
```
# Phase Validation Task

## Objective
Validate that Phase [N]: [Phase Name] implementation matches the plan requirements.

## Plan Document
[Paste the FULL plan content here]

## Phase Requirements
[Paste the specific phase section with all requirements]

## Implementation Summary
The implementer reported:
[Paste the summary from phase-implementer]

## Test Results
The tester reported:
[Paste the summary from phase-tester]

## Validation Checklist

### 1. Completeness Check
- [ ] All items in the phase are implemented
- [ ] All checkboxes in the plan are accurately marked
- [ ] No requirements were skipped or partially done

### 2. Correctness Check
- [ ] Implementation matches the technical approach in the plan
- [ ] Code follows the patterns specified
- [ ] Edge cases mentioned in the plan are handled

### 3. Quality Check
- [ ] Tests exist for new functionality
- [ ] Error handling is appropriate
- [ ] No obvious performance issues
- [ ] Code is consistent with codebase style

### 4. Success Criteria Check
For each success criterion in the plan:
- [ ] Criterion 1: [status and evidence]
- [ ] Criterion 2: [status and evidence]

## Output Required
Provide:
1. Validation status: PASSED / FAILED
2. List of any unmet requirements
3. List of any deviations from plan (beneficial or problematic)
4. Recommendations for fixes if FAILED
```

#### 3d. Handle Issues

Based on sub-agent reports, decide how to proceed:

**If all pass:** Update todo list, proceed to next phase.

**If minor issues only:**
- Spawn a fixer sub-agent (`general-purpose`) to address them automatically
- Re-run tester and validator after fixes

**If major issues:**
- Stop execution
- Report to user with full context
- Ask how to proceed before continuing

**Prompt template for fixer sub-agent:**
```
# Phase Fix Task

## Objective
Fix minor issues identified in Phase [N]: [Phase Name].

## Issues to Fix
[List the minor issues from tester/validator]

## Files to Modify
[List the specific files that need changes]

## Constraints
- Only fix the issues listed above
- Do not refactor or improve unrelated code
- Add any missing tests identified as "minor gaps"
- Run tests after fixes to verify

## Output Required
Provide:
1. Fixes applied (file:line references)
2. Tests added
3. Confirmation tests pass
4. Any issues that couldn't be fixed (escalate these)
```

### Step 4: Phase Completion Reporting

After each phase completes successfully, report to the user:

```
Phase [N] Complete: [Phase Name]

Implementation:
- [Key changes summary]

Tests:
- [Test results summary]
- [Any gaps addressed]

Validation:
- Status: PASSED
- [Any notes]

Proceeding to Phase [N+1]: [Next Phase Name]
```

### Step 5: Final Completion

After all phases are complete:

1. **Run final validation** - Spawn a validator for the entire plan
2. **Create summary report** for the user:

```
Implementation Complete: [Ticket/Feature Name]

Phases Completed:
✓ Phase 1: [Name]
✓ Phase 2: [Name]
✓ Phase 3: [Name]

All Tests: PASSING
All Validations: PASSED

Manual Testing Required:
- [ ] [Manual test item 1]
- [ ] [Manual test item 2]

Ready for: Code review and manual testing
```

3. **Ask user** if they want to:
   - Create a commit (`/commit`)
   - Create a PR (`gh pr create`)
   - Run additional validation

## Issue Severity Guidelines

Use these guidelines to determine if an issue is minor (auto-fix) or major (escalate):

### Minor Issues (Auto-Fix)
- Missing tests for simple utility functions
- Minor style inconsistencies
- Missing null checks that are straightforward to add
- Documentation gaps
- Simple validation that was overlooked

### Major Issues (Escalate to User)
- Architectural deviations from the plan
- Missing tests for complex business logic
- Security concerns
- Performance issues
- Integration failures
- Unclear requirements needing clarification
- Changes that affect other features

**When in doubt, escalate.** It's better to ask than to auto-fix something incorrectly.

## Error Recovery

If a sub-agent fails or times out:

1. **Capture the error** and any partial output
2. **Assess the failure**:
   - Transient (retry once)
   - Context issue (provide more context and retry)
   - Fundamental (escalate to user)
3. **Report to user** with:
   - What was being attempted
   - What failed
   - Recommended next steps

## Context Management

**Why sub-agents:** Each sub-agent gets fresh context, preventing the accumulation issues that occur with long implementation sessions. The orchestrator maintains minimal context (just tracking state) while sub-agents handle the heavy lifting.

**What to pass to sub-agents:**
- Always: The full plan document
- Always: All files mentioned in the current phase
- Always: Clear success criteria
- For validators: Summaries from implementer and tester
- For fixers: Specific list of issues to address

**What NOT to pass:**
- Previous phases' detailed implementation logs
- Full conversation history
- Unrelated files not in the current phase
