#!/usr/bin/env python3
"""Local completion backends for the Helix Neovim-compatibility config.

Document text is read from stdin so unsaved Markdown metadata and cross
references participate. Output is a JSON list understood by the generic Steel
completion bridge in evil-helix.
"""

from __future__ import annotations

import argparse
from collections import defaultdict
import json
import os
from pathlib import Path
import re
import shutil
import sqlite3
import sys
from typing import Any


def _clean_bib_field(value: str | None) -> str:
    if not value:
        return ""
    return re.sub(r"\s{2,}", " ", value.replace("\n", " ")).strip()


def _pandoc_items(document: str, cwd: Path) -> list[dict[str, Any]]:
    items: list[dict[str, Any]] = []
    location: str | None = None
    location_pattern = re.compile(
        r'''bibliography\s*[:=(]["'\s]*([\w./\-\\]+)["'\s]*\)?'''
    )
    for line in document.splitlines():
        match = location_pattern.search(line)
        if match:
            location = match.group(1)
            break

    if location:
        bibliography = Path(location).expanduser()
        if not bibliography.is_absolute():
            # cmp-pandoc-references opens relative paths against Neovim's cwd.
            bibliography = cwd / bibliography
        try:
            contents = bibliography.read_text(encoding="utf-8")
        except OSError:
            contents = ""

        # Match the intentionally simple parser used by cmp-pandoc-references.
        for match in re.finditer(r"@.*?\n}\s*(?:\n|$)", contents, re.DOTALL):
            entry = match.group(0)
            if re.match(r"@[Cc]omment\{", entry):
                continue
            key_match = re.match(r"@\w+\{(.*?),", entry)
            if not key_match:
                continue
            title_match = re.search(r'title\s*=\s*["{]*(.*?)["}],?\s*$', entry, re.I | re.M)
            author_match = re.search(r'author\s*=\s*["{]*(.*?)["}],?\s*$', entry, re.I | re.M)
            year_match = re.search(r'year\s*=\s*["{]?(\d+)["}]?,?', entry, re.I)
            title = _clean_bib_field(title_match.group(1) if title_match else "")
            author = _clean_bib_field(author_match.group(1) if author_match else "")
            year = year_match.group(1) if year_match else ""
            label = "@" + key_match.group(1)
            items.append(
                {
                    "label": label,
                    "insert-text": label,
                    "filter-text": label,
                    "kind": "reference",
                    "documentation": f"**{title}**\n\n*{author}*\n{year}",
                }
            )

    for match in re.finditer(r"\{#([A-Za-z]+[:\-][\w_-]+)", document):
        label = "@" + match.group(1)
        items.append(
            {
                "label": label,
                "insert-text": label,
                "filter-text": label,
                "kind": "reference",
            }
        )
    for match in re.finditer(r"#\|\s*label:\s*([A-Za-z]+[:\-][\w_-]+)", document):
        label = "@" + match.group(1)
        items.append(
            {
                "label": label,
                "insert-text": label,
                "filter-text": label,
                "kind": "reference",
            }
        )
    return items


_FALLBACK_CREATORS = (
    "editor",
    "seriesEditor",
    "translator",
    "reviewedAuthor",
    "artist",
    "performer",
    "composer",
    "director",
    "podcaster",
    "cartographer",
    "programmer",
    "presenter",
    "interviewee",
    "interviewer",
    "recipient",
    "sponsor",
    "inventor",
)


def _generated_key(entry: dict[str, Any]) -> str:
    creators = entry.get("creators", {})
    names: list[str] = []
    for creator_type in ("author", *_FALLBACK_CREATORS):
        if creators.get(creator_type):
            names = [str(pair[0]) for pair in creators[creator_type]]
            break
    if not names:
        authors = "No_author"
    elif len(names) > 3:
        authors = names[0] + "-etal"
    else:
        authors = "-".join(names)
    year_match = re.match(r"(\d{4})", str(entry.get("date") or entry.get("issueDate") or ""))
    year = year_match.group(1) if year_match else "????"
    # Zotcite removes punctuation from the expanded {Authors}-{Year} template.
    return "".join(character for character in f"{authors}-{year}" if character.isalnum())


