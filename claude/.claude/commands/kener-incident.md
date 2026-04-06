---
allowed-tools: Bash(curl:*), Bash(pass show:*)
argument-hint: <list|create|get|update|resolve|comment> [options]
description: Manage Kener incidents - list, create, update, resolve incidents and add timeline comments.
---

# Kener Incident Management

Manage incidents on the Kener status page.

**Prerequisites:** `KENER_URL` environment variable must be set. The API key is retrieved from `pass` at runtime.

**Base URL:** `$KENER_URL/api/v4/incidents`
**Auth:** Retrieve the key inline: `$(pass show Work/SRB/credentials/kener/api_key)`

Parse `$ARGUMENTS` to determine the action. If no arguments or unclear, list active incidents.

---

## Actions

### `list` (default)
List all incidents. Optionally filter by monitor tag.

```bash
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" "$KENER_URL/api/v4/incidents"
```

Display as table: **ID**, **Title**, **Status**, **Type**, **Started**, **Monitors**

### `create <title>`
Create a new incident. Ask the user for any missing required details:

- **title** (required) — from arguments
- **start_date_time** — default to now (ISO 8601 format)
- **monitors** — ask which monitors are affected and impact level (UP/DOWN/DEGRADED/MAINTENANCE)
- **status** — ask the user (INVESTIGATING, IDENTIFIED, MONITORING, RESOLVED)

```bash
curl -s -X POST -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" \
  -H "Content-Type: application/json" \
  -d '{"title":"...","start_date_time":"...","monitors":[{"monitor_tag":"...","impact":"DOWN"}]}' \
  "$KENER_URL/api/v4/incidents"
```

After creation, show the incident ID and confirm.

### `get <id>`
Fetch a specific incident with its comments.

```bash
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" "$KENER_URL/api/v4/incidents/<id>"
```
```bash
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" "$KENER_URL/api/v4/incidents/<id>/comments"
```

Display incident details and timeline of comments.

### `update <id>`
Update an incident. Ask the user what to change (title, status, end_date_time, monitors).

```bash
curl -s -X PATCH -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" \
  -H "Content-Type: application/json" \
  -d '{"title":"..."}' \
  "$KENER_URL/api/v4/incidents/<id>"
```

### `resolve <id>`
Shortcut to resolve an incident: sets `end_date_time` to now and adds a RESOLVED comment.

1. Update the incident with `end_date_time` set to current time
2. Add a comment with state `RESOLVED` — ask the user for the resolution message

```bash
curl -s -X PATCH -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" \
  -H "Content-Type: application/json" \
  -d '{"end_date_time":"..."}' \
  "$KENER_URL/api/v4/incidents/<id>"
```
```bash
curl -s -X POST -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" \
  -H "Content-Type: application/json" \
  -d '{"comment":"...","state":"RESOLVED"}' \
  "$KENER_URL/api/v4/incidents/<id>/comments"
```

### `comment <id>`
Add a timeline comment to an incident. Ask for:

- **comment** (required) — the update message
- **state** (required) — one of: INVESTIGATING, IDENTIFIED, MONITORING, RESOLVED

```bash
curl -s -X POST -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" \
  -H "Content-Type: application/json" \
  -d '{"comment":"...","state":"..."}' \
  "$KENER_URL/api/v4/incidents/<id>/comments"
```

---

## Error Handling

- If the API returns a 401, tell the user their API key is invalid.
- If 404, tell the user the incident ID was not found.
- For any other error, show the error response message.
