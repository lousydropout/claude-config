---
description: Create worktree and launch implementation session for a plan
---

# Goal
Create a git worktree for isolated development to implement a plan file. This enables parallel work on multiple features without branch conflicts.

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

You can now:
1. Navigate to the worktree: cd ~/wt/REPO_NAME/SHORT_NAME
2. Start a new Claude Code session there
3. Run /implement_plan thoughts/shared/plans/PLAN_NAME.md

Or I can implement the plan in this session if you prefer.
```

Wait for user confirmation or feedback.

# Step 6: Implementation Options

After creating the worktree, the user can either:

**Option A: Implement in current session**
- Use `/implement_plan thoughts/shared/plans/PLAN_NAME.md` to start implementation
- Changes will be made in the worktree directory

**Option B: Start a new session in the worktree**
- Navigate to the worktree directory
- Start a fresh Claude Code session
- This keeps the current session's context clean

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
