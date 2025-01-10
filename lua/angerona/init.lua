local M = {}

local http = require("plenary.curl")

M.api_key = nil
M.base_url = nil

function M.setup(user_config)
	M.api_key = user_config.api_key or M.api_key
	M.base_url = user_config.base_url or M.base_url
	M.api_key = M.api_key
	M.base_url = M.base_url

	vim.api.nvim_create_user_command("CreateRedmineTask", function()
		local parent_id = vim.fn.input("Parent Ticket ID (required): ")

		if parent_id == "" then
			vim.notify("Parent Ticket ID is required.", vim.log.levels.ERROR)
			return
		end

		local subject = vim.fn.input("Subject: ")
		local description = vim.fn.input("Description: ")

		M.get_project_id_from_parent(parent_id, function(project_id)
			if project_id then
				M.create_task(project_id, subject, description, parent_id)
			else
				vim.notify("Failed to fetch project ID from parent ticket.", vim.log.levels.ERROR)
			end
		end)
	end, { desc = "Create a Redmine task via REST API" })

	vim.api.nvim_create_user_command("ReadRedmineTicket", function()
		local ticket_id = vim.fn.input("TicketID: ")
		M.read_ticket(ticket_id)
	end, { desc = "Read Redmine ticket via REST API" })
end

function M.get_project_id_from_parent(parent_id, callback)
	local url = M.base_url .. "/issues/" .. parent_id .. ".json"
	local headers = {
		["X-Redmine-API-Key"] = M.api_key,
	}

	local response = http.get(url, { headers = headers })

	if response.status == 200 then
		local issue = vim.fn.json_decode(response.body)
		if issue and issue.issue and issue.issue.project and issue.issue.project.id then
			callback(issue.issue.project.id)
		else
			vim.notify("Project ID not found in the parent ticket.", vim.log.levels.ERROR)
			callback(nil)
		end
	else
		vim.notify("Failed to fetch parent ticket details: " .. (response.body or "No response"), vim.log.levels.ERROR)
		callback(nil)
	end
end

function M.create_task(project_id, subject, description, parent_id)
	local url = M.base_url .. "/issues.json"
	local headers = {
		["Content-Type"] = "application/json",
		["X-Redmine-API-Key"] = M.api_key,
	}
	local body = {
		issue = {
			project_id = project_id,
			subject = subject,
			description = description,
			tracker_id = 16,
			parent_issue_id = tonumber(parent_id),
		},
	}

	local response = http.post(url, {
		headers = headers,
		body = vim.fn.json_encode(body),
	})

	if response.status == 201 then
		vim.notify("Task created successfully!", vim.log.levels.INFO)
	else
		vim.notify("Failed to create task: " .. (response.body or "No response"), vim.log.levels.ERROR)
	end
end

function M.read_ticket(ticket_id)
	local url = M.base_url .. "/issues/" .. ticket_id .. ".json"
	local headers = {
		["Content-Type"] = "application/json",
		["X-Redmine-API-Key"] = M.api_key,
		["Accept"] = "application/json",
	}

	local ticket_text = http.get(url, {
		headers = headers,
	})

	local body_json = vim.json.decode(ticket_text["body"])

	local ticket_subject = body_json["issue"]["subject"]

	local lines = {}
	for s in body_json["issue"]["description"]:gmatch("[^\n]+") do
		table.insert(lines, s)
	end

	local buf = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_buf_set_name(buf, "Ticket " .. ticket_id)
	vim.api.nvim_buf_set_lines(buf, -1, -1, true, { ticket_subject, "------------------", table.unpack(lines) })
end

return M
