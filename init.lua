return {
  -- Set colorscheme to use
  colorscheme = "gruvbox",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  lsp = {
    config = {
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
    },
  },

  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
  },

  polish = function()
    -- vim.api.nvim_command('set nohlsearch')
    -- vim.api.nvim_command('set so=3')
    -- vim.api.nvim_command('set colorcolumn=80')
  end,
}
