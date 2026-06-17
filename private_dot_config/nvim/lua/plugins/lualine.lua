local function is_prose()
  local ft = vim.bo.filetype
  return ft == "markdown" or ft == "tex"
end

local function word_count()
  if not is_prose() then
    return ""
  end
  local wc = vim.fn.wordcount()
  local w = wc.visual_words or wc.words
  local c = wc.visual_chars or wc.chars
  return string.format("%d words |  %d chars", w, c)
end

-- Docs for what lazyvim does: https://www.lazyvim.org/plugins/ui#:~:text=Displays%20a%20fancy%20status%20line,%7D%2C
-- Docs for lualine: https://github.com/nvim-lualine/lualine.nvim

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, {
      word_count,
      cond = is_prose,
    })
    return opts
  end,
}
