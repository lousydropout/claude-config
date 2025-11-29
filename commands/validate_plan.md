---
description: Validate implementation against plan, verify success criteria, identify issues
---

# Validate Plan

Your goal is to validate that an implementation plan was correctly executed. You will verify all success criteria are met and identify any deviations, issues, or incomplete work. This validation catches problems before they reach production and ensures the implementation fulfills its intended purpose.

## Initial Setup

### Step 1: Establish Context

Determine your starting point to focus validation appropriately:
- **Existing conversation**: Review this session's todo list and conversation history to see what was just implemented
- **Fresh session**: Analyze git history and codebase to discover what was recently completed

### Step 2: Locate the Implementation Plan

The plan document contains the success criteria you'll validate against:
- If user provided a plan path, read that file
- If not provided, search recent git commits for plan references in commit messages
- If still not found, ask the user for the plan location

### Step 3: Gather Implementation Evidence in Parallel

Run these commands in parallel (they are independent) to collect comprehensive evidence:

```bash
# Terminal 1: Check recent commit history
git log --oneline -n 20

# Terminal 2: See what changed in recent commits
git diff HEAD~5..HEAD  # Adjust number based on when implementation started

# Terminal 3: Run automated verification
cd $(git rev-parse --show-toplevel) && make check test
```

Context: Running these in parallel saves time. The git history shows WHAT was done, the diff shows HOW it was done, and make commands verify it WORKS.

## Validation Process

### Phase 1: Understanding the Plan

Read the implementation plan completely to establish your validation baseline. This gives you the checklist of what should have been implemented.

Extract from the plan:
1. **Expected file changes**: List all files that should be created or modified
2. **Success criteria**: Note both automated checks (tests, lints) and manual verification steps
3. **Key functionality**: Identify the core features and behaviors to verify

Context: Understanding the plan first prevents you from missing requirements or validating the wrong things.

### Phase 2: Discover What Was Actually Implemented

Use parallel research to efficiently gather comprehensive evidence. Launch these research tasks simultaneously (they are independent):

**Research Task 1 - Database/Schema Verification**:
```
Goal: Verify all database changes match the plan specifications
Actions:
- Search for new migration files using Glob (e.g., "**/*migration*.sql")
- Read migration files to compare schema changes vs plan
- Check if indexes, constraints, and relationships match specifications
Return: Structured comparison of planned vs actual schema changes
```

**Research Task 2 - Code Implementation Verification**:
```
Goal: Confirm code changes implement planned functionality
Actions:
- Use Grep to find all modified files mentioned in git diff
- Read each changed file to understand implementation approach
- Compare actual code structure and logic vs plan specifications
- Check if error handling, validation, and edge cases were addressed
Return: File-by-file analysis showing what matches plan and what differs
```

**Research Task 3 - Test Coverage Verification**:
```
Goal: Validate test coverage meets plan requirements
Actions:
- Search for new/modified test files using Glob
- Read test files to verify they cover specified scenarios
- Execute test commands to confirm all tests pass
- Identify any planned tests that are missing
Return: Test execution results and coverage gaps
```

Context: Parallel research tasks complete faster than sequential investigation. Each task focuses on a specific aspect of the implementation for thorough coverage.

### Phase 3: Systematic Validation

Validate each phase in the plan systematically. For each phase, complete these checks:

#### 3.1 Verify Completion Claims

Compare checkmarks in the plan against actual implementation:
- Read the plan to find phases marked complete (- [x])
- Read the actual code files mentioned in each phase
- Confirm the code implements what the checkmark claims was done
- Document any phases marked complete but not actually implemented

Context: Plans sometimes have optimistic checkmarks. Your job is to verify reality matches claims.

#### 3.2 Execute Automated Verification

Run each automated check specified in the plan's verification section:
- Execute build commands (e.g., `make build`)
- Execute test commands (e.g., `make test`, `npm test`)
- Execute lint/check commands (e.g., `make lint`, `make check`)
- Document pass/fail status for each command
- If any checks fail, read error output and investigate the root cause in the code

