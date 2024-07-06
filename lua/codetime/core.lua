local data = require("codetime.data")

local M = {}

local timeout = 1000
local timer = vim.uv.new_timer()
local start_time = nil
local total_time_secs = 0

local function start_timer()
	if timer:is_active() then
		timer:stop()
	else
		start_time = os.time()
	end

	timer:start(timeout, 0, function()
		local elapsed_secs = os.time() - start_time
		total_time_secs = total_time_secs + elapsed_secs
		start_time = nil
		data.add_time_today(elapsed_secs)
	end)
end

M.on_insert = function(_)
	start_timer()
end

return M
