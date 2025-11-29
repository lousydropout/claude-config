---
description: Create Linear ticket and PR for experimental features after implementation
---

# Context

You are working on an experimental feature that was implemented without proper ticketing and PR setup. This workflow helps you retroactively create the necessary Linear ticket and pull request to maintain project tracking and code review standards.

# Objective

Create a Linear ticket documenting what was built, then set up a proper feature branch and pull request for code review.

# Prerequisites

- You must have a git commit containing your experimental feature implementation
- If you haven't committed your changes yet, follow the instructions in `.claude/commands/commit.md` to create a commit first

# Instructions

Follow these steps sequentially to properly track and submit your experimental feature:

## Step 1: Capture the Commit SHA

Run `git log -1 --format=%H` to get the SHA of your most recent commit. Store this value as you'll need it in Step 6.

## Step 2: Create Linear Ticket

Create a Linear ticket that documents what you just implemented:

1. Think deeply about the problem your implementation solves and how it solves it
2. Create a new Linear ticket with the following structure:
   - Title: Concise description of the feature
   - State: Set to "In Dev"
   - Description with these sections:
     - `### Problem to Solve` - Explain the user need or technical gap this addresses
     - `### Proposed Solution` - Describe your implementation approach
3. Use the Linear API or CLI to create the ticket programmatically

## Step 3: Get Branch Name

Fetch the Linear ticket you just created to retrieve the recommended git branch name (typically follows the pattern `PROJECT-###-description`).

## Step 4-7: Create Feature Branch with Your Changes

Execute these git commands sequentially:

```bash
git checkout main
git checkout -b 'BRANCHNAME'  # Use the branch name from Step 3
git cherry-pick 'COMMITHASH'  # Use the SHA from Step 1
git push -u origin 'BRANCHNAME'
```

This creates a clean feature branch from main containing only your experimental feature commit.

## Step 8: Create Pull Request

Run `gh pr create --fill` to create a pull request. This will use your commit message and branch name to auto-populate the PR title and description.

## Step 9: Enhance PR Description

Add a comprehensive PR description that includes:
- Summary of changes and their purpose
- Link to the Linear ticket created in Step 2
- Testing approach or test plan
- Any relevant context for reviewers

# Important Notes

- Execute these steps in order - each step depends on the previous ones
- The cherry-pick approach ensures your feature gets a clean branch from main
- This maintains a proper git history even for experimental work
