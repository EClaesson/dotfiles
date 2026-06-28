---
name: rust
description: Idiomatic Rust authoring and review — API and error design, ownership idioms, async and trait patterns, design directives, and a review checklist. Use whenever writing, reviewing, refactoring, or critiquing Rust code, even when not explicitly asked to follow idioms.
---

## Workflow

- Verify changes with `cargo clippy -q --message-format short` before claiming done.
- Run `cargo nextest run` and fix unexpected new failures caused by your changes. Do not edit tests without approval.
- Never edit `Cargo.toml`, add dependencies, or install tools without explicit approval.
- Do not write comments, including doc comments.

## API and type design

- Accept borrowed view types in function arguments: `&str` over `&String`, `&[T]` over `&Vec<T>`, `&T` over `&Box<T>`. Take ownership (`String`, `Vec<T>`) only when ownership is actually required.
- For owning collection types, implement `Deref` to the borrowed view (`Vec<T>` → `[T]`, `String` → `str`) so read-only APIs live on the borrowed type.
- Provide constructors as an associated `new`. Derive or implement `Default` whenever a sensible default exists; if `new()` takes no arguments, provide both, even if `new()` just calls `Default::default()`.
- Prefer constructors or builders over public fields for object-like structs. For plain data structs with a sensible `Default`, public fields plus `#[non_exhaustive]` are fine.
- Builders: expose `builder()` on the target type (no public builder constructor), use `self`-taking methods by default, end in `build()`. Use `&mut self` only when conditional construction is needed.
- Use `#[non_exhaustive]` on public structs, enums, or variants you expect to extend later. Use it sparingly — it costs downstream ergonomics.
- When a fallible function takes ownership of an argument, return the original value inside the error so callers can retry without cloning.
- Prefer borrowed trait objects (`&dyn Trait`) over `Box<dyn Trait>` when ownership is not required. Prefer `impl Trait` for single-use type parameters, and always write `MyRef<'_>` rather than eliding the lifetime entirely.
- Keep data stringly-typed only where that is honestly true (e.g. transport headers). Convert to typed representations at the boundary, and promote non-string fields such as timestamps or IDs to typed struct fields rather than smuggling them through a `String` map.
- Naming: meaningful, consistent word order, UK spelling, no needless type names in identifiers. Public names need extra care since they are hard to change. If a good name is hard to find, the API likely needs rethinking.

## Error handling

- Design a concrete, enumerated `Error` type early (e.g. `thiserror`). Avoid type-erased errors (`Box<dyn Error>`, `anyhow`) in libraries — keep errors inspectable. Reserve `anyhow` for binary or handler glue only, never library or domain layers.
- Define one error enum per layer or module boundary (Repository, Service, Api), not per operation — share variants such as `NotFound`, `Database`, `Validation` across operations. Use `#[from]` to derive the conversions `?` needs.
- Convert external errors into the crate's error type at the boundary, as early as possible.
- When an error or result drives downstream branching (retry vs dead-letter), encode the distinction as enum variants (e.g. `RetryableFailure` vs `PermanentFailure`), never a bare success/fail bit.
- Use `?` and `ok_or`/`ok_or_else` over panics. Reserve `.unwrap()`/`.expect()` for cases that can only fail through programmer error (e.g. a static regex) and for tests.
- Panic only for unrecoverable states not caused by user input; prefix internal-fault messages with `internal error:`.
- Error messages: concise, start with a verb (prefer "cannot"), lowercase unless using acronyms or proper names. Use a `source` field for wrapped errors; hide dependency error types behind an `Internal` variant.
- Place `Error`/`Result` in `lib.rs` (libraries, right after `mod`/`use`) or in `error.rs`/`result.rs` at the crate root (binaries).

## Ownership and idioms

