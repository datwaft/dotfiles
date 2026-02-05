---
name: fennel-lang
description: Expert guidance for Fennel code in all forms. Load this skill whenever a task involves reading, writing, debugging, reviewing, translating, or reasoning about Fennel.
license: MIT
---

# Fennel Language

Fennel is a Lisp that compiles to Lua. It preserves Lua runtime semantics while providing Lisp syntax, expression-oriented forms, pattern matching, and macros.

This skill is language-first: prioritize semantics, forms, idioms, and reasoning. Do not assume tooling or project setup unless explicitly requested.

## Use this skill when

- writing, editing, reviewing, or refactoring Fennel code
- translating between Lua and Fennel
- explaining Fennel syntax, forms, macros, or runtime behavior
- debugging compile-time and runtime issues
- evaluating idiomatic quality and semantic correctness

## Non-negotiable Fennel model

- Fennel is fully interoperable with Lua; compiled output should not add runtime overhead.
- Everything is expression-oriented.
- Tables are the core runtime data structure and are mutable.
- `:name` syntax is a string literal, not a keyword type.
- `nil` means absence; setting a table key to `nil` removes that key.
- Prefer `let` and `local` for immutable locals; use `var` only for intentional reassignment.
- `fn` has no arity checks; `lambda` enforces required arguments.
- Operators (`+`, `=`, `and`, etc.) and `..` are special forms, not higher-order functions.
- Operator argument counts are fixed at compile-time.
- Pattern matching is ordered: first matching clause wins.
- In `case`, `?x` means maybe-nil binding and `_x` means ignored binding.
- Sequential patterns are prefix matches; `[]` matches any table.
- `match` auto-pins existing bindings; `case` binds fresh names unless explicitly pinned.
- Native multiple return values are common and affect composition behavior.
- Iterators are foundational (`each`, `for`, `icollect`, `collect`, `accumulate`) rather than seq abstractions.
- Macros are compile-time transformations running in compiler scope, not runtime scope.
- Macro hygiene matters: use gensym (`name#`) for helper locals.
- Modules are plain returned values (usually tables) with explicit exports.

## Coding defaults

- Keep code idiomatic to both Fennel readers and Lua runtime constraints.
- Favor simple, explicit forms over clever macro-heavy abstractions.
- Use `if` for value branches and `when` for side effects.
- Keep `var` lifetimes tight.
- Prefer destructuring where it improves readability.
- Prefer static field/method syntax (`foo.bar`, `foo:bar`) when possible.
- Handle expected failures with `(values nil err)` and `case`/`case-try` patterns.
- Reserve `error`/`assert` for unrecoverable paths or boundary failures.
- Treat `lua` escape hatch as temporary or constrained interop aid.
- Avoid deprecated or legacy compatibility forms in new code.

## Macro defaults

- Write a macro only when syntax transformation is required.
- Design macro expansion first, then macro call shape.
- Prefer quasiquote/unquote templates over manual `list`/`sym` construction.
- Reject malformed macro inputs with `assert-compile` and source-aware forms.
- Avoid caller-scope assumptions; require runtime dependencies inside expansion when needed.

## Clojure-to-Fennel guardrails

- Do not assume `clojure.core` runtime facilities.
- Do not assume dynamic var/binding semantics.
- Do not assume persistent collection semantics or seq-first APIs.
- Translate to iterator-native and table-native patterns.
- Keep module export and visibility model explicit and Lua-friendly.

## Reference map

- Complete language semantics and forms: [reference.md](references/reference.md)
- Style, naming, layout, and module conventions: [style-guide.md](references/style-guide.md)
- Macro authoring, hygiene, AST behavior, and diagnostics: [macro-guide.md](references/macro-guide.md)
- Clojure assumption corrections and translation model: [differences-with-clojure.md](references/differences-with-clojure.md)

## Working approach

- Preserve project conventions when they differ from defaults.
- Avoid broad refactors unless requested.
- Prefer exact semantics over surface-level translation.
- If uncertain about a form or edge case, verify against `references/reference.md` before emitting code.
