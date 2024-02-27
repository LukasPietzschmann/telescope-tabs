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

local M = {
	config = {},
}

local default_conf = {
	entry_formatter = function(tab_id, buffer_ids, file_names, file_paths, is_current)
		local entry_string = table.concat(file_names, ', ')
		return string.format('%d: %s%s', tab_id, entry_string, is_current and ' <' or '')
	end,
}

M.conf = default_conf

M.setup = function(opts)
	normalize(opts, M.conf)
end

local visible_tab = vim.api.nvim_get_current_tabpage()
local tab_stack = {}

vim.api.nvim_create_autocmd('TabEnter', {
	group = vim.api.nvim_create_augroup('WatchTabs', { clear = true }),
	callback = function()
		table.insert(tab_stack, visible_tab)
		visible_tab = vim.api.nvim_get_current_tabpage()
	end,
})

M.go_to_previous = function()
	local last_tab = table.remove(tab_stack)
	while last_tab ~= nil and not vim.api.nvim_tabpage_is_valid(last_tab) do
		last_tab = table.remove(tab_stack)
	end
	if last_tab == nil then
		vim.notify('No previous tab to go to', vim.log.levels.ERROR)
		return
	end
	vim.api.nvim_set_current_tabpage(last_tab)
end

M.list_tabs = function(opts)
	opts = vim.tbl_deep_extend('force', M.conf, opts or {})
	local res = {}
	local current_tab = { number = vim.api.nvim_tabpage_get_number(0), index = nil }
	for index, tid in ipairs(vim.api.nvim_list_tabpages()) do
		local file_names = {}
		local file_paths = {}
		local file_ids = {}
		local window_ids = {}
		local is_current = current_tab.number == vim.api.nvim_tabpage_get_number(tid)
		for _, wid in ipairs(vim.api.nvim_tabpage_list_wins(tid)) do
			-- Only consider the normal windows and ignore the floating windows
			if vim.api.nvim_win_get_config(wid).relative == '' then
				local bid = vim.api.nvim_win_get_buf(wid)
				local path = vim.api.nvim_buf_get_name(bid)
				local file_name = vim.fn.fnamemodify(path, ':t')
				table.insert(file_names, file_name)
				table.insert(file_paths, path)
				table.insert(file_ids, bid)
				table.insert(window_ids, wid)
			end
		end
		if is_current then
			current_tab.index = index
		end
		table.insert(res, { file_names, file_paths, file_ids, window_ids, tid, is_current })
	end
	vim.ui.select(res, {
		prompt = 'Tabs',
		kind = 'telescope-tabs',
		format_item = function(item)
			return opts.entry_formatter(item[5], item[3], item[1], item[2], item[6])
		end,
	}, function(item)
		if item == nil then
			return
		end
		vim.api.nvim_set_current_tabpage(item[5])
	end)
end

return M
