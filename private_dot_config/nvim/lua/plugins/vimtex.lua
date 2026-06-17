return {
  "lervag/vimtex",
  lazy = false, -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_format_enabled = 1
    vim.g.vimtex_compiler_latexmk = {
      out_dir = "build",
      aux_dir = "auxiliary_files",
    }
    -- Using vim-textidote for grammar checking
    -- vim.g.vimtex_grammar_textidote = {
    --   jar = "/usr/local/bin/textidote.jar",
    --   args = "-- check en",
    -- }
    -- vim.g.vimtex_grammar_vlty = { lt_directory = "LanguageTool6.6" }
  end,
}
