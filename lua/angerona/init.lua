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
end

return M
