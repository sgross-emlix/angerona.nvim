local M = {}

local request

local util = require("angerona.util")

local function get_ticket_id(args, desc)
	return args[1] or util.get_ticket_from_branch() or vim.fn.input(desc .. " ID: ")
end

function M.read_ticket(ticket)
	local response = request.get(ticket)

	if response == nil then
		vim.notify("Failed to read : " .. ticket, vim.log.levels.ERROR)
		return
	end

	local issue = response.issue

	local lines = {}
	for s in issue.description:gmatch("([^[\n\r]+)[\n\r]*") do
		table.insert(lines, s)
	end

	vim.cmd("tabnew")
	local buf = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_buf_set_name(buf, "Ticket " .. ticket)
	vim.api.nvim_buf_set_lines(buf, 0, -1, true, { issue.subject, "", table.unpack(lines) })
	vim.api.nvim_set_current_buf(buf)
end

function M.update_ticket()
	local buf_name = vim.api.nvim_buf_get_name(0)
	local ticket = buf_name:match("Ticket ([%d]+)")

	local buf_subject = vim.api.nvim_buf_get_lines(0, 0, 1, true)[1]
	local lines = vim.api.nvim_buf_get_lines(0, 2, -1, true)

	local buf_description = ""
	for _, line in ipairs(lines) do
		buf_description = buf_description .. "\n" .. line
	end

	local body = {
		issue = {
			subject = buf_subject,
			description = buf_description,
		},
	}

	local response = request.put(ticket, body)

	if response == nil then
		vim.notify("Failed to update ticket!", vim.log.levels.ERROR)
		return
	end
end

function M.callback_read_ticket(opts)
	local ticket = get_ticket_id(opts.fargs, "Ticket")
	if ticket == "" then
		vim.notify("Ticket ID is required.", vim.log.levels.ERROR)
		return
	end

	M.read_ticket(ticket)
end

function M.callback_update_ticket(opts)
	M.update_ticket()
end

function M.setup(config)
	request = require("angerona.http").setup(config, "issues")

	return M
end

return M
