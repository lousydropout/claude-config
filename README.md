# Claude Code Configuration

Personal configuration for [Claude Code](https://claude.com/claude-code).

## Structure

- `agents/` - Custom sub-agent definitions for specialized tasks
- `commands/` - Custom slash commands
- `notes/` - Reference notes and documentation (persistent knowledge)
- `settings.json` - Permissions and environment settings

## Agents

### Codebase Analysis
| Agent | Purpose |
|-------|---------|
| `codebase-analyzer` | Analyze codebase implementation details |
| `codebase-locator` | Locate files and components relevant to a task |
| `codebase-pattern-finder` | Find similar implementations and usage examples |

### Research
| Agent | Purpose |
|-------|---------|
| `thoughts-analyzer` | Deep dive on research topics |
| `thoughts-locator` | Discover relevant documents in thoughts directory |
| `web-search-researcher` | Research topics using web search |

### Sandboxes
| Agent | Purpose |
|-------|---------|
| `sandbox` | General-purpose code experimentation (any language) |
| `fortran-sandbox` | Fortran/LAPACK code testing |
| `worktree-sandbox` | Project-level experimentation using git worktrees |
| `nextjs-bun-sandbox` | Next.js testing with bun runtime |
| `nextjs-npm-sandbox` | Next.js testing with npm |

## Commands

### Planning & Implementation
| Command | Purpose | Example |
|---------|---------|---------|
| `/create_plan` | Create detailed implementation plans | `/create_plan add user authentication` |
| `/implement_plan` | Implement plans from thoughts/shared/plans | `/implement_plan auth-feature.md` |
| `/validate_plan` | Validate implementation against plan | `/validate_plan` |

### Session Management
| Command | Purpose | Example |
|---------|---------|---------|
| `/commit` | Create git commits with user approval | `/commit` |
| `/create_handoff` | Create handoff document for session transfer | `/create_handoff` |
| `/resume_handoff` | Resume work from handoff document | `/resume_handoff` |

### Research & Debugging
| Command | Purpose | Example |
|---------|---------|---------|
| `/research_codebase` | Document codebase comprehensively | `/research_codebase` |
| `/debug` | Debug issues by investigating logs and history | `/debug checkout failing` |

### Sandbox Management
| Command | Purpose | Example |
|---------|---------|---------|
| `/sandbox-init` | Initialize a language sandbox | `/sandbox-init fortran` |
| `/sandbox-clean` | Clean up sandbox artifacts | `/sandbox-clean fortran --reset` |
| `/sandbox-query` | Query sandbox test history | `/sandbox-query fortran failures` |

### Worktree Sandbox Management
| Command | Purpose | Example |
|---------|---------|---------|
| `/worktree-init` | Initialize worktree sandbox | `/worktree-init myapp nextjs-bun` |
| `/worktree-clean` | Clean orphaned worktrees | `/worktree-clean myapp` |
| `/worktree-query` | Query worktree test history | `/worktree-query myapp recent 20` |

## Notes

Reference documentation that persists across sessions. Claude reads these before working with specific technologies.

| Note | Purpose |
|------|---------|
| `fortran.md` | Fortran compiler flags, LAPACK patterns, legacy code handling |
| `nextjs.md` | Next.js App Router conventions, server/client components, common errors |

### Adding Notes

Create `~/.claude/notes/{topic}.md` with sections:
- Compiler/runtime specifics
- Common libraries and patterns
- Idioms and conventions
- Lessons learned (append as you discover issues)

## Sandbox System

The sandbox system provides isolated environments for code experimentation.

### Simple Sandboxes (`sandbox/`)
For single-file or small code experiments:
```
sandbox/{language}/
  config.json      # language settings
  tests.db         # SQLite test history
  tests/           # temporary test directories
```

### Worktree Sandboxes (`sandbox/`)
For full project experiments using git worktrees:
```
sandbox/{project}/
  main/            # base project (git repo)
  worktrees/       # isolated test branches
  config.json      # project settings
  tests.db         # SQLite test history
```

Worktrees allow testing changes without affecting the main branch, with automatic cleanup after each experiment.
