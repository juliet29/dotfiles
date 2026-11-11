return {
  "saghen/blink.cmp",
  -- pin to a tagged release so Lazy.nvim downloads a pre-built binary
  -- building from source requires a nightly Rust toolchain
  version = "1.*",
  dependencies = {
    -- a large collection of pre-written snippets for many languages
    -- "rafamadriz/friendly-snippets",
  },
  opts = {
    keymap = { preset = "super-tab" },
    fuzzy = {
      max_typos = 0,
      sorts = { "exact", "score", "sort_text" },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },

      min_keyword_length = 2,

      per_filetype = {
        typst = {
          "lsp",
          "path",
          "snippets",
        },
      },
    },

    providers = {
      snippets = {
        opts = {
          friendly_snippets = false,
        },
      },
    },
  },
}
