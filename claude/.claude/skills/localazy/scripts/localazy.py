#!/usr/bin/env python3
"""Localazy REST API helper for managing translations.

Auth: the Bearer token is read at runtime from `pass` (default entry
work/srb/credentials/localazy/consumer/token) and is never printed or logged.
Override with LOCALAZY_PASS_ENTRY or --pass-entry.

Common flows:
  localazy.py status                      # per-language coverage table
  localazy.py files                       # list files in the project
  localazy.py untranslated de             # source keys missing a German translation
  localazy.py untranslated de --file file.json > todo.json
  # ...translate the `source_value`s, writing `value` into each item...
  localazy.py push de todo.json --dry-run # inspect the import payload
  localazy.py push de todo.json           # upload the translations

The `untranslated` output and the `push` input share one shape, so a typical
job is: dump untranslated -> fill in `value` for each item -> push.
"""
import argparse
import json
import subprocess
import sys
import urllib.error
import urllib.parse
import urllib.request

BASE_URL = "https://api.localazy.com"
DEFAULT_PASS_ENTRY = "work/srb/credentials/localazy/consumer/token"


def eprint(*a):
    print(*a, file=sys.stderr)


def get_token(pass_entry):
    try:
        out = subprocess.run(
            ["pass", "show", pass_entry],
            capture_output=True, text=True, check=True,
        ).stdout
    except FileNotFoundError:
        eprint("error: `pass` not found on PATH.")
        sys.exit(2)
    except subprocess.CalledProcessError as e:
        eprint("error: could not read token from pass entry '%s'." % pass_entry)
        eprint((e.stderr or "").strip())
        sys.exit(2)
    token = (out.splitlines() or [""])[0].strip()
    if not token:
        eprint("error: pass entry '%s' is empty." % pass_entry)
        sys.exit(2)
    return token


def api(method, path, token, query=None, body=None):
    url = BASE_URL + path
    if query:
        url += "?" + urllib.parse.urlencode(query)
    data = None
    headers = {"Authorization": "Bearer " + token, "Accept": "application/json"}
    if body is not None:
        data = json.dumps(body).encode()
        headers["Content-Type"] = "application/json"
    req = urllib.request.Request(url, data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req) as resp:
            raw = resp.read().decode()
    except urllib.error.HTTPError as e:
        detail = e.read().decode(errors="replace")
        eprint("error: %s %s -> HTTP %s" % (method, path, e.code))
        eprint(detail[:2000])
        sys.exit(1)
    except urllib.error.URLError as e:
        eprint("error: network failure: %s" % e.reason)
        sys.exit(1)
    if not raw:
        return None
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        return raw


# ---- project / language helpers -------------------------------------------

def list_projects(token):
    return api("GET", "/projects", token, query={"languages": "true"})


def resolve_project(token, project_id):
    projects = list_projects(token)
    if project_id:
        for p in projects:
            if p["id"] == project_id:
                return p
        eprint("error: project id '%s' not found for this token." % project_id)
        sys.exit(2)
    if len(projects) == 1:
        return projects[0]
    eprint("error: token can see %d projects; pass --project <id>:" % len(projects))
    for p in projects:
        eprint("  %s  %s" % (p["id"], p.get("name", "")))
    sys.exit(2)


def source_lang_tag(project):
    src_id = project.get("sourceLanguage")
    for lang in project.get("languages", []):
        if lang.get("id") == src_id:
            return lang.get("tag") or lang.get("code")
    return "en"


# ---- key fetching ----------------------------------------------------------

def fetch_keys(token, pid, fid, lang, no_content=False):
    """Return all keys for a file+language, following pagination.

    The API returns ONLY keys that have a value for `lang` (untranslated keys
    are omitted), except for the source language which returns everything.
    """
    keys = []
    query = {"limit": "1000"}
    if no_content:
        query["no_content"] = "true"
    nxt = None
    while True:
        q = dict(query)
        if nxt:
            q["next"] = nxt
        page = api("GET", "/projects/%s/files/%s/keys/%s" % (pid, fid, lang), token, query=q)
        keys.extend(page.get("keys", []))
        nxt = page.get("next")
        if not nxt:
            break
    return keys


def select_files(token, pid, file_name):
    files = api("GET", "/projects/%s/files" % pid, token)
    if file_name:
        files = [f for f in files if f.get("name") == file_name]
        if not files:
            eprint("error: no file named '%s' in project." % file_name)
            sys.exit(2)
    return files


