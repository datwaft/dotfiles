# Fennel for Clojure Users (Critical Differences)

Use this as a guardrail when a task starts drifting into Clojure assumptions that do not hold in Fennel.

The fastest way to stay correct is to think in Lua runtime semantics with Lisp syntax, not JVM + `clojure.core` semantics.

## Core mindset shifts

- Fennel is a Lisp syntax/compiler layer over Lua runtime behavior.
- Fennel is smaller than Clojure in language surface and built-in runtime facilities.
- Tables and iterators replace much of what Clojure users expect from persistent collections and seqs.
- Macro power is high, but lexical clarity matters more than abstraction cleverness.

## Runtime and standard library

- Host runtime is Lua, not JVM.
- Fennel functions are plain Lua functions at runtime.
- Fennel modules are plain Lua modules at runtime.
- Fennel does not provide a `clojure.core`-like runtime namespace.
- Most language power comes from forms/macros plus Lua stdlib + libraries.

Practical implication: when you need an operation like `merge`, `keys`, or richer collection helpers, reach for Lua/Fennel libraries rather than expecting core language functions.

## Locals, scope, and rebinding

- Scope is lexical by default.
- Use `let` for scoped immutable locals in a body.
- Use `local` for file/module-scope bindings.
- Use `var` only when mutation is intentionally required.
- There is no Clojure-style dynamic var + `binding` mechanism.

```fennel
(local x 10)
(let [y 32]
  (+ x y))

(var counter 0)
(set counter (+ counter 1))
```

Reloading model differs too: think module-level reloads, not var-level replacement as the primary unit.

## Functions and calling conventions

- `fn` does not enforce arity; missing args become `nil`, extra args are ignored.
- `lambda` enforces required args (except `?arg` names).
- Named `fn` introduces a local binding, so it behaves more like `defn` + local declaration.
- No dedicated `apply` form; unpack arg tables into call position.

```fennel
;; Clojure: (apply add [1 2 3])
(add (table.unpack [1 2 3]))
```

- Hashfn shorthand uses `$1`, `$2`, `$...` (not `%1`, `%2`).
- Hashfn can be written without surrounding list parens for trivial cases.

```fennel
(local pick-third #$3)
(local always-abc #"abc")
```

- Operators (`+`, `=`, `and`, etc.) and `..` are special forms, not first-class functions.
- Their argument count must be fixed at compile-time.

## Tables instead of rich persistent collections

Lua/Fennel has one core data structure: the table.

- Tables can be used in both sequence-like and map-like ways.
- Iteration behavior is chosen by iterator (`ipairs` vs `pairs`), not by collection type.
- Tables are mutable.
- Table equality is identity-based for table values.
- Two equal-looking tables are distinct keys unless they are the same object.

### Keyword differences

- `:name` in Fennel is a string literal syntax, not a distinct keyword type.

### Nil behavior (important)

- `nil` always means absence.
- Setting a key to `nil` removes that key.
- Tables do not store `nil` as a value in-place the way Clojure maps can represent `nil` values.
- In sequence-style tables, assigning `nil` creates holes rather than shifting elements.

```fennel
(set my-map.abc nil) ; remove key
(table.remove my-seq 3) ; shift sequence safely
```

## No dynamic scope, but mutable indirection patterns

Because there is no built-in dynamic var binding, common substitutes are:

- mutable config/context tables
- explicit parameter threading
- narrow `var` rebinding patterns

```fennel
(local dynamic {:foo 32})

(fn bar [x]
  (+ dynamic.foo x))

(set dynamic.foo 17)
```

This is explicit but permanent until reset; it is not scope-delimited like Clojure `binding`.

## Iterators instead of seqs

Clojure's "everything is a seq" mental model does not transfer directly.

- In Fennel/Lua, iterator protocols are central.
- `each` is the general iterator consumer.
- `for` is numeric range iteration.
- `icollect` and `collect` are macro-based table builders similar to map/filter/into patterns.

```fennel
(each [k v (pairs {:key "value" :other-key "shiny"})]
  (print k "is" v))

(icollect [_ x (ipairs [1 2 3 4 5 6])]
  (if (= 0 (% x 2)) x)) ; => [2 4 6]

(collect [k v (pairs {:a "x" :b "y"})]
  (values k (.. "prefix:" v)))
```

Notes:

- Returning `nil` in `icollect`/`collect` filters an entry out.
- `icollect` still compacts sequential results; it does not create nil holes for filtered values.
- Custom iterators (`io.lines`, `string.gmatch`, library iterators) work directly with these forms.

## Pattern matching vs Clojure conditional idioms

Fennel has first-class pattern matching in core forms.

- Use `case` for structured matching and destructuring.
- Use `match` when you want implicit pinning of existing names.
- `case` default behavior introduces fresh bindings.
- In `case`, explicit pinning uses `(= name)` inside `where` guards.
- Match order matters: first matching clause wins.
- Sequential patterns are prefix matches; `[]` matches any table.

```fennel
(case (calculate)
  result (print "Got" result)
  _ (print "No result"))
```

This often replaces Clojure `if-let` style code.

## Modules and visibility model

- Fennel modules are plain returned values (usually tables).
- Top-level locals are private unless included in returned export table.
- Export surface is explicit at bottom of file.
- There is no direct equivalent to Clojure namespace vars being public-by-default.

```fennel
(local x 13)

(fn add-x [y]
  (+ x y))

{:add-x add-x}
```

Use `require` to load modules, optionally destructuring fields at binding time.

## Macros and compile-time environment

- Macros are compile-time functions transforming forms.
- Reusable macros are typically loaded with `import-macros` from macro modules.
- Inline `macro` is file-local and does not export runtime values.
- Quasiquote uses backtick; unquote is `,` (not `~`).
- Splicing is done with `,(unpack xs)` patterns.
- Macro code runs in compiler scope, not runtime lexical scope.

```fennel
;; macros.fnl
{:flip (fn [a b] `(values ,b ,a))}

;; usage file
(import-macros {:flip flip} :macros)
(print (flip :abc :def))
```

## Errors and failure signaling

Two common error channels exist:

- `(values nil err)` for expected failures
- `error` + `pcall`/`xpcall` for exception-like flow

```fennel
(case (io.open path)
  (nil msg) (values nil msg)
  fh (read-all fh))
```

Do not assume JVM exception ergonomics, exception hierarchies, or Clojure-style error tooling.

## Additional Clojure-to-Fennel gotchas

- No separate `cond` form needed; `if` supports multiple condition/body pairs.
- Multiple return values are native and can change behavior in call/collection contexts.
- Many "standard" Clojure data and sequence conveniences are library-level in Fennel/Lua.
- `set` mutates vars/table fields; immutable update idioms are possible but not the default runtime cost model.

When translating from Clojure, prioritize Lua runtime assumptions, iterator-native forms, explicit module exports, deliberate `fn` vs `lambda` choice, and compile-time-safe macro hygiene.
