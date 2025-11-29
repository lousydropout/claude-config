# Build: Local Documentation CLI (`docs`)

## Overview

Build a CLI tool called `docs` that provides a local, queryable knowledge base for:
1. **Library documentation** — Scraped from official docs sites, stored globally
2. **Repository knowledge** — Per-repo, branch-aware understanding of a codebase

The goal is to give Claude Code (or any AI coding assistant) fast, local access to documentation and project context without relying on external services.

## Architecture

```
~/.local-docs/                    # Project root (installed globally via bun link)
├── docs.sqlite                   # Library docs database (global)
├── package.json                  # Bun project config
├── tsconfig.json
├── src/
│   ├── index.ts                  # CLI entrypoint (#!/usr/bin/env bun)
│   ├── commands/                 # Command implementations
│   ├── db/
│   │   ├── library.ts            # Library docs DB operations
│   │   └── repo.ts               # Repo knowledge DB operations
│   ├── scraper/
│   │   ├── crawler.ts            # URL crawling
│   │   ├── extractor.ts          # Symbol/example extraction
│   │   └── parser.ts             # HTML to markdown
│   └── utils/
│       ├── git.ts                # Git helpers (branch, repo root, worktree)
│       ├── paths.ts              # Path resolution
│       └── format.ts             # Output formatting
└── bin/
    └── docs -> ../src/index.ts   # Symlink (created by bun link)

~/repos/some-project/             # Any git repository
└── .local-docs/
    └── repo.sqlite               # Repo-specific knowledge (branch-aware)
```

## Tech Stack

- **Runtime**: Bun
- **Language**: TypeScript (ESM)
- **Database**: SQLite via `bun:sqlite` (native, no external dependencies)
- **CLI framework**: `commander`
- **Scraper**: `cheerio` + native `fetch` (static sites only for MVP)
- **HTML to Markdown**: `turndown`
- **Installation**: Global via `bun link` from `~/.local-docs/`

## Database Schemas

### Library Docs (`~/.local-docs/docs.sqlite`)

```sql
CREATE TABLE libraries (
  id INTEGER PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  docs_url TEXT,
  version TEXT,
  scraped_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pages (
  id INTEGER PRIMARY KEY,
  library_id INTEGER REFERENCES libraries(id) ON DELETE CASCADE,
  url TEXT NOT NULL,
  title TEXT,
  content TEXT,
  scraped_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(library_id, url)
);

CREATE TABLE symbols (
  id INTEGER PRIMARY KEY,
  library_id INTEGER REFERENCES libraries(id) ON DELETE CASCADE,
  page_id INTEGER REFERENCES pages(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  kind TEXT,                            -- 'function' | 'type' | 'hook' | 'component' | 'class'
  signature TEXT,
  description TEXT,
  source TEXT DEFAULT 'scraped',        -- 'scraped' | 'user'
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(library_id, name, kind)
);

CREATE TABLE examples (
  id INTEGER PRIMARY KEY,
  library_id INTEGER REFERENCES libraries(id) ON DELETE CASCADE,
  symbol_id INTEGER REFERENCES symbols(id) ON DELETE SET NULL,
  code TEXT NOT NULL,
  language TEXT DEFAULT 'typescript',
  description TEXT,
  source TEXT DEFAULT 'scraped',        -- 'scraped' | 'user'
  tags TEXT,                            -- JSON array
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notes (
  id INTEGER PRIMARY KEY,
  library_id INTEGER REFERENCES libraries(id) ON DELETE CASCADE,
  symbol_id INTEGER REFERENCES symbols(id) ON DELETE SET NULL,
  content TEXT NOT NULL,
  tags TEXT,                            -- JSON array
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- FTS indexes
CREATE VIRTUAL TABLE pages_fts USING fts5(title, content, content=pages, content_rowid=id);
CREATE VIRTUAL TABLE symbols_fts USING fts5(name, description, content=symbols, content_rowid=id);
CREATE VIRTUAL TABLE notes_fts USING fts5(content, content=notes, content_rowid=id);

-- FTS triggers (INSERT, UPDATE, DELETE for each table)
CREATE TRIGGER pages_fts_insert AFTER INSERT ON pages BEGIN
  INSERT INTO pages_fts(rowid, title, content) VALUES (new.id, new.title, new.content);
END;
-- Add UPDATE and DELETE triggers for pages, symbols, notes
```

