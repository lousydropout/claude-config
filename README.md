# Claude Code Configuration

Personal configuration for [Claude Code](https://claude.com/claude-code).

## Structure

- `agents/` - Custom sub-agent definitions for specialized tasks
- `commands/` - Custom slash commands
- `notes/` - Reference notes and documentation
- `settings.json` - Permissions and environment settings

## Agents

| Agent | Purpose |
|-------|---------|
| `codebase-analyzer` | Analyze codebase implementation details |
| `codebase-locator` | Locate files and components relevant to a task |
| `codebase-pattern-finder` | Find similar implementations and usage examples |
| `thoughts-analyzer` | Deep dive on research topics |
| `thoughts-locator` | Discover relevant documents in thoughts directory |
| `web-search-researcher` | Research topics using web search |
| `sandbox` | Sandboxed environment for code execution |
| `fortran-sandbox` | Sandboxed environment for Fortran code |

## Commands

| Command | Purpose |
|---------|---------|
| `/commit` | Create git commits with user approval |
| `/create_plan` | Create detailed implementation plans |
| `/implement_plan` | Implement plans from thoughts/shared/plans |
| `/debug` | Debug issues by investigating logs and history |
| `/research_codebase` | Document codebase comprehensively |
| `/create_handoff` | Create handoff document for session transfer |
| `/resume_handoff` | Resume work from handoff document |
| `/validate_plan` | Validate implementation against plan |
| `/sandbox-init` | Initialize a sandbox environment |
| `/sandbox-clean` | Clean up sandbox environment |
| `/sandbox-query` | Query sandbox state |

See `commands/` directory for full list.
