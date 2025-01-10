local M = {}

local http = require('plenary.curl')

M.api_key = nil
M.base_url = nil

local function setup(user_config)

    M.api_key = user_config.api_key or M.api_key
    M.base_url = user_config.base_url or M.base_url

vim.api.nvim_create_user_command('CreateRedmineTicket', function()
    local project_id = vim.fn.input("Project ID: ")
    local subject = vim.fn.input("Subject: ")
    local description = vim.fn.input("Description: ")
    M.create_ticket(project_id, subject, description)
end, { desc = "Create a Redmine ticket via REST API" })

end

function M.create_ticket(project_id, subject, description)
    local url = M.base_url .. "/issues/25810.json"
    local headers = {
        ["Content-Type"] = "application/json",
        ["X-Redmine-API-Key"] = M.api_key
    }
    local body = {
        issue = {
            project_id = project_id,
            subject = subject,
            description = description
        }
    }

    http.get(url, {
        headers = headers,
        body = vim.fn.json_encode(body),
    })
end

return { setup = setup }
