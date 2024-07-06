local core = require("codetime.core")
local data = require("codetime.data")

local M = {}

M.setup = function(_)
	local group = vim.api.nvim_create_augroup("CodeTime", { clear = true })
	vim.api.nvim_create_autocmd("InsertCharPre", { callback = core._on_insert, group = group })
	vim.api.nvim_create_autocmd("VimLeave", { callback = data._on_vim_leave, group = group })
	vim.api.nvim_create_user_command("CodeTime", data.print_time_today, {})
end

return M
