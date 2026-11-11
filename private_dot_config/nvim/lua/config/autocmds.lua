-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-reload buffers when the underlying file changes on disk (git, the shell,
-- Claude, etc.). `autoread` alone is insufficient — Neovim only re-checks on
-- certain events — so we nudge it with :checktime on focus/enter/idle. Pairs
-- with tmux `focus-events on`, which lets FocusGained fire inside tmux.
vim.opt.autoread = true
vim.api.nvim_create_autocmd(
  { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermClose", "TermLeave" },
  {
    group = vim.api.nvim_create_augroup("auto_reload_changed_files", { clear = true }),
    callback = function()
      -- :checktime errors in the command-line window / cmdline mode; skip those.
      if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
        vim.cmd("checktime")
      end
    end,
    desc = "Reload buffer if the file changed on disk",
  }
)

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = vim.api.nvim_create_augroup("auto_reload_notify", { clear = true }),
  callback = function()
    vim.notify("File changed on disk — buffer reloaded", vim.log.levels.INFO)
  end,
  desc = "Notify when a buffer is reloaded due to an external change",
})

-- ── Restart the LSP when Python deps change (DISABLED — enable only if the ────
-- focus-events refresh proves insufficient after `uv add` / `pixi add`) ───────
-- basedpyright caches site-packages at startup, so a newly installed package
-- keeps reporting reportMissingImports until the server re-scans. Package adds
-- happen in the shell, not in nvim, so nothing changes an open buffer — we watch
-- the dep file's mtime and restart the LSP on refocus (needs tmux focus-events
-- on, same as above). Uncomment to enable.
-- local _dep_mtimes = {}
-- local _dep_files = { "uv.lock", "pyproject.toml", "pixi.lock" }
-- vim.api.nvim_create_autocmd("FocusGained", {
--   group = vim.api.nvim_create_augroup("lsp_restart_on_dep_change", { clear = true }),
--   callback = function()
--     local uv = vim.uv or vim.loop
--     for _, name in ipairs(_dep_files) do
--       local path = vim.fs.find(name, { upward = true, path = vim.fn.getcwd() })[1]
--       if path then
--         local stat = uv.fs_stat(path)
--         local mtime = stat and stat.mtime.sec
--         if mtime and _dep_mtimes[path] and mtime ~= _dep_mtimes[path] then
--           vim.cmd("LspRestart")
--           vim.notify(name .. " changed — restarting LSP", vim.log.levels.INFO)
--         end
--         _dep_mtimes[path] = mtime
--       end
--     end
--   end,
--   desc = "Restart LSP when Python dependency files change on disk",
-- })
