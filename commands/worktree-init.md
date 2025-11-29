# Initialize Worktree Sandbox

Set up a project-based sandbox using git worktrees for isolation.

## Arguments
$ARGUMENTS format: `{project_name} {template}`

Templates:
- `nextjs-bun` — Next.js with bun
- `nextjs-npm` — Next.js with npm
- `custom` — Empty git repo, configure manually

Examples:
- `myapp nextjs-bun`
- `experiment nextjs-npm`
- `rust-project custom`

## Instructions

1. Create directory structure:
   ```
   sandbox/{project_name}/
     main/              # base project
     worktrees/         # test worktrees go here
     config.json
     tests.db
   ```

2. Initialize based on template:

### nextjs-bun
```bash
cd sandbox/{project_name}/main
bunx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --no-import-alias
git init
git add .
git commit -m "Initial Next.js setup"
```

Config:
```json
{
  "project": "{project_name}",
  "project_root": "sandbox/{project_name}/main",
  "worktree_root": "sandbox/{project_name}/worktrees",
  "package_manager": "bun",
  "install_command": "bun install",
  "lint_command": "bun run lint",
  "typecheck_command": "bun run tsc --noEmit",
  "build_command": "bun run build",
  "test_command": null,
  "uses_worktrees": true
}
```

### nextjs-npm
```bash
cd sandbox/{project_name}/main
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --no-import-alias
git init
git add .
git commit -m "Initial Next.js setup"
```

Config:
```json
{
  "project": "{project_name}",
  "project_root": "sandbox/{project_name}/main",
  "worktree_root": "sandbox/{project_name}/worktrees",
  "package_manager": "npm",
  "install_command": "npm install",
  "lint_command": "npm run lint",
  "typecheck_command": "npx tsc --noEmit",
  "build_command": "npm run build",
  "test_command": null,
  "uses_worktrees": true
}
```

### custom
```bash
cd sandbox/{project_name}/main
git init
git commit --allow-empty -m "Initial commit"
```

Config:
```json
{
  "project": "{project_name}",
  "project_root": "sandbox/{project_name}/main",
  "worktree_root": "sandbox/{project_name}/worktrees",
  "package_manager": null,
  "install_command": null,
  "lint_command": null,
  "typecheck_command": null,
  "build_command": null,
  "test_command": null,
  "uses_worktrees": true
}
```

3. Ensure shared files exist. If not, create them:

### sandbox/schema-worktree.sql
```sql
CREATE TABLE tests (
    test_id TEXT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    files_changed TEXT,
    
    lint_success BOOLEAN,
    lint_output TEXT,
    
    typecheck_success BOOLEAN,
    typecheck_output TEXT,
    
    build_success BOOLEAN,
    build_output TEXT,
    
    test_success BOOLEAN,
    test_output TEXT,
    
    diff TEXT,
    notes TEXT
);

CREATE INDEX idx_tests_created_at ON tests(created_at);
CREATE INDEX idx_tests_build_success ON tests(build_success);
```

### sandbox/helpers/log_worktree_result.sh
```bash
#!/bin/bash
set -e

PROJECT="$1"
TEST_ID="$2"
DESCRIPTION="$3"
FILES_CHANGED="$4"
LINT_OK="$5"
LINT_OUTPUT="$6"
TYPECHECK_OK="$7"
TYPECHECK_OUTPUT="$8"
BUILD_OK="$9"
BUILD_OUTPUT="${10}"
TEST_OK="${11}"
TEST_OUTPUT="${12}"
DIFF="${13}"
NOTES="${14:-}"

DB="sandbox/${PROJECT}/tests.db"

escape_sql() { sed "s/'/''/g"; }

to_sql_bool() {
    case "$1" in
        ""|"null"|"NULL") echo "NULL" ;;
        "1"|"true"|"TRUE") echo "1" ;;
        *) echo "0" ;;
    esac
}

DESC_ESC=$(echo "$DESCRIPTION" | escape_sql)
LINT_OUT_ESC=$(echo "$LINT_OUTPUT" | escape_sql)
TC_OUT_ESC=$(echo "$TYPECHECK_OUTPUT" | escape_sql)
BUILD_OUT_ESC=$(echo "$BUILD_OUTPUT" | escape_sql)
TEST_OUT_ESC=$(echo "$TEST_OUTPUT" | escape_sql)
DIFF_ESC=$(echo "$DIFF" | escape_sql)
NOTES_ESC=$(echo "$NOTES" | escape_sql)

sqlite3 "$DB" <<EOF
INSERT INTO tests (
    test_id, description, files_changed,
    lint_success, lint_output,
    typecheck_success, typecheck_output,
    build_success, build_output,
    test_success, test_output,
    diff, notes
) VALUES (
    '$TEST_ID', '$DESC_ESC', '$FILES_CHANGED',
    $(to_sql_bool "$LINT_OK"), '$LINT_OUT_ESC',
    $(to_sql_bool "$TYPECHECK_OK"), '$TC_OUT_ESC',
    $(to_sql_bool "$BUILD_OK"), '$BUILD_OUT_ESC',
    $(to_sql_bool "$TEST_OK"), '$TEST_OUT_ESC',
    '$DIFF_ESC', '$NOTES_ESC'
);
EOF

echo "Logged test $TEST_ID to $DB"
```

4. Initialize database:
   ```bash
   sqlite3 sandbox/{project_name}/tests.db < sandbox/schema-worktree.sql
   ```

5. Create worktrees directory:
   ```bash
   mkdir -p sandbox/{project_name}/worktrees
   ```

6. Report what was created and any manual setup needed
