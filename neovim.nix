{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    initLua = ''
      local set_transparency = function()
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      end
  
      -- Apply transparency
      set_transparency()
  
      -- Re-apply on colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = set_transparency,
      })

      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.softtabstop = 2
      vim.opt.expandtab = true
      vim.opt.smartindent = true

      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file', silent = true })
      vim.keymap.set('n', '<leader>n', ':bn<CR>', { desc = 'Next buffer', silent = true })
      vim.keymap.set('n', '<leader>p', ':bn<CR>', { desc = 'Next buffer', silent = true })
      vim.keymap.set('n', '<leader>e', ':Ex<CR>', { desc = 'Open file explorer', silent = true })
      vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>', { desc = 'Clear search highlights', silent = true })
    '';

  };
}
