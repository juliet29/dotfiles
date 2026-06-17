return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Python hints
    opts.inlay_hints = {
      exclude = { "python" },
    }

    -- Enbale servers
    opts.servers = opts.servers or {}

    -- BasedPyright
    opts.servers.basedpyright = {
      settings = {
        basedpyright = {
          analysis = { typeCheckingMode = "standard" },
          reportMissingTypeStubs = false,
          reportMissingParameterType = false,
          reportMissingTypeArgument = false,
        },
      },
    }

    -- Astro and Typescript
    opts.servers.astro = {}

    opts.servers.vtsls = opts.servers.vtsls or {}
    LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
      {
        name = "@astrojs/ts-plugin",
        location = LazyVim.get_pkg_path("astro-language-server", "/node_modules/@astrojs/ts-plugin"),
        enableForWorkspaceTypeScriptVersions = true,
      },
    })
  end,
}
