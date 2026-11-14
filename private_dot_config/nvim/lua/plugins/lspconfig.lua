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
          analysis = { typeCheckingMode = "basic", autoImportCompletions = false },
          reportMissingTypeStubs = false,
          reportMissingParameterType = false,
          reportMissingTypeArgument = false,
        },
      },
    }

    opts.servers.tinymist = {
      settings = {
        projectResolution = "lockDatabase",
      },
    }
  end,
}
