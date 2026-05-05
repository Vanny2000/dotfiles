---
allowed-tools: Bash(git diff:*), Bash(git diff --cached:*), Bash(git status:*), Bash(git add:*), Bash(git commit:*), Bash(git log:*), Bash(git stash:*), Bash(git reset:*)
argument-hint: [optional: focus area or scope hint]
description: Intelligently splits large staged or unstaged changes into atomic commits, each representing a single logical unit of change with a conventional commit message.
---

# Atomic Commit Splitter

Your task is to analyze all current changes in this repository and split them into the smallest meaningful, atomic commits — where each commit does exactly one logical thing.

## Step 1: Assess the current state

Run `git status` and `git diff HEAD` (or `git diff` + `git diff --cached` if some changes are staged) to get the full picture of all modified, added, and deleted files.

Also run `git log --oneline -5` to understand the recent commit style and conventions used in this project.


## Step 2: Analyze and group changes

Carefully read through ALL the diffs. Group the changes into logical units based on:

- **Feature additions** — new functionality, new files, new endpoints
- **Bug fixes** — corrections to existing behavior  
- **Refactors** — restructuring without behavior change (rename, extract, move)
- **Style / formatting** — whitespace, linting, code style only
- **Tests** — new or updated test files
- **Docs** — README, comments, docstrings, changelogs
- **Config / build** — package.json, CI files, env configs, Makefiles
- **Dependencies** — lockfile updates, new packages added/removed
- **Chores** — generated files, migrations, i18n updates

> Important: A single file can contribute to multiple logical groups. Split it if needed.

## Step 3: Plan the commit sequence

Before making any commits, output a numbered plan like this:

```
PROPOSED COMMIT PLAN
====================
1. [type(scope)]: short description
   Files: file1.ts, file2.ts (lines X–Y in file3.ts)
   Reason: <why these belong together>

2. [type(scope)]: short description
   Files: ...
   Reason: ...
...
```

Order commits so that:
- Foundational changes (types, interfaces, config) come first
- Dependent changes come after what they depend on
- Tests follow the code they test
- Docs/chores come last

## Step 4: Execute the commits

For each commit in the plan:

1. Use `git add <specific files>` or `git add -p` for partial file staging when a file has changes belonging to different commits
2. Verify staged changes with `git diff --cached` before committing
3. DO NOT use `Co-Author-By`
4. Commit using **Conventional Commits** format:
   ```
   <type>(<scope>): <short imperative description>

   <optional body: what changed and why, not how>

   <optional footer: BREAKING CHANGE, Closes #issue>
   ```

**Allowed types:** `feat`, `fix`, `refactor`, `test`, `docs`, `style`, `chore`, `perf`, `build`, `ci`

**Rules for the commit message:**
- Subject line: max 72 chars, imperative mood ("add" not "added"), no period at end
- Body: explain the *why*, not the *what* — the diff already shows the what
- Reference issues if detectable from context (e.g., `Closes #123`)

## Step 5: Confirm and summarize

After all commits are made, run `git log --oneline -20` and output a clean summary table:

```
COMMITS CREATED
===============
<hash>  feat(auth): add OAuth2 token refresh logic
<hash>  test(auth): add unit tests for token refresh
<hash>  refactor(api): extract request validation middleware
<hash>  chore: update eslint config for new rules
```

---

## Additional guidelines

- **Never mix** a bug fix with a refactor in the same commit, even if they touch the same file
- **Never mix** dependency updates with feature code
- **NEVER** include the Co-Author.
- **Skip** committing generated files (e.g., `dist/`, `*.lock`) unless they are the *only* change in a logical unit
- If $ARGUMENTS is provided, treat it as a scope hint or focus area (e.g., "only commit auth-related changes", "scope: payments module")
- If you are unsure whether two changes belong together, **split them** — atomic is better than bundled
- If a change looks like it might be debug/test code that shouldn't be committed (e.g., `console.log`, hardcoded mock data, `TODO: remove this`), flag it and ask before committing
