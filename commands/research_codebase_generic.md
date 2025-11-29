---
description: Research codebase comprehensively using parallel sub-agents
model: opus
---

# Research Codebase

Your role is to conduct comprehensive codebase research by orchestrating parallel sub-agents and synthesizing their findings into actionable insights. The goal is to provide developers with concrete, well-referenced answers backed by actual code locations and architectural understanding.

## Initial Setup:

When this command is invoked, respond with:
```
I'm ready to research the codebase. Please provide your research question or area of interest, and I'll analyze it thoroughly by exploring relevant components and connections.
```

Then wait for the user's research query.

## Research Execution Steps

Follow these steps sequentially after receiving the research query. Each step builds on the previous one to ensure comprehensive and accurate research.

### Step 1: Read Directly Mentioned Files

**What to do**: If the user mentions specific files (tickets, docs, JSON, configuration files), read them completely in the main context first.

**Why this matters**: Reading files yourself before delegating ensures you understand the full context and can decompose the research intelligently. Partial reads lead to missed connections.

**How to execute**:
- Use the Read tool WITHOUT limit/offset parameters to read entire files
- Read all mentioned files in parallel if they have no dependencies
- Complete all file reads before moving to Step 2

### Step 2: Analyze and Decompose the Research Question

**What to do**: Break down the user's query into specific, parallelizable research areas.

**Why this matters**: Good decomposition leads to efficient parallel research. Poor decomposition causes redundant work or missed areas.

**How to execute**:
- Identify the underlying patterns, connections, and architectural implications the user is seeking
- List specific components, patterns, or concepts to investigate
- Create a structured research plan using TodoWrite to track all subtasks
- Map which directories, files, or architectural patterns are relevant to each subtask
- Develop competing hypotheses about where answers might be found

### Step 3: Spawn Parallel Sub-Agent Tasks

**What to do**: Create multiple Task agents to research different aspects concurrently.

**Why this matters**: Parallel research maximizes efficiency and minimizes total research time. Sequential research wastes time and context.

**How to execute**:
- Start with locator agents to find what exists (run these in parallel)
- Then spawn analyzer agents on the most promising findings (run these in parallel)
- Make each agent prompt specific and focused: "Find all implementations of X" or "Analyze how Y connects to Z"
- Keep prompts concise - sub-agents already know how to search, you just tell them what to find
- Launch all independent research tasks in parallel, not sequentially

**Research strategy**:
- Search in a structured way across likely locations
- Track which areas have been searched and which remain
- Consider alternative locations if initial searches yield nothing
- Self-critique: Are we searching the right places? Are we missing patterns?

### Step 4: Synthesize All Findings

**What to do**: Wait for ALL sub-agent tasks to complete, then compile and connect their findings.

**Why this matters**: Premature synthesis leads to incomplete answers. The value is in connecting findings across components, not just listing them.

**How to execute**:
- Wait for every sub-agent to complete before proceeding
- Compile all results from both codebase and thoughts/ directory findings
- Prioritize live codebase findings as primary source of truth
- Use thoughts/ findings as supplementary historical context
- Connect findings across different components to reveal patterns
- Include specific file paths with line numbers for developer reference
- Verify all thoughts/ paths are correct (preserve directory structure, only remove "searchable/")
- Highlight architectural patterns, design decisions, and component interactions
- Track confidence levels: mark findings as "confirmed" vs "likely" vs "uncertain"
- Answer the user's specific questions with concrete evidence and code references

### Step 5: Gather Research Metadata

**What to do**: Collect all metadata needed for the research document before writing it.

**Why this matters**: Gathering metadata upfront prevents placeholder values and ensures complete, accurate documentation. Research documents serve as permanent records that other developers will reference.

**How to execute**:
- Run these git commands in parallel to collect metadata efficiently:
  - `git log -1 --format='%H'` for commit hash
  - `git branch --show-current` for branch name
  - `git remote get-url origin` for repository info
