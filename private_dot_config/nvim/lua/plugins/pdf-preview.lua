-- Live PDF preview in the browser, auto-reloads on file change.
-- Requires Node.js (npm/npx) on PATH.
--
-- pdf-preview.nvim prompts for the PDF path via vim.ui.input every time you
-- start it. The <leader>lp keymap below skips that prompt by pre-answering
-- with vimtex's known output path (e.g. build/<mainfile>.pdf).
return {
  "franco-ruggeri/pdf-preview.nvim",
  ft = { "tex", "markdown", "typst" },
  cmd = { "PdfPreviewStart", "PdfPreviewStop", "PdfPreviewToggle" },
  opts = {
    reload_debouce = 500,
  },
  config = function(_, opts)
    require("pdf-preview").setup(opts)
  end,
  keys = {
    {
      "<leader>lp",
      function()
        -- Resolve expected PDF path: (1) vimtex state → (2) newest PDF in build dir → (3) build/main.pdf
        local pdf_abs
        local out_dir = "build"
        local root = vim.fn.getcwd()

        local ok, state = pcall(vim.fn["vimtex#state#get_current"])
        if ok and type(state) == "table" then
          root = state.root or root
          out_dir = (state.compiler and state.compiler.out_dir) or out_dir
          if state.tex then
            local base = vim.fn.fnamemodify(state.tex, ":t:r")
            pdf_abs = root .. "/" .. out_dir .. "/" .. base .. ".pdf"
          end
        end

        -- Fallback: newest .pdf in build dir (handles section files without a magic root comment)
        if not pdf_abs or vim.uv.fs_stat(pdf_abs) == nil then
          local pdfs = vim.fn.glob(root .. "/" .. out_dir .. "/*.pdf", false, true)
          if #pdfs > 0 then
            table.sort(pdfs, function(a, b)
              local sa = vim.uv.fs_stat(a) or { mtime = { sec = 0 } }
              local sb = vim.uv.fs_stat(b) or { mtime = { sec = 0 } }
              return sa.mtime.sec > sb.mtime.sec
            end)
            pdf_abs = pdfs[1]
          else
            pdf_abs = root .. "/" .. out_dir .. "/main.pdf"
          end
        end

        -- pdf-preview builds its path as cwd .. "/" .. <input>, so hand it a cwd-relative path
        local rel = vim.fn.fnamemodify(pdf_abs, ":.")

        local orig = vim.ui.input
        local restored = false
        local function restore()
          if not restored then
            restored = true
            vim.ui.input = orig
          end
        end
        vim.ui.input = function(_, cb)
          restore()
          cb(rel)
        end
        vim.defer_fn(restore, 200) -- safety net if toggle is a stop (no prompt fires)

        vim.cmd("PdfPreviewToggle")
      end,
      ft = { "tex", "markdown" },
      desc = "Toggle PDF preview (auto path)",
    },
    { "<leader>lP", "<cmd>PdfPreviewStart<cr>", desc = "PDF preview (pick path)" },
  },
}
