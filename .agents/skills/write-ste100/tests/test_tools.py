from __future__ import annotations

import sys
import unittest
from pathlib import Path


SKILL_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SKILL_ROOT / "scripts"))

from preservation_check import check_preservation  # noqa: E402
from ste_lint import count_words, lint_text  # noqa: E402


class SteLintTests(unittest.TestCase):
    def test_empty_document_fails(self) -> None:
        findings = lint_text("```text\ncode only\n```\n")
        self.assertEqual([item.rule for item in findings], ["DOC-EMPTY"])

    def test_procedural_sentence_limit(self) -> None:
        text = (
            "Remove one two three four five six seven eight nine ten eleven "
            "twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty."
        )
        findings = lint_text(text, "procedural")
        self.assertIn("5.1", {item.rule for item in findings})

    def test_official_count_collapses_parentheses_measurements_and_hyphens(self) -> None:
        sentence = "Install the high-pressure valve (refer to Figure 2) at 10 mm."
        self.assertEqual(count_words(sentence), 7)

    def test_semicolon_and_contraction_fail(self) -> None:
        findings = lint_text("Don't open the valve; stop the pump.", "procedural")
        rules = {item.rule for item in findings}
        self.assertIn("4.2", rules)
        self.assertIn("8.1", rules)

    def test_possible_passive_and_ing_are_review_findings(self) -> None:
        findings = lint_text(
            "The pump is being removed from the aircraft.", "descriptive"
        )
        rules = {item.rule for item in findings}
        self.assertIn("3.4", rules)
        self.assertIn("3.5", rules)

    def test_verified_approved_ing_forms_are_not_flagged(self) -> None:
        findings = lint_text(
            "During servicing, examine the remaining lighting units.", "procedural"
        )
        self.assertNotIn("3.5", {item.rule for item in findings})

    def test_note_instruction_fails(self) -> None:
        findings = lint_text("NOTE: Remove the cap.", "procedural")
        self.assertIn("5.5", {item.rule for item in findings})


class PreservationTests(unittest.TestCase):
    def test_empty_rewrite_fails(self) -> None:
        findings = check_preservation("Install part AB-12.", "")
        self.assertEqual(findings[0].code, "PRES-REWRITE-EMPTY")

    def test_exact_invariants_pass(self) -> None:
        findings = check_preservation(
            'If pressure is more than 10 kPa, do not select "AUTO" on AB-12.',
            'If the pressure is more than 10 kPa, do not select "AUTO" on AB-12.',
        )
        errors = [item for item in findings if item.severity == "error"]
        self.assertEqual(errors, [])

    def test_repeated_identifier_is_not_a_new_identifier(self) -> None:
        findings = check_preservation(
            "Remove panel AB-12.",
            "Remove panel AB-12. Put panel AB-12 on the bench.",
        )
        self.assertNotIn("PRES-ID", {item.code for item in findings})

    def test_changed_measurement_fails(self) -> None:
        findings = check_preservation(
            "Set the pressure to 10 kPa.", "Set the pressure to 12 kPa."
        )
        self.assertIn("PRES-NUMBER", {item.code for item in findings})

    def test_removed_negation_fails(self) -> None:
        findings = check_preservation(
            "Do not open the valve.", "Open the valve."
        )
        self.assertIn("PRES-NEGATION", {item.code for item in findings})

    def test_added_safety_consequence_fails(self) -> None:
        findings = check_preservation(
            "Fuel vapor can ignite.",
            "Fuel vapor can ignite and cause injury or death.",
        )
        self.assertIn("PRES-SAFETY", {item.code for item in findings})

    def test_modal_change_requires_review(self) -> None:
        findings = check_preservation(
            "The operator should stop the pump.", "Stop the pump."
        )
        modal_findings = [item for item in findings if item.code == "PRES-MODAL"]
        self.assertTrue(modal_findings)
        self.assertTrue(all(item.severity == "warning" for item in modal_findings))


if __name__ == "__main__":
    unittest.main()
