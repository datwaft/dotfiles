#!/usr/bin/env python3
"""Detect mechanically observable meaning drift between source and rewrite.

This tool cannot establish semantic equivalence. It identifies high-value
invariants and risk signals that require review.
"""

from __future__ import annotations

import argparse
import json
import re
from collections import Counter
from dataclasses import asdict, dataclass
from pathlib import Path


NUMBER_RE = re.compile(
    r"(?<![A-Za-z0-9])(?:[+-]?\d+(?:[.,]\d+)?(?:\s*(?:-|–|—|to)\s*"
    r"[+-]?\d+(?:[.,]\d+)?)?)(?:\s*(?:%|°[CF]|mm|cm|km|m|in|ft|mg|kg|g|"
    r"mL|L|Pa|kPa|MPa|psi|mV|V|mA|A|Hz|kHz|MHz|N|N[·.]?m|ms|s|min|h))?",
    re.IGNORECASE,
)
QUOTED_RE = re.compile(r'"([^"\n]+)"|`([^`\n]+)`')
IDENTIFIER_RE = re.compile(
    r"\b(?:[A-Za-z]+[-_.][A-Za-z0-9_.-]*\d[A-Za-z0-9_.-]*|"
    r"[A-Za-z]+\d+[A-Za-z0-9_.-]*|\d+[A-Za-z][A-Za-z0-9_.-]*)\b"
)
NEGATION_RE = re.compile(
    r"\b(?:not|no|never|neither|nor|without|unless|except|cannot|can't|don't|"
    r"doesn't|didn't|isn't|aren't|wasn't|weren't|won't|mustn't|shouldn't)\b",
    re.IGNORECASE,
)
CONDITION_RE = re.compile(
    r"\b(?:only if|if|unless|when|whenever|before|after|until|while|during|except)\b",
    re.IGNORECASE,
)
SAFETY_TERMS = {
    "warning", "caution", "danger", "injury", "death", "damage", "fire",
    "flammable", "ignite", "ignition", "explosion", "toxic", "hazard",
}
MODAL_GROUPS = {
    "obligation": re.compile(r"\b(?:must|shall|required)\b", re.IGNORECASE),
    "recommendation": re.compile(r"\b(?:should|recommended)\b", re.IGNORECASE),
    "permission_or_possibility": re.compile(r"\bmay\b", re.IGNORECASE),
    "ability_or_possibility": re.compile(r"\bcan\b", re.IGNORECASE),
    "uncertainty": re.compile(r"\b(?:might|could|possible|possibly|probable|probably)\b", re.IGNORECASE),
    "future_or_expected": re.compile(r"\bwill\b", re.IGNORECASE),
    "attempt": re.compile(r"\b(?:attempt|attempts|attempted|try|tries|tried)\b", re.IGNORECASE),
}


@dataclass(frozen=True)
class Finding:
    severity: str
    code: str
    message: str
    source_values: tuple[str, ...] = ()
    rewrite_values: tuple[str, ...] = ()


def normalized(value: str) -> str:
    return re.sub(r"\s+", " ", value.strip().lower().replace("–", "-").replace("—", "-"))


def extract_counter(pattern: re.Pattern[str], text: str) -> Counter[str]:
    values: list[str] = []
    for match in pattern.finditer(text):
        captured = next((group for group in match.groups() if group is not None), None)
        values.append(normalized(captured if captured is not None else match.group(0)))
    return Counter(values)


def extract_words(text: str) -> set[str]:
    return set(re.findall(r"\b[A-Za-z]+\b", text.lower()))


def differences(source: Counter[str], rewrite: Counter[str]) -> tuple[tuple[str, ...], tuple[str, ...]]:
    missing = tuple(sorted((source - rewrite).elements()))
    added = tuple(sorted((rewrite - source).elements()))
    return missing, added


def compare_counter(
    findings: list[Finding], code: str, label: str, source: Counter[str],
    rewrite: Counter[str], severity: str = "error",
) -> None:
    missing = tuple(sorted(set(source) - set(rewrite)))
    added = tuple(sorted(set(rewrite) - set(source)))
    if missing or added:
        findings.append(Finding(
            severity, code, f"{label} changed; verify every difference.", missing, added
        ))


