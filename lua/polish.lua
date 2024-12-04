-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Table to store quickfix entries with shortcuts
local quickfix_shortcuts = {}

-- Function to add the current position to the quickfix list with a shortcut
function add_position_to_quickfix_with_shortcut(char)
  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.fn.line "."
  local col = vim.fn.col "."
  local filename = vim.fn.expand "%:p"

  -- Create a quickfix entry
  local entry = {
    bufnr = bufnr,
    lnum = line,
    col = col,
    filename = filename,
    text = "Marked position " .. char,
  }

  -- Add the entry to the quickfix list
  vim.fn.setqflist({}, "a", { items = { entry } })

  -- Store the entry with the shortcut
  quickfix_shortcuts[char] = entry

  -- Notify the user
  -- print("Position added to quickfix list with shortcut: " .. char)
end

function remove_position_from_quickfix_with_shortcut(char)
  -- Check if the entry exists in the quickfix_shortcuts table
  local entry = quickfix_shortcuts[char]
  if entry then
    -- Remove the entry from the quickfix_shortcuts table
    quickfix_shortcuts[char] = nil

    -- Get the current quickfix list
    local qflist = vim.fn.getqflist()

    -- Find and remove the entry from the quickfix list
    for i, item in ipairs(qflist) do
      if item.bufnr == entry.bufnr and item.lnum == entry.lnum and item.col == entry.col then
        table.remove(qflist, i)
        break
      end
    end

    -- Update the quickfix list without the removed entry
    vim.fn.setqflist(qflist, "r")

    -- Notify the user
    -- print("Removed quickfix entry for shortcut: " .. char)
  else
    print("No quickfix entry found for shortcut: " .. char)
  end
end

-- Function to jump to a quickfix entry using a shortcut
function jump_to_quickfix_with_shortcut(char)
  local entry = quickfix_shortcuts[char]
  if entry then
    vim.api.nvim_set_current_buf(entry.bufnr)
    vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })
    -- print("Jumped to quickfix position: " .. char)
  else
    print("No quickfix entry found for shortcut: " .. char)
  end
end

-- Set up key mappings for adding and jumping to quickfix entries
for char = string.byte "a", string.byte "z" do
  local key = string.char(char)
  vim.api.nvim_set_keymap(
    "n",
    "<leader>m" .. key,
    ':lua add_position_to_quickfix_with_shortcut("' .. key .. '")<CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>j" .. key,
    -- ':lua jump_to_quickfix_with_shortcut("' .. key .. '")<CR>',
    ':lua jump_to_quickfix_with_shortcut("'
      .. key
      .. '")<CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>k" .. key,
    -- ':lua jump_to_quickfix_with_shortcut("' .. key .. '")<CR>',
    ':lua remove_position_from_quickfix_with_shortcut("'
      .. key
      .. '")<CR>',
    { noremap = true, silent = true }
  )
end

-- Set up custom filetypes
vim.filetype.add {
  extension = {
    foo = "fooscript",
  },
  filename = {
    ["Foofile"] = "fooscript",
  },
  pattern = {
    ["~/%.config/foo/.*"] = "fooscript",
  },
}
