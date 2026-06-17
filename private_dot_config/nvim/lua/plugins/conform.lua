return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    opts.formatters_by_ft.lua = { "stylua" }
    opts.formatters_by_ft.python = { "ruff", "black", "prettier" }
    opts.formatters_by_ft.tex = { "latexindent" }

    -- if LazyVim.has_extra("formatting.prettier") then
    opts.formatters_by_ft.astro = { "prettier" }
    -- end

    -- format_on_save = {
    --   timeout_ms = 500,
    --   lsp_format = "fallback",
    -- },
    return opts
  end,
}
