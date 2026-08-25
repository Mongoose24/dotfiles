return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			animate = {
				duration = 20,
				easing = "linear",
				fps = 120,
			},
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			dim = { enabled = true },
			explorer = {
				enabled = true,
				replace_netrw = false,
			},
			image = { enabled = true },
			lazygit = { enabled = true },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			picker = {
				enabled = true,
				sources = {
					explorer = {
						hidden = true,
					},
				},
			},
			quickfile = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
		keys = {
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},
			{
				"<leader>gb",
				function()
					Snacks.git.blame_line()
				end,
				desc = "Git blame line",
			},
			{
				"<leader>gB",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Git browse",
			},
			{
				"<leader>cR",
				function()
					Snacks.rename.rename_file()
				end,
				desc = "Rename file",
			},
			{
				"<leader>e",
				function()
					Snacks.explorer()
				end,
				desc = "File explorer",
			},
			{
				"<leader>bd",
				function()
					Snacks.bufdelete.delete()
				end,
				desc = "Delete buffer",
			},
			{
				"<leader>n",
				function()
					Snacks.picker.notifications()
				end,
				desc = "Notification history",
			},
			{
				"<leader>td",
				function()
					vim.g.snacks_dim_enabled = not vim.g.snacks_dim_enabled
					if vim.g.snacks_dim_enabled then
						Snacks.dim()
					else
						Snacks.dim.disable()
					end
				end,
				desc = "Toggle dimming",
			},

			{
				"<leader>/",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader><space>",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
		},
	},
}
