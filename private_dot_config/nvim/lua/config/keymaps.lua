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
