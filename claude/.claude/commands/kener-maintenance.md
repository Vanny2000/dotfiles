---
allowed-tools: Bash(curl:*), Bash(pass show:*)
argument-hint: <list|create|get|update|delete|events> [options]
description: Manage Kener maintenance windows - schedule, update, and track maintenance events.
---

# Kener Maintenance Management

Manage scheduled maintenance windows on the Kener status page.

**Prerequisites:** `KENER_URL` environment variable must be set. The API key is retrieved from `pass` at runtime.

**Base URL:** `$KENER_URL/api/v4/maintenances`
**Auth:** Retrieve the key inline: `$(pass show Work/SRB/credentials/kener/api_key)`

Parse `$ARGUMENTS` to determine the action. If no arguments or unclear, list active maintenances.

---

## Actions

### `list` (default)
List maintenances. Optionally filter by status (ACTIVE/INACTIVE) or monitor_tag.

```bash
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" "$KENER_URL/api/v4/maintenances"
```

Display as table: **ID**, **Title**, **Status**, **Start Time**, **Duration**, **Monitors**

### `create <title>`
Create a new maintenance window. Ask the user for details:

- **title** (required) — from arguments
- **start_date_time** (required) — ISO 8601 datetime
- **duration_seconds** (required) — ask for duration in human-friendly format (e.g. "2 hours"), convert to seconds
- **rrule** (required) — recurrence rule. For one-time maintenance, use `FREQ=DAILY;COUNT=1`. Ask the user if this is recurring or one-time.
- **monitors** — ask which monitors are affected and impact level

```bash
curl -s -X POST -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" \
  -H "Content-Type: application/json" \
  -d '{"title":"...","start_date_time":"...","rrule":"FREQ=DAILY;COUNT=1","duration_seconds":3600,"monitors":[{"monitor_tag":"...","impact":"MAINTENANCE"}]}' \
  "$KENER_URL/api/v4/maintenances"
```

### `get <id>`
Fetch a specific maintenance and its upcoming events.

```bash
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" "$KENER_URL/api/v4/maintenances/<id>"
```
```bash
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" "$KENER_URL/api/v4/maintenances/<id>/events"
```

Display maintenance details and list of events with their statuses.

### `update <id>`
Update a maintenance window. Ask the user what to change.

```bash
curl -s -X PATCH -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" \
  -H "Content-Type: application/json" \
  -d '{"title":"..."}' \
  "$KENER_URL/api/v4/maintenances/<id>"
```

### `delete <id>`
Delete a maintenance window. Confirm with the user before deleting.

```bash
curl -s -X DELETE -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" \
  "$KENER_URL/api/v4/maintenances/<id>"
```

### `events [maintenance_id]`
List maintenance events. If a maintenance_id is given, show events for that maintenance. Otherwise show all events.

```bash
# All events
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" "$KENER_URL/api/v4/maintenances/events"

# Events for a specific maintenance
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" "$KENER_URL/api/v4/maintenances/<id>/events"
```

Display as table: **Event ID**, **Maintenance**, **Status**, **Start**, **End**

Event statuses: SCHEDULED, ONGOING, COMPLETED, CANCELLED, READY

---

## Error Handling

- If the API returns a 401, tell the user their API key is invalid.
- If 404, tell the user the maintenance ID was not found.
- For any other error, show the error response message.
