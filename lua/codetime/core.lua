local M = {}

local timeout = 3000
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
	end)
end

local on_insert = function(_)
	start_timer()
end

M.print_total_time = function()
	print("Total coding time this session: " .. os.date("!%H:%M:%S", total_time_secs))
end

M.init = function()
	local group = vim.api.nvim_create_augroup("codetime", { clear = true })
	vim.api.nvim_create_autocmd("InsertCharPre", { callback = on_insert, group = group })
	vim.api.nvim_create_user_command("CodeTime", "lua require('codetime').print_total_time()", {})
end

return M
