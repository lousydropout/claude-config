# Query Sandbox Test History

Search and analyze test results from sandbox experiments.

## Arguments
$ARGUMENTS format: `{language} {query_type} [pattern]`

Examples:
- `fortran recent` — last 10 tests
- `fortran recent 20` — last 20 tests
- `fortran failures` — failed compilations/runs
- `rust search undefined reference` — search output for pattern
- `python stats` — success rate statistics

## Instructions

1. Parse arguments:
   - Language (required)
   - Query type: `recent`, `failures`, `compiled-but-failed`, `search`, `stats`
   - Optional: count for recent, pattern for search

2. Check database exists: `sandbox/{language}/tests.db`

3. Run appropriate query:

### recent [N]
```sql
SELECT test_id, description, compile_success, run_success, created_at
FROM tests ORDER BY created_at DESC LIMIT {N or 10};
```

### failures
```sql
SELECT test_id, description, 
       compile_success, compile_output,
       run_success, run_output
FROM tests 
WHERE compile_success = 0 OR run_success = 0
ORDER BY created_at DESC;
```

### compiled-but-failed
```sql
SELECT test_id, description, run_output
FROM tests
WHERE compile_success = 1 AND run_success = 0
ORDER BY created_at DESC;
```

### search {pattern}
```sql
SELECT test_id, description, created_at
FROM tests
WHERE lint_output LIKE '%{pattern}%'
   OR typecheck_output LIKE '%{pattern}%'
   OR compile_output LIKE '%{pattern}%'
   OR run_output LIKE '%{pattern}%'
ORDER BY created_at DESC;
```

### stats
```sql
SELECT 
  COUNT(*) as total,
  SUM(CASE WHEN lint_success THEN 1 ELSE 0 END) as lint_passed,
  SUM(CASE WHEN typecheck_success THEN 1 ELSE 0 END) as typecheck_passed,
  SUM(CASE WHEN compile_success THEN 1 ELSE 0 END) as compile_passed,
  SUM(CASE WHEN run_success THEN 1 ELSE 0 END) as run_passed
FROM tests;
```

4. Present results readably

5. If database missing, suggest: `sandbox-init {language}`
