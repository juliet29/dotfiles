-- LaTeX snippets (Gilles Castel-style, math autotriggers etc.)
-- After install run :LuaSnipListAvailable to see what's loaded.
return {
  {
    "L3MON4D3/LuaSnip",
    opts = function(_, opts)
      opts = opts or {}
      opts.enable_autosnippets = true
      -- Treat trailing \ as a snippet-trigger boundary so math triggers fire in LaTeX
      opts.store_selection_keys = "<Tab>"
      return opts
    end,
  },
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    ft = { "tex", "markdown" },
    config = function()
      require("luasnip-latex-snippets").setup({ use_treesitter = true })
      local ls = require("luasnip")
      ls.config.setup({ enable_autosnippets = true })

      -- Custom user snippets for LaTeX.
      -- Type the trigger then <Tab> in insert mode to expand.
      local s = ls.snippet
      local i = ls.insert_node
      local fmt = require("luasnip.extras.fmt").fmt
      -- Autosnippet: expands the moment the trigger is typed, no <Tab> needed.
      -- Using uppercase \TT (not a real LaTeX command) to avoid clashing with
      -- \tt / \ttfamily. Trigger fires anywhere (wordTrig=false).
      ls.add_snippets("tex", {
        s(
          { trig = "\\TT", wordTrig = false, snippetType = "autosnippet" },
          fmt("{{\\tt {}}}", { i(1) })
        ),
      })
    end,
  },
}
