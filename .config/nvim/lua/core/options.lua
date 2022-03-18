local opt = vim.opt
local g = vim.g

local options = require("core.utils").load_config().options

opt.title = true
opt.cul = true -- cursor line

-- Indentline
opt.expandtab = options.expandtab
opt.shiftwidth = options.shiftwidth
opt.smartindent = options.smartindent

opt.hidden = options.hidden
opt.ignorecase = options.ignorecase
opt.smartcase = options.smartcase

-- Numbers
opt.number = options.number
opt.numberwidth = options.numberwidth
opt.relativenumber = options.relativenumber
opt.ruler = options.ruler

-- disable nvim intro
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true

g.mapleader = options.mapleader
