require "nvchad.options"

local o = vim.o
local opt = vim.opt

o.history = 2000
o.scrolloff = 7
o.wrap = false
o.showmatch = true
o.matchtime = 2
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.clipboard = "unnamedplus"

opt.fileencodings = { "ucs-bom", "utf-8", "cp936", "gb18030", "big5", "euc-jp", "euc-kr", "latin1" }
opt.formatoptions:append "m"
opt.formatoptions:append "B"
opt.wildignore:append { "*.o", "*~", "*.pyc", "*.class" }
