return {
  {
    "alexpasmantier/pymple.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- optional (nicer ui)
      "stevearc/dressing.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    -- No build step: :PympleBuild runs `sudo apt-get install sed/fd-find`
    -- unconditionally, but the container has no sudo (and sed+fd already exist), so
    -- it crashes. gg (grip-grab), pymple's only real dep, is built by moth-restore.sh 2b.
    config = function()
      -- TEMP: debug logging to diagnose "No jobs to run" (logs computed import
      -- paths + resolved project root to ~/.local/share/nvim/pymple.vlog). Revert
      -- to require("pymple").setup() once diagnosed.
      require("pymple").setup({ logging = { level = "debug" } })
    end,
  },
}
