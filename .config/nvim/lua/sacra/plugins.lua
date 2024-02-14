local status, packer = pcall(require, "packer")
if not status then
	print("Packer is not installed")
	return
end

-- Reloads Neovim after whenever you save plugins.lua
vim.cmd([[
    augroup packer_user_config
      autocmd!
     autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup END
]])


packer.startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

    use("tpope/vim-fugitive")

    use("nvim-lua/plenary.nvim")
    use("nvim-lua/popup.nvim")
    	-- Telescope
--	use({
--		"nvim-telescope/telescope.nvim",
--		tag = "0.1.0",
--		requires = { { "nvim-lua/plenary.nvim" } },
--	})
--	use("nvim-telescope/telescope-file-browser.nvim")

    use("nvim-lualine/lualine.nvim") -- A better statusline

	use("PotatoesMaster/i3-vim-syntax")
	use("kovetskiy/sxhkd-vim")
	use("vim-python/python-syntax")
	use("ap/vim-css-color")

    use("neovim/nvim-lspconfig")

    use("RRethy/nvim-base16")
    use("kyazdani42/nvim-palenight.lua")

	if packer_bootstrap then
		packer.sync()
	end
end)

