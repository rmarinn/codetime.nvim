local Path = require("plenary.path")

local _timer = vim.uv.new_timer()
local _start_time = nil
local _total_time_secs = 0

M = {}

M._data_dir = string.format("%s/codetime/", vim.fn.stdpath("data"))
M._data_path = string.format("%s/codetime/data.json", vim.fn.stdpath("data"))
M._today = tostring(os.date("%x"))
M._time_coded_today = nil
M._disk_write_interval = 300000 -- 5 mins

M._ensure_data_dir_exists = function()
	local path = Path:new(M._data_dir)
	if not path:exists() then
		path:mkdir()
	end
end

M._read_data_from_disk = function()
	local path = Path:new(M._data_path)

	if path:exists() then
		local data = vim.json.decode(path:read())
		if data[M._today] then
			-- assign value from disk to local variable
			M._time_coded_today = data[M._today]
		else
			-- if no value found, create a new key and assign 0
			data[M._today] = 0
			M._time_coded_today = 0
		end
		return data
	else
		M._time_coded_today = 0
		return {}
	end
end

M._write_data_to_disk = function()
	local path = Path:new(M._data_path)
	local data = nil

	if path:exists() then
		-- retrieve data from disk then assign value for today
		data = vim.json.decode(path:read())
		data[M._today] = M._time_coded_today
	else
		-- otherwise, create a new table with only the time today
		data = { [M._today] = M._time_coded_today }
	end

	local data_json = vim.json.encode(data)
	path:write(data_json, "w")
end

M._add_time_today = function(time_secs)
	M._time_coded_today = M._time_coded_today + time_secs
end

M.get_time_today = function()
	return M._time_coded_today
end

M.print_time_today = function()
	print("Total coding time today: " .. os.date("!%H:%M:%S", M._time_coded_today))
end

local function update_time_today()
	local elapsed_secs = os.time() - _start_time
	_total_time_secs = _total_time_secs + elapsed_secs
	_start_time = nil
end

local function _start_disk_write_timer()
	if _timer:is_active() then
		_timer:stop()
	else
		_start_time = os.time()
	end

	_timer:start(M._disk_write_interval, 0, function()
		update_time_today()
		M._write_data_to_disk()
		_start_disk_write_timer()
	end)
end

M._on_vim_leave = function()
	if _timer:is_active() then
		_timer:stop()
	end
	update_time_today()
	M._write_data_to_disk()
end

M.init = function()
	M._ensure_data_dir_exists()
	M._read_data_from_disk()
	_start_disk_write_timer()
end
M.init()

return M