# ---- commands --------------------------------------------------------------

def cmd_projects(args, token):
    projects = list_projects(token)
    print(json.dumps(projects, indent=2, ensure_ascii=False))


def cmd_status(args, token):
    project = resolve_project(token, args.project)
    src_id = project.get("sourceLanguage")
    src_total = next((l.get("active", 0) for l in project["languages"] if l["id"] == src_id), 0)
    rows = []
    for l in project["languages"]:
        if l["id"] == src_id:
            continue
        translated = l.get("translated", 0)
        missing = max(src_total - translated, 0)
        rows.append((l.get("tag") or l.get("code"), l.get("name", ""), translated,
                     src_total, missing, l.get("review", 0), l.get("needImprovement", 0)))
    if args.json:
        print(json.dumps({
            "project": project.get("name"), "id": project["id"],
            "source": source_lang_tag(project), "source_keys": src_total,
            "languages": [
                {"tag": r[0], "name": r[1], "translated": r[2], "source_total": r[3],
                 "missing": r[4], "review": r[5], "need_improvement": r[6]} for r in rows
            ],
        }, indent=2, ensure_ascii=False))
        return
    print("Project: %s (%s)   source=%s, %d source keys\n"
          % (project.get("name"), project["id"], source_lang_tag(project), src_total))
    print("%-8s %-22s %8s %8s %8s %14s" % ("LANG", "NAME", "DONE", "MISSING", "REVIEW", "NEED_IMPROVE"))
    for r in sorted(rows, key=lambda x: -x[4]):
        print("%-8s %-22s %8d %8d %8d %14d" % (r[0], r[1][:22], r[2], r[4], r[5], r[6]))


def cmd_files(args, token):
    project = resolve_project(token, args.project)
    files = api("GET", "/projects/%s/files" % project["id"], token)
    print(json.dumps(files, indent=2, ensure_ascii=False))


def cmd_untranslated(args, token):
    project = resolve_project(token, args.project)
    pid = project["id"]
    src = source_lang_tag(project)
    if args.lang == src:
        eprint("error: '%s' is the source language." % args.lang)
        sys.exit(2)
    files = select_files(token, pid, args.file)
    out = []
    for f in files:
        fid, fname = f["id"], f.get("name")
        src_keys = fetch_keys(token, pid, fid, src)
        tgt_ids = {k["id"] for k in fetch_keys(token, pid, fid, args.lang, no_content=True)}
        for k in src_keys:
            if k["id"] not in tgt_ids:
                out.append({
                    "file": fname,
                    "id": k["id"],
                    "key": k["key"],
                    "source_value": k.get("value"),
                    "value": "",  # fill this in with the translation, then `push`
                })
    if args.count:
        print(len(out))
        return
    print(json.dumps(out, indent=2, ensure_ascii=False))


def cmd_pull(args, token):
    project = resolve_project(token, args.project)
    pid = project["id"]
    files = select_files(token, pid, args.file)
    result = {}
    for f in files:
        keys = fetch_keys(token, pid, f["id"], args.lang)
        nested = {}
        for k in keys:
            _set_nested(nested, k["key"], k.get("value"))
        result[f.get("name")] = nested
    print(json.dumps(result, indent=2, ensure_ascii=False))


def _set_nested(root, path, value):
    node = root
    for seg in path[:-1]:
        nxt = node.get(seg)
        if not isinstance(nxt, dict):
            nxt = {}
            node[seg] = nxt
        node = nxt
    node[path[-1]] = value


def cmd_push(args, token):
    project = resolve_project(token, args.project)
    pid = project["id"]
    with open(args.translations, encoding="utf-8") as fh:
        items = json.load(fh)
    if not isinstance(items, list):
        eprint("error: push input must be a JSON array of {file, key, value} objects.")
        sys.exit(2)
    # group by file, skip blanks
    by_file = {}
    skipped = 0
    for it in items:
        val = it.get("value")
        if val is None or val == "":
            skipped += 1
            continue
        fname = it["file"]
        key = it["key"]
        if isinstance(key, str):
            key = [key]
        by_file.setdefault(fname, []).append((key, val))
    if not by_file:
        eprint("error: nothing to push (all %d items had empty `value`)." % len(items))
        sys.exit(2)
    files_payload = []
    for fname, pairs in by_file.items():
        content = {"type": "json", args.lang: {}}
        for key, val in pairs:
            _set_nested(content[args.lang], key, val)
        files_payload.append({"name": fname, "content": content})
    payload = {
        "importAsNew": False,
        "filterSource": True,
        "forceCurrent": True,
        "forceSource": False,
        "files": files_payload,
    }
    total = sum(len(p) for p in by_file.values())
    eprint("Pushing %d translations for '%s' across %d file(s); skipped %d blank."
           % (total, args.lang, len(by_file), skipped))
    if args.dry_run:
        print(json.dumps(payload, indent=2, ensure_ascii=False))
        eprint("(dry-run: nothing was uploaded)")
        return
    res = api("POST", "/projects/%s/import" % pid, token, body=payload)
    print(json.dumps(res, indent=2, ensure_ascii=False))