def _fixture_entries(path: Path) -> list[dict[str, Any]]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, list):
        raise ValueError("Zotero completion fixture must contain a JSON array")
    return [dict(item) for item in value]


def _database_entries(database: Path) -> list[dict[str, Any]]:
    cache_root = Path(os.environ.get("XDG_CACHE_HOME", "~/.cache")).expanduser() / "helix"
    cache_root.mkdir(parents=True, exist_ok=True)
    cached_database = cache_root / "copy_of_zotero.sqlite"
    try:
        needs_copy = (
            not cached_database.exists()
            or database.stat().st_mtime_ns != cached_database.stat().st_mtime_ns
            or database.stat().st_size != cached_database.stat().st_size
        )
        if needs_copy:
            temporary = cached_database.with_suffix(".sqlite.tmp")
            shutil.copy2(database, temporary)
            os.replace(temporary, cached_database)
    except OSError:
        cached_database = database

    connection = sqlite3.connect(f"file:{cached_database}?mode=ro", uri=True)
    connection.row_factory = sqlite3.Row
    try:
        entries: dict[int, dict[str, Any]] = {}
        for row in connection.execute(
            """
            SELECT items.itemID, items.dateAdded, items.key, itemTypes.typeName
            FROM items JOIN itemTypes USING (itemTypeID)
            """
        ):
            if row["typeName"] in {"attachment", "annotation", "note"}:
                continue
            entries[row["itemID"]] = {
                "zotkey": row["key"],
                "etype": row["typeName"],
                "added": row["dateAdded"],
                "creators": defaultdict(list),
            }

        for row in connection.execute(
            """
            SELECT itemData.itemID, fields.fieldName, itemDataValues.value
            FROM itemData
            JOIN fields USING (fieldID)
            JOIN itemDataValues USING (valueID)
            """
        ):
            if row["itemID"] in entries:
                entries[row["itemID"]][row["fieldName"]] = row["value"]

        for row in connection.execute(
            """
            SELECT itemCreators.itemID, creatorTypes.creatorType,
                   creators.lastName, creators.firstName
            FROM itemCreators
            JOIN creators USING (creatorID)
            JOIN creatorTypes USING (creatorTypeID)
            ORDER BY itemCreators.itemID, itemCreators.orderIndex
            """
        ):
            if row["itemID"] in entries:
                entries[row["itemID"]]["creators"][row["creatorType"]].append(
                    [row["lastName"], row["firstName"]]
                )

        deleted = {row[0] for row in connection.execute("SELECT itemID FROM deletedItems")}
        for item_id in deleted:
            entries.pop(item_id, None)
    finally:
        connection.close()

    result = list(entries.values())
    for entry in result:
        author_pairs = entry["creators"].get("author", [])
        if not author_pairs:
            for creator_type in _FALLBACK_CREATORS:
                if entry["creators"].get(creator_type):
                    author_pairs = entry["creators"][creator_type]
                    break
        entry["alastnm"] = ", ".join(str(pair[0]) for pair in author_pairs)
        year_match = re.match(r"(\d{4})", str(entry.get("date") or entry.get("issueDate") or ""))
        entry["year"] = year_match.group(1) if year_match else "????"
        entry.setdefault("title", "???")
        entry["citekey"] = _generated_key(entry)

    # Match Zotcite's chronological a/b/c suffixes for template duplicates.
    groups: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for entry in result:
        groups[entry["citekey"]].append(entry)
    for duplicates in groups.values():
        if len(duplicates) < 2:
            continue
        duplicates.sort(key=lambda item: str(item.get("added", "")), reverse=True)
        for index, entry in enumerate(duplicates, 1):
            entry["citekey"] += chr(ord("a") + index - 1)
    return result


