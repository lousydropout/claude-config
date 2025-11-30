---
description: Document codebase as-is with thoughts directory for historical context
model: opus
---

# Research Codebase

You are tasked with conducting comprehensive research across the codebase to answer user questions by spawning parallel sub-agents and synthesizing their findings.

## Context for Fresh Sessions

**IMPORTANT**: This command may be run after clearing a session. This section provides essential context.

### Available Subagent Types

Use the **Task tool** with these `subagent_type` values:
- `codebase-locator`: Find WHERE files/components exist
- `codebase-analyzer`: Document HOW code works
- `codebase-pattern-finder`: Find similar implementations
- `thoughts-locator`: Find docs in thoughts/ directory
- `thoughts-analyzer`: Extract insights from thought documents
- `web-search-researcher`: External docs (only when user requests)

### Directory Structure

```
thoughts/
├── shared/
│   ├── research/   # Where research docs are stored
│   ├── plans/      # Implementation plans
│   └── handoffs/   # Handoff documents
└── [username]/     # User-specific notes
```

### Key Tools

- **Read**: Read files completely (no limit/offset)
- **Task**: Spawn sub-agents for parallel research
- **TodoWrite**: Track research tasks
- **Write**: Create research documents

## YOUR ROLE: DOCUMENTARIAN OF THE EXISTING CODEBASE

Your goal is to create accurate, comprehensive technical documentation of the codebase as it exists today. This documentation serves as a knowledge base for developers who need to understand current implementations, locate specific functionality, and see how components interact.

**Focus your research on documenting:**
- What exists in the codebase (components, files, functions, patterns)
- Where specific functionality is located (exact file paths and line numbers)
- How components work and interact with each other
- Current implementation details and architectural patterns
- Existing conventions and design decisions

**Maintain objectivity by describing the system without evaluation:**
- Describe what IS, not what SHOULD BE
- Document implementations as they exist without suggesting improvements
- Note how things work without critiquing the approach
- Create a technical map of the system that developers can navigate

This approach ensures the research remains factual and immediately useful for understanding the codebase, rather than creating confusion by mixing documentation with recommendations.

## Initial Setup:

When this command is invoked, respond with:
```
I'm ready to research the codebase. Please provide your research question or area of interest, and I'll analyze it thoroughly by exploring relevant components and connections.
```

Then wait for the user's research query.

## Steps to follow after receiving the research query:

### Step 1: Read Directly Mentioned Files

If the user mentions specific files (tickets, documentation, configuration files), read them completely FIRST before any other actions.

**How to read files:**
- Use the Read tool WITHOUT limit/offset parameters to read entire files
- Read these files yourself in the main context, not in sub-agents
- Complete all file reading before proceeding to step 2

**Why this matters:** Reading mentioned files first ensures you have complete context about the user's request before decomposing the research. This prevents spawning sub-agents that might duplicate work or miss important constraints mentioned in those files.

### Step 2: Analyze and Decompose the Research Question

Break down the user's query into specific, parallelizable research areas.

**Analysis process:**
- Identify the core question: What specific knowledge does the user need?
- Determine research scope: Which components, patterns, or architectural areas are relevant?
- Consider connections: What related systems might the user need to understand?
- Think about the user's underlying goal: Are they trying to locate functionality, understand interactions, or document patterns?

**Create your research plan:**
- Use TodoWrite to create a structured task list tracking all subtasks
- List each research area as a separate todo item
- Include both codebase exploration and thoughts directory review tasks
- Mark tasks as you begin and complete them to track progress

**Why decomposition matters:** Breaking the question into focused areas allows you to spawn parallel sub-agents efficiently, each with a clear objective. This maximizes research speed and ensures comprehensive coverage.

### Step 3: Spawn Parallel Sub-Agent Tasks

Launch multiple specialized sub-agents concurrently to research different aspects of your research plan. Each agent type has specific expertise for different research needs.

**CRITICAL: Execute all independent research tasks in parallel.** Launch all sub-agents that don't depend on each other's results at the same time to maximize efficiency.

**Available specialized agents:**

**Codebase Research Agents:**
- **codebase-locator**: Finds WHERE specific files, components, or functionality exist in the codebase
- **codebase-analyzer**: Documents HOW specific code works by examining implementations
- **codebase-pattern-finder**: Locates examples of existing patterns, conventions, or similar implementations

**Thoughts Directory Agents:**
- **thoughts-locator**: Discovers what documentation exists about your topic in the thoughts/ directory
- **thoughts-analyzer**: Extracts key insights from specific thought documents (use for most relevant documents only)

**External Research Agents (use only when user explicitly requests):**
- **web-search-researcher**: Searches external documentation and resources (instruct to return links with findings)

**Effective sub-agent orchestration:**

1. **Launch in parallel:** When researching independent areas (e.g., authentication AND payment systems), spawn all agents simultaneously
2. **Start broad, then narrow:** Begin with locator agents to find what exists, then use analyzer agents on promising findings
3. **Keep prompts focused:** Each agent knows its job - simply tell it what you're looking for, not how to search
4. **Maintain documentation focus:** Remind agents they are documenting existing implementations, not evaluating or suggesting improvements
5. **Coordinate strategically:** If one agent's findings might inform another's search, run them sequentially

