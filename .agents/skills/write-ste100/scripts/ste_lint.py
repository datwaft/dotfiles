#!/usr/bin/env python3
"""Heuristic ASD-STE100 Issue 9 structural linter.

This tool checks rules that can be approximated without the controlled
dictionary. It does not certify STE compliance.
"""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import asdict, dataclass
from pathlib import Path


WORD_RE = re.compile(r"[A-Za-z0-9]+(?:[-'][A-Za-z0-9]+)*")
LIST_RE = re.compile(r"^\s*(?:(\d+|[A-Z])[.)]|[-+*])\s+")
NUMBERED_STEP_RE = re.compile(r"^\s*(?:\d+|[A-Z])[.)]\s+")
HEADING_RE = re.compile(r"^\s{0,3}#{1,6}\s+")
TABLE_RE = re.compile(r"^\s*\|.*\|\s*$")
FENCE_RE = re.compile(r"^\s*(```|~~~)")
HTML_COMMENT_START_RE = re.compile(r"<!--")
HTML_COMMENT_END_RE = re.compile(r"-->")
URL_RE = re.compile(r"https?://\S+")
INLINE_CODE_RE = re.compile(r"`[^`\n]+`")
DOUBLE_QUOTE_RE = re.compile(r'"[^"\n]+"')
PAREN_RE = re.compile(r"\([^()]*\)")
MEASUREMENT_RE = re.compile(
    r"\b\d+(?:[.,]\d+)?\s*(?:%|°[CF]|mm|cm|km|m|in|ft|mg|kg|g|mL|L|"
    r"Pa|kPa|MPa|psi|mV|V|mA|A|Hz|kHz|MHz|N|N[·.]?m|ms|s|min|h)\b",
    re.IGNORECASE,
)
IDENTIFIER_RE = re.compile(
    r"\b(?:[A-Za-z]+[-_.]?)?\d+(?:[-_.][A-Za-z0-9]+)+\b|"
    r"\b[A-Za-z]+\d+[A-Za-z0-9_.-]*\b"
)
CONTRACTION_RE = re.compile(
    r"\b(?:aren't|can't|couldn't|didn't|doesn't|don't|hadn't|hasn't|haven't|"
    r"isn't|mustn't|shan't|shouldn't|wasn't|weren't|won't|wouldn't|"
    r"I'm|I've|I'll|I'd|you're|you've|you'll|you'd|we're|we've|we'll|we'd|"
    r"they're|they've|they'll|they'd|he's|he'll|he'd|she's|she'll|she'd|"
    r"it's|it'll|it'd|that's|there's|here's|what's|who's|let's)\b",
    re.IGNORECASE,
)
COMPLEX_HAVE_RE = re.compile(
    r"\b(?:have|has|had)\s+(?:not\s+)?(?:been\s+)?[A-Za-z]+(?:ed|en)\b",
    re.IGNORECASE,
)
PROGRESSIVE_RE = re.compile(
    r"\b(?:am|is|are|was|were|be|been|being)\s+(?:not\s+)?[A-Za-z]+ing\b",
    re.IGNORECASE,
)
MODAL_HAVE_RE = re.compile(
    r"\b(?:can|could|may|might|must|shall|should|will|would)\s+have\s+"
    r"[A-Za-z]+(?:ed|en)\b",
    re.IGNORECASE,
)
IRREGULAR_PARTICIPLES = (
    "been|begun|broken|built|bought|caught|chosen|come|done|driven|found|"
    "given|gone|held|kept|known|left|lost|made|put|read|run|seen|sent|set|"
    "shown|shut|spoken|taken|told|written"
)
PASSIVE_RE = re.compile(
    rf"\b(?:am|is|are|was|were|be|been|being)\s+(?:not\s+)?"
    rf"(?:[A-Za-z]+(?:ed|en)|{IRREGULAR_PARTICIPLES})\b",
    re.IGNORECASE,
)
ING_RE = re.compile(r"\b[A-Za-z]{2,}ing\b", re.IGNORECASE)
APPROVED_ING_FORMS = {
    "during", "lighting", "mating", "missing", "opening", "remaining",
    "routing", "servicing", "something", "warning",
}

