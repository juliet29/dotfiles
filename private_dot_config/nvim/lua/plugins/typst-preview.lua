return {
  "chomosuke/typst-preview.nvim",
  lazy = false, -- or ft = 'typst'
  version = "1.*",
  opts = {
    -- Pin to a port the SSH config already forwards (LocalForward 23627),
    -- so the preview is reachable at http://127.0.0.1:23627 with no extra setup.
    port = 23627,
    -- Headless container: no browser, so don't call xdg-open. Just print the URL.
    open_cmd = "echo 'typst-preview ready: open %s in your browser' 1>&2",

    -- Debugging
    debug = true,

    -- Set root for previews
    get_root = function(_)
      return "/projectsContainer"
    end,

    -- extra_args = { "--verbosity=DEBUG" },
  },
}
