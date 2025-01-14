local M = {}

CFG_FILE_NAME = ".ang.cfg"
M.cfg = nil

function M.get_ticket_from_branch()
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

function M.local_config()
	pcall(function()
		M.cfg = read_config(get_repo_root())
	end)

	if M.cfg == nil then
		pcall(function()
			M.cfg = read_config(vim.env.HOME)
		end)
	end

	return M.cfg
end

return M
