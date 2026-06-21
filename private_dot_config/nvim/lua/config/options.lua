--- local basedpyright = require("lspconfig.configs.basedpyright")
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "basedpyright"
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"

vim.g.autoformat = true
vim.opt.wrap = true

--- vimtex completion
vim.g.vimtex_complete_enabled = true
--- --- Basedpyright settings
--- basedpyright.setup({ settings = {
---   basedpyright = {
---     analysis = { typeCheckingMode = "standard" },
---   },
--- } })

vim.opt.spellfile = vim.fn.expand("~/.config/vim/spell/spell.en.utf-8.add")

--- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.foldlevelstart = 99

-- Create an augroup to prevent duplicate autocommands if you reload config
local spell_group = vim.api.nvim_create_augroup("SpellCheck", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = spell_group,
  -- 'tex' covers LaTeX files; 'markdown' covers .md files
  pattern = { "markdown", "tex" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en_us" }
  end,
  desc = "Enable spell check for Markdown and LaTeX",
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*.txt", "*.md" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    -- vim.opt.textwidth = 80
    -- vim.opt.formatoptions:remove("t")
  end,
})

-- Stop Macros!!!
vim.keymap.set("n", "q", "<Nop>")

--- Special color scheme for latex
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.o.background = "light"
    vim.cmd("colorscheme dawnfox") -- light theme from the nightfox family (matches duskfox)
  end,
})
