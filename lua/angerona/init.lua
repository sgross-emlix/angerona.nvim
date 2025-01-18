local M = {}

-- compability
table.unpack = table.unpack or unpack

function M.setup(user_config)
	local redmine = require("angerona.redmine").setup(user_config)

	vim.api.nvim_create_user_command(
		"RedmineReadTicket",
		redmine.callback_read_ticket,
		{ nargs = "?", desc = "Read Redmine ticket via REST API" }
	)

	vim.api.nvim_create_user_command(
		"RedmineCreateTask",
		redmine.callback_create_task,
		{ nargs = "?", desc = "Create a Redmine task via REST API" }
	)

	vim.api.nvim_create_user_command(
		"RedmineOpen",
		redmine.callback_open,
		{ nargs = "?", desc = "Open current redmine ticket URL in a web browser" }
	)
end

return M
