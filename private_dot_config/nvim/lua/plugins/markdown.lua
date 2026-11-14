return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      win_options = {
        wrap = { rendered = true },
        linebreak = { rendered = true },
        breakindent = { rendered = true },
      },
      heading = {
        sign = false,
        position = "inline",
        icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
        border = { true, true, false, false, false, false },
        above = " ",
        below = "▔",
      },
      code = {
        style = "full",
        width = "full",
        left_pad = 2,
        right_pad = 2,
        language_pad = 1,
        border = "thick",
        above = "▄",
        below = "▀",
        highlight = "RenderMarkdownCode",
        highlight_border = "RenderMarkdownCodeBorder",
        highlight_language = "RenderMarkdownCodeLanguage",
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      local function apply_markdown_highlights()
        local is_light = vim.o.background == "light"

        -- 1. Bold, high-contrast headings (adapts automatically to light or dark themes)
        local h_colors = is_light and { "#1a1a1a", "#2c3e50", "#34495e", "#4a5568", "#4a5568", "#718096" }
          or { "#f8f9fa", "#cbd5e1", "#94a3b8", "#64748b", "#64748b", "#475569" }

        for i = 1, 6 do
          vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i, { fg = h_colors[i], bold = true })
          local h_bg = "NONE"
          if i == 1 then
            h_bg = is_light and "#e8ecef" or "#2a2d34"
          elseif i == 2 then
            h_bg = is_light and "#f1f4f6" or "#22252a"
          end
          vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i .. "Bg", { bg = h_bg, bold = true })
        end

        -- 2. High-contrast fenced code blocks & language pill badge
        local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
        local code_bg = is_light and "#e4e8ee" or "#181a1f"
        local border_fg = is_light and "#cbd2dc" or "#2c313a"

        vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = code_bg })
        vim.api.nvim_set_hl(0, "RenderMarkdownCodeBorder", { fg = border_fg, bg = normal_bg or "NONE" })
        vim.api.nvim_set_hl(0, "RenderMarkdownCodeLanguage", {
          fg = is_light and "#ffffff" or "#181a1f",
          bg = is_light and "#4a6fa5" or "#7aa2f7",
          bold = true,
        })

        -- 3. Distinct inline `code` styling
        vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", {
          fg = is_light and "#b83227" or "#f7768e",
          bg = is_light and "#ebedf0" or "#292e42",
        })
      end

      -- Apply immediately on startup and re-apply whenever ANY colorscheme changes
      apply_markdown_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("GlobalRenderMarkdownHighlights", { clear = true }),
        pattern = "*",
        callback = apply_markdown_highlights,
      })
    end,
  },
}
