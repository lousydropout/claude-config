---
description: Create worktree and launch implementation session for a plan
---

# Goal
Create a git worktree for isolated development to implement a plan file. This enables parallel work on multiple features without branch conflicts.

## Context for Fresh Sessions

**IMPORTANT**: This command may be run after clearing a session. This section provides essential context.

### Directory Structure

```
thoughts/shared/
├── plans/        # Implementation plans (YYYY-MM-DD-ENG-XXXX-description.md)
├── handoffs/     # Handoff documents by ticket
└── research/     # Research documents

~/wt/             # Default worktree location
└── REPO_NAME/
    └── SHORT_NAME/  # Individual worktrees
```

### Related Commands

After creating the worktree, use these commands in the new session:
- `/implement_plan [plan_path]` - Implement an existing plan
- `/oneshot_plan [ticket]` - Create plan and implement in one workflow
- `/resume_handoff [handoff_path]` - Resume from previous work

# Step 1: Determine Repository and Paths

First, gather information about the current repository:

```bash
# Get repository name
basename "$(git rev-parse --show-toplevel)"

# Get current directory for reference
pwd
```

# Step 2: Set Up Worktree

Create a new worktree for isolated development:

```bash
# Create worktree with a new branch
git worktree add -b BRANCH_NAME ~/wt/REPO_NAME/SHORT_NAME origin/main
```

Where:
- `REPO_NAME` is the repository name (from step 1)
- `SHORT_NAME` is a short identifier (e.g., ticket number like `eng-1234` or feature name)
- `BRANCH_NAME` is a descriptive branch name (e.g., `eng-1234-fix-mcp-keepalive`)

This creates an isolated working directory at `~/wt/REPO_NAME/SHORT_NAME` with a new branch.

# Step 3: Configure the Worktree

Set up the worktree environment:

```bash
# Copy Claude settings if they exist
cp .claude/settings.local.json ~/wt/REPO_NAME/SHORT_NAME/.claude/ 2>/dev/null || true

# Install dependencies (adapt based on project type)
cd ~/wt/REPO_NAME/SHORT_NAME

# Check for common setup methods
if [ -f "Makefile" ] && grep -q "setup" Makefile; then
    make setup
elif [ -f "package.json" ]; then
    npm install
elif [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
elif [ -f "go.mod" ]; then
    go mod download
fi
```

# Step 4: Gather Required Information

Collect the following data needed for implementation:

1. **Branch name** - The descriptive name for this feature/fix
2. **Plan file path** - Path to the implementation plan
3. **Worktree path** - Full path to the created worktree

## Path Format for Plan Files

If using a shared thoughts directory with symlinks:
- **Format**: Use the relative path starting with `thoughts/shared/...`
- **Example**: `thoughts/shared/plans/fix-mcp-keepalive.md`

If the plan is in the main repository:
- Copy it to the worktree or use an absolute path

# Step 5: Confirm with User

Present the configuration to the user for confirmation before proceeding:

```
Based on your input, I have created a worktree with the following configuration:

Worktree path: ~/wt/REPO_NAME/SHORT_NAME
Branch name: BRANCH_NAME
Plan file path: thoughts/shared/plans/PLAN_NAME.md

Next steps:
1. Navigate to the worktree: cd ~/wt/REPO_NAME/SHORT_NAME
2. Start a new Claude Code session there
3. Choose an implementation approach (see options below)

Or I can start implementation in this session if you prefer.
```

Wait for user confirmation or feedback.

# Step 6: Implementation Options

After creating the worktree, choose the appropriate command:

**Option A: Plan already exists** → `/implement_plan`
```
/implement_plan thoughts/shared/plans/PLAN_NAME.md
```
- Uses orchestration pattern with sub-agents
- Sub-agents handle implementation, testing, and validation
- Progress reported after each phase
- Major issues escalated to user

**Option B: No plan yet** → `/oneshot_plan`
```
/oneshot_plan [ticket_number]
```
- Creates plan first, then implements
- Same orchestration pattern as /implement_plan
- Good for starting fresh from a ticket

**About the orchestration pattern:**
Both commands use sub-agents for implementation, which means:
- Fresh context for each phase (no context accumulation)
- You stay informed through detailed progress reports
- No manual session clearing needed between phases
- Major issues are escalated for your input

# Important Notes

- Worktrees share the same git objects but have separate working directories
- Each worktree can have different branches checked out simultaneously
- Use `git worktree list` to see all worktrees
- Remove a worktree with `git worktree remove ~/wt/REPO_NAME/SHORT_NAME`
- Clean up orphaned worktree references with `git worktree prune`

# Example Usage

```
/create_worktree eng-1234 fix-authentication-flow
```

This will:
1. Create worktree at `~/wt/<repo>/eng-1234`
2. Create branch `eng-1234-fix-authentication-flow`
3. Set up the development environment
4. Provide instructions for next steps
