return {
  -- Set colorscheme to use
  colorscheme = "gruvbox",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
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