def cmd_key_update(args, token):
    project = resolve_project(token, args.project)
    body = {}
    if args.deprecated is not None:
        body["deprecated"] = args.deprecated
    if args.hidden is not None:
        body["hidden"] = args.hidden == "true"
    if args.comment is not None:
        body["comment"] = args.comment
    if args.limit is not None:
        body["limit"] = args.limit
    if not body:
        eprint("error: nothing to update; pass at least one of --deprecated/--hidden/--comment/--limit")
        sys.exit(2)
    res = api("PUT", "/projects/%s/keys/%s" % (project["id"], args.key_id), token, body=body)
    print(json.dumps(res, indent=2, ensure_ascii=False))


def cmd_key_delete(args, token):
    project = resolve_project(token, args.project)
    res = api("DELETE", "/projects/%s/keys/%s" % (project["id"], args.key_id), token)
    print(json.dumps(res, indent=2, ensure_ascii=False))


def cmd_get(args, token):
    path = args.path if args.path.startswith("/") else "/" + args.path
    res = api("GET", path, token)
    print(json.dumps(res, indent=2, ensure_ascii=False) if not isinstance(res, str) else res)


def build_parser():
    p = argparse.ArgumentParser(description="Localazy REST API helper.")
    p.add_argument("--pass-entry", default=DEFAULT_PASS_ENTRY,
                   help="pass entry holding the Bearer token (default: %s)" % DEFAULT_PASS_ENTRY)
    p.add_argument("--project", help="project id (auto-detected if the token sees only one)")
    sub = p.add_subparsers(dest="cmd", required=True)

    sp = sub.add_parser("projects", help="list projects the token can access")
    sp.set_defaults(func=cmd_projects)

    sp = sub.add_parser("status", help="per-language translation coverage")
    sp.add_argument("--json", action="store_true")
    sp.set_defaults(func=cmd_status)

    sp = sub.add_parser("files", help="list files in the project")
    sp.set_defaults(func=cmd_files)

    sp = sub.add_parser("untranslated", help="source keys missing a translation in LANG")
    sp.add_argument("lang")
    sp.add_argument("--file", help="limit to one file by name")
    sp.add_argument("--count", action="store_true", help="print only the number missing")
    sp.set_defaults(func=cmd_untranslated)

    sp = sub.add_parser("pull", help="dump translations for LANG as nested JSON")
    sp.add_argument("lang")
    sp.add_argument("--file")
    sp.set_defaults(func=cmd_pull)

    sp = sub.add_parser("push", help="upload translations from a JSON array of {file,key,value}")
    sp.add_argument("lang")
    sp.add_argument("translations", help="path to the JSON file produced from `untranslated`")
    sp.add_argument("--dry-run", action="store_true", help="print the import payload, upload nothing")
    sp.set_defaults(func=cmd_push)

    sp = sub.add_parser("key-update", help="edit a source key (deprecated/hidden/comment/limit)")
    sp.add_argument("key_id")
    sp.add_argument("--deprecated", type=int)
    sp.add_argument("--hidden", choices=["true", "false"])
    sp.add_argument("--comment")
    sp.add_argument("--limit", type=int)
    sp.set_defaults(func=cmd_key_update)

    sp = sub.add_parser("key-delete", help="delete a source key by id")
    sp.add_argument("key_id")
    sp.set_defaults(func=cmd_key_delete)

    sp = sub.add_parser("get", help="raw authenticated GET of an arbitrary API path")
    sp.add_argument("path", help="e.g. /projects/<id>/files")
    sp.set_defaults(func=cmd_get)
    return p


def main():
    args = build_parser().parse_args()
    token = get_token(args.pass_entry)
    args.func(args, token)


if __name__ == "__main__":
    main()