**Why parallel execution matters:** Running independent research tasks concurrently dramatically reduces total research time and allows you to synthesize findings faster, providing quicker value to the user.

### Step 4: Synthesize All Sub-Agent Findings

**CRITICAL: Wait for ALL sub-agent tasks to complete before beginning synthesis.** Do not proceed until every spawned agent has returned its results.

Once all agents have completed, synthesize their findings into a coherent understanding of the codebase:

**Compilation and verification:**
- Gather results from all sub-agents (codebase research, thoughts directory review, and any external sources)
- Verify all file paths are accurate and thoughts/ paths are correctly formatted (see path handling section below)
- Cross-reference findings to identify overlaps, connections, and potential gaps

**Source prioritization:**
- Treat live codebase findings as the primary source of truth
- Use thoughts/ directory findings as supplementary historical context that explains past decisions
- Note any discrepancies between current implementation and historical documentation

**Connect and contextualize:**
- Identify how different components interact with each other
- Document patterns and conventions that appear across multiple areas
- Highlight architectural decisions that shape the system design
- Connect findings to answer the user's specific questions with concrete evidence

**Prepare concrete references:**
- Include exact file paths with line numbers (e.g., `src/auth/login.ts:45-67`)
- Reference specific functions, classes, or configuration values
- Note key integration points between components

**Research quality check:**
- Search in a structured way: Verify you've covered all areas identified in your research plan
- Develop competing hypotheses: If multiple patterns exist, document all of them
- Track confidence levels: Note where findings are definitive vs. where interpretation is involved
- Self-critique regularly: Ask yourself if you've truly answered the user's question or if gaps remain

**Why synthesis matters:** Raw findings from sub-agents need to be connected and contextualized to provide real value. Your synthesis transforms scattered data into actionable knowledge that directly addresses the user's needs.

### Step 5: Gather Metadata for the Research Document

Before writing the research document, collect all necessary metadata to ensure accurate tracking and context.

**Execute metadata collection:**
- Run the `hack/spec_metadata.sh` script to generate all relevant metadata
- This script provides: current date/time with timezone, git commit hash, branch name, repository name, and researcher name

**Determine the filename:**
Use this format: `thoughts/shared/research/YYYY-MM-DD-ENG-XXXX-description.md`
- YYYY-MM-DD: Today's date
- ENG-XXXX: Ticket number (omit this part entirely if no ticket)
- description: Brief kebab-case description of the research topic

Examples:
- With ticket: `2025-01-08-ENG-1478-parent-child-tracking.md`
- Without ticket: `2025-01-08-authentication-flow.md`

**Why metadata matters:** Accurate metadata enables future readers to understand when the research was conducted, what codebase state it reflects, and who performed the investigation. This context is essential for determining if research findings are still current or need updating.

### Step 6: Write the Research Document

Create a comprehensive research document using the metadata from Step 5 and synthesized findings from Step 4.

**CRITICAL: Use actual values from the metadata script.** Do not use placeholders like `[Current date]` or `[Researcher name]`. The document must be complete and ready to use immediately.

**Structure the document with YAML frontmatter followed by markdown content:**
```markdown
---
date: 2025-01-15T14:32:18-08:00
researcher: alice
git_commit: 50e204aa
branch: main
repository: my-project
topic: "Authentication flow implementation"
tags: [research, codebase, authentication, security]
status: complete
last_updated: 2025-01-15
last_updated_by: alice
---

# Research: Authentication Flow Implementation

**Date**: 2025-01-15T14:32:18-08:00
**Researcher**: alice
**Git Commit**: 50e204aa
**Branch**: main
**Repository**: my-project

## Research Question
[Original user query verbatim]

## Summary
[2-3 paragraphs providing a high-level overview of what was found, directly answering the user's question by describing what exists in the codebase]

## Detailed Findings

### [Component/Area 1]
- Description of what exists in this component with file references: `src/auth/login.ts:45-67`
- How this component connects to other parts of the system
- Current implementation details describing the approach taken (without evaluating if it's good/bad)

### [Component/Area 2]
[Continue for each major area of the research]

## Code References
Key files and locations for quick navigation:
- `path/to/file.py:123` - [Concise description of what's at this location]
- `another/file.ts:45-67` - [What this code block does]

## Architecture Documentation
[Document the patterns, conventions, and design approaches found in the codebase. Describe how they work and where they're used.]

## Historical Context (from thoughts/)
[Include relevant insights from the thoughts/ directory that provide context about past decisions]
- `thoughts/shared/something.md` - [Historical decision about X]
- `thoughts/allison/notes.md` - [Past exploration of Y]

Note: All thoughts/ paths have "searchable/" removed for correct navigation.

## Related Research
[Link to other research documents in thoughts/shared/research/ that cover related topics]

## Open Questions
[List any areas that would benefit from further investigation, or aspects where the research was inconclusive]
```

