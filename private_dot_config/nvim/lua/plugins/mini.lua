return {
  "nvim-mini/mini.files",
  --- don't lazy looad so can be the use_as_default_explorer
  lazy = false,
  keys = {
    -- the keybindings from above
  },
  opts = {
    options = {
      use_as_default_explorer = true,
    },
  },
}