def _yaml_key_type(document: str) -> str:
    match = re.search(r"^\s*zotcite-key-type:\s*(\S+)\s*$", document, re.M)
    if match and match.group(1) in {"template", "better-bibtex", "zotero"}:
        return match.group(1)
    return "template"


def _zotero_items(document: str, prefix: str) -> list[dict[str, Any]]:
    if any(character.isspace() for character in prefix):
        return []
    fixture = os.environ.get("HELIX_ZOTERO_COMPLETION_FIXTURE")
    if fixture:
        entries = _fixture_entries(Path(fixture))
    else:
        database = Path(
            os.environ.get("HELIX_ZOTERO_DATABASE", "~/Zotero/zotero.sqlite")
        ).expanduser()
        if not database.is_file():
            return []
        entries = _database_entries(database)

    key_type = _yaml_key_type(document)
    needle = prefix.casefold()
    buckets: list[list[dict[str, Any]]] = [[] for _ in range(4)]
    for entry in entries:
        if key_type == "zotero":
            key = str(entry.get("zotkey", ""))
        elif key_type == "better-bibtex":
            key = str(entry.get("citationKey") or entry.get("citekey", ""))
        else:
            key = str(entry.get("citekey") or _generated_key(entry))
        title = str(entry.get("title", "???"))
        key_folded, title_folded = key.casefold(), title.casefold()
        if key_folded.startswith(needle):
            bucket = 0
        elif title_folded.startswith(needle):
            bucket = 1
        elif needle in key_folded:
            bucket = 2
        elif needle in title_folded:
            bucket = 3
        else:
            continue
        copied = dict(entry)
        copied["selected_key"] = key
        buckets[bucket].append(copied)

    output: list[dict[str, Any]] = []
    for bucket in buckets:
        for entry in bucket:
            authors = str(entry.get("alastnm", ""))
            year = str(entry.get("year", "????"))
            title = str(entry.get("title", "???"))
            label = f"{authors} ({year}) {title}"
            if len(label) > 58:
                label = label[:58] + "⋯"
            venue = entry.get("publicationTitle") or entry.get("bookTitle")
            documentation = f"**{title}**"
            if venue:
                documentation += f"\n\n*{venue}*"
            documentation += f"\n\n{authors} ({year})"
            output.append(
                {
                    "label": label,
                    "filter-text": label,
                    "insert-text": entry["selected_key"],
                    "kind": "variable",
                    "documentation": documentation,
                }
            )
    return output


def _rule_candidates(cwd: Path) -> list[dict[str, str]]:
    output: list[dict[str, str]] = []
    for relative in ("scratch/cursor/rules", "scratch/custom_rules"):
        directory = cwd / relative
        for extension in ("*.md", "*.mdc"):
            for path in sorted(directory.glob(extension)):
                try:
                    documentation = "\n".join(
                        path.read_text(encoding="utf-8").splitlines()[:5]
                    )
                except OSError:
                    documentation = ""
                output.append(
                    {
                        "label": "@" + path.stem,
                        "insert-text": "@" + str(path.resolve()),
                        "documentation": documentation,
                    }
                )
    return output


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", choices=("pandoc", "zotero", "rules"))
    parser.add_argument("--cwd", type=Path, default=Path.cwd())
    parser.add_argument("--prefix", default="")
    args = parser.parse_args()
    document = sys.stdin.read()
    try:
        if args.source == "pandoc":
            items = _pandoc_items(document, args.cwd)
        elif args.source == "zotero":
            items = _zotero_items(document, args.prefix)
        else:
            items = _rule_candidates(args.cwd)
        json.dump(items, sys.stdout, ensure_ascii=False)
        return 0
    except Exception as error:
        print(f"completion helper: {type(error).__name__}: {error}", file=sys.stderr)
        json.dump([], sys.stdout)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
