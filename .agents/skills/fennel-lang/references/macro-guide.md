# Fennel Macro Guide

Use this when designing, reviewing, debugging, or teaching macros.

This guide is aimed at expert, production-quality macro design: readable expansions, predictable scope behavior, and good diagnostics.

## Macro mental model

- Macros run at compile-time, not runtime.
- A macro receives Fennel forms as data and returns new Fennel forms.
- Input to a macro is AST data (lists, symbols, tables), not evaluated values.
- The core task is transformation: forms in, forms out.

```fennel
(macro postfix3 [[x1 x2 x3]]
  (list x3 x2 x1))

(postfix3 ("world" "hello" print))
;; expands to: (print "hello" "world")
```

## When to use macros

Use a macro when you need one of these:

- New notation for existing semantics.
- Control over evaluation order or binding shape.
- Body-taking forms that improve readability at call sites.

Prefer functions when plain value-level composition is sufficient.

Good rule: if you can write the desired behavior as a normal function call with clear inputs and outputs, start there.

## Expansion-first workflow

1. Write the target expansion you want callers to get.
2. Write the call-site syntax you want users to type.
3. Confirm the macro adds clarity over direct code.
4. Implement as pure transformation.
5. Inspect with `macrodebug`.
6. Add compile-time assertions for invalid forms.

## Building expansions

You have two construction styles:

- Explicit constructors: `list` and `sym`.
- Quasiquote template style: backtick + comma.

Prefer quasiquote in most macros because it is easier to read and safer with gensym checks.

```fennel
(macro thrice-if [condition result]
  (fn step [i]
    (if (< 0 i)
        `(if ,condition
             (do ,result ,(step (- i 1))))))
  (step 3))
```

### Unquote and multi-values

Unquoting a multi-value expression keeps all values only in tail position of a list.
If unquoted in the middle, only the first value is retained.

```fennel
(macro broken [xs]
  `(do
     ,(unpack xs)
     (print :done)))

(macro fixed [xs]
  `(do
     (do ,(unpack xs))
     (print :done)))
```

## Hygiene and bindings

Hygiene is the main macro safety concern.

- Any local introduced by a macro should generally use gensym (`name#`).
- Do not bind bare identifiers in backtick templates unless explicitly user-visible.
- Never assume caller-local names are free for reuse.

```fennel
;; Good: compiler assigns unique names for helper locals
(macro with-thing [expr & body]
  `(let [value# ,expr]
     ,(unpack body)))
```

Fennel enforces this aggressively when using backtick templates; if you forget gensym, compilation should fail.

### Intentionally visible identifiers

Sometimes the macro must create a local visible to the macro body. In that case, accept the identifier from arguments.

```fennel
(macro with-open2 [[name to-open] & body]
  `(let [,name ,to-open
         value# (do ,(unpack body))]
     (: ,name :close)
     value#))
```

This keeps binding intent explicit at the call site and avoids hidden scope effects.

## Scope and dependency discipline

- Macro expansions must not assume specific locals exist in caller scope.
- If expanded code needs helpers from a module, require them in expansion with gensym locals.
- `require` is cached, so runtime cost is typically a cheap table lookup.

```fennel
(macro call-processor [a b c]
  `(let [m# (require :mymodule)]
     (m#.process (+ ,b ,c) ,a)))
```

Bad pattern:

```fennel
(macro call-processor [a b c]
  `(mymodule.process (+ ,b ,c) ,a))
```

The bad version depends on whatever `mymodule` binding happens to be in caller scope.

## Body-taking macro ergonomics

- Prefer names starting with `with-` or `def` for body-taking macros.
- Accept body forms with `& body` and splice with `,(unpack body)`.
- Keep expansion shape familiar to existing core forms (`let`, `if`, `do`, `case`).

This helps tools and humans infer indentation and behavior.

## Macro modules and reuse

- Use inline `macro`/`macros` for file-local macros.
- Use macro modules plus `import-macros` for reusable macros across files.
- Macro modules run in compiler environment and export macro functions via returned table.

```fennel
;; in my-macros.fnl
(fn when2 [condition body1 & rest-body]
  (assert body1 "expected body")
  `(if ,condition
     (do ,body1 ,(unpack rest-body))))

{: when2}

;; in consumer
(import-macros {: when2} :my-macros)
```

## AST facts and quirks

- Lists are compile-time table structures with list metatable.
- Symbols are compile-time objects, not plain strings.
- Forms often carry source metadata (line/file) useful for errors.
- `nil` appearing in code positions is represented in AST form as a symbol named `nil`, which avoids ambiguous length behavior from nil-gapped tables.

Implication: if you build entirely new tables in macros, diagnostics may degrade unless you preserve source forms where possible.

## Compiler-environment tools (practical map)

Commonly useful helpers while writing macros:

- Constructors: `list`, `sym`, `gensym`
- Predicates: `list?`, `sym?`, `table?`, `sequence?`, `varg?`, `multi-sym?`, `comment?`
- Utilities: `view`, `unpack`, `pack`
- Diagnostics: `assert-compile`
- Macro-only helpers: `in-scope?`, `macroexpand`

Use these to validate shapes early and emit precise compiler errors.

## Diagnostics and debugging

- Use `macrodebug` constantly during authoring.
- Use `assert-compile` for user-facing compile-time errors.
- Pass the relevant form as third arg to `assert-compile` for accurate source location.

```fennel
(macro thrice-if [condition result]
  (assert-compile (list? result) "expected list for result" result)
  (fn step [i]
    (if (< 0 i)
        `(if ,condition (do ,result ,(step (- i 1))))))
  (step 3))
```

## Macro design anti-patterns

- Macros that provide behavior only possible through hidden magic.
- Macros that silently capture or shadow caller bindings.
- Macros that depend on compile-time side effects unrelated to expansion.
- Overusing macros where functions would be simpler.
- Reaching for `eval-compiler` instead of ordinary macro mechanisms.

Good macro practice means preserving lexical clarity, gensyming helper locals, requiring explicit user-visible bindings, avoiding caller-scope assumptions, and rejecting malformed inputs with `assert-compile`.
