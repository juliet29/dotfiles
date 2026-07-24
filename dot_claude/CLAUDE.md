# Global preferences (all projects)

## Tooling
- Always run Python via `uv` (e.g. `uv run python ...`, `uv run pytest`). Never invoke a bare `python`/`python3`.
- Use `rg` (ripgrep) instead of `grep`, and `fd` instead of `find`, for command-line search.
- Type-check Python with `basedpyright` (run via `uv run basedpyright <paths>`).

## Code style
- No docstrings, ever. Minimal comments — only to explain *how*/*why* in the rare case it isn't obvious from the code.
- Use explicit, intention-revealing names (Kent Beck *Refactoring* / *Clean Code* style) so the code reads without comments.
- Do not extract single-use helper functions that do just one thing — inline them. Only factor out a function when it's reused elsewhere.
- Avoid dense nested function calls. Bind intermediate results to well-named local variables so the code is glanceable, even when the intermediate is used only once.
- Name callable-typed fields/parameters as verbs so they read as functions (e.g. `pick_framing_value`, not `framing_value`).
