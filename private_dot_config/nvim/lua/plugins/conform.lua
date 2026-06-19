return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    opts.formatters_by_ft.lua = { "stylua" }
    -- ruff_fix removes unused imports (F401) + applies autofixes,
    -- ruff_organize_imports sorts them, ruff_format does black-style formatting.
    opts.formatters_by_ft.python = { "ruff_fix", "ruff_organize_imports", "ruff_format" }
    opts.formatters_by_ft.tex = { "latexindent" }

    -- if LazyVim.has_extra("formatting.prettier") then
    -- opts.formatters_by_ft.astro = { "prettier" }
    -- end

    -- format_on_save = {
    --   timeout_ms = 500,
    --   lsp_format = "fallback",
    -- },
    return opts
  end,
}
