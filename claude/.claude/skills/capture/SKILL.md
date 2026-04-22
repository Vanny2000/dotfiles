---
name: capture
description: "Captures findings, insights, code snippets, solutions, and learnings from a Claude Code session into the user's Obsidian vault at ~/notes/The Brain/. Use whenever the user wants to save something they discovered — phrases like 'save this to obsidian', 'capture this', 'note this down', 'jot this down', 'remember this for later', or the /capture command. Also trigger when the user asks to document a solution, save a code snippet, or record what they learned during a session — even if they don't say 'obsidian' explicitly."
---

# Capture to Obsidian

Save findings from the current coding session into the Obsidian vault at `~/notes/The Brain/`.

During coding sessions, you discover things worth keeping — a tricky fix, a useful command, an architectural insight, a debugging technique. This skill distills those findings into clean Obsidian notes, auto-categorized and tagged, so they're easy to find later.

## Parsing the command

The user invokes `/capture` with optional arguments. Parse them flexibly:

| Example | Meaning |
|---|---|
| `/capture` | Auto-detect finding + auto-categorize |
| `/capture knowledge/` | Save to `knowledge/` folder |
| `/capture "Docker networking gotcha"` | Use as note title |
| `/capture append to useful_cmds.md` | Append to existing note |
| `/capture knowledge/ "SSH port forwarding"` | Folder + title |
| `/capture the sql query we used to debug orders` | Description of what to capture |

Arguments are positional and flexible — a quoted string is a title, a path ending in `/` is a folder, `append to <file>` means append, and anything else is a description of what to capture.

## Identifying what to capture

Look backwards through the conversation for the most recent substantive finding. This could be:

- A solution to a bug or error the user hit
- A useful command, query, or code snippet
- An insight about how something works ("TIL")
- An architecture decision or pattern
- A configuration trick or setup procedure
- A debugging technique that worked

**Distill it.** The note should read like something the user wrote for their future self — clear, concise, immediately useful when revisited months from now. Strip away the debugging back-and-forth and capture just the finding.

If the user described what to capture (e.g., `/capture the nginx config fix`), use that to locate the specific part of the conversation.

## Auto-categorization

When no folder is specified, choose based on content:

| Content type | Folder | Examples from vault |
|---|---|---|
| General technical tips, CLI commands, how-tos, reusable knowledge | `knowledge/` | `useful_cmds.md`, `laravel_file_permissions.md`, `VPS_SETUP.md` |
| Shoprunback project notes, snippets, setup procedures | `projects/shoprunback/` | `Code snippets.md`, setup guides in `setup/` subfolder |
| Other project-specific docs, architecture, deep guides | `projects/<project-name>/` | `projects/evalley/`, `projects/Logfret_project.md` |
| App or project ideas | `ideas/` | `coffee_corner.md`, `deepfake_video_generator.md` |
| Personal non-technical notes | `personal/` | `routines.md` |
| Daily work logs, standup notes | `dailies/` | `2025-03-27.md` |
| General insights, TILs, anything else | `knowledge/` | (fallback — prefer knowledge over creating new top-level folders) |

## Checking for related notes

Before creating a new file, do a quick search for related notes:

1. Glob the target folder to see what's there
2. Grep for 2-3 key terms from the finding across the vault
3. If a closely related note exists and the new finding naturally extends it (e.g., another useful command that belongs in `useful_cmds.md`), append to it instead of creating a new file
4. If a related note exists but the finding is distinct, create a new file and link to the related note with `[[related-note]]`

Skip the search if the user explicitly said where to put it or what to append to.

## Note format

Use YAML frontmatter consistent with the vault's existing conventions:

```markdown
---
id: kebab-case-identifier
aliases: []
tags:
  - technology-tag
  - type-tag
---

# Note Title

The finding content goes here.

Code blocks use triple backticks with language identifiers:

\```bash
example command
\```
```

### Tags

Generate 2-4 lowercase hyphenated tags based on:
- Technology involved: `docker`, `laravel`, `nginx`, `sql`, `git`
- Type of finding: `debugging`, `configuration`, `snippet`, `til`, `how-to`
- Project context if relevant: `shoprunback`, `logfret`

### File naming

Use the title in kebab-case: `docker-networking-gotcha.md`

If no title was provided, generate a short descriptive one from the content.

## Appending to existing notes

When appending to an existing file:

1. Read the existing file first
2. Add a horizontal rule separator
3. Add a date header: `## Added: YYYY-MM-DD`
4. Add the new content
5. Merge any new tags into the existing YAML frontmatter (don't replace existing tags)

## After writing

Confirm with:
- The file path relative to vault root
- A one-line summary of what was captured
- Any related notes that were linked
