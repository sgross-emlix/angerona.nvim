local M = {}

local request

local util = require("angerona.util")

local TRACKER_ID_TASK = 16

M.cfg = nil

M.state = {}

local function get_project_id_from_parent(parent)
	local response = request.get(parent)

	if response == nil then
		vim.notify("Failed to get Project ID from: " .. parent, vim.log.levels.ERROR)
		return nil
	end

	return response.issue.project.id
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

function M.create_task(project_id, subject, description, parent_id)
	local body = {
		issue = {
			project_id = project_id,
			subject = subject,
			description = description,
			tracker_id = TRACKER_ID_TASK,
			parent_issue_id = tonumber(parent_id),
		},
	}

	local response = request.post(nil, body)

	if response == nil then
		vim.notify("Failed to create task!", vim.log.levels.ERROR)
		return
	end

	vim.notify("Task created: " .. response.issue.id, vim.log.levels.INFO)

	M.state.last_created = response.issue.id
end

function M.open_browser(ticket)
	request.open(ticket)
end

function M.callback_read_ticket(opts)
	local ticket = util.get_issue_id(M.state, "Ticket", opts.fargs)

	if ticket == "" then
		vim.notify("Ticket ID is required.", vim.log.levels.ERROR)
		return
	end

	M.read_ticket(ticket)

	M.state.last = ticket
end

function M.callback_update_ticket(opts)
	M.update_ticket()
end

function M.callback_create_task(opts)
	local parent = util.get_issue_id(M.state, "Parent", opts.fargs)
	if parent == "" then
		vim.notify("Parent Ticket ID is required.", vim.log.levels.ERROR)
		return
	end

	local project = get_project_id_from_parent(parent)
	if project == nil then
		vim.notify("Project ID is required.", vim.log.levels.ERROR)
		return
	end

	local subject = vim.fn.input("Subject: ")
	local description = vim.fn.input("Description: ")

	M.create_task(project, subject, description, parent)
end

function M.callback_open(opts)
	local ticket = util.get_issue_id(M.state, "Ticket", opts.fargs)

	if ticket == "" then
		vim.notify("Ticket ID is required.", vim.log.levels.ERROR)
		return
	end

	M.open_browser(ticket)

	M.state.last = ticket
end

function M.setup(config)
	request = require("angerona.http").setup(config, "issues")

	M.cfg = util.local_config()

	return M
end

return M
