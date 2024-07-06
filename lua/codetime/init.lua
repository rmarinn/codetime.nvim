local core = require("codetime.core")
local data = require("codetime.data")

local M = {}

M.setup = function(_)
	local group = vim.api.nvim_create_augroup("CodeTime", { clear = true })
	vim.api.nvim_create_autocmd("InsertCharPre", { callback = core.on_insert, group = group })
	-- vim.api.nvim_create_user_command("CodeTime", "lua require('codetime.data').print_time_today", {})
	vim.api.nvim_create_user_command("CodeTime", data.print_time_today, {})
end

return M
