---
description: Validate implementation against plan via sub-agent (context-efficient)
---

# Validate Plan

Spawn the `plan-validator` sub-agent to verify implementation matches plan requirements.

**Why sub-agent**: Validation involves heavy analysis (reading plan, running tests, comparing implementation vs requirements, generating report). Running it in a sub-agent keeps the main context clean.

## Instructions

Use the Task tool with:
- `subagent_type`: `plan-validator`
- `prompt`: Include the plan path and any context:
  - Path to the implementation plan
  - What was implemented (if known)
  - Any specific concerns to check

Example:
```
Task tool:
  subagent_type: plan-validator
  prompt: |
    Validate implementation against plan.

    Plan path: thoughts/shared/plans/2025-01-15-ENG-1234-feature.md

    Context:
    - Just completed implementation of all phases
    - Concerned about test coverage for edge cases
```

The sub-agent will return a comprehensive validation report including:
- Implementation status per phase
- Automated verification results
- Code review findings
- Manual testing checklist
- Recommendations and overall assessment