- Determine the filename using this format: `thoughts/shared/research/YYYY-MM-DD-ENG-XXXX-description.md`
  - YYYY-MM-DD is today's date
  - ENG-XXXX is the ticket number (omit if no ticket)
  - description is a brief kebab-case description of the research topic
  - Examples:
    - With ticket: `2025-01-08-ENG-1478-parent-child-tracking.md`
    - Without ticket: `2025-01-08-authentication-flow.md`
- Get current timestamp in ISO format with timezone
- Identify the researcher name

### Step 6: Write Research Document

**What to do**: Create the research document using the metadata from Step 5 and findings from Step 4.

**Why this matters**: A well-structured research document becomes a permanent, searchable knowledge base entry. Other developers will use this to understand the codebase without repeating research.

**How to execute**:
- Use the exact metadata values gathered in Step 5 (no placeholders)
- Structure the document with YAML frontmatter followed by markdown content:
     ```markdown
     ---
     date: [Current date and time with timezone in ISO format]
     researcher: [Researcher name]
     git_commit: [Current commit hash]
     branch: [Current branch name]
     repository: [Repository name]
     topic: "[User's Question/Topic]"
     tags: [research, codebase, relevant-component-names]
     status: complete
     last_updated: [Current date in YYYY-MM-DD format]
     last_updated_by: [Researcher name]
     ---

     # Research: [User's Question/Topic]

     **Date**: [Current date and time with timezone from step 4]
     **Researcher**: [Researcher name]
     **Git Commit**: [Current commit hash from step 4]
     **Branch**: [Current branch name from step 4]
     **Repository**: [Repository name]

     ## Research Question
     [Original user query]

     ## Summary
     [High-level findings answering the user's question]

     ## Detailed Findings

     ### [Component/Area 1]
     - Finding with reference ([file.ext:line](link))
     - Connection to other components
     - Implementation details

     ### [Component/Area 2]
     ...

     ## Code References
     - `path/to/file.py:123` - Description of what's there
     - `another/file.ts:45-67` - Description of the code block

     ## Architecture Insights
     [Patterns, conventions, and design decisions discovered]

     ## Historical Context (from thoughts/)
     [Relevant insights from thoughts/ directory with references]
     - `thoughts/shared/something.md` - Historical decision about X
     - `thoughts/local/notes.md` - Past exploration of Y
     Note: Paths exclude "searchable/" even if found there

     ## Related Research
     [Links to other research documents in thoughts/shared/research/]

     ## Open Questions
     [Any areas that need further investigation]
     ```

### Step 7: Add GitHub Permalinks (If Applicable)

**What to do**: Convert local file references to permanent GitHub URLs when possible.

**Why this matters**: GitHub permalinks remain valid even as code changes, providing stable references for long-term documentation. Local paths break when files move or branches are deleted.

**How to execute**:
- Run these checks in parallel: `git branch --show-current` and `git status`
- If on main/master branch or the commit is pushed to remote:
  - Get repository info: `gh repo view --json owner,name`
  - Create permalinks using format: `https://github.com/{owner}/{repo}/blob/{commit}/{file}#L{line}`
  - Replace local file references with permalinks throughout the document
- If not pushed or on feature branch, keep local paths (permalinks will break)

### Step 8: Present Findings to User

**What to do**: Deliver a concise summary of your research findings with actionable references.

**Why this matters**: Users need quick answers first, with the option to dive deeper. Leading with dense documentation wastes their time.

**How to execute**:
- Start with a 2-3 sentence executive summary answering the core question
- List 3-5 key findings with specific file references
- Include the research document path for complete details
- Highlight any surprising discoveries or architectural insights
- Provide file paths in a copy-paste friendly format
- Ask if they have follow-up questions or need deeper investigation in specific areas

### Step 9: Handle Follow-Up Questions

**What to do**: When users ask follow-up questions, extend the existing research rather than starting fresh.

**Why this matters**: Continuity keeps related research together, making it easier to find complete information later. Scattered research documents create knowledge silos.

