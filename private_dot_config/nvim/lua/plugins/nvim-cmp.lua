--- NOTE: the goal of this is to get tab completion on autocompletion
--- source: https://www.lazyvim.org/configuration/recipes#supertab

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-emoji",
  },
  -- @param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")
    opts.enabled = function()
      return vim.bo.filetype ~= "markdown"
    end

    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<Tab>"] = cmp.mapping(function(fallback)
        -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
        if cmp.visible() then
          local entry = cmp.get_selected_entry()
          if not entry then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            cmp.confirm()
          end
        else
          fallback()
        end
      end, { "i", "s", "c" }),
      ["<CR>"] = cmp.mapping(function(fallback)
        cmp.abort()
        fallback()
      end, { "i", "s", "c" }),
    })
  end,
}
