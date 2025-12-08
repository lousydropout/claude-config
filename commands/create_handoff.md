---
description: Create handoff document via sub-agent (context-efficient)
---

# Create Handoff

Spawn the `handoff-creator` sub-agent to create a handoff document for the current session.

**Why sub-agent**: Running handoff creation in a sub-agent keeps the main context window small. The sub-agent does all the heavy lifting (file reads, git commands, writing the document) in its own context, returning only a brief summary.

## Instructions

Use the Task tool with:
- `subagent_type`: `handoff-creator`
- `prompt`: Provide context about the current session including:
  - Working directory and repository
  - Task(s) being worked on
  - Key changes made
  - Any ticket number (for directory organization)
  - Current status and blockers

Example:
```
Task tool:
  subagent_type: handoff-creator
  prompt: |
    Create a handoff document for the current session.

    Context:
    - Working directory: [path]
    - Task: [description]
    - Changes made: [list key changes]
    - Ticket: [ENG-XXXX or "none"]
```

After the sub-agent completes, it will return the handoff file path and resume command.
