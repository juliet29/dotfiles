-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

vim.api.nvim_set_keymap(
  "n",
  "<Leader>wa",
  ":wa<CR>",
  { noremap = true, silent = true, desc = "Save all modified buffers" }
)

vim.keymap.set("n", "<Leader>sr", "<Cmd>spellrepall<CR>", {
  desc = "Spell: replace all instances of last z= correction",
})

vim.keymap.set("n", "<Leader>sn", "]sz=", { desc = "Spell: next error + suggest" })
vim.keymap.set("n", "<Leader>s1", "]s1z=", { desc = "Spell: next error + accept first" })
vim.keymap.set("n", "<Leader>sg", "]szg", { desc = "Spell: next error + add to dict" })

vim.keymap.set("n", "<Leader>sz", function()
  local word = vim.fn.expand("<cword>")
  local suggestions = vim.fn.spellsuggest(word, 10)
  if #suggestions == 0 then
    return vim.notify("No suggestions for " .. word, vim.log.levels.WARN)
  end
  vim.ui.select(suggestions, { prompt = "Fix '" .. word .. "':" }, function(choice)
    if choice then
      vim.cmd("normal! ciw" .. choice)
      vim.cmd("normal! ]s")
    end
  end)
end, { desc = "Spell: suggest via picker + jump" })

-- Grammar (LTeX diagnostics) — analog of the spell loop
local function is_ltex(d)
  return d.source == "ltex" or d.source == "ltex_plus" or d.source == "LTeX"
end

vim.keymap.set("n", "<Leader>gn", function()
  vim.diagnostic.jump({ count = 1, filter = is_ltex })
  vim.schedule(function()
    vim.lsp.buf.code_action({ filter = function(a) return (a.kind or ""):match("quickfix") end })
  end)
end, { desc = "Grammar: next LTeX diag + code action" })

vim.keymap.set("n", "<Leader>gp", function()
  vim.diagnostic.jump({ count = -1, filter = is_ltex })
end, { desc = "Grammar: prev LTeX diag" })

vim.keymap.set("n", "<Leader>g1", function()
  vim.diagnostic.jump({ count = 1, filter = is_ltex })
  vim.schedule(function()
    vim.lsp.buf.code_action({
      filter = function(a) return (a.kind or ""):match("quickfix") end,
      apply = true, -- auto-applies if exactly one match
    })
  end)
end, { desc = "Grammar: next LTeX diag + apply first quickfix" })

vim.keymap.set("n", "<Leader>gl", function()
  Snacks.picker.diagnostics_buffer({
    filter = { source = "ltex_plus" },
  })
end, { desc = "LTeX: list all issues in buffer" })

-- One-keystroke LTeX review loop
local function ltex_apply_and_next(title_pattern)
  vim.lsp.buf.code_action({
    filter = function(a) return a.title and a.title:match(title_pattern) ~= nil end,
    apply = true,
  })
  vim.defer_fn(function()
    vim.diagnostic.jump({ count = 1, filter = is_ltex })
  end, 80)
end

vim.keymap.set("n", "<F3>", function() ltex_apply_and_next("^Use '") end,
  { desc = "LTeX: accept top suggestion + next" })
vim.keymap.set("n", "<F4>", function() ltex_apply_and_next("^Add '") end,
  { desc = "LTeX: add to dictionary + next" })
vim.keymap.set("n", "<F5>", function() vim.diagnostic.jump({ count = 1, filter = is_ltex }) end,
  { desc = "LTeX: skip to next" })

-- Diagnostic highlights (nightfox colorscheme)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, sp = "#ef5350" })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, sp = "#ffb74d" })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, sp = "#64b5f6" })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, sp = "#81c784" })
  end,
})

vim.diagnostic.config({
  underline = { severity = { min = vim.diagnostic.severity.INFO } },
  virtual_text = true,
})

-- Final grammar check: start LTeX for a comprehensive pass (disabled by default, Harper handles ongoing)
vim.api.nvim_create_user_command("LTexCheck", function()
  vim.lsp.start({
    name = "ltex_plus",
    cmd = { "ltex-ls" },
    filetypes = { "tex", "plaintex", "bib", "markdown" },
    settings = {
      ltex = {
        language = "en-US",
        additionalRules = { enablePickyRules = true, motherTongue = "en" },
        disabledRules = { ["en-US"] = { "PROFANITY" } },
        dictionary = { ["en-US"] = { ":" .. vim.fn.expand("~/.config/nvim/spell/en.utf-8.add") } },
      },
    },
  })
  vim.notify("LTeX started for final grammar check", vim.log.levels.INFO)
end, { desc = "Start LTeX for final grammar check" })
