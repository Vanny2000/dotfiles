---
allowed-tools: Bash(curl:*), Bash(pass show:*)
argument-hint: <list|get|create|update|data> [options]
description: Manage Kener monitors - list, create, update monitors and view or push monitoring data.
---

# Kener Monitor Management

Manage monitors on the Kener status page.

**Prerequisites:** `KENER_URL` environment variable must be set. The API key is retrieved from `pass` at runtime.

**Base URL:** `$KENER_URL/api/v4/monitors`
**Auth:** Retrieve the key inline: `$(pass show Work/SRB/credentials/kener/api_key)`

Parse `$ARGUMENTS` to determine the action. If no arguments or unclear, list all monitors.

---

## Actions

### `list` (default)
List all monitors. Supports optional filters from arguments: status, category, type, hidden.

```bash
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" "$KENER_URL/api/v4/monitors"
```

Display as table: **Tag**, **Name**, **Status**, **Type**, **Category**, **Hidden**

### `get <tag>`
Get detailed info for a specific monitor.

```bash
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" "$KENER_URL/api/v4/monitors/<tag>"
```

Display all monitor fields in a readable format.

### `create`
Create a new monitor. Ask the user for:

- **tag** (required) — unique identifier, kebab-case
- **name** (required) — display name
- **description** — optional description
- **monitor_type** — type of monitoring (API, Ping, TCP, DNS, SSL, SQL, Heartbeat, GameDig, gRPC)
- **cron** — cron expression for check frequency (e.g. `* * * * *` for every minute)
- **default_status** — UP, DOWN, DEGRADED, MAINTENANCE, or NO_DATA (default: UP)
- **category_name** — optional category grouping
- **type_data** — type-specific config (URL for API, host for Ping, etc.)

```bash
curl -s -X POST -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" \
  -H "Content-Type: application/json" \
  -d '{"tag":"...","name":"...","monitor_type":"...","cron":"* * * * *"}' \
  "$KENER_URL/api/v4/monitors"
```

### `update <tag>`
Update an existing monitor. Ask the user what to change.

```bash
curl -s -X PATCH -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" \
  -H "Content-Type: application/json" \
  -d '{"name":"..."}' \
  "$KENER_URL/api/v4/monitors/<tag>"
```

### `data <tag> [range]`
View or push monitoring data for a monitor.

**View data** (default): Fetch data points for the last hour or a specified range.

```bash
# Last hour (compute start_ts and end_ts as UTC epoch seconds)
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" \
  "$KENER_URL/api/v4/monitors/<tag>/data?start_ts=<start>&end_ts=<end>"
```

Display as table: **Timestamp**, **Status**, **Latency (ms)**

**Push a data point**: If the user wants to push data, ask for:
- **timestamp** — UTC epoch seconds (minute-aligned), default to now
- **status** — UP, DOWN, or DEGRADED
- **latency** — response time in ms

```bash
curl -s -X PATCH -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" \
  -H "Content-Type: application/json" \
  -d '{"status":"UP","latency":150}' \
  "$KENER_URL/api/v4/monitors/<tag>/data/<timestamp>"
```

**Bulk update**: For updating a range, ask for start_ts, end_ts, status, and latency.

```bash
curl -s -X PATCH -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" \
  -H "Content-Type: application/json" \
  -d '{"start_ts":...,"end_ts":...,"status":"UP","latency":100}' \
  "$KENER_URL/api/v4/monitors/<tag>/data"
```

---

## Error Handling

- If the API returns a 401, tell the user their API key is invalid.
- If 404, tell the user the monitor tag was not found.
- For any other error, show the error response message.
