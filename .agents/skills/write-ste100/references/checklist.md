# Final verification checklist

Complete every applicable gate. A failed gate requires correction, an explicit
deviation, or a focused clarification request.

## 1. Mode and authority

- [ ] The output mode is rules-only or dictionary-verified.
- [ ] The governing specification is ASD-STE100 Issue 9, unless the user named
      another issue.
- [ ] Dictionary-verified mode used the official controlled dictionary.
- [ ] Project terminology was used for technical nouns and technical verbs.
- [ ] The final claim does not exceed the evidence.

## 2. Semantic preservation

- [ ] Every source proposition appears in the output.
- [ ] No output proposition lacks a source basis.
- [ ] Actors, actions, objects, and referents did not change.
- [ ] Obligation, permission, ability, recommendation, probability, frequency,
      and uncertainty did not change.
- [ ] Negation, conditions, exceptions, conjunctions, and quantifier scope did
      not change.
- [ ] Numbers, ranges, limits, tolerances, units, identifiers, and references
      match the source.
- [ ] Timing, prerequisites, and step order match the source.
- [ ] Quoted strings, labels, code, commands, paths, and part numbers remain
      exact unless changes were authorized.
- [ ] Ambiguities were resolved from evidence, clarified, or reported; none
      were guessed.

## 3. Official writing rules

- [ ] Rules 1.1–1.14 were checked to the extent allowed by the selected mode.
- [ ] Multi-word nouns comply with Rules 2.1–2.2.
- [ ] Verb forms, tense, voice, and action wording comply with Rules 3.1–3.7.
- [ ] Sentence structure complies with Rules 4.1–4.5.
- [ ] Procedural text complies with Rules 5.1–5.5.
- [ ] Descriptive text complies with Rules 6.1–6.6.
- [ ] Safety content complies with Rules 7.1–7.3.
- [ ] Punctuation and official word counting comply with Rules 8.1–8.7.
- [ ] Sentence reconstruction, word use, phrasal verbs, and consistency comply
      with Rules 9.1–9.4.
- [ ] Applicable general recommendations GR-1–GR-8 were reviewed.

## 4. Structural limits

- [ ] Every procedural and safety sentence has no more than 20 words.
- [ ] Every descriptive sentence has no more than 25 words.
- [ ] Every procedure sentence contains one instruction, except simultaneous
      actions permitted by Rule 5.2.
- [ ] Every instruction uses the imperative.
- [ ] Every prerequisite condition precedes its command.
- [ ] Every note contains information only.
- [ ] Every descriptive paragraph has one topic and no more than six sentences.
- [ ] Complex content uses a clear vertical list where applicable.
- [ ] No semicolon or contraction remains in editable prose.

## 5. Dictionary gate

In dictionary-verified mode:

- [ ] Every content word was classified.
- [ ] Every dictionary word uses its approved part of speech, meaning, and form.
- [ ] Every technical noun and technical verb has a valid category and
      terminology basis.
- [ ] No alternative was substituted without checking its context.
- [ ] Every unresolved lexical item is listed.

In rules-only mode:

- [ ] The output states that controlled-dictionary compliance was not verified.
- [ ] No individual word is called approved without a dictionary check.

## 6. Safety gate

- [ ] Signal word and severity follow the governing source.
- [ ] Hazard, exposed entity, protective action, timing, consequence, and
      probability match the source.
- [ ] No injury, death, damage, ignition, or other consequence was inferred.
- [ ] No safety instruction was hidden in a note.
- [ ] Any missing information needed for risk classification is reported.

## 7. Tool-assisted checks

- [ ] `ste_lint.py` findings were reviewed, including possible false positives.
- [ ] `preservation_check.py` findings were reviewed.
- [ ] Deterministic success was not treated as proof of semantic or dictionary
      compliance.

## 8. Delivery

- [ ] Clean usable text appears before optional audit detail.
- [ ] The verification note names the mode and dictionary status.
- [ ] Unresolved ambiguities and deliberate deviations are concise and visible.
- [ ] The output does not claim certification.