**How to execute**:
- Append to the same research document from Step 6
- Update these frontmatter fields:
  - `last_updated`: Current date in YYYY-MM-DD format
  - `last_updated_by`: Researcher name
  - `last_updated_note`: "Added follow-up research for [brief description]"
- Add a new section: `## Follow-up Research [timestamp]`
- Spawn new sub-agents in parallel as needed for additional investigation
- Follow the same synthesis and documentation process from Steps 3-4
- Present the updated findings to the user

## Critical Requirements

### Execution Order
Follow the numbered steps exactly in sequence. This order is designed to ensure complete, accurate research:

1. Read mentioned files FULLY first (Step 1 before Step 2)
2. Decompose before delegating (Step 2 before Step 3)
3. Wait for ALL sub-agents to complete before synthesizing (Step 4 waits for Step 3)
4. Gather metadata before writing (Step 5 before Step 6)
5. Write document with real values, never placeholders (Step 6 uses Step 5 data)

**Why this order matters**: Each step depends on the previous one. Skipping or reordering causes incomplete research, placeholder values, or missed connections.

### Parallel Operations
Maximize efficiency by running independent operations in parallel:

- Read multiple mentioned files simultaneously (Step 1)
- Spawn all location-finding sub-agents at once (Step 3)
- Run metadata collection commands together (Step 5)
- Execute git status checks concurrently (Step 7)

**Why this matters**: Parallel execution dramatically reduces total research time and context usage. Sequential execution wastes resources.

### File Reading
Always read mentioned files FULLY using the Read tool WITHOUT limit/offset parameters.

**Why this matters**: Partial reads miss critical context and connections. Complete files reveal relationships that partial reads obscure.

### Path Handling
The `thoughts/searchable/` directory contains hard links for searching. When documenting findings:

- Remove ONLY "searchable/" from paths
- Preserve all other subdirectories exactly
- Examples of correct transformations:
  - `thoughts/searchable/allison/old_stuff/notes.md` → `thoughts/allison/old_stuff/notes.md`
  - `thoughts/searchable/shared/prs/123.md` → `thoughts/shared/prs/123.md`
  - `thoughts/searchable/global/shared/templates.md` → `thoughts/global/shared/templates.md`
- NEVER change allison/ to shared/ or vice versa

**Why this matters**: Correct paths ensure files can be edited and navigated. Incorrect paths break links and workflows.

### Sub-Agent Orchestration
Delegate effectively to sub-agents:

- Keep prompts specific and focused: "Find all implementations of X in directory Y"
- Specify read-only operations to prevent unintended changes
- Use sub-agents for deep exploration, main agent for synthesis
- Encourage sub-agents to find usage patterns and examples, not just definitions
- Let sub-agents explore all of thoughts/ directory, not just research subdirectory

**Why this matters**: Clear delegation prevents redundant work and ensures comprehensive coverage. Vague prompts lead to incomplete or overlapping research.

### Research Quality
Produce high-quality, actionable research:

- Always run fresh codebase research - never rely solely on existing research documents
- Focus on concrete file paths and line numbers for developer reference
- Make research documents self-contained with all necessary context
- Consider cross-component connections and architectural patterns
- Include temporal context (when the research was conducted)
- Use thoughts/ directory for historical context to supplement live findings
- Link to GitHub when possible for permanent references

**Why this matters**: Research documents serve as permanent knowledge base entries. Incomplete or outdated research misleads future developers.

### Documentation Standards
Maintain consistency across all research documents:

- Always include YAML frontmatter at the beginning
- Use snake_case for multi-word field names (e.g., `last_updated`, `git_commit`)
- Keep frontmatter fields consistent across documents
- Update frontmatter when adding follow-up research
- Choose tags relevant to the research topic and components studied
- Never use placeholder values - use real data from Step 5

**Why this matters**: Consistent documentation enables search, filtering, and automated processing. Inconsistency creates technical debt.
