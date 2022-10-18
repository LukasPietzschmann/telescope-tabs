local is_empty_table = function(t)
	if t == nil then
		return true
	end
	return next(t) == nil
end

local normalize = function(config, existing)
	local conf = existing
	if is_empty_table(config) then
		return conf
	end

	for k, v in pairs(config) do
		conf[k] = v
	end

	return conf
end

local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local conf = require('telescope.config').values

local close_tab = function(bufnr)
	local current_picker = action_state.get_current_picker(bufnr)
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
end

local M = {
	config = {},
}

local default_conf = {
	entry_formatter = function(tab_id, buffer_ids, file_names, file_paths)
		local entry_string = table.concat(file_names, ', ')
		return string.format('%d: %s', tab_id, entry_string)
	end,
	show_preview = true,
	close_tab_shortcut_i = '<C-d>',
	close_tab_shortcut_n = 'D',
}

M.conf = default_conf

M.setup = function(opts)
	normalize(opts, M.conf)
end

local current_index = vim.api.nvim_get_current_tabpage()
local last_index = current_index

vim.api.nvim_create_autocmd('TabEnter', {
	group = vim.api.nvim_create_augroup('WatchTabs', { clear = true }),
	callback = function()
		last_index = current_index
		current_index = vim.api.nvim_get_current_tabpage()
	end,
})

M.go_to_previous = function()
	vim.api.nvim_set_current_tabpage(last_index)
end

M.list_tabs = function(opts)
	opts = vim.tbl_deep_extend('force', M.conf, opts or {})
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
					local entry_string = opts.entry_formatter(entry[5], entry[3], entry[1], entry[2])
					return {
						value = entry,
						path = entry[2][1],
						display = entry_string,
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
				map('i', opts.close_tab_shortcut_i, function()
					close_tab(prompt_bufnr)
				end)
				map('n', opts.close_tab_shortcut_n, function()
					close_tab(prompt_bufnr)
				end)
				return true
			end,
			previewer = opts.show_preview and conf.file_previewer {} or nil,
		})
		:find()
end

return M