COMMON_IMPERATIVES = {
    "add", "adjust", "apply", "attach", "check", "clean", "close",
    "connect", "continue", "disconnect", "do", "drain", "examine",
    "fill", "find", "get", "hold", "install", "keep", "make", "measure",
    "move", "open", "operate", "push", "record", "remove", "replace",
    "set", "start", "stop", "tighten", "turn", "use", "wait", "write",
}


@dataclass(frozen=True)
class Block:
    line: int
    text: str
    kind: str


@dataclass(frozen=True)
class Finding:
    severity: str
    rule: str
    line: int
    message: str
    excerpt: str


def strip_markdown(text: str) -> str:
    value = URL_RE.sub(" URL ", text)
    value = INLINE_CODE_RE.sub(" QUOTEDTEXT ", value)
    value = re.sub(r"!\[[^]]*]\([^)]*\)", " IMAGE ", value)
    value = re.sub(r"\[([^]]+)]\([^)]*\)", r"\1", value)
    value = re.sub(r"[*_~]", "", value)
    return value.strip()


def prose_blocks(text: str) -> list[Block]:
    blocks: list[Block] = []
    buffered: list[str] = []
    start_line = 1
    kind = "paragraph"
    in_fence = False
    in_comment = False

    def flush() -> None:
        nonlocal buffered
        if buffered:
            cleaned = strip_markdown(" ".join(buffered))
            if cleaned:
                blocks.append(Block(start_line, cleaned, kind))
            buffered = []

    for number, raw in enumerate(text.splitlines(), start=1):
        if FENCE_RE.match(raw):
            flush()
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        if HTML_COMMENT_START_RE.search(raw):
            flush()
            in_comment = True
        if in_comment:
            if HTML_COMMENT_END_RE.search(raw):
                in_comment = False
            continue
        if not raw.strip():
            flush()
            continue
        if HEADING_RE.match(raw) or TABLE_RE.match(raw):
            flush()
            continue

        list_match = LIST_RE.match(raw)
        safety = re.match(r"^\s*>?\s*(WARNING|CAUTION|DANGER|NOTICE):", raw,
                          re.IGNORECASE)
        if list_match or safety:
            flush()
            start_line = number
            kind = "safety" if safety else (
                "numbered-step" if NUMBERED_STEP_RE.match(raw) else "list-item"
            )
            buffered = [LIST_RE.sub("", raw, count=1).lstrip("> ")]
            continue

        if not buffered:
            start_line = number
            kind = "paragraph"
        buffered.append(raw.strip())

    flush()
    return blocks


def split_sentences(text: str) -> list[str]:
    if not text.strip():
        return []
    parts: list[str] = []
    start = 0
    for match in re.finditer(r"[.!?]+(?:[\"')\]]+)?(?=\s+|$)", text):
        end = match.end()
        sentence = text[start:end].strip()
        if sentence:
            parts.append(sentence)
        start = end
    tail = text[start:].strip()
    if tail:
        parts.append(tail)
    return parts


def collapse_counted_units(sentence: str) -> str:
    value = sentence
    value = URL_RE.sub(" ONE ", value)
    value = INLINE_CODE_RE.sub(" ONE ", value)
    value = DOUBLE_QUOTE_RE.sub(" ONE ", value)
    previous = None
    while previous != value:
        previous = value
        value = PAREN_RE.sub(" ONE ", value)
    value = MEASUREMENT_RE.sub(" ONE ", value)
    value = IDENTIFIER_RE.sub(" ONE ", value)
    return value


def count_words(sentence: str) -> int:
    return len(WORD_RE.findall(collapse_counted_units(sentence)))


def first_word(text: str) -> str:
    cleaned = re.sub(r"^[^A-Za-z]+", "", text)
    match = re.match(r"[A-Za-z]+", cleaned)
    return match.group(0).lower() if match else ""


def classify(block: Block, mode: str) -> str:
    if mode != "auto":
        return mode
    if block.kind in {"safety", "numbered-step"}:
        return "procedural"
    if first_word(block.text) in COMMON_IMPERATIVES:
        return "procedural"
    return "descriptive"


def add_pattern_findings(
    findings: list[Finding], block: Block, pattern: re.Pattern[str],
    severity: str, rule: str, message: str,
) -> None:
    for match in pattern.finditer(block.text):
        findings.append(
            Finding(severity, rule, block.line, message, match.group(0))
        )


