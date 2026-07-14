return {
  "lervag/vimtex",
  lazy = false, -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- Viewing is done via pdf-preview.nvim, so disable vimtex's own viewer integration.
    -- If you want forward-search from tex → Skim later, flip vimtex_view_enabled back to 1.
    vim.g.vimtex_view_enabled = 0
    vim.g.vimtex_view_automatic = 0
    vim.g.vimtex_view_forward_search_on_start = 0
    vim.g.vimtex_view_method = "skim" -- unused while view_enabled=0, kept for future toggle
    vim.g.vimtex_format_enabled = 1

    -- Compiler: continuous latexmk, keep aux files out of the source tree
    vim.g.vimtex_compiler_latexmk = {
      out_dir = "build",
      aux_dir = "auxiliary_files",
      callback = 1,
      continuous = 1,
      executable = "latexmk",
      hooks = {},
      options = {
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
      },
    }

    -- Speed: disable the syntax features that lag on big docs
    vim.g.vimtex_syntax_conceal_disable = 1
    vim.g.vimtex_matchparen_enabled = 0
    vim.g.vimtex_indent_enabled = 0

    -- Less noise: don't focus/pop the quickfix on warnings, silence known-noisy ones
    vim.g.vimtex_quickfix_mode = 2
    vim.g.vimtex_quickfix_open_on_warning = 0
    vim.g.vimtex_quickfix_autoclose_after_keystrokes = 3
    vim.g.vimtex_view_automatic = 0 -- previewing via pdf-preview.nvim instead of Skim
    vim.g.vimtex_log_ignore = {
      "Underfull",
      "Overfull",
      "specifier changed to",
      "Token not allowed in a PDF string",
    }
  end,
  keys = {
    { "<leader>lw", "<cmd>VimtexCountWords<cr>", ft = "tex", desc = "LaTeX word count" },
    { "<leader>lW", "<cmd>VimtexCountLetters<cr>", ft = "tex", desc = "LaTeX letter count" },
    {
      "g)",
      "<Cmd>call search('[.!?]\\%(\\s\\|$\\)', 'W')<CR>",
      ft = "tex",
      mode = { "n", "x", "o" },
      desc = "End of sentence",
    },
    {
      "<leader>vs",
      function()
        vim.fn.search("\\<[A-Z]", "bcW")
        vim.cmd("normal! v")
        vim.fn.search("[.!?]", "W")
      end,
      ft = "tex",
      desc = "Select sentence (capital → period)",
    },
  },
}
