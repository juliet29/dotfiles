return {
  "PatrBal/vim-textidote",
  init = function()
    vim.g.textidote_jar = "/usr/local/bin/textidote.jar"
    vim.g.textidote_dictionary = "/.config/vim/spell/spell.en.utf-8.add"
    vim.g.textidote_ignore_rules = "lt:en:MORFOLOGIK_RULE_EN_US"
  end,
  keys = {
    {
      "<leader>tx",
      function()
        vim.cmd([[execute 'mkspell! ' . &spellfile]])
        vim.cmd("TeXtidoteToggle")
      end,
      mode = { "n", "v" },
      desc = "Toggle TeXtidote",
    },

    -- {
    --   "<leader>tr",
    --   function()
    --     -- 1. Safely check if spellfile exists and is not empty
    --     local sf = vim.opt.spellfile:get()
    --     if sf and #sf > 0 then
    --       -- Recompile only if a spellfile is actually set
    --       vim.cmd([[silent execute 'mkspell! ' . &spellfile]])
    --     end
    --
    --     -- 2. Trigger the refresh
    --     -- Use pcall (protected call) to prevent E108 from crashing your session
    --     local status, err = pcall(function()
    --       vim.cmd("TeXtidoteCheck")
    --     end)
    --
    --     if not status then
    --       print("TeXtidote: Could not refresh (Is the plugin loaded?)")
    --     else
    --       print("TeXtidote: Refreshed!")
    --     end
    --   end,
    --   mode = "n",
    --   desc = "Refresh TeXtidote",
    -- },
    -- {
    --   "<leader>tr",
    --   function()
    --     vim.cmd([[execute 'mkspell! ' . &spellfile]])
    --     vim.cmd("TeXtidoteCheck")
    --   end,
    --   mode = { "n", "v" },
    --   desc = "Refresh TeXtidote",
    -- },
  },
}
