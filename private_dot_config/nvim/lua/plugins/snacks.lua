return {
  "folke/snacks.nvim",
  keys = {
    -- the keybindings from above
    {
      "<leader>fih",
      function()
        Snacks.picker.files({ hidden = true, ignored = true })
      end,
      desc = "Find Hidden and Ignored Files",
    },
  },
}
