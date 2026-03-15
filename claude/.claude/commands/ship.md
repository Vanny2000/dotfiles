---
allowed-tools: Bash(git diff:*), Bash(git diff --cached:*), Bash(git status:*), Bash(git add:*), Bash(git commit:*), Bash(git log:*), Bash(git stash:*), Bash(git reset:*), Bash(git branch:*), Bash(git checkout:*), Bash(git switch:*), Bash(git push:*), Bash(git rev-parse:*), Bash(git remote:*)
argument-hint: [optional: branch name or focus area]
description: Runs atomic-commit to split changes into logical commits, then pushes to the upstream feature branch (never to main/master/production). Creates a feature branch if currently on a protected branch.
---

# Atomic Commit & Push

Split changes into atomic commits, then safely push to an upstream feature branch.

## Phase 1: Atomic commits

Run `/atomic-commit` with any provided $ARGUMENTS to split and commit changes.
If $ARGUMENTS contains a branch name hint (e.g., "feat/new-login"), note it for Phase 2.

## Phase 2: Safe push

After commits are created, push them upstream — but with strict safety rules.

### Step 1: Identify the current branch

```bash
git rev-parse --abbrev-ref HEAD
```

### Step 2: Check if the current branch is protected

The following branches are **protected** and must NEVER be pushed to directly:
- `main`, `master`, `develop`, `development`
- `production`, `prod`, `staging`, `release`
- Any branch matching common protected patterns (e.g., `release/*` is OK to push to, but `release` alone is not)

**If on a protected branch:**
1. Create a new feature branch. Use a descriptive name based on the changes just committed:
   - If $ARGUMENTS contains a branch name, use that
   - Otherwise, derive one from the commit messages (e.g., `feat/add-oauth-refresh`)
   - Format: `<type>/<short-kebab-description>`
2. Switch to the new branch: `git switch -c <branch-name>`

**If already on a feature branch:** proceed directly to pushing.

### Step 3: Ensure remote tracking is set up

Check if the branch has an upstream:
```bash
git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null
```

- If no upstream exists, push with `-u` to set it: `git push -u origin <branch>`
- If upstream exists, push normally: `git push`

### Step 4: Confirm

Output a summary:

```
PUSH SUMMARY
============
Branch: feat/add-oauth-refresh
Remote: origin
Commits pushed: 3
Protected branch check: ✓ passed
```

## Safety rules (non-negotiable)

- **NEVER** push to a protected branch. If in doubt, ask the user.
- **NEVER** use `--force` or `--force-with-lease` unless the user explicitly requests it.
- **NEVER** skip hooks (`--no-verify`).
- **NEVER** include the Co-Author.
- If the push fails (e.g., rejected due to remote changes), report the error and suggest `git pull --rebase` — do NOT force push.
- If there are no commits to push (everything is up to date), say so and stop.
