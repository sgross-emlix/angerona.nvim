local M = {}

-- compability
table.unpack = table.unpack or unpack

function M.setup(user_config)
	local redmine = require("angerona.redmine").setup(user_config)

	vim.api.nvim_create_user_command(
		"RedmineRead",
		redmine.callback_read,
		{ nargs = "?", desc = "Read Redmine issue via REST API into dedicated buffer" }
	)

	vim.api.nvim_create_user_command(
		"RedmineCreate",
		redmine.callback_create,
		{ nargs = "?", desc = "Create a Redmine task via REST API" }
	)

	vim.api.nvim_create_user_command(
		"RedmineOpen",
		redmine.callback_open,
		{ nargs = "?", desc = "Open current redmine issue URL in a web browser" }
	)
end

return M
