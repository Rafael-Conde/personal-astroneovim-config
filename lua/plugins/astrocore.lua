-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        shiftwidth = 4,
        so = 3,
        hlsearch = true,
        guifont = "CaskaydiaCove Nerd Font:h12",
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        cmp_enabled = true, -- enable completion at start
        autopairs_enabled = true, -- enable autopairs at start
        diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
        icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
        ui_notifications_enabled = true, -- disable notifications when toggling UI elements
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        ["<F12>"] = { "@a", desc = "executes the macro at a" },
        ["<leader>a"] = { desc = "QuickFix list" },
        ["<leader>ac"] = {
          function() vim.fn.setqflist({}, "r") end,
          desc = "Clear QuickFix list",
        },
        ["<leader>ao"] = {
          function() vim.cmd "copen" end,
          desc = "Open QuickFix list",
        },
        ["<leader>ai"] = {
          function() vim.cmd "cclose" end,
          desc = "Closes QuickFix list",
        },
        ["<leader>aa"] = {
          function()
            -- Get the current buffer number
            local bufnr = vim.api.nvim_get_current_buf()
            -- Get the current buffer name
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            -- Get the current cursor position
            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            local lnum = cursor_pos[1]
            local col = cursor_pos[2] + 1 -- Neovim returns column starting from 0, adding 1 to make it 1-based

            -- Prompt the user for a name
            local name = vim.fn.input "Enter quickfix entry name: "

            -- Use default text if no name is provided
            if name == "" then name = "Current position in buffer" end

            -- Create the quickfix item
            local quickfix_item = {
              filename = bufname,
              lnum = lnum,
              col = col,
              text = name,
            }

            -- Append the item to the quickfix list
            vim.fn.setqflist({}, "a", { items = { quickfix_item } })

            -- Optionally, open the quickfix list window to see the changes
            vim.cmd "copen"
          end,
          desc = "Append current buffer QuickFix list with a name",
        },
        ["<leader>ar"] = {
          function()
            -- Ensure the cursor is in the quickfix window
            if vim.fn.getwininfo(vim.fn.win_getid())[1].quickfix == 1 then
              -- Get the current cursor position in the quickfix window
              local cursor_pos = vim.fn.getpos "."
              local current_idx = cursor_pos[2] -- Line number in the quickfix window

              -- Get the current quickfix list
              local qflist = vim.fn.getqflist()

              -- Check if the current index is within the range of the quickfix list
              if current_idx >= 1 and current_idx <= #qflist then
                -- Remove the current quickfix item
                table.remove(qflist, current_idx)
                -- Update the quickfix list
                vim.fn.setqflist(qflist, "r")
                -- Refresh the quickfix window to reflect changes
                vim.cmd "copen"
              else
                print "Invalid quickfix list index"
              end
            else
              print "Not in the quickfix window"
            end
          end,
          desc = "Remove from QuickFix list",
        },

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
    },
  },
}
