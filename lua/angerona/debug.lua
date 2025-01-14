local M = {}

local function stringify(obj)
	if type(obj) == "table" then
		local str = "{ "
		for k, v in pairs(obj) do
			str = str .. "[" .. k .. "] = " .. stringify(v) .. ","
		end
		return str .. "} "
	else
		if type(obj) == "string" then
			return '"' .. obj .. '"'
		else
			return tostring(obj)
		end
	end
end

function M.dump_object(obj)
	vim.notify(stringify(obj), vim.log.levels.ERROR)
end

return M
