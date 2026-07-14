return {
  "folke/snacks.nvim",
  opts = {
    explorer = { enabled = false },
    input = { enabled = true },
    picker = { ui_select = true },
  },
  keys = {
    -- the keybindings from above
    {
      "<leader>fih",
      function()
        Snacks.picker.files({ hidden = true, ignored = true })
      end,
      desc = "Find Hidden and Ignored Files",
    },
    -- disable explorer keys
    { "<leader>e", false },
    { "<leader>E", false },
  },
}