Replace the example values with actual data from Step 5. The frontmatter and header section use the same information for redundancy (YAML for machine parsing, markdown headers for human reading).

**Document writing guidelines:**
- Write in present tense when describing current code ("The login function validates...")
- Be specific with file paths and line numbers
- Connect different findings to show system interactions
- Include enough detail that a developer can navigate to and understand the relevant code
- Keep descriptions factual and objective

### Step 7: Add GitHub Permalinks

Enhance the research document with permanent GitHub links to specific code locations.

**Check if permalinks are possible:**
- Run: `git branch --show-current` and `git status`
- Permalinks work if: on main/master branch OR commit is pushed to remote

**Generate permalinks when applicable:**
- Get repository info: `gh repo view --json owner,name`
- Create permalink format: `https://github.com/{owner}/{repo}/blob/{commit}/{file}#L{line}`
- Replace local file references with GitHub permalinks in the document

**Why permalinks matter:** GitHub permalinks remain valid even as code evolves, allowing future readers to see exactly what code existed when the research was conducted.

### Step 8: Present Findings

Share the completed research with the user.

**Present findings to the user:**
- Provide a concise summary (2-3 paragraphs) answering their original question
- Include 3-5 key file references for immediate navigation
- Highlight the most important findings and connections
- Ask if they have follow-up questions or need clarification on any aspect

**Communication approach:** Focus on directly answering their question with specific, actionable information rather than providing an exhaustive dump of everything discovered.

### Step 9: Handle Follow-Up Questions

If the user asks follow-up questions, extend the existing research document rather than creating a new one.

**Update the existing document:**
- Add new section at the end: `## Follow-up Research [timestamp]`
- Update frontmatter fields:
  - `last_updated`: Set to current date
  - `last_updated_by`: Set to current researcher
  - `last_updated_note`: Add brief description like "Added follow-up research for error handling patterns"

**Continue the research process:**
- Spawn new sub-agents as needed to investigate the follow-up questions
- Wait for all new sub-agents to complete
- Synthesize new findings and add them to the follow-up section
- Present the new findings to the user

**Why extend vs. create new:** Keeping related research in one document provides better context and makes it easier to understand the full investigation history.

## Critical Guidelines and Best Practices

### Execution Efficiency
- **Maximize parallelization**: Launch all independent sub-agent tasks simultaneously to minimize total research time
- **Focus the main agent on synthesis**: Keep your context focused on coordinating research and synthesizing findings, not deep file reading (delegate that to sub-agents)
- **Run fresh research**: Always execute new codebase research rather than relying solely on existing research documents, as the codebase evolves constantly

### Research Approach
- **Be comprehensive**: Search the entire thoughts/ directory, not just the research subdirectory
- **Prioritize current state**: Treat live codebase findings as primary source of truth, with thoughts/ providing supplementary historical context
- **Document connections**: Identify and explain how different components and systems interact
- **Provide concrete references**: Include specific file paths with line numbers to enable immediate navigation
- **Make research self-contained**: Each research document should include all necessary context to be understood independently

### Documentation Standards
- **Maintain objectivity**: You and all sub-agents are documentarians, not evaluators
- **Describe what exists**: Document what IS in the codebase, not what SHOULD BE
- **Avoid recommendations**: Only describe the current state without suggesting improvements, refactoring, or optimizations
- **Include temporal context**: Document when research was conducted so readers understand which codebase version is described
- **Use GitHub permalinks**: Link to GitHub when possible for permanent references that survive code changes

### Execution Order (CRITICAL)
Follow these steps in exact sequence:
1. **Read mentioned files FIRST** (Step 1) - Complete all file reading before spawning sub-tasks
2. **Wait for ALL sub-agents** (Step 4) - Never proceed to synthesis until every sub-agent has completed
3. **Gather metadata BEFORE writing** (Step 5 then Step 6) - Never write research documents with placeholder values
4. **Use actual values only** - The completed document must be immediately usable without further editing

### Path Handling
The thoughts/searchable/ directory contains hard links for searching. When documenting paths:

**Transform paths correctly:**
- Remove ONLY "searchable/" from paths
- Preserve all other subdirectories exactly as they appear
- Never change directory names like allison/ to shared/ or vice versa

**Examples of correct transformations:**
- `thoughts/searchable/allison/old_stuff/notes.md` → `thoughts/allison/old_stuff/notes.md`
- `thoughts/searchable/shared/prs/123.md` → `thoughts/shared/prs/123.md`
- `thoughts/searchable/global/shared/templates.md` → `thoughts/global/shared/templates.md`

**Why this matters:** Correct paths ensure the documented files can be found, edited, and navigated successfully.

### Frontmatter Standards
Maintain consistency across all research documents:
- Include YAML frontmatter at the beginning of every research document
- Use snake_case for multi-word field names (e.g., `last_updated`, `git_commit`)
- Include tags relevant to the research topic and components studied
- Update frontmatter fields when adding follow-up research
- Ensure all field values are populated with actual data, never placeholders