Context: Automated checks catch bugs and regressions. All must pass before the implementation can be considered complete.

#### 3.3 Identify Manual Testing Requirements

Create a clear checklist of what the user needs to test manually:
- List each manual verification step from the plan
- Provide specific instructions for how to test each item
- Include expected outcomes for successful verification
- Note any test data or setup required

Context: Some functionality requires human judgment. Make manual testing steps explicit and actionable.

#### 3.4 Critical Analysis of Implementation Quality

Think deeply about implementation robustness and ask:
- **Error handling**: Does the code handle error conditions gracefully?
- **Input validation**: Are user inputs validated and sanitized?
- **Edge cases**: What happens with empty arrays, null values, boundary conditions?
- **Backward compatibility**: Could these changes break existing functionality?
- **Performance**: Are there obvious performance issues (N+1 queries, unbounded loops)?

Context: Plans focus on happy paths. Your critical analysis catches issues the plan may have missed.

### Phase 4: Generate Validation Report

Create a comprehensive validation report using this structured format. This report serves as the deliverable that communicates validation results to the user and team.

```markdown
## Validation Report: [Plan Name]

### Executive Summary
[2-3 sentence summary: overall implementation quality, major findings, recommendation to proceed/fix issues]

### Implementation Status
✓ Phase 1: [Name] - Fully implemented and verified
✓ Phase 2: [Name] - Fully implemented and verified
⚠️ Phase 3: [Name] - Partially implemented (see issues below)
✗ Phase 4: [Name] - Not implemented or significantly incomplete

### Automated Verification Results
✓ Build passes: `make build` (exit code 0)
✓ Tests pass: `make test` (42/42 tests passing)
✗ Linting issues: `make lint` (3 warnings, 1 error - see details)

Details on failures:
- [Specific error message and file location]
- [Root cause analysis]
- [Suggested fix]

### Code Review Findings

#### Implementation Matches Plan ✓
- Database migration adds `users` table with correct schema
- API endpoints `/api/users` implement all specified methods (GET, POST, PUT, DELETE)
- Error handling returns proper HTTP status codes per plan

#### Beneficial Deviations (Improvements)
- Added input validation in `src/api/users.ts:45` beyond plan requirements
- Implemented request rate limiting for API endpoints (security improvement)

#### Problematic Deviations (Concerns)
- Used synchronous file I/O in `src/utils/file.ts:12` instead of async (performance concern)
- Skipped database transaction in `src/db/users.ts:67` mentioned in plan (data integrity risk)

#### Issues Requiring Attention
1. **Missing index**: Foreign key `user_id` in `posts` table lacks index (performance)
   - Impact: Queries will be slow with large datasets
   - Fix: Add index migration
2. **No rollback**: Migration lacks down() function (deployment risk)
   - Impact: Cannot easily revert if issues found in production
   - Fix: Implement rollback logic

### Manual Testing Required
Complete these manual verification steps to fully validate the implementation:

1. **UI Functionality**:
   - [ ] Navigate to `/users` page and verify user list displays
   - [ ] Click "Add User" button and submit form with valid data
   - [ ] Test error state by submitting form with invalid email format
   - Expected: Form shows validation error message below email field

2. **Integration Testing**:
   - [ ] Create new user and verify it appears in the posts dashboard
   - [ ] Test with 1000+ users to check pagination and performance
   - Expected: Page loads in <2 seconds, pagination works correctly

3. **Error Handling**:
   - [ ] Disconnect database and attempt to create user
   - Expected: User sees friendly error message, not raw database error

### Recommendations

**Must Fix Before Merge**:
1. Resolve linting error in `src/api/users.ts`
2. Add database migration rollback function
3. Change synchronous file operations to async

**Should Consider**:
1. Add integration test for user creation -> posts workflow
2. Document new API endpoints in `docs/api.md`
3. Add performance test for user list with 10k+ records

**Nice to Have**:
1. Add user avatar upload functionality (mentioned in original requirements)
2. Implement user search/filter feature for better UX

### Overall Assessment
[✓ Ready to merge | ⚠️ Ready with minor fixes | ✗ Requires significant work]

Rationale: [Explain the overall quality and readiness based on findings above]
```

