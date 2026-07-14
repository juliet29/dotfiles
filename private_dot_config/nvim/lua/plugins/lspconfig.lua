return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Python hints
    opts.inlay_hints = {
      exclude = { "python" },
    }

    -- Enbale servers
    opts.servers = opts.servers or {}

    -- Don't let Mason install these (json/yaml extras still active)
    opts.servers.jsonls = opts.servers.jsonls or {}
    opts.servers.jsonls.mason = false
    opts.servers.yamlls = opts.servers.yamlls or {}
    opts.servers.yamlls.mason = false

    -- Ruff
    opts.servers.ruff = {
      mason = false,
      cmd = { "ruff", "server" },
    }

    -- BasedPyright
    opts.servers.basedpyright = {
      mason = false,
      cmd = { "basedpyright-langserver", "--stdio" },
      settings = {
        basedpyright = {
          analysis = { typeCheckingMode = "basic" },
          reportMissingTypeStubs = false,
          reportMissingParameterType = false,
          reportMissingTypeArgument = false,
        },
      },
    }

    --- Typst
    opts.servers.tinymist = {
      -- cmd = { "tinymist" }, -- let Mason install
      root_dir = function(_, on_dir)
        return on_dir("/projectsContainer")
      end,
    }

    --- texlab: native LaTeX language server — provides \command completion,
    --- citations, cross-refs, symbol goto-definition.
    --- Compilation is handled by vimtex (\ll), so texlab's build is disabled.
    --- Grammar comes from LTeX, so chktex is disabled to avoid duplication.
    --- Formatting goes through conform.nvim + latexindent, so texlab's
    --- formatter isn't wired up.
    opts.servers.texlab = {
      settings = {
        texlab = {
          build = { onSave = false },
          chktex = { onOpenAndSave = false, onEdit = false },
          diagnosticsDelay = 300,
          forwardSearch = { executable = "", args = {} },
        },
      },
    }

    --- LTeX+ (LanguageTool as LSP) for grammar in tex/markdown/bib
    opts.servers.ltex_plus = {
      filetypes = { "tex", "plaintex", "bib", "markdown" },
      settings = {
        ltex = {
          language = "en-US",
          additionalRules = {
            enablePickyRules = true,
            motherTongue = "en",
          },
          disabledRules = {
            ["en-US"] = { "PROFANITY" },
          },
          -- Load personal dictionary from the same spellfile used by :zg
          dictionary = {
            ["en-US"] = { ":" .. vim.fn.expand("~/.config/nvim/spell/en.utf-8.add") },
          },
        },
      },
    }
    -- Astro and Typescript
    -- opts.servers.astro = {}
    --
    -- opts.servers.vtsls = opts.servers.vtsls or {}
    -- LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
    --   {
    --     name = "@astrojs/ts-plugin",
    --     location = LazyVim.get_pkg_path("astro-language-server", "/node_modules/@astrojs/ts-plugin"),
    --     enableForWorkspaceTypeScriptVersions = true,
    --   },
    -- })
  end,
}
