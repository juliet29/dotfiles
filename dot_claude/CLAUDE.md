# Global preferences (all projects)

## Tooling
- Always run Python via `uv` (e.g. `uv run python ...`, `uv run pytest`). Never invoke a bare `python`/`python3`.
- Use `rg` (ripgrep) instead of `grep`, and `fd` instead of `find`, for command-line search.
- Type-check Python with `basedpyright` (run via `uv run basedpyright <paths>`), but only when I ask or when we're fixing a type issue — do not run it proactively after every change.
- Prefer existing libraries over building from scratch; assume you can add whatever dependencies are genuinely useful.

## Code style
- No docstrings, ever. No comments in code, either — write zero `#` comment lines. If something seems to need explaining, surface it as a note in your chat reply instead; I'll add a comment myself if I decide it's warranted. This applies to source/application code I'm actually developing; for config files (dotfiles, editor config, tool config, etc.) comments are fine.
- Use explicit, intention-revealing names (Kent Beck *Refactoring* / *Clean Code* style) so the code reads without comments.
- Do not extract single-use helper functions that do just one thing — inline them. Only factor out a function when it's reused elsewhere. *Exception:* when a block is genuinely complex logic (not a one-liner) representing a distinct low-level concern, extracting it is right even if single-use — the goal is to separate abstraction levels (SLAP) so the caller reads as high-level intent and the helper holds the gnarly detail. The rule bans pulling out trivial one-liners, not cohesive complex protocols.
- Never put imports in the middle of a function (no lazy/inline imports). All imports go at the top of the module. If you think a lazy import is needed to break a cycle, verify the cycle actually exists first — usually it doesn't.
- Avoid dense nested function calls. Bind intermediate results to well-named local variables so the code is glanceable, even when the intermediate is used only once.
- Name callable-typed fields/parameters as verbs so they read as functions (e.g. `pick_framing_value`, not `framing_value`).
- Extract the *per-item body* of a loop into a small named *nested* function (a verb, e.g. `register(settings)`) that operates on one element / mutates a closed-over accumulator; leave the `for` loop itself in the outer function just calling it. Extract the item-level work, NOT a wrapper around the whole loop. Nested functions are exempt from the "no single-use helpers" rule — that rule targets module-level helpers.

## Architecture
- The project's `paths.py` (e.g. a `ProjectPaths` class of concrete input/output locations) is used ONLY in the CLI layer. Library code — analysis, plotting, IO — takes paths as arguments and never imports the paths module. Inject concrete locations at the CLI boundary so the logic stays decoupled from filesystem layout and unit-testable.
- CLI is built with `cyclopts`: one `App` per topic module (e.g. `cli/weather.py`, `weather = App(name="weather")`) with `@weather.command` functions; a top-level `cli/_study.py` aggregates the sub-apps (`app.command(weather)`) and exposes `def main(): logset(to_stderr=True); app()`; the console entry point is declared in `pyproject.toml` `[project.scripts]` pointing at `<pkg>.cli._study:main`.
- Keep CLI commands thin and split for testability: express orchestration as several small independently-runnable commands (e.g. one to compute, one to plot) rather than one monolithic `main`. The reusable logic lives in library modules; the CLI just wires it.
- For output, don't use bare `print`: use `logger` from loguru (configured via `utils4plans.logs.logset`) for long-standing informational output, and `ic` from `icecream` for "show me what this value is" debug inspection.
