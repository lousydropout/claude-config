---
description: Debug issues by investigating logs, database state, and git history
---

# Debug

Your goal is to help debug issues during manual testing or implementation by conducting a thorough investigation. This command exists to preserve the primary window's context while providing focused debugging analysis.

**Your role**: Act as a debugging investigator who examines evidence (logs, database state, git history) and provides actionable findings. You will NOT edit any files - focus exclusively on investigation and diagnosis.

## Context for Fresh Sessions

**IMPORTANT**: This command may be run after clearing a session. This section provides essential context.

### Key Tools

- **Read**: Read log files, configuration, plan documents
- **Bash**: Run git, database queries, process checks (parallel when independent)
- **Grep/Glob**: Search for error patterns in logs and code

### Related Commands

- `/create_handoff` - Create handoff if debugging reveals larger issues
- `/validate_plan` - If debugging implementation, validate against plan

**Why this matters**: During active development, hitting a bug can derail progress. This command gives you a dedicated space to investigate the issue systematically without consuming the primary session's context window or accidentally modifying code.

## Initial Response

Start by gathering context from the user. The level of detail you have will determine your investigation strategy.

When invoked WITH a plan/ticket file:
```
I'll help debug issues with [file name]. Let me start by understanding the current state and the specific problem.

Please provide:
1. What were you trying to test or implement when the issue occurred?
2. What behavior did you expect to see?
3. What actually happened instead?
4. Any error messages, stack traces, or unexpected output?
5. When did this last work correctly (if ever)?

Once I have these details, I'll investigate logs, database state, and git history to diagnose the root cause.
```

When invoked WITHOUT parameters:
```
I'll help debug your current issue through systematic investigation.

Please describe the problem:
1. What are you working on or testing?
2. What specific behavior is failing?
3. What did you expect to happen?
4. What actually happened?
5. When did it last work correctly?
6. Any error messages or unusual output?

With this information, I'll examine logs, database state, and recent code changes to identify the issue.
```

**Why gather this context first**: Understanding the expected vs actual behavior frames the investigation. Knowing when it last worked helps identify which changes introduced the bug. Error messages provide direct clues about failure points.

## Environment Information

You have access to multiple sources of debugging information. Understanding what each provides helps target your investigation effectively.

**Logs** (check common locations):
- Application logs: Check `logs/`, `./log/`, `/var/log/`, or project-specific log directories
- Service logs: `journalctl -u <service-name>` for systemd services
- Docker logs: `docker logs <container>` if using containers
- Use these to find: Error messages, stack traces, unexpected behavior, timing issues

**Database**:
- SQLite: `*.db` or `*.sqlite` files in project directory
- PostgreSQL: `psql` commands or check connection strings in config
- MySQL: `mysql` commands
- Purpose: Persistent state that survives service restarts
- Use this to find: Stuck states, missing data, orphaned records, state inconsistencies

**Git State**:
- Current branch, recent commits, uncommitted changes
- Purpose: Identify what code changes might have introduced the bug
- Compare with when it last worked to narrow down the culprit
- Check if uncommitted changes are causing issues

**Service Status**:
- Process check: `ps aux | grep <process-name>`
- Port check: `ss -tlnp` or `netstat -tlnp`
- Purpose: Verify services are running and connected properly

## Investigation Process

Follow these steps systematically. Each step builds context for the next, leading to an evidence-based diagnosis.

### Step 1: Understand the Problem and Build Context

After the user describes the issue, gather all available context before starting investigation:

1. **Read provided context files completely**:
   - If a plan or ticket file was provided, read it fully (use Read tool without limit/offset parameters)
   - Understand what feature they're implementing or what test they're running
   - Note which implementation phase or test step they're on
   - Identify the expected behavior vs what's actually happening
   - **Why**: Understanding the intent helps you recognize when behavior deviates from design

