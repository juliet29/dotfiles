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
