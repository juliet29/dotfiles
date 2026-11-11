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

-- Vimtex compile status: pure event-driven so lualine doesn't have to poll.
-- Starts as "stopped" until \ll fires. Polling was causing flicker.
local vimtex_state = { label = "stopped" }
local function set_state(label)
  vimtex_state.label = label
  vim.schedule(function()
    vim.cmd("redrawstatus")
  end)
end
local ev = vim.api.nvim_create_augroup("VimtexStatusIndicator", { clear = true })
for pattern, label in pairs({
  VimtexEventCompileStarted = "idle",
  VimtexEventCompiling = "compiling",
  VimtexEventCompileSuccess = "ok",
  VimtexEventCompileFailed = "error",
  VimtexEventCompileStopped = "stopped",
}) do
  vim.api.nvim_create_autocmd("User", {
    group = ev,
    pattern = pattern,
    callback = function()
      set_state(label)
    end,
  })
end

local vimtex_icons = {
  stopped = "○ stopped",
  idle = "◐ idle",
  compiling = "⏳ compiling",
  ok = "✓ ok",
  error = "✗ error",
}
local function vimtex_status()
  if vim.bo.filetype ~= "tex" then
    return ""
  end
  return vimtex_icons[vimtex_state.label] or "○ stopped"
end

-- LTeX-LS grammar check indicator: dot when checking, empty when idle.
-- State is populated by plugins/ltex-quiet.lua via _G.ltex_state.
local function ltex_status()
  if not is_prose() then
    return ""
  end
  if _G.ltex_state and _G.ltex_state.checking then
    return "󰗧 ltex"
  end
  return ""
end

-- Docs for what lazyvim does: https://www.lazyvim.org/plugins/ui#:~:text=Displays%20a%20fancy%20status%20line,%7D%2C
-- Docs for lualine: https://github.com/nvim-lualine/lualine.nvim

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, {
      vimtex_status,
      cond = function()
        return vim.bo.filetype == "tex"
      end,
      color = function()
        local map = {
          compiling = "#e0af68",
          ok = "#9ece6a",
          error = "#f7768e",
          stopped = "#565f89",
          idle = "#7aa2f7",
        }
        return { fg = map[vimtex_state.label] or "#565f89" }
      end,
    })
    table.insert(opts.sections.lualine_x, {
      ltex_status,
      cond = is_prose,
      color = { fg = "#7aa2f7" },
    })
    table.insert(opts.sections.lualine_x, {
      word_count,
      cond = is_prose,
    })
    return opts
  end,
}
