# Tree-sitter gotcha after `:Lazy sync` (read before/after updating on a new machine)

## TL;DR
nvim-treesitter (master) was **archived 2026-04-03**; its final version is the Neovim 0.12
rewrite that **compiles parsers with the `tree-sitter` CLI** instead of gcc-direct. If the CLI
isn't installed, parser rebuilds fail silently after `:Lazy sync`, parsers go stale while their
queries advance, and you get query/parser mismatch errors.

## Symptom
After `:Lazy sync`, an error like:
```
.../runtime/lua/vim/treesitter/query.lua:374: Query error at ...: "<node>"  ^
```
In Neovim 0.12 the **command-line is highlighted with the `vim` parser**, so a stale `vim`
parser makes this fire on every `:` and renders nvim nearly unusable. (`"tab"` was the node in
the case I hit — a node added to a newer tree-sitter-vim grammar that the old parser lacked.)

## Root cause check
Compare pinned vs installed parser revision:
- pinned: `~/.local/share/nvim/lazy/nvim-treesitter/lua/nvim-treesitter/parsers.lua` (the lang's `revision`)
- installed: `~/.local/share/nvim/site/parser-info/<lang>.revision`
If they differ and `<lang>.so` (in `~/.local/share/nvim/site/parser/`) is old, the rebuild failed.

## Fix
1. Install the `tree-sitter` CLI somewhere on PATH (gcc/cc must also be present for the compile):
   - Sherlock / no-sudo / userspace: prebuilt binary into `~/bin` (on PATH, persists):
     ```sh
     curl -fsSL -o /tmp/ts.gz \
       https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz
     gunzip -f /tmp/ts.gz && chmod +x /tmp/ts && mv -f /tmp/ts ~/bin/tree-sitter
     tree-sitter --version
     ```
   - Or with node present: `npm i -g tree-sitter-cli` (set a userspace prefix if no root).
2. Rebuild parsers: in nvim `:TSUpdate` (or one lang: `:TSInstall! vim`).
   - If nvim's cmdline is too broken to type, do it headless from a shell (note `-l` runs a BARE
     nvim, so prepend the plugin to rtp first):
     ```sh
     cat > /tmp/ts_fix.lua <<'LUA'
     vim.opt.runtimepath:prepend(vim.fn.expand('~/.local/share/nvim/lazy/nvim-treesitter'))
     local install = require('nvim-treesitter.install')
     install.install({'vim'}, {force=true, summary=true}):wait(180000)  -- swap 'vim' / add langs
     LUA
     PATH="$HOME/bin:$PATH" nvim --headless -l /tmp/ts_fix.lua
     ```
3. Restart nvim. (`:TSInstallSync` does NOT exist in this version — commands are async.)

## Long term
The plugin is dead. The real fix is migrating to Neovim 0.12's built-in treesitter
(parsers/queries bundled for common langs). Don't rush that mid-incident.
