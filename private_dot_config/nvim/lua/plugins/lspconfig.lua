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
