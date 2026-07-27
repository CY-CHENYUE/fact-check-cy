#!/usr/bin/env python3
"""Inventory evidence-like tokens in a text or Markdown file.

This script extracts URLs, number-like expressions, and date-like expressions
with line-level context. It does not judge whether any claim is true.
"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Iterable


URL_RE = re.compile(r"https?://[^\s<>\[\]{}\"'，。；]+")
NUMBER_RE = re.compile(
    r"(?<![\w.])"
    r"(?:[$¥￥€£]\s*)?"
    r"[+-]?(?:\d{1,3}(?:,\d{3})+|\d+)(?:\.\d+)?"
    r"\s*(?:%|％|万亿元|亿元|万元|亿美元|万美元|"
    r"百万|千万|十亿|万|亿|千|"
    r"million|billion|trillion|k|m|bn|"
    r"USD|CNY|RMB|EUR|GBP|元|人|次|件|家|个)?"
    r"(?![\w.])",
    re.IGNORECASE,
)
DATE_RE = re.compile(
    r"\b(?:19|20)\d{2}[-/.](?:0?[1-9]|1[0-2])"
    r"(?:[-/.](?:0?[1-9]|[12]\d|3[01]))?\b"
    r"|(?:19|20)\d{2}\s*年\s*(?:0?[1-9]|1[0-2])\s*月"
    r"(?:\s*(?:0?[1-9]|[12]\d|3[01])\s*日)?"
)
STRUCTURAL_NUMBER_RE = re.compile(
    r"^\s*(?:#{1,6}\s*)?(?:Step\s*)?(\d{1,2})(?:[.)、:：]|\s)",
    re.IGNORECASE,
)


def compact_context(line: str, limit: int = 240) -> str:
    context = " ".join(line.strip().split())
    if len(context) <= limit:
        return context
    return context[: limit - 1] + "…"


def is_structural_number(match: re.Match[str], line: str) -> bool:
    marker = STRUCTURAL_NUMBER_RE.match(line)
    if marker is None:
        return False
    return match.start() >= marker.start(1) and match.end() <= marker.end(1)


def collect(
    pattern: re.Pattern[str],
    lines: Iterable[str],
) -> list[dict[str, object]]:
    items: list[dict[str, object]] = []
    seen: set[tuple[int, str]] = set()
    for line_number, line in enumerate(lines, start=1):
        for match in pattern.finditer(line):
            value = match.group(0).rstrip(".,;:!?)]}，。；：！？")
            key = (line_number, value)
            if not value or key in seen:
                continue
            seen.add(key)
            items.append(
                {
                    "value": value,
                    "line": line_number,
                    "context": compact_context(line),
                }
            )
    return items


def collect_numbers(lines: Iterable[str]) -> list[dict[str, object]]:
    items: list[dict[str, object]] = []
    seen: set[tuple[int, str]] = set()
    for line_number, line in enumerate(lines, start=1):
        excluded_spans = [
            match.span()
            for pattern in (URL_RE, DATE_RE)
            for match in pattern.finditer(line)
        ]
        for match in NUMBER_RE.finditer(line):
            if is_structural_number(match, line):
                continue
            if any(
                match.start() < excluded_end and match.end() > excluded_start
                for excluded_start, excluded_end in excluded_spans
            ):
                continue
            value = match.group(0).rstrip(".,;:!?)]}，。；：！？")
            key = (line_number, value)
            if not value or key in seen:
                continue
            seen.add(key)
            items.append(
                {
                    "value": value,
                    "line": line_number,
                    "context": compact_context(line),
                }
            )
    return items


def inventory(path: Path) -> dict[str, object]:
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()
    return {
        "file": str(path.resolve()),
        "line_count": len(lines),
        "urls": collect(URL_RE, lines),
        "numbers": collect_numbers(lines),
        "dates": collect(DATE_RE, lines),
        "note": "Inventory only; no truth or source-support judgment has been made.",
    }


def render_markdown(result: dict[str, object]) -> str:
    sections = [
        "# Evidence inventory",
        "",
        f"- File: `{result['file']}`",
        f"- Lines: {result['line_count']}",
        "- Status: inventory only; not fact-checked",
    ]
    for key, title in (
        ("urls", "URLs"),
        ("numbers", "Number-like expressions"),
        ("dates", "Date-like expressions"),
    ):
        values = result[key]
        assert isinstance(values, list)
        sections.extend(["", f"## {title} ({len(values)})", ""])
        if not values:
            sections.append("_None found._")
            continue
        sections.extend(
            [
                "| Value | Line | Context |",
                "|---|---:|---|",
            ]
        )
        for item in values:
            assert isinstance(item, dict)
            value = str(item["value"]).replace("|", "\\|")
            context = str(item["context"]).replace("|", "\\|")
            sections.append(f"| `{value}` | {item['line']} | {context} |")
    return "\n".join(sections)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Extract URLs, numbers, and dates from a text/Markdown file."
    )
    parser.add_argument("file", type=Path)
    parser.add_argument(
        "--format",
        choices=("json", "markdown"),
        default="json",
        help="Output format (default: json).",
    )
    args = parser.parse_args()

    if not args.file.is_file():
        parser.error(f"not a readable file: {args.file}")

    result = inventory(args.file)
    if args.format == "markdown":
        print(render_markdown(result))
    else:
        print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
