---
name: localazy
description: >-
  Manage software translations on Localazy via its REST API — check per-language
  coverage, find untranslated keys, machine-translate the missing strings and push
  them back, pull/export translations, and manage source keys (edit, deprecate,
  delete, tag). Use this whenever the user mentions Localazy, localization,
  i18n/l10n, translation keys, untranslated/missing strings, translating an app
  into other languages, or asks you to fill in / sync / review translations for a
  project — even if they don't name Localazy explicitly. The Shoprunback
  "consumer" project lives here.
---

# Localazy translation management

This skill lets you operate on a Localazy project through its REST API. The most
common job is **filling in missing translations**: find the keys that lack a
translation in some language, translate the source text yourself, and push the
results back. You can also pull/export translations and manage source keys.

A bundled helper, `scripts/localazy.py`, wraps auth, pagination, the
untranslated-key diff, and nested-JSON reconstruction so you don't reinvent them
each time. Prefer it over hand-rolled `curl`. Run `python3 scripts/localazy.py
-h` (or `<cmd> -h`) to see every command.

## Authentication

The API uses a Bearer token. The helper reads it at runtime from `pass`:

```
pass show work/srb/credentials/localazy/consumer/token
```

**Never print, echo, or paste the token into a command line, log, or file.** The
helper keeps it in memory only. The same pass folder also holds `read_key` and
`write_key` — those are for the Localazy *CLI* (`localazy.json`), not the REST
API, so ignore them unless the user specifically wants the CLI.

The token is a **project token** scoped to one project ("consumer"), so the
helper auto-detects the project id. If a token ever sees multiple projects, pass
`--project <id>`.

## The mental model

A Localazy project has **files** (e.g. `file.json`, `exceptions.json`), each a
set of **keys**. Every key has a stable `id`, a `key` path (an array of segments
like `["views","customer","first-name"]`), and a `value` per language. English
(`en`) is the source language here.

The detail that makes everything work: requesting keys for a target language
returns **only the keys that have a translation** — untranslated keys are simply
absent. So:

> **untranslated(lang) = { source-language key ids } − { target-language key ids }**

The helper does this diff for you in the `untranslated` command.

## Workflow: fill in missing translations

This is the headline task. Walk it like this:

1. **Survey.** `python3 scripts/localazy.py status` prints a coverage table
   (done / missing / review / need-improvement per language). Use it to decide
   what to work on.

2. **Pull the gaps.** Dump the missing keys for the target language to a file:

   ```
   python3 scripts/localazy.py untranslated de --file file.json > /tmp/de.json
   ```

   Omit `--file` to cover every file. Each item looks like:

   ```json
   { "file": "file.json", "id": "_a…", "key": ["views","customer","first-name"],
     "source_value": "first name", "value": "" }
   ```

3. **Translate.** Fill the `value` of each item with a translation of its
   `source_value`. Edit the JSON in place — keep `file` and `key` untouched;
   they're how the push matches the existing key. Translation guidance:
   - Preserve placeholders and interpolation verbatim — `{name}`, `%s`,
     `:count`, `{{var}}`, `<b>…</b>`, ICU plurals like `{n, plural, …}`. Translate
     the words around them, never the tokens themselves.
   - Match the source's tone and capitalization conventions (the example values
     here are lowercase UI strings — follow what the source does).
   - **Skip keys whose `source_value` is empty** — there's nothing to translate.
     Leave their `value` as `""`; the push ignores blank values.
   - When unsure of domain terms (this is e-commerce / parcel-return UI), check
     the project glossary (`get /projects/<id>/glossary`) and stay consistent
     with translations already present (`pull`).

4. **Preview, then push.**

   ```
   python3 scripts/localazy.py push de /tmp/de.json --dry-run   # inspect payload
   python3 scripts/localazy.py push de /tmp/de.json             # upload
   ```

   Push imports with `filterSource:true, forceCurrent:true, forceSource:false`,
   which adds translations to existing keys and makes them current **without**
   creating new source keys or touching the English source. Blank `value`s are
   skipped and reported.

5. **Confirm.** Re-run `status`; the language's `missing` count should drop.

Pushing writes to a live, shared translation project. For large or unfamiliar
batches, dry-run first and show the user a sample before uploading. Don't push
machine translations the user hasn't agreed to if they asked only for a count or
a review.

## Other operations

- **Pull / export** a language as nested JSON (e.g. to drop into a repo):
  `python3 scripts/localazy.py pull fr --file file.json`
- **List files:** `python3 scripts/localazy.py files`
- **List projects:** `python3 scripts/localazy.py projects`
- **Edit a source key** (deprecate, hide, comment, char-limit):
  `python3 scripts/localazy.py key-update <keyId> --deprecated 0 --comment "…"`
- **Delete a source key:** `python3 scripts/localazy.py key-delete <keyId>`
- **Anything else the API exposes** (glossary, webhooks, screenshots, batch
  tags/priority): use the raw passthrough and the reference below:
  `python3 scripts/localazy.py get /projects/<id>/glossary`

  For writes the helper doesn't wrap, fall back to `curl`, but pull the token via
  command substitution so it never appears literally:

  ```bash
  TOKEN=$(pass show work/srb/credentials/localazy/consumer/token | head -1)
  curl -s -H "Authorization: Bearer $TOKEN" \
    -H 'Content-Type: application/json' \
    "https://api.localazy.com/projects/<id>/keys/tags" -X PUT -d '{…}'
  ```

## Gotchas

- **Quote URLs in zsh.** `?` and `&` are glob/job characters; an unquoted
  `…/projects?languages=true` fails with "no matches found". The helper handles
  this internally; only relevant for ad-hoc `curl`.
- **Locale codes.** The status/`pull`/`untranslated` commands accept the tag form
  shown by `status` (`de`, `fr`, `nl-BE`, `nl-NL`). Use those exact tags.
- **Pagination** is automatic in the helper (1000/page); don't assume a single
  request returns everything if you call the API directly.
- **Endpoint reference:** see `references/api.md` for the full endpoint map,
  payload shapes, and flags when you need something beyond the wrapped commands.
