# Clean Sandbox

Remove test artifacts and optionally reset the database.

## Arguments
$ARGUMENTS format: `{language|all} [--reset]`

Examples:
- `fortran` — remove leftover test directories only
- `fortran --reset` — also clear the database
- `all` — clean all language sandboxes
- `all --reset` — reset all sandboxes

## Instructions

1. Parse arguments for language(s) and reset flag

2. For single language:
   ```bash
   rm -rf sandbox/{language}/tests/*/
   ```

   If `--reset`:
   ```bash
   rm -f sandbox/{language}/tests.db
   sqlite3 sandbox/{language}/tests.db < sandbox/schema.sql
   ```

3. For `all`:
   - Find directories in `sandbox/` containing `config.json`
   - Apply clean to each

4. Report what was cleaned

## Safety

- Never delete config.json or helper scripts
- Only delete contents of `tests/` subdirectories
- Confirm before `--reset` (destroys history)
