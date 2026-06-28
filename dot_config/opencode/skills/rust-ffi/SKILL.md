---
name: rust-ffi
description: Safe Rust FFI design across C boundaries — C-string handling, error representations, and ownership patterns for foreign interop. Use whenever writing or reviewing Rust that crosses an FFI boundary, including extern functions, bindgen output, c_char, CStr/CString, #[repr(C)], or linking C/C++.
---

## Strings

- Accepting C strings: convert `*const c_char` → `&CStr` → `&str`, borrowing rather than copying. Validate UTF-8 explicitly. Keep `unsafe` blocks minimal and document the pointer safety invariants.
- Passing strings out: use `CString`/`CStr` and keep the owned `CString` alive for the full call. Never pass a pointer to a temporary `CString` that drops immediately. Use `Vec<u8>` when the foreign side may mutate the buffer. Avoid transferring ownership unless required.

## Errors across the boundary

- Keep rich Rust error types internally; expose C-compatible representations outward.
- Flat errors → integer error codes. Structured errors → a code paired with a message. Detailed data → `#[repr(C)]` error structs.

## API shape

- Object-based design: encapsulate internal state in opaque, library-owned types; keep transactional data transparent and user-owned. Expose all behavior as functions on the opaque types.
- Avoid lifetime-based abstractions (iterators, borrowed views) across the boundary — they force provenance tracking the foreign caller cannot uphold. Consolidate related types into a single opaque wrapper that owns its state instead (e.g. fold an iterator into its collection).

## When reviewing FFI

- Every `unsafe` block is minimal, justified, and its preconditions hold.
- No pointers to dropped `CString`/temporaries; owned buffers outlive the call.
- UTF-8 validated at the boundary; pointer invariants documented.
- No Rust lifetimes leak across the boundary; opaque types own their state.