### Repo Knowledge (`.local-docs/repo.sqlite` in repo root)

```sql
CREATE TABLE file_index (
  id INTEGER PRIMARY KEY,
  branch TEXT NOT NULL,
  path TEXT NOT NULL,
  description TEXT,
  kind TEXT,                            -- 'file' | 'function' | 'class' | 'component' | 'module'
  content_hash TEXT,
  indexed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(branch, path)
);

CREATE TABLE notes (
  id INTEGER PRIMARY KEY,
  branch TEXT,                          -- NULL = applies to all branches
  path TEXT,                            -- NULL = repo-wide note
  symbol TEXT,
  content TEXT NOT NULL,
  tags TEXT,                            -- JSON array
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE relationships (
  id INTEGER PRIMARY KEY,
  branch TEXT NOT NULL,
  source_path TEXT NOT NULL,
  target_path TEXT NOT NULL,
  kind TEXT NOT NULL,                   -- 'imports' | 'calls' | 'extends' | 'relates'
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(branch, source_path, target_path, kind)
);

-- FTS indexes
CREATE VIRTUAL TABLE file_index_fts USING fts5(path, description, content=file_index, content_rowid=id);
CREATE VIRTUAL TABLE notes_fts USING fts5(content, content=notes, content_rowid=id);

-- Add FTS triggers
```

## CLI Commands

### Library Docs (Global)

```bash
docs add <name> <url> [--version <version>]
# Add a library and scrape its docs
# Example: docs add xstate https://stately.ai/docs/xstate --version 5.19.0

docs update <name> [--version <version>]
# Re-scrape a library's docs

docs remove <name>
# Remove a library and all its data

docs list
# List all libraries with stats

docs search <library> <query>
# Full-text search across pages, symbols, notes, examples
# Example: docs search xstate "spawn child actor"

docs get <library> <symbol>
# Get symbol details: signature, description, examples, notes
# Example: docs get xstate createActor

docs note <library> <content> [--symbol <symbol>] [--tags <tags>]
# Add a note
# Example: docs note xstate "Always use systemId for cross-actor refs" --symbol createActor --tags "gotcha,best-practice"

docs notes <library> [--symbol <symbol>]
# List notes for a library

docs note remove <id>
# Remove a note by ID

docs example <library> <code_or_file> [--symbol <symbol>] [--description <desc>] [--tags <tags>]
# Add an example (inline code or file path)
# Example: docs example xstate ./src/machines/auth.ts --symbol createMachine --description "Auth flow"

docs examples <library> [--symbol <symbol>]
# List examples for a library
```

### Repo Knowledge (Per-repo, Branch-aware)

```bash
docs repo init
# Initialize .local-docs/repo.sqlite in repo root

docs repo index
# Index current branch's files

docs repo search <query>
# Search repo knowledge (file descriptions, notes)

docs repo what <path>
# Get description of a file/symbol

docs repo deps <path>
# Show what this file depends on and what depends on it

docs repo describe <path> <description>
# Add/update description for a file/symbol
# Example: docs repo describe src/auth/machine.ts "Main auth state machine"

docs repo note <content> [--path <path>] [--symbol <symbol>] [--tags <tags>] [--global]
# Add a repo note (--global makes it apply to all branches)

docs repo notes [--path <path>]
# List repo notes

docs repo note remove <id>
# Remove a repo note

docs repo relate <source> <target> --kind <kind> [--description <desc>]
# Add a relationship between files
# Example: docs repo relate src/auth/machine.ts src/api/session.ts --kind calls

docs repo merge <branch>
# Copy notes and descriptions from <branch> to current branch

docs repo branches
# List branches that have notes/descriptions

docs repo prune
# Remove data for deleted branches or non-existent paths
```

