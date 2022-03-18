local present, packer = pcall(require, 'plugins.packerInit')

if not present then
   return false
end

local plugins = {
   { "nvim-lua/plenary.nvim" },
   { "lewis6991/impatient.nvim" },
   { "nathom/filetype.nvim" },

   {
      "wbthomason/packer.nvim",
      event = "VimEnter",
   },

   {
      "folke/tokyonight.nvim",
      after = "packer.nvim",
      config = function()
         require("colors").init()
      end,
   },
   {
      "kyazdani42/nvim-web-devicons",
      after = "tokyonight.nvim",
      config = function()
         require("plugins.config.icons").setup()
      end,
   },
   {
      "kyazdani42/nvim-tree.lua",
      after = "nvim-web-devicons",
      cmd = { "NvimTreeToggle", "NvimTreeFocus" },
      config = function()
         require("plugins.config.nvimtree").setup()
      end,
      setup = function()
         require("core.mappings").nvimtree()
      end,
   },
   {
      "goolord/alpha-nvim",
      config = function ()
         require("plugins.config.alpha")
      end
   },
}

return packer.startup(function(use)
   for _, v in pairs(plugins) do
      use(v)
   end
end)
