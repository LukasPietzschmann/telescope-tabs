local has_telescope, telescope = pcall(require, 'telescope')
local TelescopeTabs = require 'telescope._extensions.telescope-tabs.main'

if not has_telescope then
	error 'This plugin requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)'
end

return telescope.register_extension {
	setup = function(ext_config, config) end,
	exports = {
		list_tabs = TelescopeTabs.list_tabs,
	},
}