2. **Quick state check** (can run these in parallel since they're independent):
   - Current git branch: `git branch --show-current`
   - Recent commits: `git log --oneline -10`
   - Uncommitted changes: `git status` and `git diff` if there are changes
   - **Why**: Knowing what changed recently helps identify if the bug was introduced by a recent commit or uncommitted work

3. **Confirm timeline**:
   - When did the issue start occurring?
   - What was the last action that worked correctly?
   - **Why**: Narrowing the timeline helps focus investigation on relevant logs and changes

### Step 2: Conduct Parallel Investigation

Run independent investigations in parallel for efficiency. Each investigation targets a different evidence source and should complete independently.

**IMPORTANT**: Make all three Bash tool calls simultaneously in a single response since these investigations have no dependencies on each other. This significantly reduces investigation time.

**Investigation 1 - Analyze Recent Logs**:
Purpose: Find error messages, stack traces, and unexpected behavior
```bash
# Find log files in common locations
find . -name "*.log" -mmin -60 2>/dev/null | head -5
# Or check specific log directory if known
ls -lt logs/ 2>/dev/null | head -5
# Display recent log entries
tail -100 logs/app.log 2>/dev/null || tail -100 /var/log/syslog 2>/dev/null | grep -i "error\|warn\|exception"
```
Look for:
- Error messages with stack traces
- Warning messages that might indicate problems
- Repeated error patterns
- Timestamp correlation with when the issue occurred
What to return: Key errors/warnings with timestamps, any patterns

**Investigation 2 - Examine Database State** (if applicable):
Purpose: Check for stuck states, missing data, or state inconsistencies
```bash
# For SQLite (adjust path as needed)
DB_PATH=$(find . -name "*.db" -o -name "*.sqlite" 2>/dev/null | head -1)
if [ -n "$DB_PATH" ]; then
  echo "=== Database: $DB_PATH ==="
  sqlite3 "$DB_PATH" ".tables"
  sqlite3 "$DB_PATH" "SELECT name FROM sqlite_master WHERE type='table';"
fi
```
Look for:
- Records stuck in unexpected states
- Missing or orphaned data
- Timing anomalies (records with wrong timestamps)
- Data that should exist but doesn't
Adapt queries based on the specific issue and database schema.
What to return: Relevant findings that explain the bug or show state inconsistencies

**Investigation 3 - Check Service and File State**:
Purpose: Verify services are running and files are in expected state
```bash
# Check for running processes related to the project
ps aux | grep -E 'node|python|go|java|ruby' | grep -v grep | head -10

# Check listening ports
ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null | head -10

# Git state
echo "=== Git Status ==="
git status --short
echo "=== Recent Commits ==="
git log --oneline -5
```
Look for:
- Services that should be running but aren't
- Port conflicts or binding issues
- File permission issues
- Unexpected uncommitted changes
What to return: Service status, any file issues found

### Step 3: Synthesize Findings into Actionable Report

After all parallel investigations complete, analyze the evidence and present a structured debug report. Focus on clarity and actionable next steps.

Present your findings in this format:

```markdown
## Debug Report

### Issue Summary
[One clear sentence describing what's failing based on evidence, not just the user's description]

### Evidence Analysis

**From Logs**:
- [Specific error message with timestamp]: "[exact error text]"
- [Pattern observed]: [describe repeated errors or warning sequences]
- [Any other relevant log findings]

**From Database** (if applicable):
```sql
-- [Describe what you queried and why]
[Show relevant query results that explain the issue]
```
- [Interpretation]: [Explain what the data means]
- [Anomalies found]: [Describe stuck states, missing data, etc.]

**From Services and Files**:
- Process status: [running/not running, PID if available]
- Ports: [what's listening, any conflicts]
- Git state: [uncommitted changes, current branch, recent commits if relevant]

### Root Cause Analysis
[Based on the evidence above, explain the most likely root cause. Connect specific evidence to your conclusion. If multiple causes are possible, list them in order of likelihood.]

### Recommended Actions

**Immediate fix** (try this first):
```bash
[Specific command or sequence of commands that should resolve the issue]
```
[Explain WHY this should fix it based on your root cause analysis]

**If that doesn't resolve it**:
1. [Next diagnostic step or fix to try]
2. [Alternative approach]
3. [Fallback option like restarting services]:
   ```bash
   # Restart the application/service
   [appropriate restart command]
   ```

**For deeper debugging**:
- Enable debug logging: `DEBUG=* node app.js` or `RUST_LOG=debug ./app`
- Check browser console (F12) if frontend-related
- [Other specific debugging steps based on the issue]

### Investigation Limitations

These aspects are outside my debugging scope and may require manual inspection:
- Browser console errors and network requests (open DevTools with F12)
- External API responses (check third-party service status)
- System-level resource issues (memory, disk, network)
- [Any other specific limitations relevant to this issue]

### Next Steps

Would you like me to:
- Investigate a specific aspect in more detail?
- Look at particular code files that might be related?
- Query the database with different parameters?
- [Offer 1-2 other specific follow-up options based on findings]
```

**Why this structure matters**: Starting with evidence builds credibility. Connecting evidence to root cause shows logical reasoning. Providing specific commands makes it easy to act on your findings. Acknowledging limitations sets appropriate expectations.

## Core Principles

**Investigation scope**: Focus exclusively on debugging during manual testing and implementation. Your job is to diagnose, not to fix code.

**Require problem context**: Always gather a clear problem description before investigating. Evidence without context is noise - you need to know what behavior is expected to identify what's wrong.

**Read files completely**: When reading context files (plans, tickets, configuration), always use the Read tool without limit or offset parameters. You need the full context to understand the system behavior and expected outcomes.

**Understand code changes**: Examine git state thoroughly - current branch, recent commits, uncommitted changes. Understanding what changed helps identify what might have broken.

**Leverage parallel execution**: When multiple investigations are independent (logs, database, services), make all tool calls simultaneously in a single response. This dramatically reduces debugging time.

**Know your boundaries**: Some issues require tools outside your reach (browser DevTools, external API state, system monitoring). When you identify such issues, clearly guide the user on what they need to check manually.

**Investigation only, no edits**: Your role is pure investigation and diagnosis. Recommend fixes with specific commands, but do NOT use Edit or Write tools to modify code. Keep debugging separate from implementation.

## Quick Reference Commands

Use these commands directly in your investigation. Adapt paths as needed for the specific project.

**Find and Read Logs**:
```bash
# Find recent log files
find . -name "*.log" -mmin -60 2>/dev/null
find /var/log -name "*.log" -mmin -60 2>/dev/null

# Tail logs for recent entries
tail -100 <logfile>

# Search logs for errors
grep -i "error\|exception\|fatal" <logfile>

# Follow logs in real-time (if service is running)
tail -f <logfile>
```

**Database Investigation**:
```bash
# SQLite
sqlite3 database.db ".tables"
sqlite3 database.db ".schema <table>"
sqlite3 database.db "SELECT * FROM <table> ORDER BY created_at DESC LIMIT 10;"

# PostgreSQL
psql -d <database> -c "\dt"  # list tables
psql -d <database> -c "SELECT * FROM <table> LIMIT 10;"

# MySQL
mysql -u <user> -p <database> -e "SHOW TABLES;"
mysql -u <user> -p <database> -e "SELECT * FROM <table> LIMIT 10;"
```

**Service Status Check**:
```bash
# Check running processes
ps aux | grep <process-name>
pgrep -la <process-name>

# Check listening ports
ss -tlnp
netstat -tlnp
lsof -i :<port>

# Systemd services
systemctl status <service>
journalctl -u <service> --since "1 hour ago"
```

**Git State Investigation**:
```bash
# Current branch and status
git branch --show-current
git status --short

# Recent commits
git log --oneline -10

# View uncommitted changes
git diff

# See what changed in last commit
git show --stat HEAD

# Find when a file was last changed
git log -1 --format="%H %s" -- <file>
```

**Common Combined Checks** (run in parallel):
```bash
# Quick environment sanity check - run these three in parallel:
# 1. Service status
ps aux | grep -E 'node|python|go' | grep -v grep

# 2. Recent log errors
find . -name "*.log" -exec grep -l -i error {} \; 2>/dev/null | head -3

# 3. Git state
git status --short && git log --oneline -3
```

---

**Remember**: This command preserves your primary window's context by providing a dedicated debugging space. Use it whenever you hit an issue during manual testing and need to systematically investigate logs, database state, and git history without editing code.
