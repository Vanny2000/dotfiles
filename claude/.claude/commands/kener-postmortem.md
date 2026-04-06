---
allowed-tools: Bash(curl:*), Bash(pass show:*), mcp__bookstack__create_page, mcp__bookstack__get_book
argument-hint: <incident_id>
description: Generate a post-mortem from a resolved Kener incident and publish it to BookStack.
---

# Kener Post-Mortem Generator

Generate a structured post-mortem page in BookStack from a resolved Kener incident, then link it back as a comment on the incident.

**Prerequisites:**
- `KENER_URL` environment variable must be set
- Kener API key via `pass show Work/SRB/credentials/kener/api_key`
- BookStack MCP server connected
- Post-Mortems book in BookStack (ID: 12)

---

## Step 1: Fetch incident data

Parse `$ARGUMENTS` to get the incident ID. If no ID provided, list recent incidents and ask which one.

```bash
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" "$KENER_URL/api/v4/incidents/<id>"
```

```bash
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" "$KENER_URL/api/v4/incidents/<id>/comments"
```

Verify the incident exists. If not resolved, warn the user but proceed if they confirm.

## Step 2: Build the post-mortem content

Using the incident data and comments timeline, generate a markdown post-mortem page following this template:

IMPORTANT: Do NOT include an H1 heading in the markdown content — BookStack automatically renders the page name as H1, so adding one creates a duplicate title.

```markdown
**Date:** [incident date, YYYY-MM-DD]<br>
**Duration:** [start_time] - [end_time] UTC ([calculated duration])<br>
**Affected Services:** [list monitor names and impact levels from the incident]<br>
**Incident Lead:** [ask the user]

---

## Summary

[Generate a 2-3 sentence summary from the incident data and comments]

## Timeline

| Time (UTC) | Event |
|------------|-------|
[Build from incident comments — map each comment's timestamp and state to a row]

## Root Cause

[Extract from the IDENTIFIED comment, or ask the user for details]

## Impact

- **Users affected:** [ask the user]
- **Failed requests:** [ask the user]
- **Revenue impact:** [ask the user, or "N/A"]

## Resolution

[Extract from the MONITORING and RESOLVED comments]

## Lessons Learned

### What went well
[Ask the user]

### What went wrong
[Ask the user]


## Action Items

| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
[Ask the user for action items]
```

## Step 3: Ask the user for missing details

Before creating the page, present the draft and ask the user to fill in:
- Incident lead name
- Impact details (users affected, failed requests, revenue impact)
- Lessons learned (what went well, what went wrong, where we got lucky)
- Action items (action, owner, due date)

## Step 4: Create the BookStack page

Use `mcp__bookstack__create_page` to create the post-mortem page in the Post-Mortems book (ID: 12):
- **name**: "Post-Mortem: [incident title]"
- **book_id**: 12
- **markdown**: the completed post-mortem content

## Step 5: Link back to Kener

Add a final comment on the Kener incident linking to the BookStack post-mortem page:

```bash
curl -s -X POST -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" \
  -H "Content-Type: application/json" \
  -d '{"comment":"Post-mortem published: [bookstack_page_url]","state":"RESOLVED"}' \
  "$KENER_URL/api/v4/incidents/<id>/comments"
```

## Step 6: Confirm

Show the user:
- The BookStack page URL
- A summary of the post-mortem content
- Confirmation that the Kener incident was updated with the link
