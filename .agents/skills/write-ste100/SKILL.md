---
name: write-ste100
description: Write, rewrite, and audit technical content using ASD-STE100 Simplified Technical English Issue 9 while preserving technical meaning, uncertainty, conditions, quantities, identifiers, sequence, and safety information. Use when the user explicitly asks for ASD-STE100, STE100, Simplified Technical English, controlled English, an STE compliance audit, or plain technical English based on STE; use for requested STE work on procedures, descriptions, notes, warnings, cautions, manuals, and translation-ready technical content. Supports rules-only rewriting and strict dictionary-verified review.
---

# Write ASD-STE100

Apply ASD-STE100 Issue 9 without inventing compliance or changing technical
meaning. Treat semantic preservation as a prerequisite, not a final polish.

## Select the operating mode

Select one mode before writing:

- **Rules-only mode:** Apply every structural rule and every lexical rule that
  can be verified without the controlled dictionary. Mark the remaining
  dictionary-dependent checks as unverified.
- **Dictionary-verified mode:** Apply the writing rules and verify every lexical
  item against the official Issue 9 dictionary. Use this mode when the user
  requests strict compliance and the official specification is available.

Never call rules-only output “ASD-STE100 compliant.” Never call any output
“certified.” Certification or organizational approval requires a qualified
human and the applicable controlled terminology.

## Load the required guidance

For every rewrite or audit:

1. Read `references/semantic-preservation.md`.
2. Read `references/official-rules.md`.
3. Read `references/checklist.md` before the final response.

Additionally:

- Read `references/dictionary-workflow.md` in dictionary-verified mode or when
  making any claim about an approved word, meaning, form, or part of speech.
- Read `references/safety-instructions.md` for warnings, cautions, hazards, or
  other safety-related content.
- Read `references/examples.md` when an example is useful for ambiguity,
  modality, safety preservation, or dictionary-status reporting.

## Rewrite workflow

1. **Establish the contract.** Identify the requested output, audience, source
   language, governing issue, organizational terminology, and whether the user
   wants a clean rewrite, an audit, or both.
2. **Build a semantic ledger.** Record actors, actions, objects, negation,
   modality, uncertainty, conditions, exceptions, quantities, units,
   tolerances, identifiers, timing, sequence, references, and safety effects.
3. **Resolve ambiguity.** Do not select a meaning that the source does not
   establish. Ask a focused question when the answer changes the technical
   result. If interaction is not possible, retain the ambiguity explicitly or
   give labeled alternatives.
4. **Classify the text.** Mark each passage as procedural, descriptive, a note,
   a safety instruction, quoted text, a label, code, or another protected
   literal. A document can contain more than one class.
5. **Apply the rules.** Use the exact Issue 9 numbering in
   `references/official-rules.md`. Do not replace a word mechanically when the
   sentence requires reconstruction.
6. **Verify the dictionary when required.** Follow
   `references/dictionary-workflow.md`. Record unresolved words instead of
   guessing.
7. **Run deterministic checks when files are available.** Run:

   ```bash
   python3 scripts/ste_lint.py REWRITE --mode auto --format text
   python3 scripts/preservation_check.py SOURCE REWRITE --format text
   ```

   Use `--mode procedural` or `--mode descriptive` when the entire file has one
   text type. Treat script results as evidence for review, not as proof of
   compliance.
8. **Complete the checklist.** Correct each confirmed defect. If a rule
   conflicts with accuracy, preserve accuracy and report the deviation.

## Non-negotiable preservation rules

- Do not add, remove, reorder, strengthen, or weaken technical claims.
- Preserve obligation, permission, ability, recommendation, probability, and
  uncertainty. `Must`, `should`, `may`, `can`, and `will` are not synonyms.
- Preserve all negation, conditions, exceptions, logical relationships,
  quantities, ranges, tolerances, units, identifiers, and sequence constraints.
- Do not infer a hazard, consequence, injury, death, or equipment-damage claim
  that the source does not supply.
- Preserve quoted UI strings, code, commands, filenames, part numbers, labels,
  and contractual text unless the user explicitly authorizes changes.
- Do not silently “correct” technical content. Flag suspected source errors.

## Output contract

Unless the user requests another format, provide:

1. **Rewritten text** — clean copy that is ready to use.
2. **Verification note** — mode, specification issue, dictionary status,
   unresolved ambiguities, and deliberate deviations.

For an audit, add a compact findings table with the official rule number,
source excerpt, finding, and recommended change. Do not bury the usable rewrite
inside a sentence-by-sentence table unless the user asks for that presentation.

Use one of these dictionary-status statements exactly when applicable:

- `ASD-STE100 Issue 9 structural writing rules applied; controlled-dictionary compliance was not verified.`
- `ASD-STE100 Issue 9 writing rules and controlled dictionary checked; no unresolved lexical items remain.`
- `ASD-STE100 Issue 9 writing rules and controlled dictionary checked; unresolved lexical items are listed below.`

## Failure conditions

Stop and explain the limitation when:

- Strict compliance is requested but the official dictionary is unavailable.
- An ambiguity can change an action, threshold, actor, sequence, or safety
  outcome.
- The source omits information required to select a warning or caution level.
- A required technical term conflicts with a writing rule.
- The requested simplification would change the governing legal, contractual,
  safety, or technical meaning.

Offer rules-only output or labeled alternatives when that still helps the user.
