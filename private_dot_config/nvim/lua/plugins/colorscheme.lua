return {

  { "EdenEast/nightfox.nvim", opts = {} },
  {
    "preservim/vim-colors-pencil",
    lazy = false,
    init = function()
      vim.g.pencil_terminal_italics = 1
      -- Optional: uncomment any of these to customize
      vim.g.pencil_higher_contrast_ui = 1
      vim.g.pencil_neutral_headings = 1
      -- vim.g.pencil_neutral_code_bg = 1
      vim.g.pencil_gutter_color = 1
    end,
  },
}
