local M = {}

local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local conf = require('telescope.config').values

M.list_tabs = function(opts)
	local res = {}
	for _, tid in ipairs(vim.api.nvim_list_tabpages()) do
		local file_names = {}
		local file_paths = {}
		local file_ids = {}
		local window_ids = {}
		for _, wid in ipairs(vim.api.nvim_tabpage_list_wins(tid)) do
			local bid = vim.api.nvim_win_get_buf(wid)
			local path = vim.api.nvim_buf_get_name(bid)
			local file_name = vim.fn.fnamemodify(path, ':t')
			table.insert(file_names, file_name)
			table.insert(file_paths, path)
			table.insert(file_ids, bid)
			table.insert(window_ids, wid)
		end
		table.insert(res, { file_names, file_paths, file_ids, window_ids, tid })
	end
	pickers
		.new(opts, {
			prompt_title = 'Tabs',
			finder = finders.new_table {
				results = res,
				entry_maker = function(entry)
					local entry_string = table.concat(entry[1], ', ')
					return {
						value = entry,
						path = entry[2][1],
						display = string.format('%d: %s', entry[5], entry_string),
						ordinal = entry_string,
					}
				end,
			},
			sorter = conf.generic_sorter {},
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					vim.api.nvim_set_current_tabpage(selection.value[5])
				end)
				map('i', '<C-d>', function()
					local current_picker = action_state.get_current_picker(prompt_bufnr)
					local current_entry = action_state:get_selected_entry()
					if vim.api.nvim_get_current_tabpage() == current_entry.value[5] then
						print 'You cannot close the currently visible tab :('
						return
					end
					current_picker:delete_selection(function(selection)
						for _, wid in ipairs(selection.value[4]) do
							vim.api.nvim_win_close(wid, false)
						end
					end)
				end)
				return true
			end,
			previewer = conf.file_previewer {},
		})
		:find()
end

return M
