# Global Configuration

## Stack

Rust and Python programmer.

## Tool preferences

- Tests: `cargo nextest run` (not `cargo test`)
- Search: `rg` (not `grep`)
- Editor: `nvim`
- Directory listing: `eza`

## Coding conventions

### Rust

- Prefer idiomatic Rust; use `?` for error propagation
- Run `cargo clippy` before considering code complete
- `cargo fmt` for formatting

### Python

- Always use type hints
- `pytest` for tests

## Workflow

- Never `git push` without explicit instruction
- Never `git reset` or `git rebase` without explicit instruction
- Prefer editing existing files over creating new ones
