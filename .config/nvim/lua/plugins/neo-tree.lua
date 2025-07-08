return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", 
    "MunifTanjim/nui.nvim",
  },
  config = function()
    vim.keymap.set('n', '<C-n>', function()
      local neotree_is_open = false
    
      -- Check if any window has 'neo-tree' in its buffer name
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local bufname = vim.api.nvim_buf_get_name(buf)
        if bufname:match("neo%-tree") then
          neotree_is_open = true
          break
        end
      end
    
      if neotree_is_open then
        vim.cmd('Neotree close')
      else
        vim.cmd('Neotree filesystem reveal left')
      end
    end, { desc = "Toggle Neo-tree", noremap = true, silent = true })
  end
}

