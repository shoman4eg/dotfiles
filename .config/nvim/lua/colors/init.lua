local M = {}

-- if theme given, load given theme if given, otherwise nvchad_theme
M.init = function()
   vim.g.tokyonight_style = "night"

   require('tokyonight').colorscheme()
end

-- returns a table of colors for given or current theme
M.get = function()
   return require("tokyonight.colors").setup({})
end

return M
