-- Vale is not registered as an auto-run linter. Trigger it manually with <leader>lV.
-- Reasoning: LTeX-LS covers grammar in real time; Vale is used as a second-pass style
-- check on demand rather than on every save.
return {
  "mfussenegger/nvim-lint",
  keys = {
    {
      "<leader>lV",
      function()
        require("lint").try_lint("vale")
      end,
      ft = { "tex", "markdown", "text" },
      desc = "Run Vale (on demand)",
    },
  },
}