Context: Structure the report to prioritize critical issues first. Use specific file paths and line numbers so issues can be quickly located and fixed.

## Special Case: Validating Your Own Implementation

If you implemented the plan in this session, apply extra rigor to your validation:

1. **Review conversation history**: Scroll through to identify shortcuts or compromises you made during implementation
2. **Check todo list**: Verify all todo items are actually completed, not just marked complete
3. **Be self-critical**: Question your own implementation decisions objectively
4. **Acknowledge incomplete work**: Explicitly call out any parts you didn't finish or did partially

Context: Self-validation requires extra discipline. It's easy to overlook your own mistakes or rationalize shortcuts. Your validation must be as rigorous as if reviewing someone else's code.

## Core Validation Principles

Apply these principles throughout your validation work:

### 1. Read Before Judging
Always read the actual code files before validating. The git diff shows changes, but reading the full context reveals integration issues, naming consistency, and architectural fit.

### 2. Execute All Automated Checks
Run every automated verification command from the plan. These checks exist because they catch real bugs. Execute them even if you expect them to pass.

### 3. Prioritize Critical Over Perfect
Focus validation effort on:
- Correctness: Does it work as specified?
- Safety: Can it cause data loss or security issues?
- Maintainability: Can others understand and modify it?

Secondary concerns like minor style inconsistencies matter less than the above.

### 4. Provide Actionable Findings
Every issue you identify must include:
- Specific file path and line number
- Clear description of the problem
- Concrete suggestion for fixing it

Vague findings like "error handling could be better" don't help. Specific findings like "Missing null check in `src/api/users.ts:45` when accessing `req.body.email`" enable quick fixes.

### 5. Use Parallel Operations
When validation tasks are independent, execute them in parallel for efficiency:
- Read multiple files simultaneously
- Run multiple test commands in parallel
- Conduct separate research tasks concurrently

Context: These principles ensure your validation is thorough, fair, and actionable.

## Validation Checklist

Before completing validation, verify you have addressed all of these:

- [ ] Read the complete implementation plan to understand requirements
- [ ] Identified all phases and success criteria from the plan
- [ ] Reviewed git history to see what was actually implemented
- [ ] Read all modified code files to understand implementation approach
- [ ] Executed all automated verification commands (build, test, lint)
- [ ] Compared implementation against plan phase-by-phase
- [ ] Analyzed code for error handling, validation, and edge cases
- [ ] Identified any regressions or breaking changes to existing functionality
- [ ] Created clear manual testing steps for user verification
- [ ] Generated comprehensive validation report with specific findings
- [ ] Provided actionable recommendations prioritized by severity

## Relationship to Other Commands

This command fits into the standard development workflow:

1. **`/create_plan`** - Creates the implementation plan with success criteria
2. **`/implement_plan`** - Executes the implementation following the plan
3. **`/commit`** - Creates atomic git commits for the changes
4. **`/validate_plan`** ← You are here - Verifies implementation matches plan and works correctly
5. **`/founder_mode`** or **`/describe_pr`** - Generates PR description after validation passes

**Why validation comes after commits**: Git history provides the concrete evidence of what was implemented. Commits show the sequence of changes, making it easier to trace implementation decisions and identify any missed requirements.

## Success Criteria

Your validation is complete and successful when:

1. **You have verified all plan requirements**: Every phase and success criterion has been checked
2. **All automated checks pass**: Build, tests, and linting complete without errors
3. **Issues are documented with specifics**: File paths, line numbers, and concrete fix suggestions provided
4. **Manual testing steps are clear**: User can execute them without ambiguity
5. **Overall assessment is justified**: Recommendation to merge/fix is supported by findings

Context: Validation quality directly impacts deployment success. Thorough validation prevents production issues and builds confidence in the implementation.
