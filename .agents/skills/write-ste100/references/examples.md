# Preservation-focused examples

These examples show the workflow. They are not dictionary-verified unless the
example explicitly says so.

## Preserve uncertainty

Source:

> A format mismatch may have caused the failure.

Unsafe rewrite:

> A format mismatch caused the failure.

Rules-only rewrite:

> The cause of the failure is not known. A format mismatch is one possible cause.

The safe version preserves uncertainty instead of converting a hypothesis into
a fact.

## Preserve recommendation force

Source:

> The operator should inspect the seal after the test.

Unsafe rewrite:

> Inspect the seal after the test.

Rules-only rewrite:

> We recommend that the operator examine the seal after the test.

Do not use the final wording in dictionary-verified mode until each lexical
item is checked. The key preservation requirement is that a recommendation
must not become a command.

## Do not invent a safety consequence

Source:

> Fuel vapor can ignite.

Unsafe rewrite:

> WARNING: FUEL VAPOR CAN IGNITE AND CAUSE INJURY OR DEATH.

The source does not state injury or death. Ask for the governing hazard data
before selecting a warning or adding that consequence.

## Preserve attempted behavior

Source:

> The service attempts to send the report three times.

Unsafe rewrite:

> The service sends the report three times.

Rules-only rewrite:

> The service tries to send the report three times.

The unsafe version incorrectly guarantees successful transmission.

## Report dictionary status

When only structural rules were applied, finish with:

> ASD-STE100 Issue 9 structural writing rules applied; controlled-dictionary compliance was not verified.

When the official dictionary was checked, name the issue and list every
unresolved term. Do not use the word `certified`.
