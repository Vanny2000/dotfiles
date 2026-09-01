---
name: localazy
description: >-
  Manage software translations on Localazy, through both its REST API (check
  per-language coverage, find untranslated keys, translate the missing strings and
  push them back, pull/export translations, manage source keys) and its CLI (sync a
  repo: upload source keys, download regenerated locale files, wire it into CI). Use
  this whenever the user mentions Localazy, localization, i18n/l10n, translation
  keys, untranslated/missing strings, adding a new i18n key to an app, translating
  an app into other languages, or asks you to fill in / sync / review translations
  for a project — even if they don't name Localazy explicitly. The Shoprunback
  "consumer" project lives here.
---

# Localazy translation management

This skill lets you operate on a Localazy project. There are **two interfaces**,
and picking the right one is the first decision:

- **The CLI** (`localazy upload` / `localazy download`) syncs whole *files*
  between a repo and Localazy. Reach for it when the job starts or ends in a
  repo: a developer added a key to the source file, or the repo's locale files
  need refreshing. See *Workflow: sync a repo*.
- **The REST API**, via the bundled `scripts/localazy.py`, operates on
  individual *keys*. Reach for it to inspect coverage, diff what's untranslated,
  push translations you wrote yourself, or edit/deprecate source keys. See
  *Workflow: fill in missing translations*.

They meet in the middle: the CLI gets keys in and files out; the API is how you
see and fix what's in between.

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
helper keeps it in memory only.

The token is a **project token** scoped to one project ("consumer"), so the
helper auto-detects the project id. If a token ever sees multiple projects, pass
`--project <id>`.

The same pass folder also holds `read_key` and `write_key`. Those are the *CLI's*
credentials, not the REST API's — use them only when the repo has no
`localazy.keys.json` of its own, and prefer the keys file (see *Workflow: sync a
repo*) so the CLI picks them up without them ever reaching a command line.

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

## Workflow: sync a repo (the CLI)

The usual repo setup makes **one language file the source of truth** (English,
say `src/plugins/i18n/locales/en.json`) and treats every other locale file as
generated output. So the loop for "I added a new UI string" is:

1. **Add the key to the source file only.** Never hand-write the other locales —
   the next download overwrites them, and the string never reaches Localazy where
   translators can see it.
2. **`localazy upload`** — pushes the source file's keys up.
3. **Check whether it needs you.** Many projects auto-translate new keys on
   arrival, so the work may already be done. Verify before translating by hand:
   `python3 scripts/localazy.py untranslated <lang>` (or `status`). If keys are
   genuinely missing, use the API workflow below to fill them.
4. **`localazy download`** — regenerates every target locale file.
5. **Commit the regenerated files** along with the source-file change.

### Configuration and credentials

The CLI reads `localazy.json` from the project root: an `upload` block (which
file(s) go up, `type`, `excludeKeys`) and a `download` block (`files.output`
pattern, `langAliases`, `excludedLangs`, `includeSourceLang`).

Keep **credentials out of that file**. The CLI automatically reads
`localazy.keys.json` next to it, and those keys win over any in `localazy.json`:

```json
{ "writeKey": "…", "readKey": "…" }
```

So the clean arrangement is: commit a keyless `localazy.json`, gitignore
`localazy.keys.json`, and in CI pass the credentials as flags from masked
variables — `localazy upload -w "$WRITE_KEY"`, `localazy download -r "$READ_KEY"`.
`-k <file>` overrides the keys-file name; `-s`/`--simulate` dry-runs an upload;
`-p key:value` overrides any config option at the command line.

**Never let CI generate its own config.** A pipeline that writes a `localazy.json`
heredoc will drift from the committed one, and the drift is silent: a missing
`langAliases` writes `nl-NL.json` next to the `nl.json` the app actually loads,
a missing `excludeKeys` re-uploads keys the team deliberately excluded. One
committed config, credentials injected separately.

### Which job downloads

A build that only *uploads* ships whatever locale files happen to be committed.
If both a staging and a production pipeline exist, **both should download**, or
staging will show stale (or English) strings that production doesn't. Uploading
from both is harmless — upload doesn't deprecate missing keys by default.

Downloads are complete by construction: **untranslated keys fall back to the
source language**, so a build never ships a blank string. (To opt out and let
untranslated keys be absent, add `filter_untranslated` to the upload `features`
and re-upload the source.)

See `references/cli.md` for the full option map.

## Workflow: fill in missing translations (the API)

When keys exist on Localazy but lack translations — whether you found them via
`status` or arrived here from step 3 of the sync loop — walk it like this:

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
- **Two sets of credentials.** The `pass` folder holds a REST `token` *and* the
  CLI's `read_key` / `write_key`. The token drives `scripts/localazy.py`; the keys
  drive `localazy upload` / `download`. They are not interchangeable.
- **`upload` reporting "0 added" is not proof of failure.** Confirm what actually
  landed by reading the key back — `pull <source-lang>` — rather than trusting the
  summary line or a `status` key count, which can lag an import.
- **The repo's locale files are generated.** Editing a non-source locale file by
  hand is nearly always a mistake; the fix is to change the source file and run
  the sync loop.
- **Reference:** `references/api.md` for the REST endpoint map, payload shapes and
  flags; `references/cli.md` for CLI commands and `localazy.json` options.
