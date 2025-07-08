return {
 {
   "williamboman/mason.nvim",
   config = function()
     require("mason").setup()
   end
  },
  {
    "williamboman/mason-lspconfig.nvim", version = "0.1.7",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua-lsp" }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
    end
  }
}
