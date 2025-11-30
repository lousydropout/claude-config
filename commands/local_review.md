---
description: Set up worktree for reviewing colleague's branch
---

# Local Review

Your task is to set up a local review environment for a colleague's branch by creating a git worktree, configuring dependencies, and preparing it for development.

## Context for Fresh Sessions

**IMPORTANT**: This command may be run after clearing a session. This section provides essential context.

### Worktree Location

Worktrees are created at: `~/wt/REPO_NAME/SHORT_NAME`

### Key Tools

- **Bash**: Run git commands for remote setup, fetch, and worktree creation

### Related Commands

After setting up the worktree, you can use in the new session:
- `/implement_plan` - If reviewing implementation work
- `/debug` - If investigating issues in the branch

## Context and Purpose

This command streamlines the code review process by creating an isolated workspace. Git worktrees allow you to work with multiple branches simultaneously without disrupting your main working directory. The setup process ensures the new workspace is fully configured and ready for testing or review.

## Implementation Steps

Execute the following steps in sequence. Use parallel tool calls when operations are independent.

### 1. Parse Input Parameters

Extract the GitHub username and branch name from the format: `username:branchname`

If no parameter is provided, ask the user for input in this exact format: `gh_username:branchName`

### 2. Extract Ticket Information

Parse the branch name to find ticket identifiers (patterns like `eng-1696` or `ENG-1696`). This ticket number will be used as the worktree directory name for easy identification.

If no ticket number is found, create a sanitized directory name from the branch name by:
- Converting to lowercase
- Replacing slashes and special characters with hyphens
- Truncating to a reasonable length (e.g., 30 characters)

### 3. Set Up Git Remote and Worktree

Execute these git operations in sequence (they have dependencies):

a. Check if the remote already exists:
   ```
   git remote -v
   ```

b. If the remote doesn't exist, add it (replace REPO_NAME with the actual repository):
   ```
   git remote add USERNAME git@github.com:USERNAME/REPO_NAME
   ```

c. Fetch the remote branch:
   ```
   git fetch USERNAME
   ```

d. Create the worktree with the branch:
   ```
   git worktree add -b BRANCHNAME ~/wt/REPO_NAME/SHORT_NAME USERNAME/BRANCHNAME
   ```

Replace `USERNAME` with the GitHub username, `REPO_NAME` with the repository name, `BRANCHNAME` with the full branch name, and `SHORT_NAME` with the ticket number or sanitized name.

### 4. Configure the Worktree Environment

Execute these configuration steps in sequence:

a. Copy Claude settings to preserve your configuration (if .claude directory exists):
   ```
   cp .claude/settings.local.json ~/wt/REPO_NAME/SHORT_NAME/.claude/ 2>/dev/null || true
   ```

b. Install dependencies using the project's setup process:
   ```
   # Check for common setup methods and run the appropriate one
   cd ~/wt/REPO_NAME/SHORT_NAME
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

### 5. Report Completion

Provide the user with:
- The absolute path to the new worktree
- A summary of what was set up
- Instructions for accessing the worktree (e.g., `cd ~/wt/REPO_NAME/SHORT_NAME`)

## Error Handling

Handle these specific error scenarios:

**Worktree Already Exists**: If the worktree path already exists, inform the user they need to remove it first with: `git worktree remove ~/wt/REPO_NAME/SHORT_NAME` or `rm -rf ~/wt/REPO_NAME/SHORT_NAME && git worktree prune`

**Remote Fetch Fails**: If fetching fails, verify the GitHub username and repository access. Suggest checking if the user has the correct repository name or if the branch exists.

**Setup Fails**: If `make setup` fails, display the error message but continue to completion. The user can troubleshoot setup issues in the new worktree.

## Example Usage

```
/local_review samdickson22:sam/eng-1696-hotkey-for-yolo-mode
```

This command will:
1. Add 'samdickson22' as a git remote (if not already added)
2. Fetch the branch `sam/eng-1696-hotkey-for-yolo-mode`
3. Create a worktree at `~/wt/<repo-name>/eng-1696`
4. Copy Claude settings to the new worktree (if they exist)
5. Run dependency setup

## Important Notes

- All commands must be executed exactly as specified to ensure proper worktree setup
- The worktree path `~/wt/<repo-name>/` is standardized for consistency across reviews
- Preserve the user's Claude settings by copying `settings.local.json` before running setup
