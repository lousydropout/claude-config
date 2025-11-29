# Query Worktree Sandbox History

Search and analyze test results from worktree-based experiments.

## Arguments
$ARGUMENTS format: `{project} {query_type} [pattern]`

Examples:
- `nextjs-bun recent` — last 10 tests
- `nextjs-bun failures` — failed builds
- `nextjs-bun search "Module not found"` — search output
- `nextjs-npm stats` — success statistics
- `nextjs-bun diff {test_id}` — show diff for specific test

## Instructions

1. Parse arguments:
   - Project (required)
   - Query type: `recent`, `failures`, `search`, `stats`, `diff`
   - Optional: count, pattern, or test_id

2. Check database exists: `sandbox/{project}/tests.db`

3. Run appropriate query:

### recent [N]
```sql
SELECT test_id, description, build_success, created_at
FROM tests ORDER BY created_at DESC LIMIT {N or 10};
```

### failures
```sql
SELECT test_id, description,
       lint_success, typecheck_success, build_success, test_success,
       lint_output, typecheck_output, build_output, test_output
FROM tests 
WHERE lint_success = 0 
   OR typecheck_success = 0 
   OR build_success = 0 
   OR test_success = 0
ORDER BY created_at DESC;
```

### search {pattern}
```sql
SELECT test_id, description, created_at
FROM tests
WHERE lint_output LIKE '%{pattern}%'
   OR typecheck_output LIKE '%{pattern}%'
   OR build_output LIKE '%{pattern}%'
   OR test_output LIKE '%{pattern}%'
ORDER BY created_at DESC;
```

### stats
```sql
SELECT 
  COUNT(*) as total,
  SUM(CASE WHEN lint_success THEN 1 ELSE 0 END) as lint_passed,
  SUM(CASE WHEN typecheck_success THEN 1 ELSE 0 END) as typecheck_passed,
  SUM(CASE WHEN build_success THEN 1 ELSE 0 END) as build_passed,
  SUM(CASE WHEN test_success THEN 1 ELSE 0 END) as test_passed
FROM tests;
```

### diff {test_id}
```sql
SELECT diff FROM tests WHERE test_id = '{test_id}';
```

4. Present results readably

5. If database missing, suggest: `worktree-init {project} {template}`
