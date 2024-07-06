local data = require("codetime.data")

local M = {}

M._typing_timeout = 1000
local _timer = vim.uv.new_timer()
local _start_time = nil
local _total_time_secs = 0

local function start_timer()
	if _timer:is_active() then
		_timer:stop()
	else
		_start_time = os.time()
	end

	_timer:start(M._typing_timeout, 0, function()
		local elapsed_secs = os.time() - _start_time
		_total_time_secs = _total_time_secs + elapsed_secs
		_start_time = nil
		data._add_time_today(elapsed_secs)
	end)
end

M._on_insert = function(_)
	start_timer()
end

return M
