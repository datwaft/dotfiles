# Controlled-dictionary workflow

Use this workflow for dictionary-verified mode and before claiming that any
word is approved. ASD-STE100 has two equal parts: writing rules and the
controlled dictionary. Structural conformance alone is not strict STE.

The authoritative source for this skill is ASD-STE100 Issue 9, dated
2025-01-15: <https://www.asd-ste100.org/assets/files/ASD-STE100_ISSUE9.pdf>.
Do not bundle or reproduce the full dictionary.

## Verification prerequisites

Before a strict lexical audit:

1. Obtain the official specification from ASD or use a user-provided authorized
   copy.
2. Confirm the issue and date.
3. Obtain the applicable organization, program, or project terminology for
   technical nouns and technical verbs.
4. Identify quoted text, proper nouns, identifiers, and other protected
   literals that must remain unchanged.

If the official dictionary is unavailable, switch to rules-only mode. Report
that controlled-dictionary compliance was not verified.

## Classify every lexical item

Classify each content word as one of:

- **Dictionary-approved word:** Verify its part of speech, approved meaning,
  allowed inflections, and restrictions.
- **Technical noun:** Verify that the word belongs to an Issue 9 technical-noun
  category and is the established term for the applicable organization,
  industry, or subject field.
- **Technical verb:** Verify the applicable technical-verb category and the
  governing terminology.
- **Protected literal:** Preserve a quoted label, proper noun, identifier,
  part number, command, code token, or other non-prose literal.
- **Unresolved word:** Do not guess. Reconstruct the sentence, retain the term
  with a finding, or request terminology approval.

A technical noun is not automatically permitted as a verb. A technical verb is
not automatically permitted as a noun.

## Read dictionary entries correctly

In Issue 9 dictionary tables:

- An uppercase entry is approved.
- A lowercase entry is not approved and is followed by an alternative or a
  required sentence reconstruction.
- An approved entry can still have a restricted meaning or part of speech.
- An alternative is contextual guidance, not permission for blind
  word-for-word replacement.

For each proposed word, verify:

1. Exact spelling and part of speech.
2. Approved definition for the intended context.
3. Approved verb or adjective forms.
4. Notes, help categories, and contextual restrictions.
5. Whether a technical-noun or technical-verb exception is valid.

Apply Rule 9.1 when substitution changes grammar or meaning: reconstruct the
sentence with verified words.

## Verified Issue 9 traps

These examples prevent common false mappings. Re-check them when the governing
issue changes.

- `ABOUT` is approved as a preposition meaning “concerned with.” Use
  `APPROXIMATELY` for an approximate quantity. Do not change
  `approximately 3 L` to `about 3 L` in STE.
- `PERSON` means one human being. `PERSONNEL` means persons employed in a group
  or organization. Do not replace one mechanically with the other.
- `MAIN` is generally not approved outside an established technical noun. Use
  the entry’s applicable alternative, commonly `PRIMARY`, when the context
  supports it.
- `TEST` is approved as a noun in the ordinary dictionary use. Write `do a
  test`; use `test` as a verb only when an applicable technical-verb category
  and controlled terminology permit it.
- `FOLLOW` has a restricted approved meaning related to coming or going after.
  Use `OBEY` for instructions when the dictionary and context require it.

## Record the audit

Keep a compact lexical audit containing:

- Specification issue and date.
- Organizational terminology source.
- Every unresolved or project-specific term.
- Every retained protected literal.
- Every approved deviation required for technical accuracy.

In the final verification note, state whether all words were checked and list
unresolved items. Never imply that an automated heuristic performed a complete
dictionary audit.