def lint_text(text: str, mode: str = "auto") -> list[Finding]:
    findings: list[Finding] = []
    blocks = prose_blocks(text)
    if not any(block.text.strip() for block in blocks):
        return [Finding("error", "DOC-EMPTY", 1, "No editable prose found.", "")]

    for block in blocks:
        text_type = classify(block, mode)
        limit = 20 if text_type == "procedural" else 25
        length_rule = "5.1" if text_type == "procedural" else "6.3"
        sentences = split_sentences(block.text)

        if text_type == "descriptive" and len(sentences) > 6:
            findings.append(
                Finding(
                    "error", "6.6", block.line,
                    f"Descriptive paragraph has {len(sentences)} sentences; maximum is 6.",
                    block.text[:160],
                )
            )

        for sentence in sentences:
            word_count = count_words(sentence)
            if word_count > limit:
                findings.append(
                    Finding(
                        "error", length_rule, block.line,
                        f"{text_type.title()} sentence has {word_count} words; maximum is {limit}.",
                        sentence[:200],
                    )
                )

        if ";" in block.text:
            findings.append(
                Finding("error", "8.1", block.line, "Semicolons are not permitted.", block.text[:160])
            )
        add_pattern_findings(
            findings, block, CONTRACTION_RE, "error", "4.2",
            "Contractions are not permitted in editable prose.",
        )
        for pattern in (COMPLEX_HAVE_RE, PROGRESSIVE_RE, MODAL_HAVE_RE):
            add_pattern_findings(
                findings, block, pattern, "warning", "3.4",
                "Possible unapproved complex verb construction; review in context.",
            )
        add_pattern_findings(
            findings, block, PASSIVE_RE, "warning", "3.6",
            "Possible passive voice or participial adjective; identify the agent and review.",
        )
        for match in ING_RE.finditer(block.text):
            if match.group(0).lower() not in APPROVED_ING_FORMS:
                findings.append(Finding(
                    "warning", "3.5", block.line,
                    "Review this '-ing' form; it is permitted only in an applicable technical noun.",
                    match.group(0),
                ))
        if re.match(r"^NOTE:", block.text, re.IGNORECASE):
            note_body = block.text.split(":", 1)[1].strip()
            if first_word(note_body) in COMMON_IMPERATIVES:
                findings.append(
                    Finding("error", "5.5", block.line, "A note must not contain an instruction.", block.text[:160])
                )

    return sorted(findings, key=lambda item: (item.line, item.rule, item.message))


def render_text(path: Path, mode: str, findings: list[Finding]) -> str:
    errors = sum(item.severity == "error" for item in findings)
    warnings = sum(item.severity == "warning" for item in findings)
    lines = [
        f"STE structural lint: {path}",
        f"Mode: {mode}",
        f"Findings: {errors} error(s), {warnings} warning(s)",
    ]
    for item in findings:
        lines.append(
            f"[{item.severity.upper()}] rule {item.rule}, line {item.line}: "
            f"{item.message}"
        )
        if item.excerpt:
            lines.append(f"  {item.excerpt}")
    lines.append("Heuristic result only; controlled-dictionary compliance was not checked.")
    return "\n".join(lines)


def should_fail(findings: list[Finding], threshold: str) -> bool:
    if threshold == "never":
        return False
    if threshold == "warning":
        return bool(findings)
    return any(item.severity == "error" for item in findings)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Check deterministic ASD-STE100 Issue 9 structural rules."
    )
    parser.add_argument("path", type=Path, help="UTF-8 text or Markdown file")
    parser.add_argument(
        "--mode", choices=("auto", "procedural", "descriptive"), default="auto"
    )
    parser.add_argument("--format", choices=("text", "json"), default="text")
    parser.add_argument(
        "--fail-on", choices=("error", "warning", "never"), default="error"
    )
    args = parser.parse_args()

    text = args.path.read_text(encoding="utf-8")
    findings = lint_text(text, args.mode)
    if args.format == "json":
        print(json.dumps({
            "path": str(args.path),
            "mode": args.mode,
            "findings": [asdict(item) for item in findings],
            "disclaimer": "Heuristic result only; dictionary compliance was not checked.",
        }, indent=2))
    else:
        print(render_text(args.path, args.mode, findings))
    return 1 if should_fail(findings, args.fail_on) else 0


if __name__ == "__main__":
    raise SystemExit(main())