## Output Format

All commands output **plain text** by default, optimized for readability by both humans and LLMs.

Optional `--json` flag for structured output.

### Example: `docs get xstate createActor`

```
# createActor (function)

## Signature
createActor<T>(logic: ActorLogic<T>, options?: ActorOptions<T>): Actor<T>

## Description
Creates an actor from the given logic. The actor is not started until actor.start() is called.

Source: https://stately.ai/docs/actors#createactor

## Examples

### Official
const actor = createActor(machine);
actor.subscribe((snapshot) => console.log(snapshot));
actor.start();

### User: Auth flow with systemId
const authActor = createActor(authMachine, {
  systemId: 'auth',
  input: { redirectUrl: '/dashboard' }
});

## Notes
- [#12] Always pass systemId if you need cross-actor communication (tags: gotcha, best-practice)
```

### Example: `docs repo what src/auth/machine.ts`

```
# src/auth/machine.ts

## Description
Main auth state machine—handles login, logout, token refresh, OAuth callbacks

## Relationships
- calls: src/api/session.ts (token operations)
- imports: src/auth/types.ts

## Notes
- [#3] Consider splitting OAuth into separate machine (tags: refactor)
```

## Git Utilities

The CLI needs to detect:

1. **Current branch**: `git rev-parse --abbrev-ref HEAD`
2. **Repo root** (works in worktrees): `git rev-parse --show-toplevel`
3. **Common git dir** (shared across worktrees): `git rev-parse --git-common-dir`

For worktree support, the repo DB location should be resolved from the main repo root, not the worktree root. Use `--git-common-dir` to find the shared `.git` directory, then resolve the actual repo root from there.

## Scraper Behavior

When `docs add <name> <url>` is run:

1. Fetch the starting URL
2. Extract page content as markdown (strip nav, header, footer, sidebar)
3. Find internal links within the same docs domain
4. Crawl linked pages (respect rate limits, max depth)
5. For each page:
   - Store in `pages` table
   - Extract code blocks → `examples` table
   - Best-effort: identify function/type definitions → `symbols` table
6. Build FTS index

### Extraction Heuristics

For symbols, look for patterns like:
- Headings followed by code blocks with function signatures
- TypeScript/JSDoc-style definitions
- API reference tables

This doesn't need to be perfect—it's best-effort. Users can manually add symbols with `docs symbol` if needed.

## Claude Code Integration

### CLAUDE.md (User-level: `~/.claude/CLAUDE.md`)

```markdown
## Local Documentation

Query local library docs with the `docs` CLI:

- `docs list` — Show available libraries
- `docs search <lib> <query>` — Full-text search
- `docs get <lib> <symbol>` — Get symbol details with examples and notes
- `docs examples <lib> [symbol]` — List code examples

Add knowledge:
- `docs note <lib> "note" --symbol <symbol>` — Add a note
- `docs example <lib> ./file.ts --symbol <symbol>` — Add an example from file

If a library isn't available, inform the user they can add it:
`docs add <name> <docs-url>`
```

### CLAUDE.md (Project-level, if using repo knowledge)

```markdown
## Repository Knowledge

This repo uses local docs for codebase knowledge.

- `docs repo search <query>` — Search repo knowledge
- `docs repo what <path>` — Get file/symbol description
- `docs repo deps <path>` — Show dependencies

Add knowledge as you learn:
- `docs repo describe <path> "description"` — Describe a file
- `docs repo note "note" --path <path>` — Add a note
- `docs repo relate <src> <dst> --kind <kind>` — Document relationships
```

### Slash Command: `.claude/commands/merge.md`

