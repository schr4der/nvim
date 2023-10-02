require("nullsurface.settings")
require("nullsurface.maps")
require("nullsurface.plugins")

local themeStatus, gruvbox = pcall(require, "gruvbox")

if themeStatus then
	vim.cmd("colorscheme gruvbox")
else
	return
end
