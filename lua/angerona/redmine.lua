local M = {}

local request

function M.setup(config)
	request = require("angerona.http").setup(config, "issues")

	return M
end

return M
