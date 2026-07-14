-- Silence LTeX-LS's per-keystroke progress popups.
-- Instead, track its "checking" state and expose it for the lualine indicator.
--
-- Rationale: LTeX re-checks the document on every keystroke and floods the
-- LSP progress channel. LazyVim's notifier (snacks) shows each as a popup.
-- We drop those popups and surface a single quiet dot in the statusline.

local M = {}

-- Buffer-local state — exposed to lualine via require("ltex_state").status()
_G.ltex_state = M
M.checking = false

return {
  "neovim/nvim-lspconfig",
  optional = true,
  init = function()
    -- 1. Intercept LSP progress messages: swallow LTeX's, pass everything else through
    local orig = vim.lsp.handlers["$/progress"]
    vim.lsp.handlers["$/progress"] = function(err, result, ctx, config)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if client and (client.name == "ltex_plus" or client.name == "ltex") then
        -- Track state so lualine can show it, but don't forward to the notifier
        local kind = result and result.value and result.value.kind
        if kind == "begin" or kind == "report" then
          M.checking = true
        elseif kind == "end" then
          M.checking = false
        end
        vim.schedule(function()
          vim.cmd("redrawstatus")
        end)
        return
      end
      if orig then
        return orig(err, result, ctx, config)
      end
    end

    -- 2. Also silence any window/showMessage from LTeX (info-level notifications)
    local orig_show = vim.lsp.handlers["window/showMessage"]
    vim.lsp.handlers["window/showMessage"] = function(err, result, ctx, config)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if client and (client.name == "ltex_plus" or client.name == "ltex") then
        if result and result.type and result.type >= 3 then
          -- Only pass warnings (2) and errors (1); drop info (3) and log (4)
          return
        end
      end
      if orig_show then
        return orig_show(err, result, ctx, config)
      end
    end
  end,
}
