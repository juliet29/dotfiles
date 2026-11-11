-- Blink.cmp is LazyVim's default completion engine (replaced nvim-cmp).
-- Customizations for .tex files:
--   1. Drop the `buffer` source (no prose-word noise)
--   2. Filter LTeX-LS's completions out of the LSP source
--   3. Only auto-open the cmp menu when actively typing a LaTeX command (`\`)
--      or inside a `{...}` argument. Plain prose typing produces no popup.
--
-- To force-open the menu anywhere: <C-Space>.
--
-- Citation completion (\cite{...}) currently comes from:
--   - Zotero picker <leader>lz (whole library)
--   - Vimtex omnifunc via <C-x><C-o> (from local .bib)

local function tex_should_auto_show()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before = vim.api.nvim_get_current_line():sub(1, col)
  -- Match: (a) an in-progress LaTeX command like `\`, `\se`, `\section`
  --        (b) inside braces or after a comma — for `\input{...}`, `\cite{...}`, `\ref{...}`
  return before:match("\\[%a@*]*$") ~= nil
    or before:match("{[%w%s,./~:_%-]*$") ~= nil
    or before:match(",%s*[%w%s./~:_%-]*$") ~= nil
end

return {
  "saghen/blink.cmp",
  opts = {
    sources = {
      -- Snippets deliberately excluded: blink was surfacing luasnip-latex
      -- snippets (e.g. `plot`) mid-word and expanding them on accept.
      -- LuaSnip autotriggers still work (typing `mm` in math still expands to $...$).
      -- To insert a named snippet explicitly, type its trigger then <Tab>.
      per_filetype = {
        tex = { "lsp", "path" },
      },
      providers = {
        lsp = {
          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              local client_id = item.client_id
              if not client_id then
                return true
              end
              local client = vim.lsp.get_client_by_id(client_id)
              if client and (client.name == "ltex_plus" or client.name == "ltex") then
                return false
              end
              return true
            end, items)
          end,
        },
      },
    },
    completion = {
      menu = {
        auto_show = function(_ctx)
          if vim.bo.filetype == "tex" then
            return tex_should_auto_show()
          end
          return true
        end,
      },
    },
  },
}