def check_preservation(source: str, rewrite: str) -> list[Finding]:
    findings: list[Finding] = []
    if not source.strip():
        findings.append(Finding("error", "PRES-SOURCE-EMPTY", "Source text is empty."))
    if not rewrite.strip():
        findings.append(Finding("error", "PRES-REWRITE-EMPTY", "Rewrite is empty."))
        return findings

    source_without_ids = IDENTIFIER_RE.sub(" ", source)
    rewrite_without_ids = IDENTIFIER_RE.sub(" ", rewrite)
    compare_counter(
        findings, "PRES-NUMBER", "Numbers, ranges, or number-unit values",
        extract_counter(NUMBER_RE, source_without_ids),
        extract_counter(NUMBER_RE, rewrite_without_ids),
    )
    compare_counter(
        findings, "PRES-QUOTE", "Quoted or code literals",
        extract_counter(QUOTED_RE, source), extract_counter(QUOTED_RE, rewrite),
    )
    compare_counter(
        findings, "PRES-ID", "Identifiers or acronyms",
        extract_counter(IDENTIFIER_RE, source), extract_counter(IDENTIFIER_RE, rewrite),
    )

    source_negation = extract_counter(NEGATION_RE, source)
    rewrite_negation = extract_counter(NEGATION_RE, rewrite)
    missing_negation, added_negation = differences(source_negation, rewrite_negation)
    if missing_negation or added_negation:
        findings.append(Finding(
            "error", "PRES-NEGATION",
            "Negation or exception signals changed; verify logical polarity and scope.",
            missing_negation, added_negation,
        ))

    source_safety = Counter(extract_words(source) & SAFETY_TERMS)
    rewrite_safety = Counter(extract_words(rewrite) & SAFETY_TERMS)
    compare_counter(
        findings, "PRES-SAFETY", "Safety labels or consequence terms",
        source_safety, rewrite_safety,
    )

    source_conditions = extract_counter(CONDITION_RE, source)
    rewrite_conditions = extract_counter(CONDITION_RE, rewrite)
    missing_conditions, added_conditions = differences(source_conditions, rewrite_conditions)
    if missing_conditions or added_conditions:
        findings.append(Finding(
            "warning", "PRES-CONDITION",
            "Condition or sequence signals changed; verify prerequisites, timing, and exceptions.",
            missing_conditions, added_conditions,
        ))

    for group, pattern in MODAL_GROUPS.items():
        source_count = sum(extract_counter(pattern, source).values())
        rewrite_count = sum(extract_counter(pattern, rewrite).values())
        if source_count != rewrite_count:
            findings.append(Finding(
                "warning", "PRES-MODAL",
                f"The {group} signal count changed from {source_count} to {rewrite_count}; verify force and certainty.",
            ))

    source_word_count = len(re.findall(r"\b\w+\b", source))
    rewrite_word_count = len(re.findall(r"\b\w+\b", rewrite))
    if source_word_count >= 20 and rewrite_word_count < source_word_count * 0.35:
        findings.append(Finding(
            "warning", "PRES-COVERAGE",
            "The rewrite is less than 35% of the source length; perform a proposition-by-proposition coverage check.",
        ))

    return findings


def render_text(source_path: Path, rewrite_path: Path, findings: list[Finding]) -> str:
    errors = sum(item.severity == "error" for item in findings)
    warnings = sum(item.severity == "warning" for item in findings)
    lines = [
        f"Preservation check: {source_path} -> {rewrite_path}",
        f"Findings: {errors} error(s), {warnings} warning(s)",
    ]
    for item in findings:
        lines.append(f"[{item.severity.upper()}] {item.code}: {item.message}")
        if item.source_values:
            lines.append("  Missing or changed from source: " + ", ".join(item.source_values))
        if item.rewrite_values:
            lines.append("  Added or changed in rewrite: " + ", ".join(item.rewrite_values))
    lines.append("Heuristic result only; complete the semantic ledger and manual comparison.")
    return "\n".join(lines)


def should_fail(findings: list[Finding], threshold: str) -> bool:
    if threshold == "never":
        return False
    if threshold == "warning":
        return bool(findings)
    return any(item.severity == "error" for item in findings)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Compare high-value invariants in source and rewritten technical text."
    )
    parser.add_argument("source", type=Path)
    parser.add_argument("rewrite", type=Path)
    parser.add_argument("--format", choices=("text", "json"), default="text")
    parser.add_argument(
        "--fail-on", choices=("error", "warning", "never"), default="error"
    )
    args = parser.parse_args()

    source = args.source.read_text(encoding="utf-8")
    rewrite = args.rewrite.read_text(encoding="utf-8")
    findings = check_preservation(source, rewrite)
    if args.format == "json":
        print(json.dumps({
            "source": str(args.source),
            "rewrite": str(args.rewrite),
            "findings": [asdict(item) for item in findings],
            "disclaimer": "Heuristic result only; semantic equivalence requires manual review.",
        }, indent=2))
    else:
        print(render_text(args.source, args.rewrite, findings))
    return 1 if should_fail(findings, args.fail_on) else 0


if __name__ == "__main__":
    raise SystemExit(main())