```markdown
# Merge Branch

Merge a branch into the current branch.

## Instructions

1. Run `git merge $ARGUMENTS`
2. If merge succeeds and `.local-docs/repo.sqlite` exists at repo root:
   - Ask: "Should I sync the docs notes from $ARGUMENTS?"
   - If yes, run `docs repo merge $ARGUMENTS`
3. If merge fails, help resolve conflicts as usual
```

## Implementation Notes

### Initialization

- On first run, create `~/.local-docs/` and `docs.sqlite` if not exists
- `docs repo init` creates `.local-docs/repo.sqlite` in repo root
- Add `.local-docs/` to `.gitignore` when running `docs repo init`

### Error Handling

- If library not found: "Library 'x' not found. Run `docs list` to see available libraries."
- If repo not initialized: "Repo docs not initialized. Run `docs repo init` first."
- If not in a git repo: "Not in a git repository."

### Performance

- Use SQLite transactions for bulk inserts during scraping
- FTS queries should be fast enough for interactive use
- Consider caching branch name (changes infrequently)

## File Structure

```
~/.local-docs/
├── package.json
├── tsconfig.json
├── docs.sqlite               # Library docs database (created on first run)
├── src/
│   ├── index.ts              # CLI entrypoint (#!/usr/bin/env bun)
│   ├── commands/
│   │   ├── add.ts
│   │   ├── update.ts
│   │   ├── remove.ts
│   │   ├── list.ts
│   │   ├── search.ts
│   │   ├── get.ts
│   │   ├── note.ts
│   │   ├── notes.ts
│   │   └── repo/
│   │       ├── init.ts
│   │       ├── index.ts       # `docs repo index` command
│   │       ├── search.ts
│   │       ├── what.ts
│   │       ├── describe.ts
│   │       ├── note.ts
│   │       ├── notes.ts
│   │       └── merge.ts
│   ├── db/
│   │   ├── library.ts        # Library DB schema & operations
│   │   ├── repo.ts           # Repo DB schema & operations
│   │   └── migrations.ts     # Schema versioning
│   ├── scraper/
│   │   ├── crawler.ts        # URL crawling logic
│   │   ├── extractor.ts      # Content extraction (symbols, examples)
│   │   └── parser.ts         # HTML to markdown, code block extraction
│   └── utils/
│       ├── git.ts            # Git operations (branch, repo root, worktree)
│       ├── paths.ts          # Path resolution
│       └── format.ts         # Output formatting
└── bin/
    └── docs                  # Symlink created by `bun link`
```

Note: No `dist/` directory needed—Bun runs TypeScript directly.

## MVP Scope

### Phase 1: Library Docs (implement first)
1. ✅ Library docs: `add`, `list`, `search`, `get`, `note`, `notes`, `note remove`
2. ✅ Basic scraper (static HTML sites only)
3. ✅ FTS search
4. ✅ Plain text output

### Phase 2: Repo Knowledge (implement after Phase 1)
1. ✅ Repo knowledge: `init`, `index`, `search`, `what`, `describe`, `note`, `notes`, `note remove`, `merge`
2. ✅ Branch-aware repo DB
3. ✅ Git worktree support

### Deferred (not in MVP):
- JS-rendered site scraping (Playwright)
- `example` / `examples` commands
- `deps` / `relate` commands
- `prune` / `branches` commands
- `--json` output flag
- Export/import for team sharing

## Testing

After building, test with:

```bash
# Library docs
docs add xstate https://stately.ai/docs/xstate
docs list
docs search xstate "createActor"
docs get xstate createActor
docs note xstate "Test note" --symbol createActor
docs notes xstate
docs note remove 1

# Repo knowledge
cd /path/to/test/repo
docs repo init
docs repo index
docs repo describe src/index.ts "Main entrypoint"
docs repo search "entrypoint"
docs repo what src/index.ts
git checkout -b test-branch
docs repo note "Branch-specific note" --path src/index.ts
git checkout main
docs repo search "Branch-specific"  # Should not find it
docs repo merge test-branch
docs repo search "Branch-specific"  # Should find it now
```
