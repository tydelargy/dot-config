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

## Jujutsu (jj)

When working in a jj-managed repo, prefer `jj` commands over `git` commands.

- Check state: `jj status`, `jj log`, `jj diff`
- The working copy is always a commit — there is no staging area
- Create a new commit: `jj new` (edits to files are auto-tracked in the new commit)
- Amend commit message: `jj describe`
- Squash into parent: `jj squash`
- Never `jj git push` without explicit instruction
- Never `jj abandon` without explicit instruction (discards commits)
