# Working agreement

- Be direct about tradeoffs, risks, and uncertainty. Don't oversell or default to agreement; prefer evidence and concrete reasoning over optimism.
- If a request is ambiguous, or you're making a material assumption or tradeoff, state it and ask before proceeding — don't guess.
- If a clearly better or simpler approach exists, explain it and get input before proceeding. Push back when warranted.
- For small, low-stakes, or easily reversible choices, make a reasonable decision and note it rather than stopping to ask. Reserve interruptions for things that materially affect the outcome.
- For non-trivial tasks, sketch the approach before implementing.
- Make surgical changes: touch only what the task requires. Don't refactor, reformat, or "improve" adjacent code, and don't delete pre-existing dead code unless asked.
- Match the patterns already in the file or module over your own preferences.
- Minimise dependencies. Justify any new one and prefer the standard library or existing code over adding a package.
- Verify code changes by running the project's tests and lints before claiming a task done.
- Write all prose — chat replies, comments, commit messages, and docs — in English. Keep responses short and impersonal.

# Bash

- Start every script with the `#!/usr/bin/env bash` shebang and `set -euo pipefail`.
- Quote all expansions: `"$var"`, `"$(cmd)"`, `"${arr[@]}"`.
- Verify with `shellcheck {filename}` (and `shfmt -d {filename}`) before claiming done.
- No explanatory comments; `# shellcheck` directives are allowed where needed.

# Rust

- Verify changes with `cargo clippy -q --message-format short` and `cargo nextest run` before claiming done. Do not edit tests without approval.
- Never edit `Cargo.toml`, add dependencies, or install tools without explicit approval.
- Do not write comments, including doc comments.
