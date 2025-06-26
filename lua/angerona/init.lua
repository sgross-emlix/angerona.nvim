local M = {}

DEFAULT_BACKEND = "redmine"

-- compability
table.unpack = table.unpack or unpack

local util = require("angerona.util")

local function setup_backend(backend, config)
	local class = require("angerona." .. backend)

	if not class then
		vim.notify("backend" .. backend .. "not implemented")
		return
	end

	class.setup(config)

	local name = backend:sub(1, 1):upper() .. backend:sub(2)

	vim.api.nvim_create_user_command(
		name .. "Read",
		class.callback_read,
		{ nargs = "?", desc = "Read " .. name .. " issue via REST API into dedicated buffer" }
	)

	vim.api.nvim_create_user_command(
		name .. "Create",
		class.callback_create,
		{ nargs = "?", desc = "Create a " .. name .. " task via REST API" }
	)

	vim.api.nvim_create_user_command(
		name .. "Open",
		class.callback_open,
		{ nargs = "?", desc = "Open current " .. name .. " issue URL in a web browser" }
	)
end

function M.setup(plugin_config)
	M.cfg = util.load_config(plugin_config)

	if M.cfg.backends == nil then
		setup_backend(DEFAULT_BACKEND, M.cfg[DEFAULT_BACKEND])
	else
		for backend, cfg in pairs(M.cfg.backends) do
				setup_backend(backend, cfg)
		end
	end

end

return M
