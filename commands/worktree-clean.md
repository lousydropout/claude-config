# Clean Worktree Sandbox

Remove orphaned worktrees and optionally reset the database.

## Arguments
$ARGUMENTS format: `{project|all} [--reset]`

Examples:
- `nextjs-bun` — clean orphaned worktrees only
- `nextjs-bun --reset` — also clear the database
- `all` — clean all worktree sandboxes
- `all --reset` — reset all

## Instructions

1. Parse arguments for project(s) and reset flag

2. For single project:
   ```bash
   cd sandbox/{project}/main
   
   # Remove all worktrees
   git worktree list --porcelain | grep "^worktree" | grep -v "/main$" | cut -d' ' -f2 | while read wt; do
     git worktree remove "$wt" --force 2>/dev/null || true
   done
   
   # Prune stale entries
   git worktree prune
   
   # Delete test branches
   git branch --list "test/*" | xargs -r git branch -D
   ```
   
   If `--reset`:
   ```bash
   rm -f sandbox/{project}/tests.db
   sqlite3 sandbox/{project}/tests.db < sandbox/schema-worktree.sql
   ```

3. For `all`:
   - Find directories in `sandbox/` with `config.json` containing `"uses_worktrees": true`
   - Apply clean to each

4. Report what was cleaned

## Safety

- Never delete main project
- Never delete config.json
- Confirm before `--reset`
