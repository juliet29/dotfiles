-- Fuzzy-pick Zotero entries and insert \cite{key} at the cursor.
-- Needs: Zotero + Better BibTeX extension (already present at ~/Zotero/better-bibtex.sqlite).
-- Zotero must be running (or recently run) so the sqlite db exists and is up to date.
return {
  {
    "jmbuhr/telescope-zotero.nvim",
    dependencies = {
      { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
      "kkharji/sqlite.lua",
    },
    ft = { "tex", "markdown", "plaintex", "bib" },
    cmd = "Telescope zotero",
    keys = {
      { "<leader>lz", "<cmd>Telescope zotero<cr>", ft = { "tex", "markdown" }, desc = "Zotero citation picker" },
    },
    config = function()
      require("telescope").setup({})
      require("telescope").load_extension("zotero")
      require("zotero").setup({
        zotero_db_path = vim.fn.expand("~/Zotero/zotero.sqlite"),
        better_bibtex_db_path = vim.fn.expand("~/Zotero/better-bibtex.sqlite"),
        -- Where to write new bibtex entries when you press <C-a> in the picker
        -- (defaults to a bib file discovered from your tex project).
        -- bib_files = { vim.fn.expand("~/refs.bib") },
      })
    end,
  },
}
