local Path = require("plenary.path")
local data_dir = string.format("%s/codetime/", vim.fn.stdpath("data"))
local data_path = string.format("%s/codetime/data.json", vim.fn.stdpath("data"))
local today = tostring(os.date("%x"))

M = {}

local function read_data()
	local path = Path:new(data_path)

	if path:exists() then
		return vim.json.decode(path:read())
	else
		path:write(vim.json.encode({}), "w")
		return {}
	end
end

M.add_time_today = function(time_secs)
	local path = Path:new(data_path)
	local data = read_data()

	if data[today] then
		data[today] = data[today] + time_secs
	else
		data[today] = time_secs
	end

	path:write(vim.json.encode(data), "w")
end

M.get_time_today = function()
	local data = read_data()

	if data[today] then
		return data[today]
	else
		return 0
	end
end

M.print_time_today = function()
	local total_secs_today = M.get_time_today()
	print("Total coding time today: " .. os.date("!%H:%M:%S", total_secs_today))
end

local init = function()
	-- makes sure that the data directory exists
	local path = Path:new(data_dir)
	if not path:exists() then
		path:mkdir()
	end
	return M
end
init()

return M
