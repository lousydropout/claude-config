---
description: Implement technical plans from thoughts/shared/plans with verification
---

# Implement Plan

Your goal is to implement an approved technical plan from `thoughts/shared/plans/`. These plans contain phases with specific changes and success criteria that you must execute and verify.

## Getting Started

When given a plan path, execute these steps in order:

1. **Read the complete plan** - Use the Read tool to load the entire plan file and identify any existing checkmarks (- [x]) that indicate completed work
2. **Gather context** - Read the original ticket and all files mentioned in the plan. When reading files, always read them completely without limit/offset parameters because you need full context to understand how components interact
3. **Create a todo list** - Use the TodoWrite tool to create a structured tracking list for all phases and major steps
4. **Analyze the implementation** - Think deeply about how the pieces fit together before starting
5. **Begin implementation** - Start executing the plan changes once you have complete understanding

If no plan path is provided, ask the user for the specific plan file path.

**Why this matters:** Reading files completely prevents missing critical context that could lead to incorrect implementations. The todo list helps track progress across potentially complex multi-phase plans.

## Implementation Philosophy

Plans are carefully designed roadmaps, but codebases evolve and you may encounter situations not anticipated in the plan. Your responsibilities are:

1. **Follow the plan's intent** - Understand the goal of each phase and adapt your implementation to achieve that goal even if specific details differ from what the plan describes
2. **Complete phases sequentially** - Fully implement and verify each phase before proceeding to the next one, as later phases often depend on earlier work
3. **Maintain codebase consistency** - Ensure your changes align with existing patterns, conventions, and architecture throughout the codebase
4. **Track progress explicitly** - Use the Edit tool to update checkboxes (- [ ] to - [x]) in the plan file itself as you complete each section

**Why this matters:** Sequential phase completion prevents cascading errors, and tracking progress in the plan file creates a shared record that persists across sessions.

### Handling Mismatches

When you discover that reality doesn't match the plan (e.g., a file doesn't exist, a function has a different signature, or an approach won't work):

1. **Stop implementation immediately** - Don't try to work around the issue without understanding it
2. **Analyze the root cause** - Think deeply about why this mismatch exists and what it means for the plan
3. **Communicate clearly** - Present the issue to the user using this exact format:

```
Issue in Phase [N]:
Expected: [what the plan says should exist or happen]
Found: [the actual situation in the codebase]
Why this matters: [explanation of how this affects the implementation]

How should I proceed?
```

Your judgment and problem-solving are valuable - use them to navigate complexity while keeping the user informed.

## Verification Approach

After implementing each phase, execute verification in this order:

1. **Run automated checks** - Execute the success criteria checks specified in the plan (typically `make check test` or similar commands that run linters, type checkers, and test suites)
2. **Fix all issues** - Address any failures or errors before proceeding to the next phase, as proceeding with broken tests creates technical debt and risks
3. **Update progress tracking** - Use the Edit tool to check off completed items (- [ ] to - [x]) in both the plan file and your TodoWrite list
4. **Request manual verification** - After automated checks pass, pause and inform the user using this exact format:

```
Phase [N] Complete - Ready for Manual Verification

Automated verification passed:
- [List specific automated checks that passed, e.g., "make check", "npm test"]

Please perform the manual verification steps listed in the plan:
- [Copy the exact manual verification items from the plan]

Reply when manual testing is complete so I can proceed to Phase [N+1].
```

**Why this matters:** Automated checks catch regressions, but manual verification ensures the changes work correctly from a user perspective. Pausing for verification prevents building on faulty foundations.

### Multi-Phase Execution

If the user explicitly instructs you to execute multiple phases consecutively (e.g., "implement phases 1-3"), skip the manual verification pause until after the final phase. Otherwise, assume you should implement one phase at a time with verification between each.

**Important:** Never check off manual testing items (- [ ] to - [x]) until the user explicitly confirms they completed them successfully.


## If You Get Stuck

When something isn't working as expected, follow this debugging process:

1. **Ensure complete understanding** - Read and analyze all relevant code files completely (no limit/offset parameters). Missing context is often the root cause of implementation issues.
2. **Consider codebase evolution** - Check if the codebase has changed since the plan was written (look at git history, recent commits, or modified files).
3. **Communicate the blocker** - Present the issue clearly to the user and ask for guidance using the mismatch format shown earlier.

**Why this matters:** Thorough code reading often reveals solutions that aren't obvious from the plan alone. The codebase is the source of truth, not the plan.

### Using Parallel Tool Calls

When you need to gather information or make changes that have no dependencies between them, execute all independent tool calls in parallel within a single response. For example:
- Reading multiple unrelated files: make all Read calls together
- Running independent verification commands: execute them in parallel with multiple Bash calls
- Searching for different patterns: run multiple Grep calls simultaneously

**Why this matters:** Parallel execution significantly reduces latency and speeds up implementation.

## Resuming Work

If the plan file contains existing checkmarks (- [x]):

1. **Trust completed work** - Assume that checked-off items were properly implemented
2. **Find your starting point** - Locate the first unchecked item (- [ ]) and begin there
3. **Verify only when necessary** - Only re-examine previous work if you discover something inconsistent or broken

**Why this matters:** Plans may span multiple sessions. Trusting completed work maintains momentum and respects previous effort.

## Core Principles

Remember these guiding principles throughout implementation:

- **You're solving a problem, not just checking boxes** - Keep the end goal and user value in mind
- **Be autonomous and persistent** - Work through challenges methodically rather than giving up easily
- **Implement changes, don't just suggest them** - Execute the plan with actual code changes
- **Maintain forward momentum** - Complete phases fully rather than leaving partial work

Your goal is successful implementation of the technical plan that achieves the desired functionality and passes all verification criteria.
