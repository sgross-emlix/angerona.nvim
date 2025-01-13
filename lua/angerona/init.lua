local M = {}

-- compability
table.unpack = table.unpack or unpack

function M.setup(user_config)
	local redmine = require("angerona.redmine").setup(user_config)
end

return M