- Use `mem::take`/`mem::replace` (or `Option::take()`) to move owned fields through `&mut` instead of cloning. Prefer `take` for `Default` types, `replace` otherwise.
- Use `format!` for string construction from literals and values. For hot incremental building, use a pre-allocated `String` with `push`/`push_str`.
- Treat `Option<T>` as a zero-or-one iterator with `extend`/`chain`; use `std::iter::once` for a guaranteed single element.
- Use RAII (`Drop`) for scope-exit cleanup, including early returns and `?` propagation. Keep `Drop` lightweight and non-panicking, and do not rely on it for cleanup that must be absolutely guaranteed.
- In `move` closures, rebind variables in a tight scope to control move/clone/borrow per capture.
- Use a nested scope or shadowing to make a value immutable after a setup phase. Scope mutable bindings tightly and favor functional style over mutation.
- Match exhaustively on internal structs to force handling of every field. Unpack arguments in the function body, not in the parameter list (closures excepted). Destructure tuples with named bindings rather than `.0`/`.1`.

## Async, traits, and lifecycle

- Fold setup into construction (the constructor returns `Result`) rather than a separate `start()` that leaves the lifecycle unenforced. Provide `async fn shutdown(self)` for async cleanup, since async `Drop` does not exist.
- For runtime-selected (`dyn`) traits with async methods, use `&self`/`&mut self` receivers — a by-value `self` receiver breaks object safety and defeats `dyn`. Box futures or streams (`BoxStream`) where type erasure is needed.
- A `next(&mut self) -> Result<Option<T>>` method is a hand-rolled `Stream`. Prefer implementing `Stream` (e.g. via `async-stream`) for free termination and combinators, unless you specifically need the explicit async shutdown the trait lacks.
- Don't return a reference borrowed from `&self`/`&mut self` from an iterator-style `next()` — it is a lending iterator and cannot refill its backing buffer. Yield owned values (`Bytes`, `Vec<u8>`).
- Signal exhaustion with `Result<Option<T>>` (`None` = done) rather than a separate is-done channel.

## Design directives

- Apply YAGNI. Write what is needed now; Rust's traits, closures, and ownership eliminate many classic patterns, so reach for one only when it earns its place.
- Use the newtype pattern (`Password(String)`) for type safety and encapsulation at zero runtime cost.
- Contain `unsafe` in the smallest module that upholds the invariants and exposes a safe interface. Keep `unsafe` blocks minimal and prefer several small blocks over one large one.
- When the borrow checker blocks simultaneous borrows, decompose a large struct into smaller, independently borrowable structs.
- Use a custom trait with a blanket impl to tame unwieldy bounds (especially `Fn` traits with specific output types).
- Order a file as a tour: most important items first, helpers below. Put each `impl` block immediately after its type; never before it. `mod.rs`/`lib.rs` declare module structure, not definitions.
- Gate conditional compilation at the `mod` declaration (`#[cfg(...)] mod foo;`) rather than repeating the attribute inside the file.

## Anti-patterns

- Don't `.clone()` to satisfy the borrow checker — it masks ownership issues and desynchronizes the copy. Use `Rc`/`Arc` for genuine shared ownership.
- Don't implement `Deref` for inheritance-like method access — it is surprising and is not subtyping. Delegate explicitly or use traits.
- Don't put `#![deny(warnings)]` in the crate root — new lints break builds over time. Deny specific vetted lints, or use `RUSTFLAGS="-D warnings"` in CI.

## When reviewing, check

- Arguments take the broadest borrowed view that works; ownership is taken only when required.
- Errors are enumerated and inspectable, grouped per layer or boundary (not per operation), with `#[from]` conversions; no `unwrap`/`expect` outside tests or programmer-error cases; external errors converted at the boundary.
- Branching outcomes (retry vs dead-letter) are encoded as variants, not a single success/fail bit.
- No `.clone()` papering over borrow-checker friction.
- `new`/`Default` provided where sensible; builders follow the `builder()`/`build()` shape.
- Public API uses `#[non_exhaustive]` where future extension is likely.
- `dyn`-selected async traits use `&self`/`&mut self`; no `next()` returns a reference borrowed from `self`.
- `unsafe` is minimal, contained, and every block's invariants hold.
- Mutability is tightly scoped; functional style preferred over mutation.
- Abstractions earn their place (YAGNI); no speculative generality.
- Naming is meaningful and consistent, UK spelling, no needless type names.
- Changes are surgical and match existing module patterns.
