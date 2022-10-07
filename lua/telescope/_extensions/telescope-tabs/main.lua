local M = {}

local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local conf = require('telescope.config').values

M.list_tabs = function()
	local res = {}
	for _, tid in ipairs(vim.api.nvim_list_tabpages()) do
		local file_names = {}
		for _, wid in ipairs(vim.api.nvim_tabpage_list_wins(tid)) do
			local bid = vim.api.nvim_win_get_buf(wid)
			local path = vim.api.nvim_buf_get_name(bid)
			local file_name = vim.fn.fnamemodify(path, ':t')
			table.insert(file_names, file_name)
		end
		table.insert(res, { file_names, tid })
	end
	pickers
		.new({}, {
			prompt_title = 'Tabs',
			finder = finders.new_table {
				results = res,
				entry_maker = function(entry)
					local entry_string = table.concat(entry[1], ', ')
					return {
						value = entry,
						display = string.format('%d: %s', entry[2], entry_string),
						ordinal = entry_string,
					}
				end,
			},
			sorter = conf.generic_sorter {},
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					vim.api.nvim_set_current_tabpage(selection.value[2])
				end)
				return true
			end,
		})
		:find()
end

return M
