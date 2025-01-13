local M = {}

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

return M
