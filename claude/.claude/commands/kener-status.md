---
allowed-tools: Bash(curl:*), Bash(pass show:*)
description: Get a quick overview of all Kener monitors, active incidents, and upcoming maintenances.
---

# Kener Status Overview

Fetch and display a consolidated dashboard of the Kener instance.

**Prerequisites:** The environment variable `KENER_URL` (base URL, no trailing slash) must be set. The API key is retrieved from `pass` at runtime.

## Step 1: Validate configuration

Check that `$KENER_URL` is set. If missing, tell the user to configure it in their Claude settings (`settings.json` → `env`) or shell environment, then stop.

## Step 2: Fetch all data

Retrieve the API key and make all three API calls in parallel. Use this pattern for each curl call:

```bash
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" "$KENER_URL/api/v4/monitors"
```

```bash
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" "$KENER_URL/api/v4/incidents"
```

```bash
curl -s -H "Authorization: Bearer $(pass show Work/SRB/credentials/kener/api_key)" "$KENER_URL/api/v4/maintenances?status=ACTIVE"
```

## Step 3: Present the dashboard

Format the results as a clear, scannable summary:

### Monitors
Display a table with columns: **Tag**, **Name**, **Status**, **Type**
- Group by status (DOWN/DEGRADED first, then UP)
- Highlight any monitors that are DOWN or DEGRADED

### Active Incidents
Display a table with columns: **ID**, **Title**, **Status**, **Started**, **Affected Monitors**
- If no active incidents, say "No active incidents"

### Active Maintenances
Display a table with columns: **ID**, **Title**, **Status**, **Start Time**, **Duration**
- If no active maintenances, say "No active maintenances"

### Summary Line
End with a one-line summary, e.g.: "12 monitors (10 UP, 1 DOWN, 1 DEGRADED) · 1 active incident · 0 maintenances"
