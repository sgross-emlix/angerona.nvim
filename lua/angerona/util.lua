local M = {}

CFG_FILE_NAME = ".ang.cfg"
M.cfg = nil

local DEFAULT_ORDER = { "ARG", "CFG", "GIT", "BUF", "CRT", "LST" }

local function get_ticket_from_branch()
	local obj = vim.system({
		"git",
		"rev-parse",
		"--abbrev-ref",
		"HEAD",
	}, { text = true }):wait()

	if obj.code == 0 then
		return obj.stdout:match("[#/]?([%d]+)")
	end

	return nil
end

local function get_ticket_from_buffer()
	local str = vim.api.nvim_buf_get_name(0)

	return str:match("([%d]+)")
end

local function get_repo_root()
	local obj = vim.system({
		"git",
		"rev-parse",
		"--show-toplevel",
	}, { text = true }):wait()

	if obj.code == 0 then
		return obj.stdout:match("(.+)\n")
	end

	return nil
end

local function read_config(path)
	if path == nil then
		return nil
	end

	return dofile(path .. "/" .. CFG_FILE_NAME)
end

function M.get_issue_id(state, desc, args, order)
	local token = args[1]

	local handler = {
		["ARG"] = tonumber(token),
		["CFG"] = M.cfg.default_issue,
		["GIT"] = get_ticket_from_branch(),
		["BUF"] = get_ticket_from_buffer(),
		["CRT"] = state.last_created,
		["LST"] = state.last,
	}

	order = token or order or M.cfg.issue_order or DEFAULT_ORDER

	for _, key in pairs(order) do
		key = string.upper(key)
		if handler[key] ~= nil then
			return handler[key]
		end
	end

	return tonumber(token) or vim.fn.input(desc .. " ID: ")
end

function M.local_config()
	pcall(function()
		M.cfg = read_config(get_repo_root())
	end)

	if M.cfg == nil then
		pcall(function()
			M.cfg = read_config(vim.env.HOME)
		end)
	end

	M.cfg = M.cfg or {}

	return M.cfg
end

return M
