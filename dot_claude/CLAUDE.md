# Global preferences (all projects)

## Tooling
- Always run Python via `uv` (e.g. `uv run python ...`, `uv run pytest`). Never invoke a bare `python`/`python3`.
- Use `rg` (ripgrep) instead of `grep`, and `fd` instead of `find`, for command-line search.
- Type-check Python with `basedpyright` (run via `uv run basedpyright <paths>`).

## Code style
- No docstrings, ever. No comments in code, either — write zero `#` comment lines. If something seems to need explaining, surface it as a note in your chat reply instead; I'll add a comment myself if I decide it's warranted.
- Use explicit, intention-revealing names (Kent Beck *Refactoring* / *Clean Code* style) so the code reads without comments.
- Do not extract single-use helper functions that do just one thing — inline them. Only factor out a function when it's reused elsewhere. *Exception:* when a block is genuinely complex logic (not a one-liner) representing a distinct low-level concern, extracting it is right even if single-use — the goal is to separate abstraction levels (SLAP) so the caller reads as high-level intent and the helper holds the gnarly detail. The rule bans pulling out trivial one-liners, not cohesive complex protocols.
- Never put imports in the middle of a function (no lazy/inline imports). All imports go at the top of the module. If you think a lazy import is needed to break a cycle, verify the cycle actually exists first — usually it doesn't.
- Avoid dense nested function calls. Bind intermediate results to well-named local variables so the code is glanceable, even when the intermediate is used only once.
- Name callable-typed fields/parameters as verbs so they read as functions (e.g. `pick_framing_value`, not `framing_value`).
- Extract the *per-item body* of a loop into a small named *nested* function (a verb, e.g. `register(settings)`) that operates on one element / mutates a closed-over accumulator; leave the `for` loop itself in the outer function just calling it. Extract the item-level work, NOT a wrapper around the whole loop. Nested functions are exempt from the "no single-use helpers" rule — that rule targets module-level helpers.
