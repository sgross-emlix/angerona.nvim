local M = {}

local http = require("plenary.curl")

M.headers = nil
M.url = nil
M.end_point = nil

local function query(method, path, body)
	local url = M.base_url .. "/" .. M.end_point
	if path == nil then
		url = url .. ".json"
	else
		url = url .. "/" .. path .. ".json"
	end

	local response = http.request({
		url = url,
		method = method,
		headers = M.headers,
		body = vim.fn.json_encode(body),
	})

	if response.status == 200 or response.status == 201 or response.status == 204 then
		if response.body == "" then
			return {}
		end
		return vim.json.decode(response.body) or {}
	end

	return nil
end

function M.get(path)
	return query("GET", path)
end

function M.put(path, body)
	return query("PUT", path, body)
end

function M.post(path, body)
	return query("POST", path, body)
end

function M.setup(config, end_point)
	M.base_url = config.base_url
	M.headers = {
		["Accept"] = "application/json",
		["Content-Type"] = "application/json",
		["X-Redmine-API-Key"] = config.api_key,
	}
	M.end_point = end_point

	return M
end

return M
