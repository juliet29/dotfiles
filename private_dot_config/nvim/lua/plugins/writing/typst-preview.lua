-- Ports the SSH config forwards, in priority order. The preview is only
-- reachable through the tunnel on one of these, so pick from this set rather
-- than letting the plugin's naive port+1 fallback walk onto an unforwarded port.
local forwarded_ports = { 23627, 8888, 6006, 8501 }

local function port_is_free(port)
  local probe = vim.uv.new_tcp()
  local ok = pcall(function()
    assert(probe:bind("127.0.0.1", port))
  end)
  probe:close()
  return ok
end

local function pick_forwarded_port()
  for _, port in ipairs(forwarded_ports) do
    if port_is_free(port) then
      return port
    end
  end
  -- All forwarded ports busy: fall back to the first and let the plugin's
  -- port+1 retry take over (it will at least start, even if not tunnelled).
  return forwarded_ports[1]
end

return {
  "chomosuke/typst-preview.nvim",
  lazy = false, -- or ft = 'typst'
  version = "1.*",
  opts = {
    -- Bind to the first free SSH-forwarded port so the preview is reachable at
    -- http://127.0.0.1:<port> with no extra setup, even if 23627 is taken.
    port = pick_forwarded_port(),
    -- Headless container: no browser, so don't call xdg-open. Just print the URL.
    open_cmd = "echo 'typst-preview ready: open %s in your browser' 1>&2",
    -- Set root for previews
    -- get_root = function(_)
    --   return "/projectsContainer"
    -- end,
  },
}
