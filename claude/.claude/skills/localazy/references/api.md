# Localazy REST API reference

Base URL: `https://api.localazy.com`. All paths below are relative to it.
Auth header on every request: `Authorization: Bearer <token>` (project token from
`pass show work/srb/credentials/localazy/consumer/token`).

Official docs: https://localazy.com/docs/api/introduction

## Contents
- Projects
- Files & keys (read / export)
- Import (push source + translations)
- Source keys (edit / delete / tags / priority)
- Glossary, webhooks
- Token types

## Projects

| Method | Path | Notes |
|---|---|---|
| GET | `/projects` | List projects the token can see. Query `?languages=true` adds per-language stats; `?organization=true` adds org info. |
| POST | `/projects` | Create a project. Needs an **organization** token + Manager role. Body: `name`, `sourceLanguage` (required); optional `slug`, `description`, `type`, `tone`, `useShareTM`. |

Per-language stats object (from `languages=true`): `id`, `code`, `tag`, `name`,
`active`, `translated`, `current`, `review`, `needImprovement`, `sourceChanged`,
`enabled`, `published`. The project's `sourceLanguage` field is a language `id`.

## Files & keys (read)

| Method | Path | Notes |
|---|---|---|
| GET | `/projects/{pid}/files` | List files: `[{id, name, type}]`. |
| GET | `/projects/{pid}/files/{fid}/keys/{lang}` | List keys + values for a language. |
| GET | `/projects/{pid}/files/{fid}/download/{lang}` | Export the latest **published** file bundle as a raw file (proper Content-Type/Disposition). |

`keys/{lang}` query params:
- `limit` (max 1000), `next` (pagination cursor; response includes `next` until exhausted)
- `extra_info=true` — adds `hidden`, `limit`, `deprecated`, `comment`
- `no_content=true` — omit `value` (handy when you only need ids, e.g. the diff)
- `deprecated=true` — include deprecated keys
- `unapproved=true` — include unapproved translations

Key object: `{ id, key: [segments…], value, vid, hidden?, limit?, deprecated?, comment? }`.
**Only keys that have a value for `lang` are returned** (the source language
returns all). `untranslated = source ids − target ids` — what the helper's
`untranslated` command computes.

`{lang}` uses the tag form (`ll`, `ll-RR`, `ll-Scrp-RR`) — e.g. `de`, `nl-BE`.

## Import (push source and/or translations)

`POST /projects/{pid}/import` — write access, owner role. Returns
`{ "result": "<batchId>" }`.

```json
{
  "importAsNew": false,
  "filterSource": true,
  "forceCurrent": true,
  "forceSource": false,
  "files": [
    {
      "name": "file.json",
      "path": "",
      "content": {
        "type": "json",
        "de": { "views": { "customer": { "first-name": "vorname" } } }
      }
    }
  ]
}
```

- A file is matched by `name` (+ `path`, `module`, `buildType`, `productFlavors`
  if set). Keys are matched by their nested path within the file.
- To **add translations to existing keys**, send only the target language nested
  under its tag; you do **not** need the source value. Flags: `importAsNew:false`,
  `filterSource:true` (don't re-import source), `forceCurrent:true` (make
  imported translations current), `forceSource:false` (don't overwrite source).
  This is exactly what `localazy.py push` sends.
- To **create new source keys**, include the source language (`en`) content;
  there is no dedicated "create key" endpoint — creation happens via import.
- Nested keys must mirror the source structure (objects within objects).
- `content.type` is the format id (`json`, `android`, …). `GET /import/formats`
  lists supported formats.

## Source keys (modify existing)

| Method | Path | Notes |
|---|---|---|
| PUT | `/projects/{pid}/keys/{keyId}` | Body: `deprecated` (version int, or `-1` to clear), `hidden` (bool), `comment` (str), `limit` (char limit, `-1` to disable). |
| DELETE | `/projects/{pid}/keys/{keyId}` | Returns `{ "result": true }`. |
| PUT | `/projects/{pid}/keys/{keyId}/tags` | Tags on one key. |
| PUT | `/projects/{pid}/keys/tags` | Tags on up to 1000 keys. |
| PUT | `/projects/{pid}/keys/{keyId}/priority` | Priority: `lowest`/`low`/`normal`/`high`/`highest`. |
| PUT | `/projects/{pid}/keys/priority` | Priority on up to 1000 keys. |

`localazy.py key-update` / `key-delete` wrap the single-key PUT/DELETE. For tags
and priority, use `localazy.py get` for reads and `curl` for the PUT writes.

## Glossary & webhooks

| Method | Path |
|---|---|
| GET / POST | `/projects/{pid}/glossary` |
| PUT / DELETE | `/projects/{pid}/glossary/{id}` |
| GET / POST | `/projects/{pid}/webhooks` |

Consult the glossary before translating domain terms to stay consistent.

## Token types

Generated at https://localazy.com/developer/tokens:
- **Project token** — full read+write on one project (what we use).
- **Translation token** — AI-translation endpoint only.
- **Organization token** — by request (team@localazy.com); spans all projects,
  needed to create projects.
