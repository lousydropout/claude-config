# Initialize Language Sandbox

Set up a new sandbox environment for the specified language.

## Arguments
$ARGUMENTS should be a language name (e.g., `fortran`, `rust`, `python`)

## Instructions

1. Create the directory structure:
   ```
   sandbox/{language}/
     config.json
     tests.db
     tests/
   ```

2. If `sandbox/schema.sql` doesn't exist, create it first (see below)

3. If `sandbox/helpers/log_result.sh` doesn't exist, create it first (see below)

4. Create config.json with appropriate settings:
   ```json
   {
     "language": "{language}",
     "compiler": null,
     "run_command": null,
     "file_extensions": [],
     "default_flags": "",
     "library_flags": "",
     "needs_compile": true,
     "lint_command": null,
     "typecheck_command": null
   }
   ```
   Fill in values appropriate for the language.

5. Initialize the database:
   ```bash
   sqlite3 sandbox/{language}/tests.db < sandbox/schema.sql
   ```

6. Create notes file at `~/.claude/notes/{language}.md`:
   ```markdown
   # {Language} Notes

   Persistent knowledge for working with {Language}. Update as we learn.

   ## Compiler/Interpreter

   ## Common Libraries

   ## Idioms and Patterns

   ## Lessons Learned
   ```

7. Report what was created and any manual setup needed (e.g., installing compilers)

## Shared Files

### sandbox/schema.sql
```sql
CREATE TABLE tests (
    test_id TEXT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    source_files TEXT,
    flags TEXT,
    lint_success BOOLEAN,
    lint_output TEXT,
    typecheck_success BOOLEAN,
    typecheck_output TEXT,
    compile_success BOOLEAN,
    compile_output TEXT,
    run_success BOOLEAN,
    run_output TEXT,
    notes TEXT
);

CREATE INDEX idx_tests_created_at ON tests(created_at);
CREATE INDEX idx_tests_compile_success ON tests(compile_success);
CREATE INDEX idx_tests_run_success ON tests(run_success);
```

### sandbox/helpers/log_result.sh
See sandbox agent for usage. Creates a script that:
- Takes language, test_id, description, source_files, flags
- Takes success/output pairs for lint, typecheck, compile, run steps
- Escapes SQL strings and inserts into the appropriate database
