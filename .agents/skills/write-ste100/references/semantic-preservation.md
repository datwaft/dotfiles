# Semantic preservation protocol

Use this protocol before and after every rewrite. These are editorial-integrity
requirements, not ASD-STE100 rule numbers. If a preservation requirement and a
style rule conflict, preserve meaning and disclose the style deviation.

## Contents

- Build the semantic ledger
- Preserve force and uncertainty
- Preserve logic and scope
- Handle ambiguity
- Compare the rewrite
- Common unsafe transformations

## Build the semantic ledger

Before rewriting, record each source proposition in a compact working ledger.
Do not show the ledger unless the user asks for it.

For each proposition, capture:

- **Actor:** Who or what acts, permits, prevents, detects, or receives?
- **Action and object:** What happens to what?
- **Force:** Is it mandatory, recommended, permitted, possible, expected, or
  prohibited?
- **Certainty:** Is it confirmed, probable, possible, conditional, or unknown?
- **Negation:** What must not, cannot, does not, or did not occur?
- **Condition and exception:** What must be true first? What cases are excluded?
- **Scope:** Does the claim apply to all, some, one, only, each, or a named set?
- **Quantity:** Preserve numbers, ranges, limits, tolerances, ratios, units, and
  significant distinctions such as `more than` versus `at least`.
- **Identity:** Preserve part numbers, versions, filenames, UI labels, quoted
  strings, commands, symbols, and cross-references.
- **Time and order:** Preserve before, after, until, while, during, immediately,
  and all step dependencies.
- **Safety effect:** Preserve the stated hazard, exposure, consequence, and
  severity. Do not infer missing consequences.

Assign every proposition a source location. After rewriting, map every ledger
entry to at least one output location.

## Preserve force and uncertainty

Do not flatten modal distinctions merely to simplify grammar:

| Source signal | Preserve as |
|---|---|
| `must`, `shall`, `required` | obligation |
| `must not`, `shall not`, `prohibited` | prohibition |
| `should`, `recommended` | recommendation, not command |
| `may` | permission or possibility; resolve which meaning is intended |
| `can` | ability or possibility; do not convert automatically to permission |
| `will` | future event or stated expected behavior |
| `might`, `could`, `possible` | uncertainty or possibility |
| `usually`, `typically`, `sometimes` | frequency qualifier |
| `attempt`, `try` | attempted action, not guaranteed completion |

An imperative can preserve a source obligation in a procedure when the actor is
the reader. Record that transformation during review. Do not turn a
recommendation or possibility into an imperative.

Preserve uncertainty explicitly. For example:

- Unsafe: `A mismatch may have caused the failure.` → `A mismatch caused the failure.`
- Safe: `A mismatch possibly caused the failure.`
- Better when the source supports it: `The cause is not known. A mismatch is one possible cause.`

## Preserve logic and scope

Treat these distinctions as technical data:

- `and` versus `or`
- inclusive `or` versus exclusive `or`
- `if` versus `only if`
- `unless` versus `if not`
- `before` versus `after`
- `while` versus `then`
- `until` versus `when`
- `more than` versus `at least`
- `less than` versus `no more than`
- `all` versus `each`, `any`, `some`, or `one`
- an exception versus an example

Do not split a sentence in a way that detaches a qualifier from its target.
Repeat the governed noun or condition when necessary.

Preserve referents. Replace an ambiguous pronoun only when the intended noun is
established. If `it`, `they`, `this`, or `that` has two possible referents, do
not guess.

## Handle ambiguity

Use this decision order:

1. Resolve the meaning from explicit source context.
2. Use controlled terminology supplied by the user or governing documentation.
3. Ask one focused clarification question when the answer changes an action,
   actor, threshold, sequence, or risk.
4. If interaction is unavailable, give labeled alternatives that preserve each
   plausible meaning.
5. If alternatives are impractical, retain the source term and mark it as
   unresolved.

Never use “the most common cause,” a new actor, a new diagnostic step, or a new
safety consequence to make ambiguous source text sound complete.

## Compare the rewrite

Complete these passes separately:

1. **Coverage pass:** Map all source propositions to output propositions.
2. **Addition pass:** Identify every output proposition without a source basis.
3. **Force pass:** Compare obligation, permission, recommendation, capability,
   probability, frequency, and uncertainty.
4. **Logic pass:** Compare negation, conjunctions, conditions, exceptions,
   quantifiers, and referents.
5. **Data pass:** Compare numbers, units, tolerances, identifiers, quoted
   literals, and references character-for-character when applicable.
6. **Sequence pass:** Confirm that no action or prerequisite moved.
7. **Safety pass:** Confirm that no hazard, consequence, severity, or protective
   action was added, removed, or weakened.

Use `scripts/preservation_check.py` as an additional deterministic check. Its
result is incomplete by design; finish the human-readable passes above.

## Common unsafe transformations

- Removing `attempt` and thereby turning an attempted action into a guarantee.
- Replacing `should` with an imperative.
- Converting an unknown cause into a definite cause.
- Replacing an inclusive list with only one example.
- Splitting a conditional sentence but omitting the condition from later steps.
- Changing `not more than 5 mm` to `less than 5 mm`.
- Replacing an official long technical noun with a shorter invented term.
- Adding a check, warning, workaround, or causal explanation not present in the
  source.
- Deleting repetitive technical content that intentionally establishes scope.
- Editing a UI label, command, path, identifier, or code sample as prose.
