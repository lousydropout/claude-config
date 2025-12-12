# Rebase Onto Branch (Safe)

## Description
Safely rebase the current branch onto a target branch, defaulting to the latest remote-tracking branch (`origin/<branch>`). This command prioritizes correctness, intent preservation, and protection against accidental history loss.

---

## Assumptions
- The current branch is the branch to be rebased.
- The target branch refers to `origin/<branch>` unless explicitly stated as “local <branch>”.
- Rebasing rewrites history and must not be performed on shared or protected branches without explicit instruction.

---

## Safety Preconditions (must verify before proceeding)

1. Identify the current branch name.
2. Abort and request confirmation if:
   - The current branch is the same as the target branch.
   - The current branch is a protected or shared branch (e.g. `main`, `develop`, `release/*`).
3. Abort if the working tree is dirty unless explicitly instructed to proceed.
4. If `origin/<branch>` has diverged significantly (e.g. force-push detected), warn the user before proceeding.

---

## Procedure

1. Fetch the latest remote state for the target branch:

   ```bash
   git fetch origin <branch>
````

2. Identify commits on the current branch that are not present in `origin/<branch>` and review them to understand:

   * the intent
   * the primary features or fixes involved

3. Rebase the current branch onto the updated remote-tracking branch:

   ```bash
   git rebase origin/<branch>
   ```

---

## Conflict Resolution Policy

If conflicts occur during the rebase:

* Prefer the current branch’s changes **when they directly support the identified intent or features**.
* Prefer `origin/<branch>` for unrelated changes, refactors, or infrastructure updates.
* If intent is unclear, pause and ask for guidance rather than guessing.

---

## Post-Rebase Guidance

* If the branch has been pushed previously, recommend pushing with:

  ```bash
  git push --force-with-lease
  ```

* Explain that `--force-with-lease` ensures the remote branch has not moved since the last fetch and prevents accidental overwrites of others’ work.

* Never force-push shared or protected branches unless explicitly instructed.

---

## Notes

* Always fetch before rebasing to ensure the rebase is performed against the actual remote history.
* Fetching is safe even if the remote branch was force-pushed; rebasing onto stale refs is not.
* This command should prefer correctness and clarity over speed.
