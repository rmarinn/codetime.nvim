local core = require("codetime.core")

local M = {}

M.setup = function(_)
	core.init()
end

M.print_total_time = core.print_total_time

return M
