# Localazy CLI reference

The CLI syncs *files* between a repo and Localazy — source keys up, translated
locale files down. For key-level work (coverage, diffs, pushing individual
translations) use the REST API instead; see `api.md`.

Install: `npm i -g @localazy/cli` (or `brew install localazy/tap/localazy`).
Official docs: https://localazy.com/docs/cli/the-basics

## Commands

| Command | What it does |
|---|---|
| `localazy upload [<groups>…]` | Send the files matched by the `upload` block to Localazy as source keys. |
| `localazy download [<groups>…]` | Fetch translations and write them through the `download` rules. |
| `localazy status` | Show the project's languages and completion. |
| `localazy check` | Validate `localazy.json` without contacting the server. |

Only the default group runs unless groups are named on the command line.

## Command-line options

| Flag | Meaning |
|---|---|
| `-c, --config <file>` | Use a different config file (default `localazy.json`). |
| `-k, --keys <file>` | Use a different keys file (default `localazy.keys.json`). |
| `-r, --read-key <key>` | Read key on the command line — for CI. |
| `-w, --write-key <key>` | Write key on the command line — for CI. |
| `-d, --working-dir <dir>` | Base directory all paths resolve against. |
| `-s, --simulate` | Upload: collect and validate files, print them, send nothing. |
| `-p, --param <key:value>` | Override any config option, e.g. `-p includeSourceLang:true`. |
| `-b, --branch <branch>` | Operate on a Localazy branch. |
| `-f, --force` | Upload despite validation failure. |
| `-q, --quiet` | Suppress config/file listing. |
| `--project <slug-or-id>` | Only act if the configured project matches — a guard for shared runners. |
| `--async` | Don't wait for server-side processing (skips error reporting). |

## Credentials

Priority: `-r`/`-w` flags → `localazy.keys.json` → keys in `localazy.json`.

```json
{ "writeKey": "…", "readKey": "…" }
```

Commit a keyless `localazy.json`; gitignore `localazy.keys.json`; inject
`-w`/`-r` from masked variables in CI. Write key authorizes upload, read key
authorizes download.

## `localazy.json`

```json
{
  "upload": {
    "type": "json",
    "files": "src/plugins/i18n/locales/en.json",
    "excludeKeys": ["shared.reasons.**"]
  },
  "download": {
    "langAliases": { "nl-NL": "nl" },
    "excludedLangs": ["nl-BE"],
    "includeSourceLang": false,
    "files": {
      "conditions": "equals: ${file}, file.json",
      "output": "src/plugins/i18n/locales/${lang}.json"
    }
  }
}
```

### upload

| Option | Meaning |
|---|---|
| `files` | Path, glob, or array of rules for the source file(s). |
| `type` | Format (`json`, `android`, `strings`, `po`, …). |
| `excludeKeys` / `includeKeys` | Key globs (`shared.reasons.**`) to skip or restrict. |
| `group` | Name a rule so `localazy upload <group>` can target it. |
| `features` | Import features; `filter_untranslated` stops untranslated keys falling back to source on download. |
| `deprecate` | What to do with keys that vanish from the source: `none` (default), `file`, `all`. |

### download

| Option | Meaning |
|---|---|
| `files.output` | Output path pattern. Variables: `${lang}`, `${file}`, `${ext}`, `${dir}`. |
| `files.conditions` | Filter expression, e.g. `equals: ${file}, file.json`. |
| `files.changeExtension` | Rewrite the extension after variables resolve. |
| `files.stop` | Stop processing further rules for a matched file (default `true`). |
| `langAliases` | Rename a locale on the way out, e.g. `"nl-NL": "nl"`. |
| `langExpansions` | Write the same file under extra locale codes. |
| `excludedLangs` | Locales never written. |
| `includeSourceLang` | Write the source language too (default `false`). |
| `metadataFileJson` / `…Js` / `…Ts` | Emit a list of available languages (JS/TS variants include plural rules). |
| `folder` | Base directory for output paths (default `.`). |

`langAliases` and `excludedLangs` are what keep the output filenames matching the
locale names the app actually loads — check them against the app's supported-locale
list before trusting a download.

## Behaviour worth knowing

- **Untranslated keys fall back to the source language** on download, so output
  files are always complete. `filter_untranslated` (upload `features`) opts out.
- **Upload doesn't deprecate** missing keys unless `deprecate` says so, so
  uploading the same source from more than one pipeline is safe.
- **New keys may be auto-translated** on arrival if the project has machine
  translation enabled — check `untranslated <lang>` before translating by hand.
- **Download overwrites** every file its rules match. Uncommitted hand edits to
  generated locale files are lost.
