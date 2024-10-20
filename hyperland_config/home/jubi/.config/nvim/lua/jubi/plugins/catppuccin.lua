return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		require("catppuccin").setup {
			flavour = "macchiato"
		}
		vim.cmd.colorscheme "catppuccin"
	end,
}
